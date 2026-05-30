# Module 10 Solutions

```sql
SELECT * FROM sys.dm_exec_requests WHERE blocking_session_id <> 0;

SELECT TOP 5 wait_type, wait_time_ms FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP%' ORDER BY wait_time_ms DESC;
```

3. Typically `sql_statement_completed` or `rpc_completed` per lab script.
4. XE for targeted low-overhead capture; Activity Monitor for quick live glance.
