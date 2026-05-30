/*
================================================================================
 14 - MODULE 5 LAB: TEST PERMISSIONS & EXECUTE AS
 Prerequisite: sql/08-security-setup.sql (creates Learn_AppReader)
 WARNING: Learning passwords only — change or drop after lab.
================================================================================
*/

USE LearnSQL;
GO

PRINT N'=== MODULE 5 SECURITY LAB ===';
GO

-- ========== 1) Who am I right now? ==========
SELECT
    SUSER_SNAME() AS ServerLogin,
    USER_NAME() AS DatabaseUser,
    IS_SRVROLEMEMBER('sysadmin') AS IsSysAdmin;

-- ========== 2) Permissions for our lab principals ==========
SELECT
    pr.name AS PrincipalName,
    pr.type_desc AS PrincipalType,
    dp.permission_name,
    dp.state_desc,
    COALESCE(OBJECT_NAME(dp.major_id), SCHEMA_NAME(dp.major_id), N'database') AS Securable
FROM sys.database_principals pr
LEFT JOIN sys.database_permissions dp ON dp.grantee_principal_id = pr.principal_id
WHERE pr.name IN (N'Learn_AppReader', N'OrderReaderRole', N'db_datareader', N'public')
ORDER BY pr.name, dp.permission_name;

GO

-- ========== 3) Impersonate reader — SELECT works ==========
IF DATABASE_PRINCIPAL_ID(N'Learn_AppReader') IS NULL
BEGIN
    RAISERROR(N'Run sql/08-security-setup.sql first.', 16, 1);
    RETURN;
END
GO

EXECUTE AS USER = N'Learn_AppReader';

SELECT TOP 3 OrderId, OrderTotal FROM dbo.[Order];

-- ========== 4) Impersonate reader — DELETE should fail ==========
BEGIN TRY
    DELETE TOP (1) FROM dbo.[Order];
    PRINT N'UNEXPECTED: Delete succeeded';
END TRY
BEGIN CATCH
    PRINT N'Expected error (no DELETE permission): ' + ERROR_MESSAGE();
END CATCH;

REVERT;
GO

-- ========== 5) EXECUTE on procedure ==========
EXECUTE AS USER = N'Learn_AppReader';
EXEC dbo.usp_GetCustomerOrders @CustomerId = 1;
REVERT;
GO

-- ========== 6) Dynamic Data Masking (optional demo) ==========
IF NOT EXISTS (
    SELECT 1 FROM sys.masked_columns
    WHERE object_id = OBJECT_ID(N'dbo.Customer')
      AND COL_NAME(object_id, column_id) = N'Email'
)
BEGIN
    ALTER TABLE dbo.Customer
    ALTER COLUMN Email ADD MASKED WITH (FUNCTION = 'email()');
    PRINT N'Email column masked for non-privileged users.';
END
GO

-- Show difference: admin sees full email vs masked (if you create a low-priv viewer)
SELECT TOP 2 CustomerId, Email FROM dbo.Customer;

/*
-- Test masking as reader (reader may still see if db_datareader + UNMASK not denied):
EXECUTE AS USER = N'Learn_AppReader';
SELECT TOP 2 CustomerId, Email FROM dbo.Customer;
REVERT;
*/

-- ========== 7) LibraryDB read-only role (if capstone exists) ==========
IF DB_ID(N'LibraryDB') IS NOT NULL
BEGIN
    USE LibraryDB;

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'Library_ReadOnly' AND type = 'R')
        CREATE ROLE Library_ReadOnly;

    GRANT SELECT ON SCHEMA::library TO Library_ReadOnly;

    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'Learn_LibraryReader')
    BEGIN
        USE master;
        CREATE LOGIN Learn_LibraryReader
        WITH PASSWORD = N'Learn!Library_ChangeMe1', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
    END

    USE LibraryDB;
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'Learn_LibraryReader')
        CREATE USER Learn_LibraryReader FOR LOGIN Learn_LibraryReader;

    ALTER ROLE Library_ReadOnly ADD MEMBER Learn_LibraryReader;

    PRINT N'Library_ReadOnly role ready on LibraryDB.';

    EXECUTE AS USER = N'Learn_LibraryReader';
    SELECT TOP 3 Title, Author FROM library.Book;
    BEGIN TRY
        DELETE FROM library.Book WHERE BookId = 1;
    END TRY
    BEGIN CATCH
        PRINT N'Library delete blocked: ' + ERROR_MESSAGE();
    END CATCH;
    REVERT;
END
ELSE
    PRINT N'Skip Library section — run sql/11-capstone-library-database.sql first.';

GO

USE LearnSQL;
PRINT N'Module 5 lab complete.';
PRINT N'Test login in new SSMS window: Learn_AppReader / your password from script 08.';
GO
