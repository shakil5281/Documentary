/*
================================================================================
 11 - CAPSTONE: LIBRARY DATABASE
 Run after completing sql/01 through sql/04 (recommended).
 Dev/learning only.
================================================================================
*/

USE master;
GO

IF DB_ID(N'LibraryDB') IS NOT NULL
BEGIN
    ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryDB;
END
GO

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

CREATE SCHEMA library AUTHORIZATION dbo;
GO

CREATE TABLE library.Member (
    MemberId    INT IDENTITY(1,1) NOT NULL,
    MemberCode  NVARCHAR(20)      NOT NULL,
    FullName    NVARCHAR(200)     NOT NULL,
    Email       NVARCHAR(256)     NOT NULL,
    JoinedDate  DATE              NOT NULL CONSTRAINT DF_Member_Joined DEFAULT (CAST(GETDATE() AS DATE)),
    IsActive    BIT               NOT NULL CONSTRAINT DF_Member_Active DEFAULT (1),
    CONSTRAINT PK_Member PRIMARY KEY (MemberId),
    CONSTRAINT UQ_Member_Code UNIQUE (MemberCode),
    CONSTRAINT UQ_Member_Email UNIQUE (Email)
);

CREATE TABLE library.Book (
    BookId            INT IDENTITY(1,1) NOT NULL,
    Isbn              NVARCHAR(20)      NOT NULL,
    Title             NVARCHAR(300)     NOT NULL,
    Author            NVARCHAR(200)     NOT NULL,
    CopiesAvailable   INT               NOT NULL,
    CONSTRAINT PK_Book PRIMARY KEY (BookId),
    CONSTRAINT UQ_Book_Isbn UNIQUE (Isbn),
    CONSTRAINT CK_Book_Copies CHECK (CopiesAvailable >= 0)
);

CREATE TABLE library.Loan (
    LoanId        INT IDENTITY(1,1) NOT NULL,
    MemberId      INT               NOT NULL,
    BookId        INT               NOT NULL,
    LoanDate      DATE              NOT NULL,
    DueDate       DATE              NOT NULL,
    ReturnedDate  DATE              NULL,
    FineAmount    DECIMAL(10,2)     NOT NULL CONSTRAINT DF_Loan_Fine DEFAULT (0),
    CONSTRAINT PK_Loan PRIMARY KEY (LoanId),
    CONSTRAINT FK_Loan_Member FOREIGN KEY (MemberId) REFERENCES library.Member (MemberId),
    CONSTRAINT FK_Loan_Book FOREIGN KEY (BookId) REFERENCES library.Book (BookId),
    CONSTRAINT CK_Loan_Dates CHECK (DueDate >= LoanDate)
);

CREATE NONCLUSTERED INDEX IX_Loan_DueDate
ON library.Loan (DueDate)
INCLUDE (MemberId, BookId, ReturnedDate);

GO

-- ========== SEED ==========
INSERT INTO library.Member (MemberCode, FullName, Email, JoinedDate)
VALUES
    (N'M-1001', N'Rahim Ahmed', N'rahim@example.com', '2024-06-01'),
    (N'M-1002', N'Sara Islam', N'sara@example.com', '2025-01-15'),
    (N'M-1003', N'Karim Hossain', N'karim@example.com', '2025-03-20');

INSERT INTO library.Book (Isbn, Title, Author, CopiesAvailable)
VALUES
    (N'978-013600424', N'The Art of SQL', N'Stephanie Morris', 3),
    (N'978-073567848', N'T-SQL Fundamentals', N'Itzik Ben-Gan', 2),
    (N'978-150930200', N'Database Design', N'Louis Davidson', 1);

INSERT INTO library.Loan (MemberId, BookId, LoanDate, DueDate, ReturnedDate, FineAmount)
VALUES
    (1, 1, '2026-04-01', '2026-04-15', '2026-04-14', 0),
    (2, 2, '2026-05-01', '2026-05-15', NULL, 0),
    (1, 3, '2026-05-10', '2026-05-24', NULL, 0);

UPDATE library.Book SET CopiesAvailable = CopiesAvailable - 1 WHERE BookId IN (1, 2, 3);

GO

-- ========== Stored procedure: issue loan ==========
CREATE OR ALTER PROCEDURE library.usp_IssueLoan
    @MemberId INT,
    @BookId   INT,
    @LoanDays INT = 14
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM library.Book WHERE BookId = @BookId AND CopiesAvailable > 0)
            THROW 51000, N'No copies available.', 1;

        INSERT INTO library.Loan (MemberId, BookId, LoanDate, DueDate)
        VALUES (@MemberId, @BookId, CAST(GETDATE() AS DATE), DATEADD(DAY, @LoanDays, CAST(GETDATE() AS DATE)));

        UPDATE library.Book SET CopiesAvailable = CopiesAvailable - 1 WHERE BookId = @BookId;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO

-- ========== Stored procedure: return book ==========
CREATE OR ALTER PROCEDURE library.usp_ReturnLoan
    @LoanId       INT,
    @FinePerDay   DECIMAL(10,2) = 1.00
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @Due DATE, @Fine DECIMAL(10,2), @BookId INT;

        SELECT @Due = DueDate, @BookId = BookId
        FROM library.Loan
        WHERE LoanId = @LoanId AND ReturnedDate IS NULL;

        IF @Due IS NULL
            THROW 51001, N'Loan not found or already returned.', 1;

        SET @Fine = CASE
            WHEN CAST(GETDATE() AS DATE) > @Due
            THEN DATEDIFF(DAY, @Due, CAST(GETDATE() AS DATE)) * @FinePerDay
            ELSE 0 END;

        UPDATE library.Loan
        SET ReturnedDate = CAST(GETDATE() AS DATE), FineAmount = @Fine
        WHERE LoanId = @LoanId;

        UPDATE library.Book SET CopiesAvailable = CopiesAvailable + 1 WHERE BookId = @BookId;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO

-- ========== View: active loans ==========
CREATE OR ALTER VIEW library.vw_ActiveLoans
AS
SELECT
    l.LoanId,
    m.MemberCode,
    m.FullName,
    b.Title,
    l.LoanDate,
    l.DueDate,
    CASE WHEN l.DueDate < CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END AS IsOverdue
FROM library.Loan l
INNER JOIN library.Member m ON m.MemberId = l.MemberId
INNER JOIN library.Book b ON b.BookId = l.BookId
WHERE l.ReturnedDate IS NULL;
GO

SELECT * FROM library.vw_ActiveLoans ORDER BY DueDate;

PRINT N'LibraryDB capstone ready. See docs/11-capstone-library-project.md';
GO
