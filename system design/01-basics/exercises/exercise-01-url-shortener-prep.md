# Exercise 1: URL Shortener (Prep)

Use everything from Topics 1–7. Spend **45 minutes**. Write answers in this file or on paper.

---

## Prompt

Design a URL shortening service like **bit.ly**.

### Functional requirements
- User submits a long URL → receives a short URL
- Visiting the short URL redirects to the original long URL
- Optional: custom alias, expiration date, click analytics

### Non-functional requirements (assume unless you change them)
- 100 million new URLs per month
- Read:write ratio = 100:1
- URLs stored for 5 years
- Redirect latency p99 < 100 ms
- 99.9% availability

---

## Step 1: Clarifying questions (5 min)

Write 3–5 questions you would ask an interviewer:

<!-- Your answers here -->
1.
2.
3.

---

## Step 2: Estimates (10 min)

Fill in (show your math):

| Metric | Your estimate |
|--------|---------------|
| Write QPS (average) | |
| Write QPS (peak) | |
| Read QPS (average) | |
| Read QPS (peak) | |
| Storage (5 years) | |
| Short code length | |

---

## Step 3: High-level design (15 min)

Draw the architecture. Include:

- [ ] Client
- [ ] Load balancer
- [ ] App servers
- [ ] Cache
- [ ] Database
- [ ] (Optional) CDN, analytics queue

Describe the **write path** (create short URL):

<!-- Your answer -->


Describe the **read path** (redirect):

<!-- Your answer -->


---

## Step 4: Data model (5 min)

What tables/collections do you need?

```
Example:
  urls (
    id,
    short_code,
    long_url,
    created_at,
    expires_at,
    user_id
  )
```

<!-- Your schema -->


How do you generate `short_code`?

<!-- Your answer -->


---

## Step 5: Deep dive (10 min)

Pick two topics and explain your choice:

### Caching strategy
Which URLs do you cache? TTL? What on cache miss?

<!-- Your answer -->


### Database choice
SQL or NoSQL? Why? Primary-replica?

<!-- Your answer -->


---

## Reference solution (check after you finish)

<details>
<summary>Click only after completing your design</summary>

### Estimates
- Write QPS: 100M / (30 × 86400) ≈ **40/sec**, peak ~**120/sec**
- Read QPS: 40 × 100 ≈ **4,000/sec**, peak ~**12,000/sec**
- Storage: 100M × 60 months × ~2.5 KB ≈ **15 TB**
- Short code: 7 chars Base62 → 3.5 trillion combinations ✓

### Architecture
```
Client → LB → App Servers → Redis (cache) → PostgreSQL (primary)
                                         ↘ Read replicas
Create: generate code → insert DB → cache entry
Redirect: check Redis → on miss check DB → 301 redirect → cache result
```

### Key decisions
- **301 vs 302 redirect:** 301 is cacheable by browsers (good for permanent links); 302 if you need every click counted server-side
- **Code generation:** Random Base62 + DB unique constraint, or counter encoded to Base62 (simpler, no collision)
- **Cache:** Cache short_code → long_url mapping; TTL 24h or LRU; cache-aside
- **DB:** PostgreSQL with unique index on short_code; read replicas for redirect reads
- **Analytics:** Async — log click events to Kafka/queue, process separately (don't slow redirect)

### Bottlenecks at scale
- Hot URLs → local cache + CDN for redirect (if 302)
- DB read load → Redis handles 99%+ of redirects
- Single primary write limit → ~10K writes/sec on PG is fine for 120 peak

</details>

---

## Self-score

| Criteria | Done? |
|----------|-------|
| Estimated QPS and storage | |
| Drew full request path | |
| Explained cache-aside for redirects | |
| Picked SQL or NoSQL with reason | |
| Mentioned analytics as async | |

**4–5 checked:** Ready for intermediate topics.  
**2–3 checked:** Re-read Topics 4, 5, and 7.  
**0–1 checked:** Re-read all basics, then retry.
