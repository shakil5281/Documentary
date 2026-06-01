# Appendix C — Troubleshooting Guide

Symptom → likely cause → fix for microservices production issues.

---

## Latency

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| p99 spike on one endpoint | Slow downstream sync call | Timeout, circuit breaker, parallelize |
| Gradual latency increase | Connection pool exhaustion | Increase pool; fix connection leaks |
| Latency grows with load | CPU saturation | HPA scale out; optimize hot path |
| Cross-region slowness | Geographic distance | CDN, regional deployment, cache |
| Tail latency only | Retry storms | Backoff + jitter; circuit breaker |

---

## Errors

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| 503 bursts | Downstream overload or crash | Scale downstream; health checks |
| 504 gateway timeout | Chain exceeds gateway timeout | Reduce hops; increase budget alignment |
| 409 conflicts | Race on same resource | Optimistic locking; idempotency |
| Duplicate charges | Non-idempotent retries | Idempotency-Key on writes |
| Intermittent 401 | Token expiry mid-chain | Refresh token; propagate correctly |

---

## Data

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Stale reads across services | Eventual consistency | Accept or use read-your-writes |
| Lost events | No outbox; broker down | Outbox pattern; broker HA |
| Inconsistent order state | Saga compensation failed | Saga monitor; manual reconciliation job |
| Duplicate event processing | At-least-once delivery | Idempotent handlers |

---

## Scaling

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| One service CPU maxed | Hot service not scaled | HPA; split service if needed |
| DB connection errors | Too many pods × pool size | PgBouncer; reduce pool per pod |
| Queue backlog growing | Consumers slower than producers | Scale consumers; optimize handler |
| Cache stampede | Many misses on expiry | Lock; stagger TTL |

---

## Deployment

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Rollout stuck | Readiness failing | Check probes, migrations, config |
| Version mismatch errors | Breaking API without version | Contract tests; parallel versions |
| All pods crash loop | Bad config/secret | Roll back; fix ConfigMap |

---

## Observability gaps

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Can't find the bug" | No traceId correlation | OpenTelemetry propagation |
| Alert fatigue | CPU alerts not actionable | SLO-based alerts on error/latency |
| Missing service in trace | Not instrumented outbound calls | Auto-instrument HTTP/gRPC |

---

## Organizational

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Every deploy needs all teams | Distributed monolith | Merge services or decouple |
| 30 services, 3 engineers | Too many services | Consolidate boundaries |
| No owner for outages | Unclear ownership | One team per service on-call |

---

See [QUICK-REFERENCE.md](../../QUICK-REFERENCE.md) for resilience defaults.
