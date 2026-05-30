# Exercise 1: Design a News Feed (45 min)

Timed practice. Do not look at Topic 5 until finished.

---

## Prompt

Design the home timeline for a Twitter-like app.

**Scale:** 100M DAU, 100M posts/day, average user follows 200 accounts, 10% of users have > 100K followers.

**Requirements:**
- Create post, view home feed (newest first)
- Follow/unfollow users
- Feed p99 latency < 300 ms

---

## Your design

### Step 1: Estimates (8 min)

| Metric | Value |
|--------|-------|
| Write QPS | |
| Read QPS | |
| 5-year storage | |

### Step 2: Architecture diagram (10 min)

Draw boxes and arrows here (or on paper):

```
[paste or describe your diagram]
```

### Step 3: Fan-out strategy (10 min)

Which approach and why? How do you handle celebrities?

<!-- Your answer -->

### Step 4: Data model (7 min)

Tables/caches needed:

<!-- Your answer -->

### Step 5: Read & write paths (10 min)

**Create post:**

<!-- Your answer -->

**Load feed:**

<!-- Your answer -->

---

## Self-check (after comparing with Topic 5)

- [ ] Estimated read QPS >> write QPS
- [ ] Chose fan-out on write with celebrity exception
- [ ] Redis sorted set for pre-computed feeds
- [ ] Cursor-based pagination
- [ ] Posts sharded, media on object storage
- [ ] Async fan-out via queue (not blocking POST response)

**Score 5–6:** Strong intermediate level.  
**Score 3–4:** Re-read Topics 1, 3, and 5.  
**Score 0–2:** Review 01-basics caching and DB topics first.
