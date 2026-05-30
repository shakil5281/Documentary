/*
================================================================================
 08 - SECURITY SETUP (LEARNING LAB ONLY)
 *** PRODUCTION WARNING: Do not run unchanged on production. ***
 Change passwords. Review logins after practice.
 Prerequisite: 01-create-sample-database.sql
================================================================================
*/

USE master;
GO

-- ========== Create SQL login (learning) ==========
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'Learn_AppReader')
BEGIN
    CREATE LOGIN Learn_AppReader
    WITH PASSWORD = N'Learn!Reader_ChangeMe1',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = OFF;
    PRINT N'Created login Learn_AppReader';
END
GO

USE LearnSQL;
GO

-- ========== Database user + role ==========
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'Learn_AppReader')
BEGIN
    CREATE USER Learn_AppReader FOR LOGIN Learn_AppReader;
    ALTER ROLE db_datareader ADD MEMBER Learn_AppReader;
    PRINT N'Mapped user to db_datareader';
END
GO

-- ========== Custom role: read orders only ==========
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'OrderReaderRole' AND type = 'R')
    CREATE ROLE OrderReaderRole;
GO

GRANT SELECT ON dbo.[Order] TO OrderReaderRole;
GRANT SELECT ON dbo.OrderLine TO OrderReaderRole;
GRANT SELECT ON dbo.Customer TO OrderReaderRole;
DENY DELETE, INSERT, UPDATE ON dbo.[Order] TO OrderReaderRole;

IF DATABASE_PRINCIPAL_ID(N'Learn_AppReader') IS NOT NULL
    ALTER ROLE OrderReaderRole ADD MEMBER Learn_AppReader;
GO

-- ========== Grant execute on procedure ==========
GRANT EXECUTE ON dbo.usp_GetCustomerOrders TO Learn_AppReader;
GO

-- ========== Test as reader (run in new query window as Learn_AppReader) ==========
/*
EXECUTE AS USER = 'Learn_AppReader';
SELECT TOP 5 * FROM dbo.[Order];
REVERT;
*/

-- ========== List effective permissions ==========
SELECT
    dp.class_desc,
    OBJECT_NAME(dp.major_id) AS ObjectName,
    dp.permission_name,
    dp.state_desc,
    pr.name AS PrincipalName
FROM sys.database_permissions dp
LEFT JOIN sys.database_principals pr ON pr.principal_id = dp.grantee_principal_id
WHERE pr.name IN (N'Learn_AppReader', N'OrderReaderRole', N'public')
ORDER BY pr.name, dp.permission_name;

-- ========== Cleanup (uncomment when done learning) ==========
/*
USE LearnSQL;
DROP USER IF EXISTS Learn_AppReader;
USE master;
DROP LOGIN IF EXISTS Learn_AppReader;
*/

GO
