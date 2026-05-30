# Topic 4: Caching

## What is caching?

A **cache** stores copies of data in **fast storage** (RAM) so future reads avoid slow paths (database, disk, network).

```
Without cache:  Request → App → Database (50 ms)
With cache:     Request → App → Cache hit (1 ms)
```

Caching is one of the **highest-impact** optimizations in system design.

## Where caches live

| Location | Example | Latency | Scope |
|----------|---------|---------|-------|
| **Client** | Browser cache, mobile app | ~0 ms | One user |
| **CDN** | Cloudflare, Akamai | ~10–50 ms | Geographic |
| **Application** | Redis, Memcached | ~1 ms | All users |
| **Database** | Query cache, buffer pool | ~5 ms | All queries |

This topic focuses on **application-level cache** (Redis/Memcached).

## Cache-aside (lazy loading) — most common pattern

```
READ:
  1. App checks cache
  2. Cache HIT  → return data
  3. Cache MISS → read from DB → write to cache → return data

WRITE:
  1. App writes to DB
  2. App invalidates (deletes) cache entry
```

**Pros:** Only caches data that is actually requested  
**Cons:** Cache miss = extra latency; stale data if invalidation fails

## Write-through cache

```
WRITE:
  1. App writes to cache
  2. Cache synchronously writes to DB
  3. Return success
```

**Pros:** Cache and DB always consistent  
**Cons:** Write latency = cache + DB; caches data that may never be read

## Write-back (write-behind) cache

```
WRITE:
  1. App writes to cache only
  2. Cache asynchronously flushes to DB later
```

**Pros:** Fast writes  
**Cons:** Data loss risk if cache crashes before flush — use carefully

## Comparison

| Pattern | Read | Write | Consistency | Use when |
|---------|------|-------|-------------|----------|
| Cache-aside | Fast on hit | Invalidate on write | Eventual | General purpose |
| Write-through | Fast | Slower | Strong | Read-heavy, consistency matters |
| Write-back | Fast | Fastest | Weak | Write-heavy, can tolerate loss |

**Default choice:** Cache-aside with Redis.

## Cache eviction policies

Cache memory is limited. When full, something must go:

| Policy | Behavior |
|--------|----------|
| **LRU** (Least Recently Used) | Remove oldest accessed item — most common |
| **LFU** (Least Frequently Used) | Remove least popular item |
| **FIFO** | Remove oldest added item |
| **TTL** (Time To Live) | Auto-expire after fixed time |

Most systems combine **LRU + TTL** (e.g., expire after 1 hour OR evict if memory full).

## Cache problems to know

### Cache stampede (thundering herd)
Cache expires → thousands of requests hit DB simultaneously.

**Fix:** Lock/mutex on rebuild, stale-while-revalidate, or probabilistic early refresh.

### Hot key
One key gets massive traffic (celebrity tweet, viral product).

**Fix:** Replicate hot key across cache nodes, local in-process cache for ultra-hot keys.

### Penetration
Requests for **non-existent** keys bypass cache every time (attack or bad queries).

**Fix:** Cache null results with short TTL, bloom filter to reject known-missing keys.

## What to cache

**Good candidates:**
- User profiles, product catalog
- Session data
- Computed results (leaderboards, aggregations)
- Static/semi-static content

**Bad candidates:**
- Data that changes every request
- Large blobs rarely accessed
- Sensitive data without encryption
- Write-heavy data with strict consistency needs

## Redis vs Memcached (quick comparison)

| | Redis | Memcached |
|--|-------|-----------|
| Data structures | Strings, lists, sets, sorted sets | Strings only |
| Persistence | Optional (RDB, AOF) | None |
| Replication | Yes | No |
| Use case | General cache + more | Simple pure cache |

**Default recommendation:** Redis for most new systems.

## Check yourself

1. Walk through cache-aside for a read and a write.
2. When would you use write-through over cache-aside?
3. What is cache stampede and how do you prevent it?
4. What is a hot key problem?
5. Name two things you should NOT cache.

## Key takeaway

Cache-aside with Redis + TTL is the default pattern. Always plan for invalidation, eviction, and failure (cache down → fall back to DB).
