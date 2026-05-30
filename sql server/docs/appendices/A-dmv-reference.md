# Appendix A — DMV Quick Reference

| DMV | Returns |
|-----|---------|
| `sys.dm_exec_sessions` | Sessions (login, host, status) |
| `sys.dm_exec_requests` | Active requests, `blocking_session_id`, `wait_type` |
| `sys.dm_exec_sql_text(sql_handle)` | SQL text for handle |
| `sys.dm_os_wait_stats` | Cumulative waits since restart |
| `sys.dm_db_index_usage_stats` | Seeks/scans/lookups per index |
| `sys.dm_db_missing_index_details` | Suggested indexes (verify before creating) |
| `sys.dm_db_index_physical_stats` | Fragmentation, page counts |
| `sys.dm_tran_locks` | Lock granularity and resource |

## Quick queries

```sql
-- Who is connected?
SELECT session_id, login_name, host_name, program_name FROM sys.dm_exec_sessions WHERE is_user_process = 1;

-- Blocking
SELECT * FROM sys.dm_exec_requests WHERE blocking_session_id <> 0;

-- Top waits
SELECT TOP 10 wait_type, wait_time_ms FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE 'SLEEP%' ORDER BY wait_time_ms DESC;
```

## Scripts

- [12-module03-server-monitoring.sql](../../sql/12-module03-server-monitoring.sql)
- [19-extended-events-lab.sql](../../sql/19-extended-events-lab.sql)
