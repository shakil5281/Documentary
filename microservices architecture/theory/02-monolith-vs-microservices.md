# 02 — Monolith vs Microservices

**Level:** Beginner  
**Estimated reading time:** 25 minutes  
**Previous:** [01 — Introduction](./01-introduction.md)  
**Next:** [03 — Core Principles](./03-core-principles.md)

---

## What Is a Monolith?

A **monolith** (or monolithic architecture) is a single deployable application where all functionality — user management, catalog, orders, payments — lives in one codebase and is deployed as one unit.

```
┌─────────────────────────────────────────────┐
│              Monolithic Application          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │  Users  │ │ Catalog │ │ Orders  │  ...  │
│  └─────────┘ └─────────┘ └─────────┘       │
│              Shared Database                 │
└─────────────────────────────────────────────┘
```

Typical characteristics:

- One codebase (possibly modular internally)
- One deployment artifact (e.g., one JAR, one Docker image)
- Often one shared database
- All teams work in the same repository

---

## Side-by-Side Comparison

| Dimension | Monolith | Microservices |
|-----------|----------|---------------|
| **Deployment** | Deploy everything together | Deploy each service independently |
| **Scaling** | Scale the entire application | Scale individual services |
| **Technology** | Usually one language/framework | Polyglot — different services can use different stacks |
| **Data** | Shared database, ACID transactions | Database per service, eventual consistency |
| **Team structure** | One or few teams on one codebase | Teams own individual services |
| **Complexity location** | Inside the codebase | Across the network and operations |
| **Testing** | Simpler — everything in-process | Harder — requires integration and contract tests |
| **Failure mode** | One bug can crash everything | Isolated failures, but cascading failures possible |
| **Time to first release** | Faster | Slower (more infrastructure needed) |
| **Best for** | Startups, small teams, MVPs | Large systems, many teams, clear domain boundaries |

---

## Strengths of Monoliths

1. **Simplicity** — One repo, one deploy, one database. Easy to reason about.
2. **ACID transactions** — Cross-module operations use a single database transaction. No distributed transaction problem.
3. **Performance** — In-process calls are fast. No network overhead between modules.
4. **Easier debugging** — Stack traces, logs, and breakpoints cover the entire system.
5. **Lower operational cost** — One server, one deployment pipeline, minimal infrastructure.
6. **Faster initial development** — No need to design service boundaries, APIs, or messaging upfront.

---

## Weaknesses of Monoliths

1. **Deployment bottleneck** — Any change requires redeploying the entire application.
2. **Scaling limitations** — Cannot scale just the checkout module during a sale; you scale everything.
3. **Technology lock-in** — Hard to adopt a new language or framework for one module.
4. **Team coordination** — Many developers on one codebase leads to merge conflicts and slow releases.
5. **Blast radius** — A memory leak or bug in one module can take down the entire system.
6. **Codebase growth** — Over years, the monolith becomes a "big ball of mud" — tangled, hard to change.

---

## Strengths of Microservices

1. **Independent deployment** — Teams release on their own schedule.
2. **Targeted scaling** — Scale only the services under load.
3. **Technology freedom** — Use the best tool for each service's job.
4. **Fault isolation** — A failure in the recommendation engine does not crash checkout.
5. **Team autonomy** — Small teams own services end-to-end (Conway's Law).
6. **Clear boundaries** — Forces explicit API contracts and domain thinking.

---

## Weaknesses of Microservices

1. **Distributed complexity** — Network failures, latency, partial failures.
2. **Data consistency** — No simple cross-service transactions; need Saga, eventual consistency.
3. **Operational overhead** — Many services to deploy, monitor, and secure.
4. **Testing difficulty** — Integration tests require running multiple services.
5. **Debugging across services** — A user request may touch 5+ services; tracing is essential.
6. **Premature adoption risk** — Splitting too early creates complexity without benefit.

---

## The Modular Monolith (Middle Ground)

Before jumping to microservices, consider a **modular monolith**:

- One deployable unit, but internally organized into well-separated modules
- Each module has clear boundaries and communicates through internal interfaces
- Shared database, but each module owns its tables
- Can be split into microservices later when boundaries are proven

This is often the best starting point. It gives you clean architecture without distributed-system pain.

---

## When to Choose Monolith

- Early-stage product or MVP
- Small team (fewer than ~8–10 developers)
- Domain boundaries are unclear
- Speed to market is the top priority
- No immediate scaling pressure on individual components

---

## When to Consider Microservices

- Multiple teams need to deploy independently
- Different parts of the system have very different scaling needs
- A specific module needs a different technology (e.g., ML inference in Python, rest in Java)
- The monolith's deployment cycle is a bottleneck (e.g., weekly releases blocking teams)
- Domain boundaries are well understood and stable

---

## Signs You Should NOT Split Yet

- "Microservices is modern, so we should use it"
- The team has never operated more than one deployable service
- No observability infrastructure (logging, metrics, tracing)
- Domain boundaries change frequently
- The monolith works fine and the team is productive

---

## Migration Triggers (Monolith → Microservices)

| Signal | What it means |
|--------|---------------|
| Deployment takes hours and blocks all teams | Release process is a bottleneck |
| One module needs 10x more resources than others | Scaling mismatch |
| Teams constantly conflict over the same code | Organizational scaling problem |
| A bug in one area takes down everything | Failure isolation needed |
| Regulatory requirement to isolate data (e.g., PCI for payments) | Compliance-driven split |

Migration should be **incremental** — extract one service at a time using the Strangler Fig pattern (gradually replace monolith functionality with new services).

---

## Summary

- Monoliths are simpler and faster to build; microservices offer flexibility at the cost of complexity.
- Most projects should start as a monolith (or modular monolith) and split only when clear triggers appear.
- The decision is about team structure, scaling needs, and domain clarity — not fashion.
- Never adopt microservices "just because." Adopt them when the pain of the monolith exceeds the cost of distribution.

---

**Next:** [03 — Core Principles →](./03-core-principles.md)
