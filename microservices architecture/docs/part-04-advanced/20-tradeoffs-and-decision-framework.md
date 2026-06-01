# 20 — Trade-offs & Decision Framework

> **Part:** IV Advanced | **Week:** 15 | **Exercises:** [module-20](../../exercises/module-20.md)

## Learning outcomes

After this module you can:

1. Apply decision framework for monolith vs microservices
2. Identify anti-patterns: distributed monolith, nano-services, shared DB
3. Write Architecture Decision Records (ADRs)
4. Explain Microservices Premium and organizational impact

---

## Central truth

Microservices **trade** codebase complexity for network, data, and ops complexity. Goal: fit architecture to context.

---

## Decision framework

### Team & org (YES → consider microservices)
- 3+ independent teams
- Can deploy independently
- DevOps + platform support exists

### Technical (YES → consider)
- Clear stable domain boundaries
- Different scaling needs per module
- Proven deploy bottleneck

### Business (YES → consider)
- 5+ year system lifespan
- Complex domain
- Compliance isolation needs

**Mostly NO → modular monolith.**

---

## Anti-patterns

| Anti-pattern | Symptom | Fix |
|--------------|---------|-----|
| Distributed monolith | Must deploy together | Merge or decouple |
| Nano-services | 50+ tiny services | Consolidate |
| Shared database | Cross-team schema conflicts | DB per service |
| Premature split | Boundaries change weekly | Merge back, wait |
| No observability | Can't debug | Stop splitting; add observability |

---

## Scalability / performance cost matrix

| Gain | Cost |
|------|------|
| Independent scaling | More hops, O(k) latency |
| Team autonomy | Integration testing burden |
| Technology freedom | Ops diversity |
| Failure isolation | Eventual consistency |

---

## Microservices Premium

Below crossover point (small team/system), monolith is cheaper. Microservices pay off when organizational + scaling pain exceeds distribution cost.

---

## ADR template

```markdown
# ADR-001: Async events between Order and Payment
## Status: Accepted
## Context: Need decoupling; sync chain hurting p99
## Decision: OrderCreated event → Payment consumer
## Consequences: + eventual consistency; - Payment downtime blocks sync less
```

---

## Readiness checklist

- [ ] Domain boundaries understood
- [ ] CI/CD per service
- [ ] Centralized logging, metrics, traces
- [ ] Timeouts, retries, circuit breakers standard
- [ ] Idempotent writes
- [ ] On-call and runbooks

Fewer than 7 checked → improve platform before more splits.

---

## Exercises

See [exercises/module-20.md](../../exercises/module-20.md).

## Next module

[21 — Capstone Architecture Projects →](./21-capstone-architecture-projects.md)
