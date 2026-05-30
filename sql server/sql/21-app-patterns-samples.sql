/*
================================================================================
 21 - APP INTEGRATION PATTERNS (Module 06)
 Isolation level demo. Run in SSMS with two windows for blocking demo.
================================================================================
*/

USE LearnSQL;
GO

-- Default isolation
SELECT CASE transaction_isolation_level
    WHEN 0 THEN 'Unspecified'
    WHEN 1 THEN 'ReadUncommitted'
    WHEN 2 THEN 'ReadCommitted'
    WHEN 3 THEN 'RepeatableRead'
    WHEN 4 THEN 'Serializable'
    WHEN 5 THEN 'Snapshot'
END AS CurrentIsolation
FROM sys.dm_exec_sessions WHERE session_id = @@SPID;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
    SELECT COUNT(*) AS CustomerCount FROM dbo.Customer WITH (HOLDLOCK);
    -- In another session try UPDATE a customer — may block until COMMIT
COMMIT TRAN;

-- Snapshot requires DB option (optional)
IF (SELECT snapshot_isolation_state FROM sys.databases WHERE name = N'LearnSQL') = 0
BEGIN
    ALTER DATABASE LearnSQL SET ALLOW_SNAPSHOT_ISOLATION ON;
    PRINT N'Snapshot isolation enabled for LearnSQL.';
END

-- Parameterized pattern (what apps should emit)
DECLARE @CustomerId INT = 1;
SELECT OrderId, OrderTotal FROM dbo.[Order] WHERE CustomerId = @CustomerId;

PRINT N'Apps: always parameterize; avoid string concat of user input.';
GO
