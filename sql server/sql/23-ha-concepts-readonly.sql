/*
================================================================================
 23 - HA CONCEPTS (READ-ONLY DMVs) - Module 11
 AG DMVs return data only if Always On is configured.
================================================================================
*/

SELECT
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS PhysicalNode;

-- Always On groups (empty if not configured)
SELECT ag.name AS AGName, ar.replica_server_name, ars.role_desc, ars.synchronization_health_desc
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar ON ar.group_id = ag.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states ars ON ars.replica_id = ar.replica_id;

-- Log shipping (if used)
IF EXISTS (SELECT 1 FROM sys.databases WHERE is_log_shipping_primary = 1 OR is_log_shipping_secondary = 1)
    SELECT name, is_log_shipping_primary, is_log_shipping_secondary FROM sys.databases
    WHERE is_log_shipping_primary = 1 OR is_log_shipping_secondary = 1;
ELSE
    PRINT N'Log shipping not configured on this instance.';

PRINT N'For learning: read docs/part-04-advanced/11-high-availability.md';
GO
