# Topic 5: Design — News Feed (Twitter/Instagram)

A classic intermediate design. Tests caching, fan-out, consistency trade-offs, and sharding.

---

## Requirements

### Functional
- Users follow other users
- Users create posts (text, optional media)
- Users see a **timeline/feed** of posts from people they follow
- Posts are reverse-chronological (newest first)

### Non-functional (typical assumptions)
- 300M DAU, 200M posts/day
- Read:write ≈ 100:1 (feed reads dominate)
- Feed load p99 < 500 ms
- Eventual consistency OK for feed (slight delay acceptable)

---

## Estimates

```
Write QPS = 200M / 100K ≈ 2,000 posts/sec (peak ~6,000)

Read QPS = 2,000 × 100 = 200,000 feed reads/sec (peak ~600,000)
  → Must cache aggressively

Storage (5 years):
  200M posts/day × 1 KB avg × 365 × 5 ≈ 350 TB
  → Sharded post storage + object storage for media
```

---

## High-level architecture

```
                    ┌─── Feed Service
Client → LB → API ─┼─── Post Service
                    └─── Social Graph Service
                              │
                    ┌─────────┼─────────┐
                    ↓         ↓         ↓
                 Redis     PostgreSQL   Kafka
              (timelines)  (posts,       (fan-out
                          follows)       events)
                              ↓
                         Object Storage (S3)
                         for images/video
```

---

## Core data models

### Users
```
users (id, name, avatar_url, created_at)
```

### Follows (social graph)
```
follows (follower_id, followee_id, created_at)
INDEX on follower_id  — "who does Alice follow?"
INDEX on followee_id  — "who follows Bob?" (for fan-out)
```

**Storage options:**
- PostgreSQL for moderate scale
- Dedicated graph store (Neo4j) or Redis sets at very large scale

### Posts
```
posts (id, user_id, content, media_url, created_at)
Sharded by user_id or post_id
```

### Feed / Timeline
Pre-computed list of post IDs per user (not computed on every read).

```
feed:user_123 = [post_9, post_7, post_3, ...]   (Redis sorted set or list)
```

---

## The fan-out problem

When user A with 1M followers posts, how do 1M feeds get updated?

### Approach 1: Fan-out on write (push model)

```
A posts → Worker pushes post_id into every follower's feed cache
```

| Pros | Cons |
|------|------|
| Fast reads (pre-built feed) | Slow write for celebrities (1M followers) |
| Simple read path | Wasted work if follower never opens app |

**Hybrid (used by Twitter/Instagram):**
- **Regular users** (< 10K followers): fan-out on write
- **Celebrities**: fan-out on read — merge celebrity posts at read time

### Approach 2: Fan-out on read (pull model)

```
A posts → stored in A's post list only
User B opens feed → fetch posts from all B's followees → merge + sort
```

| Pros | Cons |
|------|------|
| Fast writes | Slow reads (fetch from 500 accounts) |
| No wasted fan-out | Complex, high read latency |

**Use for:** Low-follow-count users or celebrity accounts only.

### Hybrid timeline (recommended)

```
WRITE (regular user):
  1. Save post to DB
  2. Publish to Kafka topic "fan-out"
  3. Fan-out workers push to follower feeds in Redis

WRITE (celebrity):
  1. Save post to DB only (skip fan-out)

READ:
  1. Fetch pre-computed feed from Redis (posts from regular users)
  2. Fetch recent posts from celebrity accounts B follows
  3. Merge, sort by timestamp, paginate
  4. Hydrate post details (batch fetch from post store)
```

---

## Read path (detailed)

```
GET /feed?cursor=xyz&limit=20

1. Auth → get user_id
2. Redis: ZREVRANGE feed:user_id cursor limit  → post_ids
3. Fetch celebrity posts (parallel, last 24h)
4. Merge + sort → top 20 post_ids
5. Batch get post content: mget posts:{id} from cache/DB
6. Batch get author info from cache
7. Return JSON
```

**Cache feed in Redis** with TTL. On miss → rebuild from DB (expensive, rare).

---

## Write path (detailed)

```
POST /posts  { content, media }

1. Validate, upload media to S3 (async or sync)
2. INSERT post into DB (get post_id)
3. Publish event: { post_id, user_id, follower_count, created_at }
4. Return 201 immediately

Fan-out worker (async):
  IF follower_count < 10,000:
    Get follower list (paginated batches)
    For each follower: ZADD feed:{follower_id} timestamp post_id
  ELSE:
    Skip (celebrity — handled on read)
```

---

## Pagination

Use **cursor-based** pagination on feed:

```
GET /feed?cursor=1700000000:post_999&limit=20

Cursor = last seen (timestamp, post_id) tuple
Redis: ZREVRANGEBYSCORE feed:user_id cursor -inf LIMIT 20
```

---

## Hot keys and scaling

| Problem | Solution |
|---------|----------|
| Celebrity post fan-out | Hybrid model — skip fan-out |
| Hot feed cache | Redis cluster, replicate hot keys |
| Feed read QPS | Redis + CDN not applicable (personalized) — scale Redis |
| Post storage | Shard by user_id, media on S3 |

---

## Check yourself

1. Fan-out on write vs read — trade-offs?
2. Why use a hybrid model for celebrities?
3. What data structure stores a user's feed in Redis?
4. Walk through the read path for GET /feed.
5. Why cursor pagination over offset for feeds?

## Key takeaway

Pre-compute feeds with **fan-out on write** for most users. Handle celebrities with **fan-out on read**. Cache timelines in Redis; store posts in sharded DB + S3.
