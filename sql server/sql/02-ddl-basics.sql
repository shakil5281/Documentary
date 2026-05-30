/*
================================================================================
 02 - DDL BASICS (Data Definition Language)
 Prerequisite: sql/01 | Exercises: exercises/module-02.md
================================================================================
*/

USE LearnSQL;
GO

-- ========== ALTER TABLE: add column ==========
IF COL_LENGTH('dbo.Customer', 'Notes') IS NULL
BEGIN
    ALTER TABLE dbo.Customer
    ADD Notes NVARCHAR(500) NULL;
    PRINT N'Added column Customer.Notes';
END
GO

-- ========== DEFAULT constraint ==========
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = N'DF_Customer_Notes')
BEGIN
    ALTER TABLE dbo.Customer
    ADD CONSTRAINT DF_Customer_Notes DEFAULT (N'') FOR Notes;
END
GO

-- ========== CHECK constraint ==========
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_Order_Status')
BEGIN
    ALTER TABLE dbo.[Order]
    ADD CONSTRAINT CK_Order_Status CHECK (StatusCode IN ('OP','PD','CN','SH'));
END
GO

-- ========== CREATE INDEX (nonclustered) ==========
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Order_OrderDate' AND object_id = OBJECT_ID(N'dbo.[Order]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Order_OrderDate
    ON dbo.[Order] (OrderDate DESC);
    PRINT N'Created IX_Order_OrderDate';
END
GO

-- ========== CREATE SCHEMA (namespace) ==========
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'reporting')
    EXEC(N'CREATE SCHEMA reporting AUTHORIZATION dbo;');
GO

-- ========== CREATE TABLE in schema ==========
IF OBJECT_ID(N'reporting.DailyOrderSummary', N'U') IS NULL
BEGIN
    CREATE TABLE reporting.DailyOrderSummary (
        SummaryDate  DATE NOT NULL,
        OrderCount   INT  NOT NULL,
        Revenue      DECIMAL(18,2) NOT NULL,
        CONSTRAINT PK_DailyOrderSummary PRIMARY KEY (SummaryDate)
    );
END
GO

-- ========== DROP (commented - dangerous) ==========
-- DROP TABLE reporting.DailyOrderSummary;
-- DROP SCHEMA reporting;

-- ========== Verify structure ==========
SELECT
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME IN (N'Customer', N'Order', N'Product', N'OrderLine')
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;
GO

/* ========== EXERCISE BLOCK (Module 02) ==========
-- Add column Fax NVARCHAR(30) NULL to dbo.Customer if not exists
-- Create index IX_Customer_FullName on dbo.Customer(FullName)
========== end exercise block ========== */
