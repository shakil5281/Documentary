# Topic 2: Scalability & Performance

## Scalability vs performance

| Term | Meaning |
|------|---------|
| **Performance** | How fast **one** request completes (latency, throughput of one machine) |
| **Scalability** | How well the system handles **more load** by adding resources |

A fast system on one server is not necessarily scalable. A scalable system may accept slightly higher latency per request to serve millions of users.

## Vertical vs horizontal scaling

### Vertical scaling (scale up)
Add more CPU, RAM, or disk to **one** machine.

- **Pros:** Simple, no code changes
- **Cons:** Hardware limits, single point of failure, expensive at top end

### Horizontal scaling (scale out)
Add **more machines** and distribute work.

- **Pros:** No hard ceiling, fault tolerance, cost-effective at large scale
- **Cons:** Requires load balancing, distributed data, more complexity

**Rule of thumb:** Start vertical for small scale; plan horizontal for growth.

```
Vertical:   [Server 32GB]  →  [Server 128GB]

Horizontal: [Server]  →  [Server] [Server] [Server]
                              ↑
                         Load Balancer
```

## Latency vs throughput

- **Latency** — time for **one** operation (measured in ms). Users feel this.
- **Throughput** — **how many** operations per second (QPS/TPS). Business capacity.

They are related but not the same:

- High throughput with batching can increase latency for individual requests
- Optimizing latency (caching) often improves throughput too

### Percentiles matter

Average latency hides bad experiences. Use **p50, p95, p99**:

| Percentile | Meaning |
|------------|---------|
| p50 (median) | Half of requests are faster than this |
| p95 | 95% of requests are faster — catches most outliers |
| p99 | Worst 1% — often where bugs and overload show up |

**Target p99**, not average, for user-facing systems.

## Stateless vs stateful servers

### Stateless
Server holds **no user session data** between requests. Any server can handle any request.

- Easy to scale horizontally
- Session data stored in cache or database instead

### Stateful
Server holds session/state in memory (e.g., WebSocket connection, in-memory session).

- Harder to scale — need sticky sessions or state migration
- Used when necessary (real-time games, long-lived connections)

**Best practice:** Prefer stateless app servers; externalize state to Redis/DB.

## Common bottlenecks (in order they usually appear)

1. **Database** — too many reads/writes on one node
2. **Network** — bandwidth or round-trip latency
3. **CPU** — heavy computation (encoding, ML inference)
4. **Disk I/O** — slow writes, full disks
5. **Single server** — no redundancy

Fix order: measure first, then cache → read replicas → sharding → async processing.

## Performance optimization layers

```
Layer 1: Algorithm & code efficiency     (cheapest win)
Layer 2: Caching                         (huge win for reads)
Layer 3: Database indexes & query tuning
Layer 4: Read replicas & connection pooling
Layer 5: Horizontal scaling + sharding
Layer 6: Async processing (queues)
```

Always optimize **measured bottlenecks**, not guesses.

## CAP theorem (basic version)

In a **network partition** (servers can't talk reliably), you choose between:

- **Consistency** — all nodes see the same data at the same time
- **Availability** — every request gets a response

You cannot have both during a partition. In practice:

- Banks, inventory → favor **consistency**
- Social feeds, likes count → often favor **availability** (eventual consistency)

Full deep dive comes in intermediate module. For now: **know the trade-off exists**.

## Check yourself

1. Vertical vs horizontal scaling — pros and cons of each?
2. Why is p99 more important than average latency?
3. Why are stateless servers easier to scale?
4. Name three common bottlenecks in order.
5. What does CAP force you to choose during a network partition?

## Key takeaway

Scale **out** with stateless servers; measure **p99 latency**; fix bottlenecks layer by layer.
