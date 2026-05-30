# Microservices Architecture — Theory Learning Guide

A structured, **theory-only** curriculum for learning microservices from basics to advanced concepts. No code or hands-on labs — only concepts, patterns, trade-offs, and decision frameworks.

---

## How to Use This Guide

1. Read files in order (01 → 11). Each module builds on the previous one.
2. Read [STRUCTURE.md](./STRUCTURE.md) to understand how this repository is organized.
3. Take notes on trade-offs — microservices is as much about *when not to use them* as when to use them.
4. After each module, ask yourself: *"What problem does this pattern solve, and what new problems does it introduce?"*

---

## Learning Path

| # | Module | Level | Topics |
|---|--------|-------|--------|
| 01 | [Introduction](./theory/01-introduction.md) | Beginner | What microservices are, history, key vocabulary |
| 02 | [Monolith vs Microservices](./theory/02-monolith-vs-microservices.md) | Beginner | Comparison, when to choose each, migration triggers |
| 03 | [Core Principles](./theory/03-core-principles.md) | Beginner–Intermediate | Boundaries, DDD, single responsibility, autonomy |
| 04 | [Communication Patterns](./theory/04-communication-patterns.md) | Intermediate | REST, gRPC, messaging, event-driven architecture |
| 05 | [Data Management](./theory/05-data-management.md) | Intermediate | Database per service, consistency, Saga, CQRS |
| 06 | [Reliability & Resilience](./theory/06-reliability-and-resilience.md) | Intermediate | Timeouts, retries, circuit breaker, bulkhead |
| 07 | [Security](./theory/07-security.md) | Intermediate–Advanced | Auth, mTLS, zero trust, secrets management |
| 08 | [Observability](./theory/08-observability.md) | Intermediate–Advanced | Logging, metrics, tracing, SLOs |
| 09 | [Deployment & DevOps](./theory/09-deployment-and-devops.md) | Advanced | CI/CD, containers, Kubernetes, deployment strategies |
| 10 | [Advanced Patterns](./theory/10-advanced-patterns.md) | Advanced | Event sourcing, service mesh, API gateway, BFF |
| 11 | [Trade-offs & Decisions](./theory/11-tradeoffs-and-decision-framework.md) | Advanced | Decision framework, anti-patterns, organizational impact |

---

## Prerequisites (Conceptual Only)

Before starting, you should understand at a high level:

- What a web application and API are
- Basic client–server model (browser/app → server → database)
- What HTTP requests and responses are
- Why software is split into layers (UI, business logic, data)

You do **not** need prior microservices experience.

---

## Estimated Reading Time

| Phase | Modules | Time |
|-------|---------|------|
| Basics | 01–02 | 1–2 hours |
| Core concepts | 03–05 | 3–4 hours |
| Production concerns | 06–08 | 3–4 hours |
| Advanced | 09–11 | 3–4 hours |
| **Total** | **11 modules** | **~10–14 hours** |

---

## What You Will Be Able to Explain After Completing This Guide

- Why organizations adopt (or reject) microservices
- How to define service boundaries using domain concepts
- The difference between synchronous and asynchronous communication
- Why distributed data is hard and how patterns like Saga address it
- What makes a microservice system production-ready (observability, security, resilience)
- When advanced patterns like CQRS or event sourcing are justified
