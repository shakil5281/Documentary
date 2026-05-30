# 03 — Core Principles

**Level:** Beginner–Intermediate  
**Estimated reading time:** 30 minutes  
**Previous:** [02 — Monolith vs Microservices](./02-monolith-vs-microservices.md)  
**Next:** [04 — Communication Patterns](./04-communication-patterns.md)

---

## Principle 1: Single Responsibility

Each microservice should do **one thing** and do it well. "One thing" means one **business capability**, not one technical function.

| Good boundary | Bad boundary |
|---------------|--------------|
| Order Service (manages orders) | Database Service (wraps a database) |
| Payment Service (processes payments) | Validation Service (validates all inputs) |
| Notification Service (sends emails/SMS) | Utility Service (shared helpers) |

A service named after a technical layer ("DataService", "LogicService") is usually a sign of poor boundary design.

---

## Principle 2: Organize Around Business Capabilities

Services should map to **what the business does**, not how software is layered.

**Layer-based (bad for microservices):**
```
UI Service → Business Logic Service → Data Access Service
```

**Capability-based (good):**
```
User Service | Catalog Service | Order Service | Payment Service
```

Each capability team owns the full stack for their domain — API, business rules, and data.

---

## Principle 3: Decentralized Data Management

Each service **owns its data**. No other service should directly read or write another service's database.

```
✅ Order Service → calls Payment Service API → Payment Service reads Payment DB
❌ Order Service → directly queries Payment DB
```

Why?

- **Encapsulation** — internal data model can change without affecting others
- **Independence** — services can choose the best database for their needs
- **Autonomy** — teams control their schema, migrations, and performance tuning

---

## Principle 4: Smart Endpoints, Dumb Pipes

Services should contain their own business logic. The communication infrastructure (network, message broker) should be simple — just deliver messages, not process business rules.

This contrasts with **Enterprise Service Bus (ESB)** architectures where a central bus contains routing logic, transformations, and business rules. In microservices, intelligence lives in the services; the pipe is dumb.

---

## Principle 5: Design for Failure

In a distributed system, **failure is normal**, not exceptional. Services must assume that:

- Network calls will fail or time out
- Dependent services will be temporarily unavailable
- Messages may be delivered more than once (at-least-once delivery)

Design every inter-service interaction with failure in mind (covered in detail in module 06).

---

## Principle 6: Independent Deployability

If changing Service A requires deploying Service B at the same time, they are not truly independent. True independence means:

- Backward-compatible API changes
- Versioned APIs when breaking changes are unavoidable
- No shared libraries that must be updated in lockstep (or version them carefully)

---

## Domain-Driven Design (DDD) Basics

DDD provides the vocabulary and techniques for finding good service boundaries.

### Ubiquitous Language

Everyone — developers, product managers, domain experts — uses the same terms. If the business says "Order," the code has an `Order` entity, not a `TransactionRecord`.

### Bounded Context

A **bounded context** is a boundary within which a particular domain model applies. The same word can mean different things in different contexts:

| Term | Order Context | Shipping Context |
|------|---------------|------------------|
| "Customer" | Person who placed the order | Delivery recipient (may differ from buyer) |
| "Item" | Product with price at time of order | Physical package with weight and dimensions |

Each bounded context is a candidate for a microservice.

### Aggregates

An **aggregate** is a cluster of domain objects treated as a single unit for data changes. Each aggregate has a root entity (Aggregate Root) that controls access.

Example: `Order` is an aggregate root. `OrderLine` items belong to the Order aggregate. External services should only interact with the Order root, not individual line items directly.

### Context Map

A **context map** shows how bounded contexts relate to each other:

```
┌──────────────┐     upstream      ┌──────────────┐
│   Catalog    │ ────────────────► │    Order     │
│   Context    │   (Order reads    │   Context    │
│              │    product info)  │              │
└──────────────┘                   └──────┬───────┘
                                          │
                                   downstream
                                          │
                                   ┌──────▼───────┐
                                   │   Payment    │
                                   │   Context    │
                                   └──────────────┘
```

Relationships between contexts:

| Relationship | Meaning |
|-------------|---------|
| **Partnership** | Two contexts cooperate closely; teams coordinate |
| **Shared Kernel** | Small shared model used by both (use sparingly) |
| **Customer-Supplier** | Downstream depends on upstream; upstream serves downstream's needs |
| **Conformist** | Downstream adopts upstream's model as-is |
| **Anti-corruption Layer** | Downstream translates upstream's model into its own |

---

## Loose Coupling vs Tight Coupling

| Tight coupling (avoid) | Loose coupling (prefer) |
|------------------------|-------------------------|
| Shared database | API or event communication |
| Shared library with business logic | Published API contract |
| Synchronous chain of 5+ calls | Event-driven, async where possible |
| Hardcoded service URLs | Service discovery |
| Same deployment unit | Independent deployment |

Loose coupling allows services to evolve independently. The cost is eventual consistency and more complex communication patterns.

---

## Conway's Law

> "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations." — Melvin Conway, 1967

In practice: if you have 4 teams, you will likely end up with ~4 services. If you have 1 team trying to manage 15 services, you will have operational problems.

**Implication:** Service boundaries should align with team boundaries. A service should be ownable by one team (typically 5–9 people).

---

## The Two-Pizza Team Rule

Amazon's guideline: a team should be small enough to be fed with two pizzas (~5–9 people). Each such team owns one or a few microservices end-to-end — development, deployment, monitoring, and on-call.

---

## Summary

- Services are organized around business capabilities, not technical layers.
- Each service owns its data and is independently deployable.
- DDD provides tools (bounded context, aggregates, context map) for finding boundaries.
- Design for failure from the start.
- Align service ownership with team structure (Conway's Law).

---

**Next:** [04 — Communication Patterns →](./04-communication-patterns.md)
