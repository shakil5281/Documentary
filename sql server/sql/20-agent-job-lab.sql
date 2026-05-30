/*
================================================================================
 20 - SQL AGENT JOB LAB (Module 12)
 Requires SQL Server Agent service running.
 Express: Agent may be unavailable — read doc only if blocked.
================================================================================
*/

USE msdb;
GO

DECLARE @JobName SYSNAME = N'Learn_Maintenance_LogJob';

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @JobName)
    EXEC msdb.dbo.sp_delete_job @job_name = @JobName;
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'Learn_Maintenance_LogJob',
    @enabled = 1,
    @description = N'Learning lab - insert maintenance row';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Learn_Maintenance_LogJob',
    @step_name = N'InsertLog',
    @subsystem = N'TSQL',
    @database_name = N'LearnSQL',
    @command = N'
IF OBJECT_ID(N''dbo.MaintenanceLog'', N''U'') IS NOT NULL
    INSERT INTO dbo.MaintenanceLog (TaskName, Details)
    VALUES (N''AgentJob'', N''Ran from sql/20-agent-job-lab.sql'');
',
    @on_success_action = 1;

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Learn_Maintenance_LogJob';

EXEC msdb.dbo.sp_start_job @job_name = N'Learn_Maintenance_LogJob';

WAITFOR DELAY '00:00:03';

SELECT TOP 5 * FROM LearnSQL.dbo.MaintenanceLog ORDER BY RunAt DESC;

SELECT j.name, h.run_date, h.run_time, h.run_status
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobhistory h ON h.job_id = j.job_id
WHERE j.name = N'Learn_Maintenance_LogJob'
ORDER BY h.instance_id DESC;

PRINT N'run_status 1 = succeeded. Cleanup: sp_delete_job when done.';
GO
