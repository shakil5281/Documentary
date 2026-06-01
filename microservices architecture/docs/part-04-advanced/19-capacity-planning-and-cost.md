# 19 — Capacity Planning & Cost

> **Part:** IV Advanced | **Week:** 14 | **Exercises:** [module-19](../../exercises/module-19.md)

## Learning outcomes

After this module you can:

1. Estimate QPS from user counts and usage patterns
2. Calculate instances needed from per-node throughput
3. Identify cost drivers in microservices operations
4. Plan load tests to validate capacity before launch

---

## Back-of-envelope QPS

```
QPS = (DAU × actions_per_user_per_day) / 86400

Example: 1M DAU, 20 actions/day
QPS ≈ (1,000,000 × 20) / 86400 ≈ 231 avg
Peak ≈ 3–5× avg → ~700–1150 QPS
```

Always plan for **peak**, not average.

---

## Instance sizing

```
Instances needed = Peak QPS / (Throughput per instance × Target utilization)

Example: Peak 1000 QPS, one pod handles 200 QPS at 70% CPU
Instances = 1000 / (200 × 0.7) ≈ 8 pods
```

Add headroom for failures (N+1 or N+2).

---

## Microservices cost drivers

| Driver | Notes |
|--------|-------|
| Number of services | Each has baseline CPU, monitoring, CI cost |
| Cross-service traffic | Egress fees, latency |
| Data stores | DB per service multiplies cost |
| Observability | Log/metric/trace storage |
| Kubernetes overhead | Control plane, idle pods |
| Multi-region | 2×+ infra |

**Flexibility has a bill** — consolidate where boundaries don't justify split.

---

## Load testing

Before launch:
1. Define target QPS and p99 latency SLO
2. Run gradual ramp (k6, Gatling, Locust)
3. Find breaking point; scale or optimize
4. Test autoscaling triggers

---

## Cost optimization

- Right-size instances (don't over-provision)
- Autoscale down off-peak
- Cache to reduce DB/compute
- Async for non-critical path
- Review unused services (nano-service sprawl)

---

## Exercises

See [exercises/module-19.md](../../exercises/module-19.md).

## Next module

[20 — Trade-offs & Decision Framework →](./20-tradeoffs-and-decision-framework.md)
