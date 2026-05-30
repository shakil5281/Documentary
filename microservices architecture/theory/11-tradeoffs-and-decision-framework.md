# 11 — Trade-offs & Decision Framework

**Level:** Advanced  
**Estimated reading time:** 30 minutes  
**Previous:** [10 — Advanced Patterns](./10-advanced-patterns.md)  
**Next:** —

---

## The Central Truth

Microservices are not inherently better than monoliths. They trade one set of problems for another:

| Monolith problems | Microservices problems |
|-------------------|----------------------|
| Hard to scale individual parts | Network latency and failures |
| Slow deployments | Operational complexity |
| Technology lock-in | Distributed data consistency |
| Team coordination bottlenecks | Integration testing difficulty |
| Growing codebase complexity | Requires mature DevOps culture |

The goal is not "use microservices." The goal is to **choose the architecture that fits your context**.

---

## Decision Framework: Should You Use Microservices?

Answer these questions honestly:

### Team & Organization

| Question | If YES → microservices may fit |
|----------|--------------------------------|
| Do you have 3+ independent teams? | Teams can own services autonomously |
| Can each team deploy independently today (or could they)? | Organizational readiness |
| Do teams have DevOps skills (CI/CD, containers, monitoring)? | Operational readiness |
| Is there a platform/infrastructure team to support services? | Shared tooling and standards |

### Technical

| Question | If YES → microservices may fit |
|----------|--------------------------------|
| Are domain boundaries clear and stable? | Clean service splits |
| Do different parts have very different scaling needs? | Targeted scaling benefit |
| Does one module need a fundamentally different technology? | Polyglot advantage |
| Is the monolith deployment a proven bottleneck? | Real pain, not hypothetical |

### Business

| Question | If YES → microservices may fit |
|----------|--------------------------------|
| Is the system expected to exist for 5+ years? | Long-term investment pays off |
| Is the business domain complex with distinct sub-domains? | DDD boundaries exist |
| Are there compliance requirements for data isolation? | Regulatory driver |
| Can you accept slower initial delivery for long-term flexibility? | Business tolerance |

**If most answers are NO** → start with a modular monolith.  
**If most answers are YES** → consider microservices, but start with 2–3 services, not 20.

---

## Common Anti-Patterns

### 1. Distributed Monolith

Services that must be deployed together because they are tightly coupled.

```
Symptoms:
- Changing Service A always requires changing Service B
- Shared database tables across services
- Synchronous call chains of 5+ services for one user action
- "We can't deploy until all teams are ready"
```

This has all the complexity of microservices with none of the benefits.

**Fix:** Re-evaluate boundaries. Merge tightly coupled services. Introduce async communication.

### 2. Nano-Services

Services that are too small — a few endpoints, a single table.

```
Symptoms:
- 50+ services for a medium-sized application
- Network overhead exceeds business logic execution time
- Developers can't remember which service does what
- Simple feature requires changes in 8 services
```

**Fix:** Merge related nano-services into cohesive services around business capabilities.

### 3. Shared Database

Multiple services reading/writing the same database.

```
Symptoms:
- Schema changes require coordinating across teams
- Services break when another team changes "their" tables
- No true service independence
```

**Fix:** Each service gets its own database. Sync data via events.

### 4. Premature Decomposition

Splitting into microservices before understanding the domain.

```
Symptoms:
- Service boundaries change every sprint
- Frequent cross-service refactoring
- More time spent on infrastructure than features
- Team spends days debugging distributed issues
```

**Fix:** Merge back into a modular monolith. Re-split when boundaries stabilize.

### 5. No Observability

Running microservices without logging, metrics, or tracing.

```
Symptoms:
- "It broke but we don't know which service"
- Debugging requires checking logs on 10 different servers
- No one knows the error rate or latency of any service
```

**Fix:** Stop adding services. Invest in observability first (module 08).

---

## The Microservices Premium

Martin Fowler identified the **Microservices Premium** — the extra cost you pay before microservices become advantageous:

```
Cost
  │
  │     ┌── Microservices overhead
  │    ╱    (network, ops, distributed data)
  │   ╱
  │  ╱
  │ ╱
  │╱────── Monolith overhead
  │         (code complexity, deployment)
  │
  └──────────────────────────── System size / team size
         ▲
         │ Crossover point: microservices
         │ become cheaper than monolith
```

Below the crossover point, a monolith is simpler and cheaper. Microservices pay off when organizational and scaling complexity exceeds the cost of distribution.

---

## Organizational Impact

### Conway's Law in Practice

Your architecture will mirror your org chart:

