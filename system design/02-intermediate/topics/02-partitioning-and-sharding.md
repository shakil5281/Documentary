# Topic 2: Partitioning & Sharding

## When one database is not enough

A single PostgreSQL node handles roughly:
- **~10K writes/sec** (depends on row size, indexes)
- **~1–4 TB** practical storage before management pain

Beyond that → **partition** (split) data across multiple nodes.

---

## Partitioning vs sharding

| Term | Meaning |
|------|---------|
| **Partitioning** | Splitting data within one DB (tables, ranges) |
| **Sharding** | Splitting data across **multiple separate databases** |

In practice, "sharding" is used for horizontal split across servers.

---

## Sharding strategies

### Hash-based sharding

```
shard_id = hash(user_id) % num_shards

user_id 12345 → hash → shard 2
user_id 67890 → hash → shard 1
```

**Pros:** Even distribution  
**Cons:** Resharding is painful when adding shards (most keys remap)

**Fix for resharding:** Consistent hashing — only K/N keys move when adding a node.

### Range-based sharding

```
user_id 1–1M      → Shard A
user_id 1M–2M     → Shard B
user_id 2M–3M     → Shard C
```

**Pros:** Range queries easy (e.g., date ranges)  
**Cons:** Hot spots — new users all hit latest shard

### Directory-based sharding

Lookup table maps key → shard.

```
short_code "abc123" → lookup → Shard 7
```

**Pros:** Flexible, easy resharding  
**Cons:** Lookup service is extra dependency and potential bottleneck

---

## Choosing a shard key

The shard key determines which shard owns a row. **This is the most important decision.**

### Good shard keys
- **user_id** — most queries are per-user (profiles, messages, orders)
- **tenant_id** — in multi-tenant SaaS
- **Has high cardinality** — many distinct values

### Bad shard keys
- **country** — US has 10× traffic of others → hot shard
- **created_at** — all new data hits one shard
- **status** — "active" vs "inactive" is low cardinality

### Co-location rule
Put data that is **queried together** on the same shard.

```
Good:  user_id shards posts, comments, likes together
Bad:   posts sharded by post_id, comments by user_id → cross-shard joins
```

---

## Consistent hashing

When you add/remove shards, plain `hash % N` remaps **almost every key**.

Consistent hashing places shards and keys on a **ring**:

```
         Key K
           ↓
    ──●────────●──●────────●──  (ring)
      S1       S2  S3       S4

Key K maps to first shard clockwise from its hash position
```

Adding S5 only moves keys between S4 and S5 — not the entire keyspace.

Used by: Cassandra, DynamoDB, Redis Cluster, CDNs.

---

## Cross-shard operations

### Single-shard query (ideal)
```
GET user 12345's posts  → hash(12345) → Shard 2 → done
```

### Cross-shard query (expensive)
```
GET top 10 posts globally  → query ALL shards → merge → sort
```

**Avoid cross-shard queries in hot paths.** Use:
- Denormalized aggregates (pre-computed leaderboard per shard)
- Separate analytics DB (ETL from all shards)
- Scatter-gather with strict timeouts

---

## Resharding

Triggers:
- Shard out of disk space
- One shard overloaded (hot spot)
- Need more write capacity

Steps:
1. Add new shards
2. Dual-write to old and new (migration period)
3. Backfill historical data
4. Switch reads to new mapping
5. Stop dual-write, decommission old

**Plan for resharding from day one** — use consistent hashing or directory-based mapping.

---

## Sharding vs other scaling tools

Try in this order before sharding:

```
1. Indexes + query optimization
2. Read replicas (read scaling)
3. Caching (Redis)
4. Vertical scaling (bigger machine)
5. Sharding (write scaling + storage)
```

Sharding adds **operational complexity**. Don't shard prematurely.

---

## Real-world examples

| System | Shard key | Why |
|--------|-----------|-----|
| Instagram DMs | user pair / thread id | Messages queried per conversation |
| Uber rides | city/region | Geo-localized queries |
| Slack workspaces | workspace_id | All data scoped to workspace |
| Twitter tweets | tweet_id or user_id | Depends on access pattern |

---

## Check yourself

1. Hash vs range sharding — pros and cons?
2. Why is `country` a bad shard key for a global app?
3. What is consistent hashing and why does it help resharding?
4. Why are cross-shard queries expensive?
5. What should you try before sharding?

## Key takeaway

Shard by the **most common query pattern** (usually `user_id`). Avoid cross-shard hot-path queries. Use consistent hashing when nodes are added frequently.
