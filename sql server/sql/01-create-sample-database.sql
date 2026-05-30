/*
================================================================================
 01 - CREATE SAMPLE DATABASE (LearnSQL)
 Run in SSMS as a user who can create databases.
 *** PRODUCTION WARNING: DROP DATABASE LearnSQL — dev/learning only ***
 Prerequisite: Module 00 | Exercises: exercises/module-01.md
================================================================================
*/

USE master;
GO

IF DB_ID(N'LearnSQL') IS NOT NULL
BEGIN
    ALTER DATABASE LearnSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LearnSQL;
END
GO

CREATE DATABASE LearnSQL;
GO

USE LearnSQL;
GO

-- ========== SCHEMA: Core e-commerce model (matches ERD in docs/07) ==========

CREATE TABLE dbo.Customer (
    CustomerId   INT IDENTITY(1,1) NOT NULL,
    Email        NVARCHAR(256)     NOT NULL,
    FullName     NVARCHAR(200)     NOT NULL,
    Phone        NVARCHAR(30)      NULL,
    MetadataJson NVARCHAR(MAX)     NULL,
    IsActive     BIT               NOT NULL CONSTRAINT DF_Customer_IsActive DEFAULT (1),
    CreatedAt    DATETIME2(0)      NOT NULL CONSTRAINT DF_Customer_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (CustomerId),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email),
    CONSTRAINT CK_Customer_Email CHECK (Email LIKE N'%@%.%')
);

CREATE TABLE dbo.Product (
    ProductId   INT IDENTITY(1,1) NOT NULL,
    Sku         NVARCHAR(50)      NOT NULL,
    Name        NVARCHAR(200)     NOT NULL,
    UnitPrice   DECIMAL(18,2)     NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY CLUSTERED (ProductId),
    CONSTRAINT UQ_Product_Sku UNIQUE (Sku),
    CONSTRAINT CK_Product_UnitPrice CHECK (UnitPrice >= 0)
);

CREATE TABLE dbo.[Order] (
    OrderId      INT IDENTITY(1,1) NOT NULL,
    CustomerId   INT               NOT NULL,
    OrderDate    DATE              NOT NULL,
    OrderTotal   DECIMAL(18,2)     NOT NULL,
    StatusCode   CHAR(2)           NOT NULL CONSTRAINT DF_Order_Status DEFAULT ('OP'),
    CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderId),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId) REFERENCES dbo.Customer (CustomerId),
    CONSTRAINT CK_Order_Total CHECK (OrderTotal >= 0)
);

CREATE TABLE dbo.OrderLine (
    OrderLineId  INT IDENTITY(1,1) NOT NULL,
    OrderId      INT               NOT NULL,
    ProductId    INT               NOT NULL,
    Quantity     INT               NOT NULL,
    LineTotal    DECIMAL(18,2)     NOT NULL,
    CONSTRAINT PK_OrderLine PRIMARY KEY CLUSTERED (OrderLineId),
    CONSTRAINT FK_OrderLine_Order FOREIGN KEY (OrderId) REFERENCES dbo.[Order] (OrderId),
    CONSTRAINT FK_OrderLine_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
    CONSTRAINT CK_OrderLine_Qty CHECK (Quantity > 0),
    CONSTRAINT CK_OrderLine_Total CHECK (LineTotal >= 0)
);

CREATE TABLE dbo.OrderAudit (
    AuditId    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderId    INT               NOT NULL,
    Action     NVARCHAR(20)      NOT NULL,
    ActionAt   DATETIME2(0)      NOT NULL CONSTRAINT DF_OrderAudit_ActionAt DEFAULT (SYSUTCDATETIME())
);

-- ========== SEED DATA ==========

INSERT INTO dbo.Customer (Email, FullName, Phone, MetadataJson)
VALUES
    (N'alice@example.com', N'Alice Khan', N'+8801700000001', N'{"tier":"gold","country":"BD"}'),
    (N'bob@example.com', N'Bob Lee', NULL, N'{"tier":"silver","country":"US"}'),
    (N'carol@example.com', N'Carol Diaz', N'+8801700000003', N'{"tier":"gold","country":"BD"}');

INSERT INTO dbo.Product (Sku, Name, UnitPrice)
VALUES
    (N'LAP-001', N'Learning Laptop', 899.00),
    (N'MON-002', N'24in Monitor', 249.99),
    (N'KEY-003', N'Mechanical Keyboard', 89.50);

INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
VALUES
    (1, '2025-11-01', 1148.99, 'PD'),
    (1, '2026-01-15', 89.50, 'PD'),
    (2, '2026-02-10', 249.99, 'OP');

INSERT INTO dbo.OrderLine (OrderId, ProductId, Quantity, LineTotal)
VALUES
    (1, 1, 1, 899.00),
    (1, 2, 1, 249.99),
    (2, 3, 1, 89.50),
    (3, 2, 1, 249.99);

PRINT N'LearnSQL database created successfully.';
GO

/* ========== EXERCISE BLOCK (Module 01) — try yourself first ==========
-- List tables in LearnSQL:
USE LearnSQL;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
========== end exercise block ========== */

SELECT N'Tables' AS Info, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
