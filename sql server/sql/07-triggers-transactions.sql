/*
================================================================================
 07 - TRIGGERS AND TRANSACTIONS
 Prerequisite: 01-create-sample-database.sql
================================================================================
*/

USE LearnSQL;
GO

-- ========== AFTER INSERT trigger (audit) ==========
CREATE OR ALTER TRIGGER dbo.tr_Order_AuditInsert
ON dbo.[Order]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.OrderAudit (OrderId, Action)
    SELECT OrderId, N'INSERT' FROM inserted;
END;
GO

-- ========== Transaction success ==========
BEGIN TRY
    BEGIN TRANSACTION;

        INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
        VALUES (3, '2026-05-30', 150.00, N'OP');

    COMMIT TRANSACTION;
    PRINT N'Transaction committed.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- ========== Transaction rollback (constraint violation) ==========
BEGIN TRY
    BEGIN TRANSACTION;

        INSERT INTO dbo.[Order] (CustomerId, OrderDate, OrderTotal, StatusCode)
        VALUES (99999, '2026-05-30', 10.00, N'OP');  -- invalid FK

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT N'Expected rollback: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ========== Isolation level demo ==========
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
    SELECT COUNT(*) AS OrderCount FROM dbo.[Order];
COMMIT TRAN;

-- ========== Audit log ==========
SELECT TOP (20) * FROM dbo.OrderAudit ORDER BY ActionAt DESC;

GO
