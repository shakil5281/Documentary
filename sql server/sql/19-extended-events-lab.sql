/*
================================================================================
 19 - EXTENDED EVENTS LAB (Module 10)
 Captures completed SQL batches. Dev instance only.
 SQL Server 2016+
================================================================================
*/

USE master;
GO

DECLARE @SessionName SYSNAME = N'LearnXE_QueryCapture';

IF EXISTS (SELECT 1 FROM sys.server_event_sessions WHERE name = @SessionName)
    DROP EVENT SESSION [LearnXE_QueryCapture] ON SERVER;
GO

CREATE EVENT SESSION [LearnXE_QueryCapture] ON SERVER
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.database_name, sqlserver.sql_text, sqlserver.username)
    WHERE ([sqlserver].[database_name] = N'LearnSQL'))
ADD TARGET package0.event_file(
    SET filename = N'C:\Temp\LearnXE_QueryCapture.xel',
        max_file_size = (10))
WITH (MAX_MEMORY = 4 MB, EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
      STARTUP_STATE = OFF);
GO

ALTER EVENT SESSION [LearnXE_QueryCapture] ON SERVER STATE = START;
GO

USE LearnSQL;
SELECT TOP 10 * FROM dbo.Customer;
SELECT COUNT(*) FROM dbo.[Order];
GO

ALTER EVENT SESSION [LearnXE_QueryCapture] ON SERVER STATE = STOP;
GO

SELECT
    CAST(event_data AS XML) AS EventXml
FROM sys.fn_xe_file_target_read_file(N'C:\Temp\LearnXE_QueryCapture*.xel', NULL, NULL, NULL);

PRINT N'Create C:\Temp if missing. Review EventXml for statement text.';
GO
