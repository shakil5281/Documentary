# Topic 5: Databases Fundamentals

## Why databases matter in system design

The database is usually the **first bottleneck** at scale. Most design decisions eventually come down to: how is data stored, queried, and replicated?

## SQL vs NoSQL

### SQL (relational) — PostgreSQL, MySQL

Data in **tables** with rows, columns, and **relationships**.

```
users          posts
─────          ─────
id             id
name           user_id  → FK to users.id
email          title
               body
```

**Pros:** ACID transactions, complex joins, strong consistency, mature tooling  
**Cons:** Harder to scale writes horizontally, rigid schema

**Use when:** Financial data, orders, anything needing transactions and joins

### NoSQL — four main types

| Type | Examples | Data model | Best for |
|------|----------|------------|----------|
| **Key-value** | Redis, DynamoDB | `{key: value}` | Sessions, caching, simple lookups |
| **Document** | MongoDB, CouchDB | JSON documents | Flexible schemas, content |
| **Column-family** | Cassandra, HBase | Wide columns | Time-series, analytics at scale |
| **Graph** | Neo4j | Nodes + edges | Social graphs, recommendations |

**Pros:** Horizontal scaling, flexible schema, high write throughput  
**Cons:** Weaker transactions (often), no joins, eventual consistency

**Use when:** Massive scale, flexible schema, simple access patterns

### Decision guide

```
Need ACID transactions + complex queries?  → SQL
Need massive write scale + simple key lookups?  → NoSQL key-value / wide-column
Need flexible nested documents?  → Document DB
Need relationship traversal?  → Graph DB
```

Many production systems use **both** — PostgreSQL for core data, Redis for cache, Cassandra for feeds.

## ACID (SQL databases)

| Property | Meaning |
|----------|---------|
| **Atomicity** | All or nothing — transaction completes fully or rolls back |
| **Consistency** | Data follows all rules (constraints) before and after |
| **Isolation** | Concurrent transactions don't interfere |
| **Durability** | Committed data survives crashes |

Critical for payments, inventory, account balances.

## Indexing

An **index** is a sorted lookup structure (usually B-tree) that speeds up reads at the cost of slower writes and extra storage.

```sql
-- Without index: scan all 10M rows → slow
SELECT * FROM users WHERE email = 'alice@example.com';

-- With index on email: direct lookup → fast
CREATE INDEX idx_users_email ON users(email);
```

**Rules:**
- Index columns used in `WHERE`, `JOIN`, `ORDER BY`
- Too many indexes slow writes
- Composite index `(user_id, created_at)` helps queries filtering both

## Replication

Copy data to **multiple database servers**.

### Primary-replica (leader-follower)

```
        Writes
          ↓
      [Primary] ──replicate──→ [Replica 1]
           │                 [Replica 2]
           │                 [Replica 3]
        Reads can go to replicas (with slight lag)
```

- **Primary** handles all writes
- **Replicas** handle reads (scale read traffic)
- **Replication lag** — replicas may be milliseconds behind; reads can be stale

**Use when:** Read-heavy workloads (90%+ reads)

### Failover

If primary dies, promote a replica to primary.

- **Manual failover** — human decides (slower, safer)
- **Automatic failover** — system promotes replica (faster, risk of split-brain)

## Partitioning / Sharding (intro)

When one database is too big or too slow, **split data across multiple databases**.

```
Shard by user_id:
  user_id 1–1M    → Database A
  user_id 1M–2M   → Database B
  user_id 2M–3M   → Database C
```

**Shard key** choice is critical — bad key (e.g., by country) creates hot shards.

Deep dive in intermediate module. For now: **sharding = horizontal split of data**.

## Normalization vs denormalization

### Normalized (SQL default)
No duplicate data. Separate tables linked by foreign keys.

- Less storage, easier updates
- Joins required for queries

### Denormalized
Duplicate data to avoid joins.

```
posts table includes author_name (copied from users)
→ faster reads, harder updates when name changes
```

**At scale:** Often denormalize for read performance; accept eventual consistency on copies.

## Connection pooling

Opening a DB connection is expensive. A **connection pool** reuses open connections.

```
App Server → [Pool: 20 connections] → Database
```

Without pooling: 1000 app threads = 1000 DB connections → database overwhelmed.

## Check yourself

1. When would you pick SQL over NoSQL?
2. What does each letter in ACID mean?
3. Explain primary-replica replication. What is replication lag?
4. Why do indexes speed reads but slow writes?
5. What is sharding and why does shard key choice matter?

## Key takeaway

Start with **PostgreSQL** for most systems. Add **read replicas** when reads dominate. Plan **sharding** only when a single primary cannot handle writes. Cache hot reads in Redis.
