/*
================================================================================
 ECOMMERCE CAPSTONE - EcommerceDB
 *** PRODUCTION WARNING: DROP DATABASE EcommerceDB — dev only ***
 Modules: 14 | Doc: docs/14-capstone-ecommerce.md
================================================================================
*/

USE master;
GO

IF DB_ID(N'EcommerceDB') IS NOT NULL
BEGIN
    ALTER DATABASE EcommerceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EcommerceDB;
END
GO

CREATE DATABASE EcommerceDB;
GO

USE EcommerceDB;
GO

CREATE SCHEMA shop AUTHORIZATION dbo;
GO

CREATE TABLE shop.Category (
    CategoryId   INT IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE shop.Product (
    ProductId    INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId   INT NOT NULL REFERENCES shop.Category(CategoryId),
    Sku          NVARCHAR(40) NOT NULL UNIQUE,
    Name         NVARCHAR(200) NOT NULL,
    Price        DECIMAL(18,2) NOT NULL CHECK (Price >= 0),
    StockQty     INT NOT NULL CHECK (StockQty >= 0)
);

CREATE TABLE shop.Customer (
    CustomerId   INT IDENTITY(1,1) PRIMARY KEY,
    Email        NVARCHAR(256) NOT NULL UNIQUE,
    FullName     NVARCHAR(200) NOT NULL,
    CreatedAt    DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE shop.[Order] (
    OrderId      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId   INT NOT NULL REFERENCES shop.Customer(CustomerId),
    OrderAt      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    StatusCode   VARCHAR(20) NOT NULL DEFAULT 'Pending',
    TotalAmount  DECIMAL(18,2) NOT NULL DEFAULT 0
);

CREATE TABLE shop.OrderItem (
    OrderItemId  INT IDENTITY(1,1) PRIMARY KEY,
    OrderId      INT NOT NULL REFERENCES shop.[Order](OrderId),
    ProductId    INT NOT NULL REFERENCES shop.Product(ProductId),
    Qty          INT NOT NULL CHECK (Qty > 0),
    UnitPrice    DECIMAL(18,2) NOT NULL
);

CREATE NONCLUSTERED INDEX IX_Order_Customer_OrderAt
ON shop.[Order] (CustomerId, OrderAt DESC) INCLUDE (StatusCode, TotalAmount);
GO

INSERT INTO shop.Category (Name) VALUES (N'Electronics'), (N'Books');

INSERT INTO shop.Product (CategoryId, Sku, Name, Price, StockQty)
VALUES
    (1, N'E-100', N'Wireless Mouse', 29.99, 100),
    (1, N'E-200', N'USB Keyboard', 49.99, 80),
    (2, N'B-100', N'SQL Fundamentals Book', 39.99, 50);

INSERT INTO shop.Customer (Email, FullName)
VALUES (N'buyer1@example.com', N'Amina Karim'), (N'buyer2@example.com', N'John Smith');

INSERT INTO shop.[Order] (CustomerId, StatusCode, TotalAmount)
VALUES (1, N'Paid', 79.98), (1, N'Shipped', 39.99), (2, N'Pending', 29.99);

INSERT INTO shop.OrderItem (OrderId, ProductId, Qty, UnitPrice)
VALUES
    (1, 1, 1, 29.99), (1, 2, 1, 49.99),
    (2, 3, 1, 39.99),
    (3, 1, 1, 29.99);
GO

CREATE OR ALTER VIEW shop.vw_OrderSummary
AS
SELECT o.OrderId, c.FullName, o.OrderAt, o.StatusCode, o.TotalAmount,
       COUNT(oi.OrderItemId) AS LineCount
FROM shop.[Order] o
JOIN shop.Customer c ON c.CustomerId = o.CustomerId
LEFT JOIN shop.OrderItem oi ON oi.OrderId = o.OrderId
GROUP BY o.OrderId, c.FullName, o.OrderAt, o.StatusCode, o.TotalAmount;
GO

CREATE OR ALTER PROCEDURE shop.usp_PlaceOrder
    @CustomerId INT,
    @ProductId  INT,
    @Qty        INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Price DECIMAL(18,2), @OrderId INT;

    SELECT @Price = Price FROM shop.Product WHERE ProductId = @ProductId AND StockQty >= @Qty;
    IF @Price IS NULL THROW 54000, N'Invalid product or insufficient stock.', 1;

    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO shop.[Order] (CustomerId, StatusCode, TotalAmount)
        VALUES (@CustomerId, N'Pending', @Price * @Qty);
        SET @OrderId = SCOPE_IDENTITY();
        INSERT INTO shop.OrderItem (OrderId, ProductId, Qty, UnitPrice)
        VALUES (@OrderId, @ProductId, @Qty, @Price);
        UPDATE shop.Product SET StockQty = StockQty - @Qty WHERE ProductId = @ProductId;
        COMMIT TRAN;
        SELECT @OrderId AS NewOrderId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO

-- Reports
SELECT TOP 5 p.Name, SUM(oi.Qty * oi.UnitPrice) AS Revenue
FROM shop.Product p
JOIN shop.OrderItem oi ON oi.ProductId = p.ProductId
GROUP BY p.Name ORDER BY Revenue DESC;

SELECT * FROM shop.vw_OrderSummary ORDER BY OrderAt DESC;

PRINT N'EcommerceDB ready. See docs/14-capstone-ecommerce.md';
GO
