/*
================================================================================
 13 - MODULE 4 LAB: VIEWS, PROCEDURES, TRIGGERS, TRANSACTIONS
 Prerequisite: sql/01, sql/05, sql/06, sql/07 (run those first, or run this after 01)
================================================================================
*/

USE LearnSQL;
GO

PRINT N'=== MODULE 4 LAB ===';
GO

-- ========== 1) View: top customers ==========
CREATE OR ALTER VIEW dbo.vw_TopCustomers
AS
SELECT TOP (100)
    c.CustomerId,
    c.FullName,
    SUM(o.OrderTotal) AS LifetimeSpend
FROM dbo.Customer c
INNER JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FullName
HAVING SUM(o.OrderTotal) > 0;
GO

SELECT * FROM dbo.vw_TopCustomers ORDER BY LifetimeSpend DESC;

-- ========== 2) Procedure: place order (transactional) ==========
CREATE OR ALTER PROCEDURE dbo.usp_PlaceOrder
    @CustomerId  INT,
    @ProductId   INT,
    @Quantity    INT,
    @NewOrderId  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @UnitPrice DECIMAL(18,2), @LineTotal DECIMAL(18,2);

    SELECT @UnitPrice = UnitPrice FROM dbo.Product WHERE ProductId = @ProductId;
    IF @UnitPrice IS NULL
        THROW 52000, N'Invalid ProductId.', 1;

    SET @LineTotal = @UnitPrice * @Quantity;

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
        VALUES (@CustomerId, CAST(GETDATE() AS DATE), @LineTotal, N'OP');

        SET @NewOrderId = SCOPE_IDENTITY();

        INSERT INTO dbo.OrderLine (OrderId, ProductId, Quantity, LineTotal)
        VALUES (@NewOrderId, @ProductId, @Quantity, @LineTotal);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO

DECLARE @oid INT;
EXEC dbo.usp_PlaceOrder
    @CustomerId = 2,
    @ProductId = 3,
    @Quantity = 2,
    @NewOrderId = @oid OUTPUT;

SELECT @oid AS NewOrderId;

-- ========== 3) Function: format currency ==========
CREATE OR ALTER FUNCTION dbo.fn_FormatMoney (@Amount DECIMAL(18,2))
RETURNS NVARCHAR(32)
AS
BEGIN
    RETURN N'$' + FORMAT(@Amount, N'N2');
END;
GO

SELECT dbo.fn_FormatMoney(1234.5) AS Formatted;

-- ========== 4) Trigger already in 07 — verify audit ==========
SELECT TOP 5 OrderId, Action, ActionAt
FROM dbo.OrderAudit
ORDER BY ActionAt DESC;

-- ========== 5) Transaction rollback demo ==========
BEGIN TRY
    BEGIN TRAN;
        UPDATE dbo.Customer SET FullName = N'Transaction Test' WHERE CustomerId = 1;
        -- Force error: invalid order
        INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
        VALUES (99999, GETDATE(), 1, N'OP');
    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT N'Rolled back — customer name unchanged.';
END CATCH;

SELECT CustomerId, FullName FROM dbo.Customer WHERE CustomerId = 1;

-- ========== 6) TVF from script 06 (if you ran it) ==========
IF OBJECT_ID(N'dbo.fn_OrdersByStatus', N'IF') IS NOT NULL
    SELECT * FROM dbo.fn_OrdersByStatus(N'OP');
ELSE
    PRINT N'Run sql/06-stored-procedures-functions.sql for fn_OrdersByStatus demo.';

PRINT N'Module 4 lab complete.';
GO
