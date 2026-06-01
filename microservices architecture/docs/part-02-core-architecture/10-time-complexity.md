# 10 — Time Complexity in Distributed Systems

> **Part:** II Core Architecture | **Week:** 8 | **Exercises:** [module-10](../../exercises/module-10.md)

## Learning outcomes

After this module you can:

1. Apply Big O intuition to microservices communication patterns
2. Compare sequential sync chains vs parallel fan-out complexity
3. Analyze Saga, event replay, and pub/sub delivery costs
4. Explain why microservices often increase request-path complexity

---

## Big O refresher

| Notation | Growth | Distributed example |
|----------|--------|---------------------|
| O(1) | Constant | Single hop, fixed RTT |
| O(log n) | Logarithmic | Consistent hash ring lookup |
| O(n) | Linear | k sequential hops; n event replay |
| O(n log n) | Linearithmic | Sort/merge large fan-in results |
| O(n²) | Quadratic | Mesh anti-pattern (every service calls every other) |

**n** = number of services, hops, events, or shards — depending on context.

---

## Core insight

> Microservices improve **organizational** and **scaling** flexibility but often worsen **request-path time complexity** unless you parallelize or async.

Monolith in-process call: ~O(1) nanoseconds.  
Microservice network call: ~O(1) **milliseconds** per hop — constant but large constant.

---

## Communication patterns

### Single synchronous hop
- **Latency:** O(1) per call (fixed RTT + processing)
- **Work:** O(1)

### Sequential sync chain (k services)

```
Total wall-clock latency = L1 + L2 + ... + Lk  →  O(k)
```

Example: 5 hops × 25ms = 125ms network alone.

### Parallel fan-out (k services)

```
Wall-clock ≈ max(L1, L2, ..., Lk)  →  O(1) wall-clock*
```
*Limited by slowest branch; still O(k) total work across cluster.

### Fan-out + merge

Fetch from k services, merge results:
- **Latency:** O(1) wall-clock if parallel
- **Merge CPU:** O(k) or O(n log n) if sorting k result sets

### Pub/sub broadcast to k subscribers

- **Publish:** O(1) from producer view
- **Delivery:** O(k) total broker work

---

## Saga complexity

Forward path: n steps → **O(n)** sequential steps (orchestrated) or **O(n)** event hops (choreographed).

Failure path: up to n compensations → **O(n)** worst case.

Example 4-step saga failure at step 3:
```
Forward: 2 completed steps
Compensate: 2 rollback steps
Total operations: 4 → O(n)
```

---

## Event sourcing replay

Rebuild state from n events → **O(n)** time, **O(1)** space if streaming (or O(n) if materializing full snapshot).

Snapshots reduce replay from last snapshot: **O(m)** where m = events since snapshot.

---

## Sharding lookup

Consistent hashing: route key to shard in **O(log n)** or **O(1)** depending on implementation.

Cross-shard query: **O(shards)** — avoid in hot path.

---

## Anti-patterns and complexity

| Anti-pattern | Complexity risk |
|--------------|-----------------|
| Sync mesh (everyone calls everyone) | O(n²) connections/coupling |
| Deep sync chain (10+ hops) | O(k) latency explosion |
| Unbounded fan-out on user request | O(k) tail = max slow service |
| Full graph E2E test suite | O(services²) integration pairs |

---

## Worked comparison

**Scenario:** Product detail page needs Catalog, Reviews, Inventory, Recommendations.

| Design | Latency complexity | Notes |
|--------|-------------------|-------|
| Sequential sync | O(4) hops | ~100ms+ network |
| Parallel sync | O(1) wall | ~25ms (slowest) |
| Async + cached read model | O(1) read | Stale OK for reviews/recs |

---

## Decision table

| Need | Prefer | Complexity |
|------|--------|------------|
| Immediate consistent read | Sync (minimize k) | O(k) |
| High throughput write | Async queue | O(1) enqueue |
| Multi-service workflow | Saga | O(n) steps |
| Historical audit | Event sourcing | O(n) replay |

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Treating hops as "free" | Count k in every design review |
| Serial when parallel possible | Fan-out + merge |
| Ignoring compensation cost | Budget saga failure path |

---

## Exercises

See [exercises/module-10.md](../../exercises/module-10.md).

## Next module

[11 — Security →](../part-03-production/11-security.md)
