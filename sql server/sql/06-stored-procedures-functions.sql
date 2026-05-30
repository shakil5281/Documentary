/*
================================================================================
 06 - STORED PROCEDURES AND FUNCTIONS
 Prerequisite: 01-create-sample-database.sql
================================================================================
*/

USE LearnSQL;
GO

-- ========== Stored procedure ==========
CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerOrders
    @CustomerId INT,
    @MinTotal   DECIMAL(18,2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OrderId, OrderDate, OrderTotal, StatusCode
    FROM dbo.[Order]
    WHERE CustomerId = @CustomerId
      AND OrderTotal >= @MinTotal
    ORDER BY OrderDate DESC;
END;
GO

EXEC dbo.usp_GetCustomerOrders @CustomerId = 1, @MinTotal = 50;

-- ========== Procedure with OUTPUT ==========
CREATE OR ALTER PROCEDURE dbo.usp_CreateOrder
    @CustomerId INT,
    @OrderDate  DATE,
    @OrderTotal DECIMAL(18,2),
    @NewOrderId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
    VALUES (@CustomerId, @OrderDate, @OrderTotal, N'OP');

    SET @NewOrderId = SCOPE_IDENTITY();
END;
GO

DECLARE @id INT;
EXEC dbo.usp_CreateOrder
    @CustomerId = 2,
    @OrderDate = '2026-05-30',
    @OrderTotal = 99.00,
    @NewOrderId = @id OUTPUT;

SELECT @id AS CreatedOrderId;

-- ========== Scalar function ==========
CREATE OR ALTER FUNCTION dbo.fn_LineTotalWithTax (
    @Amount DECIMAL(18,2),
    @TaxRate DECIMAL(5,4)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN ROUND(@Amount * (1 + @TaxRate), 2);
END;
GO

SELECT dbo.fn_LineTotalWithTax(100.00, 0.15) AS TotalWithTax;

-- ========== Inline table-valued function ==========
CREATE OR ALTER FUNCTION dbo.fn_OrdersByStatus (@Status CHAR(2))
RETURNS TABLE
AS
RETURN
(
    SELECT OrderId, CustomerId, OrderDate, OrderTotal
    FROM dbo.[Order]
    WHERE StatusCode = @Status
);
GO

SELECT * FROM dbo.fn_OrdersByStatus(N'OP');

GO
