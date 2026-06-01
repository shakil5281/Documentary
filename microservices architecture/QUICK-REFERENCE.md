# Quick Reference — Microservices Architecture

Cheat sheet for patterns, metrics, and formulas. Full details in module docs.

---

## Core definitions

| Term | Meaning |
|------|---------|
| **Performance** | How fast one request completes (latency, throughput) |
| **Scalability** | How well the system handles growth by adding resources |
| **Flexibility** | How easily you change, deploy, and replace parts without breaking SLAs |
| **Elasticity** | Scale resources up/down automatically with demand |

---

## Latency budget formula

```
Total user-facing budget = Sum(sync hops) + max(parallel branches) + margin

Example (300ms checkout budget):
  Gateway:     20ms
  Order:       80ms
  Payment:    100ms  (parallel with Inventory)
  Inventory:   60ms  (parallel with Payment)
  Margin:      40ms
  ─────────────────
  Critical path: 20 + 80 + max(100, 60) + 40 = 240ms ✓
```

**Rule:** Each service timeout must be **shorter** than its caller's timeout.

---

## Percentiles

| Metric | Meaning |
|--------|---------|
| p50 | Median — half of requests faster |
| p95 | 95% of requests faster (tail starts here) |
| p99 | 1 in 100 requests slower — user-visible pain |
| p999 | Worst realistic case for SLO design |

---

## Time complexity (distributed)

| Pattern | Latency complexity | Notes |
|---------|-------------------|-------|
| Single sync hop | O(1) | Constant RTT per call |
| Sequential chain (k hops) | O(k) | Latencies **add** |
| Parallel fan-out (k) | O(1)* | *Wall-clock = slowest branch |
| Fan-out + merge | O(k) merge | Aggregation work |
| Saga (n steps) | O(n) | Compensation adds O(n) worst case |
| Event replay (n events) | O(n) | Rebuild read model |
| Pub/sub to k subscribers | O(k) | Broker delivery |
| Full mesh sync (anti-pattern) | O(n²) risk | Avoid |

---

## CAP theorem

Pick **two** of three under partition:

| | Consistency | Availability | Partition tolerance |
|---|-------------|--------------|---------------------|
| Must have | — | — | **Yes** (network fails) |
| Choose | CP or AP | CP or AP | — |

Most microservices: **AP + eventual consistency**.

---

## Pattern picker

| Problem | Pattern |
|---------|---------|
| Unclear data movement | [Data flow & system design guide](docs/DATA-FLOW-AND-SYSTEM-DESIGN.md) |
| Cross-service transaction | Saga (orchestration or choreography) |
| Reliable event publish + DB write | Outbox |
| Service temporarily down | Circuit breaker + fallback |
| Traffic spike | Queue + autoscale consumers |
| Hot read path | Cache-aside (Redis/CDN) |
| Cross-service query | CQRS read model or API composition |
| Gradual monolith migration | Strangler Fig |
| Complex sync workflow | Orchestrator |
| Independent reactions | Event choreography |
| API entry + auth | API Gateway |
| Service-to-service security | mTLS (service mesh) |

---

## Scaling strategies

| Strategy | When |
|----------|------|
| Scale up (vertical) | Small scale, quick fix |
| Scale out (horizontal) | Production, fault tolerance |
| Read replicas | Read-heavy, eventual consistency OK |
| Sharding | Write-heavy, single DB bottleneck |
| Stateless services | Easiest horizontal scaling |
| Queue buffering | Burst traffic, async work |

---

## Resilience defaults (starting points)

| Setting | Typical value |
|---------|---------------|
| HTTP timeout | 1–5 seconds |
| Max retries | 2–3 (idempotent only) |
| Circuit breaker threshold | 5 failures in 10s |
| Circuit open duration | 30 seconds |
| Bulkhead thread pool | Per downstream service |

---

## SLO examples

| Service | SLI | SLO |
|---------|-----|-----|
| API Gateway | Availability | 99.95% |
| Order Service | Latency p99 | < 1s |
| Payment Service | Success rate | 99.99% |

**Error budget:** 99.9% availability = 0.1% downtime allowed (~43 min/month).

---

## Anti-patterns (avoid)

- Distributed monolith (must deploy together)
- Shared database across services
- Nano-services (too many tiny services)
- Sync chain of 5+ calls on hot path
- No observability from day one
- Premature microservices split

---

See also: [B-pattern-catalog.md](docs/appendices/B-pattern-catalog.md) | [A-glossary.md](docs/appendices/A-glossary.md)
