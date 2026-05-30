# 05 — Data Management

**Level:** Intermediate  
**Estimated reading time:** 35 minutes  
**Previous:** [04 — Communication Patterns](./04-communication-patterns.md)  
**Next:** [06 — Reliability & Resilience](./06-reliability-and-resilience.md)

---

## The Database-per-Service Pattern

Each microservice owns its own database. Other services cannot access it directly — they must go through the service's API.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ User Service│     │Order Service│     │Payment Svc  │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
  ┌────▼────┐        ┌─────▼─────┐       ┌─────▼─────┐
  │ User DB │        │  Order DB │       │ Payment DB│
  │ (Postgres)│      │ (Postgres)│       │ (Postgres)│
  └─────────┘        └───────────┘       └───────────┘
```

Benefits:

- **Schema independence** — Order Service can change its tables without affecting others
- **Technology choice** — User Service can use Postgres, Catalog Service can use MongoDB, Search Service can use Elasticsearch
- **Scaling independence** — Scale the database that needs it, not all databases
- **Failure isolation** — Database issues in one service don't affect others

---

## The Distributed Data Problem

In a monolith, you can wrap multiple operations in a single database transaction:

```
BEGIN TRANSACTION
  INSERT INTO orders ...
  UPDATE inventory SET stock = stock - 1 ...
  INSERT INTO payments ...
COMMIT
```

In microservices, these tables live in different databases. There is no single transaction. This is the **fundamental challenge** of microservices data management.

---

## CAP Theorem

In a distributed system, you can guarantee at most **two** of three properties:

| Property | Meaning |
|----------|---------|
| **Consistency** | Every read returns the most recent write |
| **Availability** | Every request receives a response (not an error) |
| **Partition tolerance** | System continues despite network failures between nodes |

Since network partitions **will** happen, you effectively choose between:

- **CP** — Consistency + Partition tolerance (may reject requests during partition)
- **AP** — Availability + Partition tolerance (may return stale data during partition)

Most microservices systems choose **AP with eventual consistency** — accept temporary inconsistency, reconcile later.

---

## Eventual Consistency

Data across services will become consistent **over time**, but not instantly.

Example: User updates their email in User Service. Order Service still shows the old email for a few seconds until it receives the `UserEmailUpdated` event.

```
Time 0: User Service updates email → "new@email.com"
Time 1: Order Service still has → "old@email.com"  (stale)
Time 2: Order Service receives event → "new@email.com"  (consistent)
```

This is acceptable for most business scenarios. It is **not** acceptable for financial transactions without compensating mechanisms.

---

## Consistency Patterns

### Strong Consistency (Rare in Microservices)

All services see the same data at the same time. Requires distributed transactions (2PC), which are slow, fragile, and generally avoided.

### Eventual Consistency (Common)

Services converge to the same state over time via events. Requires:

- Idempotent event handlers (process the same event twice safely)
- Ordering guarantees where sequence matters
- Reconciliation jobs to detect and fix inconsistencies

### Read Your Own Writes

A weaker guarantee: after a user writes data, they always see their own write, even if other services haven't caught up yet. Often implemented with session affinity or a short-lived local cache.

---

## The Saga Pattern

A **Saga** is a sequence of local transactions, each in its own service, with compensating actions if any step fails.

### Example: Place Order Saga

```
Step 1: Order Service    → Create order (status: PENDING)
Step 2: Payment Service  → Charge customer
Step 3: Inventory Service → Reserve stock
Step 4: Order Service    → Mark order CONFIRMED
```

If Step 3 fails (out of stock):

```
Compensate 2: Payment Service  → Refund customer
Compensate 1: Order Service     → Cancel order (status: CANCELLED)
```

### Orchestrated Saga

A central coordinator (Saga Orchestrator) manages the sequence:

```
Orchestrator → Order: Create
Orchestrator → Payment: Charge
Orchestrator → Inventory: Reserve
  (failure here)
Orchestrator → Payment: Refund
Orchestrator → Order: Cancel
```

### Choreographed Saga

Each service listens for events and acts:

```
Order Service publishes OrderCreated
  → Payment Service hears it, charges, publishes PaymentCompleted
    → Inventory Service hears it, reserves, publishes InventoryReserved
      → Order Service hears it, marks CONFIRMED

  (if Inventory fails)
    → Inventory Service publishes InventoryFailed
      → Payment Service hears it, refunds, publishes PaymentRefunded
        → Order Service hears it, cancels
```

| Aspect | Orchestrated | Choreographed |
|--------|-------------|---------------|
| Visibility | Central — easy to see saga state | Distributed — trace via events |
| Coupling | Higher — orchestrator knows all steps | Lower — services react independently |
| Complexity | Simpler for complex workflows | Simpler for simple workflows |

---

## The Outbox Pattern

Problem: You need to update your database AND publish an event atomically. But you can't use a cross-service transaction.

Solution: Write the event to an **outbox table** in the same database transaction as your business data. A separate process reads the outbox and publishes events to the message broker.

```
BEGIN TRANSACTION
  UPDATE orders SET status = 'CONFIRMED' WHERE id = 123
  INSERT INTO outbox (event_type, payload) VALUES ('OrderConfirmed', '{...}')
COMMIT

(Outbox Relay Process)
  READ outbox WHERE published = false
  PUBLISH to message broker
  UPDATE outbox SET published = true
```

This guarantees that if the business data is saved, the event will eventually be published.

---

## Data Duplication

In microservices, the same data often exists in multiple services — by design.

| Data | Owner | Copy in |
|------|-------|---------|
| Product name | Catalog Service | Order Service (snapshot at order time) |
| Customer email | User Service | Notification Service (for sending emails) |
| Order total | Order Service | Analytics Service (for reporting) |

Copies are kept in sync via events. This is **denormalization for autonomy** — each service has the data it needs locally, avoiding cross-service calls for reads.

---

## Querying Across Services

There is no JOIN across service databases. Options:

| Approach | How | Trade-off |
|----------|-----|-----------|
| **API Composition** | Gateway/service calls multiple services and combines results | Simple, but slow and fragile |
| **CQRS Read Model** | Maintain a dedicated read-optimized database fed by events | Fast reads, but added complexity (see module 10) |
| **GraphQL Federation** | Each service exposes part of a GraphQL schema; gateway merges | Flexible queries, requires GraphQL adoption |

---

## Summary

- Each service owns its database; no direct cross-service database access.
- CAP theorem forces a choice — most microservices accept eventual consistency.
- Saga pattern manages multi-service transactions with compensating actions.
- Outbox pattern ensures reliable event publishing alongside database writes.
- Data duplication across services is intentional and kept in sync via events.

---

**Next:** [06 — Reliability & Resilience →](./06-reliability-and-resilience.md)
