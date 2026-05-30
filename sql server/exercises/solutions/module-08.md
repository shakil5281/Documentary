# Module 08 Solutions

1. Example: RPO 15 min (log backups every 15 min); RTO 1 hour (failover + verify).
2. `BACKUP DATABASE LearnSQL TO DISK = N'C:\Temp\SqlBackups\learn.bak' WITH COMPRESSION, CHECKSUM;`
3. `DBCC CHECKDB (LearnSQL);`
4. Student-specific; include full weekly + log schedule.
