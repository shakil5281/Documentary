# 03 — Core Principles & Domain-Driven Design

> **Part:** I Foundations | **Week:** 3 | **Exercises:** [module-03](../../exercises/module-03.md)

## Learning outcomes

After this module you can:

1. Apply six microservices principles to boundary decisions
2. Use DDD concepts: ubiquitous language, bounded context, aggregates, context map
3. Explain Conway's Law and two-pizza team rule
4. Distinguish loose vs tight coupling with examples

---

## Six principles

| # | Principle | Summary |
|---|-----------|---------|
| 1 | Single responsibility | One **business capability** per service |
| 2 | Business capabilities | Not UI/logic/data layers |
| 3 | Decentralized data | Each service owns its DB |
| 4 | Smart endpoints, dumb pipes | Logic in services, not broker |
| 5 | Design for failure | Network fails; plan for it |
| 6 | Independent deployability | No lockstep releases |

---

## Good vs bad boundaries

| Good | Bad |
|------|-----|
| Order Service | Database Service |
| Payment Service | Validation Service |
| Notification Service | Utility Service |

---

## Domain-Driven Design

### Ubiquitous language
Business and code use the same terms: "Order" not "TransactionRecord."

### Bounded context
Same word, different meaning per context:

| Term | Order context | Shipping context |
|------|---------------|------------------|
| Customer | Buyer | Delivery recipient |
| Item | Product + price | Physical package |

Each bounded context → microservice candidate.

### Aggregates
Cluster changed as one unit. `Order` is aggregate root; external services interact with Order, not OrderLine directly.

### Context map

```mermaid
flowchart LR
    Catalog[Catalog Context] -->|upstream| Order[Order Context]
    Order -->|downstream| Payment[Payment Context]
```

| Relationship | Meaning |
|-------------|---------|
| Customer-Supplier | Downstream depends on upstream |
| Anti-corruption Layer | Translate external model to yours |
| Shared Kernel | Small shared model (use sparingly) |

---

## Conway's Law

> Organizations produce designs that mirror communication structures.

Align **team boundaries** with **service boundaries**. One team (~5–9 people) owns one or few services end-to-end.

---

## Loose vs tight coupling

| Tight (avoid) | Loose (prefer) |
|---------------|----------------|
| Shared database | API / events |
| Sync chain of 5+ calls | Async where possible |
| Same deployment unit | Independent deploy |

**Flexibility cost:** Loose coupling enables independent evolution at the cost of eventual consistency.

---

## Exercises

See [exercises/module-03.md](../../exercises/module-03.md).

## Next module

[04 — API & Networking Fundamentals →](./04-api-networking-fundamentals.md)
