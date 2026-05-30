# Topic 7: Back-of-Envelope Math

System design interviews and real architecture both require **quick estimates**. You don't need exact numbers — order of magnitude is enough.

## Powers of 10 to memorize

| Number | Name | Example |
|--------|------|---------|
| 10³ | 1 thousand | 1 KB |
| 10⁶ | 1 million | 1 MB, 1 million users |
| 10⁹ | 1 billion | 1 GB, 1 billion requests/day |
| 10¹² | 1 trillion | 1 TB |

**Time:**
- 1 day = 86,400 seconds ≈ **100,000 seconds** (use 100K for estimates)
- 1 month ≈ 2.5 million seconds

## Latency numbers (approximate)

| Operation | Latency |
|-----------|---------|
| L1 cache reference | 1 ns |
| RAM reference | 100 ns |
| SSD random read | 100 μs (0.1 ms) |
| Network (same datacenter) | 0.5 ms |
| Disk seek | 10 ms |
| Network (cross-continent) | 100 ms |

**Rule:** Memory is ~1000× faster than SSD. Network inside DC is fast; cross-region is slow.

## The estimation framework

For any system, estimate four things:

1. **Traffic** — QPS (queries per second)
2. **Storage** — total data size over time
3. **Bandwidth** — data in/out per second
4. **Memory** — cache size needed

---

## Example 1: Twitter-like post creation

**Given:** 300M daily active users (DAU), each user creates 2 posts/day on average.

### Write QPS

```
Posts/day = 300M × 2 = 600M posts/day
QPS (writes) = 600M / 100K seconds ≈ 6,000 writes/sec
Peak (3× average) ≈ 18,000 writes/sec
```

### Storage (5 years)

```
Assume per post: 500 bytes text + 200 bytes metadata = 700 bytes
Daily storage = 600M × 700 B ≈ 420 GB/day
5 years ≈ 420 GB × 365 × 5 ≈ 750 TB
```

### Read QPS (assume 100 reads per post created)

```
Read QPS = 6,000 × 100 = 600,000 reads/sec → need heavy caching + replicas
```

---

## Example 2: URL shortener

**Given:** 100M new URLs/month, read:write ratio = 100:1, store URLs for 5 years.

### Write QPS

```
100M URLs/month ≈ 100M / (30 × 100K) ≈ 100M / 3M ≈ 33 writes/sec
Peak ≈ 100 writes/sec
```

### Read QPS

```
33 × 100 ≈ 3,300 reads/sec
Peak ≈ 10,000 reads/sec
```

### Storage

```
Assume: original URL (2 KB avg) + short code + metadata ≈ 2.5 KB
100M/month × 2.5 KB × 60 months (5 yr) ≈ 15 TB
```

### Short code length

```
Need enough unique codes:
  100M/month × 60 months = 6 billion URLs
  Base62 (a-z, A-Z, 0-9): 62^7 ≈ 3.5 trillion → 7 characters is enough
```

---

## Example 3: Cache sizing

**Given:** 1M active products, each product cache entry = 1 KB.

```
Cache size = 1M × 1 KB = 1 GB
```

If only 20% of products are hot (80/20 rule):

```
0.2 × 1M × 1 KB = 200 MB → easily fits in Redis
```

---

## Bandwidth estimate

```
Bandwidth = QPS × average response size

Example: 10,000 QPS × 50 KB response = 500 MB/sec ≈ 4 Gbps
```

Plan network capacity above peak. CDN reduces origin bandwidth for static content.

## Useful shortcuts

| Shortcut | Value |
|----------|-------|
| Seconds per day | ~100K |
| Seconds per month | ~2.5M |
| 1 KB × 1M | 1 GB |
| 1 MB × 1M | 1 TB |
| Peak traffic | 2–3× average |
| 80/20 rule | 20% of items get 80% of traffic |

## Sanity checks

After estimating, ask:

- Does this QPS fit on one server? (One server ≈ 1K–10K QPS depending on work)
- Does storage fit one disk? (Single SSD ≈ 1–4 TB; need sharding above that)
- Does cache fit in RAM? (Redis node ≈ 10–64 GB typical)
- Is bandwidth realistic for one datacenter?

If any answer is "no" → you need horizontal scaling, sharding, or CDN.

## Practice problems

Do these without looking at answers. Spend 10 min each.

### Problem A
**Instagram-like:** 500M DAU, each user uploads 1 photo/day. Average photo 2 MB stored. Estimate write QPS and 5-year storage.

<details>
<summary>Hints</summary>

Write QPS ≈ 500M / 100K ≈ 5,000/sec. Daily storage ≈ 500M × 2 MB = 1 PB/day — that's why Instagram uses object storage (S3), not a database.
</details>

### Problem B
**Chat app:** 50M DAU, each sends 50 messages/day. Average message 200 bytes. Estimate write QPS and daily storage.

<details>
<summary>Hints</summary>

Messages/day = 50M × 50 = 2.5B. Write QPS ≈ 25,000/sec. Daily storage ≈ 2.5B × 200 B = 500 GB/day.
</details>

## Check yourself

1. How many seconds in a day (for estimates)?
2. Write QPS formula from daily events.
3. Why use peak (2–3×) instead of average?
4. For URL shortener, how many Base62 chars for 6 billion URLs?
5. What four things do you estimate for every design?

## Key takeaway

Always estimate **QPS, storage, bandwidth, cache** before drawing architecture. Round aggressively — precision is not the goal, **correct order of magnitude** is.