| Org structure | Likely architecture |
|--------------|-------------------|
| One team of 5 | One monolith |
| 4 teams by domain | ~4 microservices |
| 20 teams across 4 departments | Platform team + 15–20 services |

Deliberately design team boundaries and service boundaries together.

### Team Topologies

| Team type | Responsibility |
|-----------|---------------|
| **Stream-aligned team** | Owns one or more services end-to-end (build, deploy, monitor, on-call) |
| **Platform team** | Provides internal tools: CI/CD, K8s cluster, observability stack, service templates |
| **Enabling team** | Helps stream-aligned teams adopt new practices (e.g., event-driven architecture) |
| **Complicated-subsystem team** | Owns specialized components (e.g., payment processing, search engine) |

### Ownership Model

Each service should have:

- A **single owning team** (not shared ownership)
- Defined **on-call rotation** for production issues
- **Runbooks** for common failure scenarios
- **SLIs/SLOs** agreed with stakeholders

---

## Migration Strategy Summary

When migrating from monolith to microservices:

1. **Don't rewrite** — extract incrementally using Strangler Fig
2. **Start with observability** — you can't manage what you can't see
3. **Extract at natural seams** — bounded contexts with few dependencies
4. **Keep the monolith running** — new services wrap/extract, monolith shrinks
5. **Accept eventual consistency** — design for it from the start
6. **Invest in platform tooling** — CI/CD, service templates, shared libraries for cross-cutting concerns
7. **Measure before and after** — deployment frequency, lead time, error rate, team satisfaction

Recommended extraction order:

```
1. Notification Service  (low risk, async, clear boundary)
2. User/Auth Service     (clear boundary, many consumers)
3. Catalog Service       (read-heavy, benefits from independent scaling)
4. Order Service         (core domain, extract after patterns are proven)
5. Payment Service       (compliance isolation, extract when team is mature)
```

---

## Architecture Decision Record (ADR)

Document important architectural decisions:

```markdown
# ADR-001: Use event-driven communication between Order and Payment

## Status: Accepted
## Date: 2026-05-30

## Context
Order Service needs to trigger payment processing. Options: sync REST call or async event.

## Decision
Use async event (OrderCreated → Payment Service).

## Consequences
+ Order Service doesn't depend on Payment Service availability
+ Payment can be retried independently
- Order status is eventually consistent (PENDING until PaymentCompleted event)
- Need Saga for failure compensation
```

ADRs create an audit trail of **why** decisions were made, invaluable when team members change.

---

## Final Checklist: Are You Ready for Microservices?

| Requirement | Ready? |
|-------------|--------|
| Domain boundaries are understood | ☐ |
| Teams can deploy independently | ☐ |
| CI/CD pipeline exists per service | ☐ |
| Centralized logging is in place | ☐ |
| Metrics and alerting are configured | ☐ |
| Distributed tracing is implemented | ☐ |
| Container orchestration is operational | ☐ |
| Team has on-call rotation and runbooks | ☐ |
| Idempotency is designed into all write operations | ☐ |
| Failure handling (timeouts, retries, circuit breakers) is standard | ☐ |

If fewer than 7 are checked, focus on infrastructure and team practices before splitting further.

---

## Key Takeaways from This Guide

1. **Microservices are an organizational strategy**, not just a technical one.
2. **Start simple** — monolith or modular monolith first.
3. **Split at bounded contexts** — use DDD to find natural seams.
4. **Design for failure** — timeouts, retries, circuit breakers, fallbacks.
5. **Embrace eventual consistency** — Saga and Outbox patterns are your tools.
6. **Observability is non-negotiable** — logs, metrics, traces from day one.
7. **Security is zero trust** — verify every call, even internal ones.
8. **Advanced patterns are tools, not defaults** — CQRS, Event Sourcing, Service Mesh when justified.
9. **Avoid the distributed monolith** — if services can't deploy independently, you've gone wrong.
10. **Measure and adapt** — architecture evolves; revisit decisions as the system and team grow.

---

## Further Reading Topics

When you're ready to go deeper, explore these areas:

- **Domain-Driven Design** — Eric Evans' book is the definitive source for bounded contexts and aggregates
- **Building Microservices** — Sam Newman's book covers practical microservices design
- **Designing Data-Intensive Applications** — Martin Kleppmann's book for distributed data fundamentals
- **Site Reliability Engineering** — Google SRE book for SLOs, error budgets, and operational practices
- **Team Topologies** — Matthew Skelton & Manuel Pais on organizing teams for microservices

---

**Congratulations — you've completed the Microservices Architecture theory guide.**

Return to [README](../README.md) to review the full learning path.
