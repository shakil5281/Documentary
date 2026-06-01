# Topic 2: Distributed Transactions & Sagas

## The Problem: Dual Writes & Distributed State

In monolithic architectures, ensuring ACID guarantees is simple: we wrap multiple DB operations in a single database transaction. 

However, in microservice or multi-database systems, a single business transaction might cross physical boundaries. For example, in an e-commerce checkout:
1. **Order Service** creates an order in DB A.
2. **Inventory Service** updates inventory in DB B.
3. **Payment Service** charges the credit card via Stripe (external system).

If the payment fails, how do we rollback order creation and inventory updates? If we don't, our system becomes inconsistent. This is the **Distributed Transaction** problem.

---

## Two-Phase Commit (2PC)

2PC is a protocol that ensures atomic commit across multiple databases (cohorts), coordinated by a central process (coordinator).

```
Coordinator               Cohort A          Cohort B
    │                         │                 │
    │ ─── 1. Prepare ───────> │                 │
    │ ─── 1. Prepare ─────────────────────────> │
    │                         │                 │
    │ <─── 2. Voted Yes ──────│                 │
    │ <─── 2. Voted Yes ────────────────────────│
    │                         │                 │
    │ ─── 3. Commit ────────> │                 │
    │ ─── 3. Commit ──────────────────────────> │
```

### Phase 1: Prepare
1. The **Coordinator** sends a `Prepare` message to all **Cohorts**.
2. Cohorts reserve resources, write transactions to local logs (undo/redo logs), and lock records.
3. Cohorts vote: `Yes` (ready to commit) or `No` (failed/aborted).

### Phase 2: Commit (or Abort)
1. If **all** cohorts voted `Yes`: The coordinator sends `Commit` to all cohorts. Cohorts make changes permanent and release locks.
2. If **any** cohort voted `No` (or timed out): The coordinator sends `Rollback` to all cohorts. Cohorts undo local actions and release locks.

### Critical Failure Mode of 2PC: Blocking
If the coordinator crashes *after* cohorts vote `Yes` but *before* sending the `Commit` decision, cohorts are left in a **blocked state**. They cannot roll back (since they voted Yes) and cannot commit (since they don't know the final decision). They must hold resource locks indefinitely until the coordinator recovers.

---

## The Saga Pattern

To avoid blocking protocols (like 2PC) and long-held database locks in microservices, we use the **Saga Pattern**. 

A Saga is a sequence of local transactions. Each local transaction updates the database within a single service. If a local transaction fails, the Saga executes **compensating transactions** to undo the changes made by the preceding local transactions.

Sagas trade strict Isolation (ACID) for **Eventual Consistency** (BASE).

```
Normal Flow:
[Order Created] ──> [Inventory Reserved] ──> [Payment Success] (Complete)

Failure & Compensation Flow:
[Order Created] ──> [Inventory Reserved] ──> [Payment Fail]
      │                     │
      │ (Compensate)        │ (Compensate)
      ▼                     ▼
[Cancel Order] <─── [Release Inventory] (Rollback Complete)
```

There are two primary ways to coordinate Sagas:

### 1. Choreography (Decentralized)
- Services publish events. Other services listen and execute actions.
- **Pros**: Simple, highly decoupled, no single coordinator bottleneck.
- **Cons**: Difficult to track the state of the transaction; risk of cyclic dependencies.

### 2. Orchestration (Centralized)
- An orchestrator service guides cohorts on what local transactions to run.
- **Pros**: Centralized state visualization, simple flow control, avoids cyclic dependencies.
- **Cons**: Orchestrator becomes a single point of failure and holds complex business logic.

---

## Comparing 2PC and Sagas

| Dimension | Two-Phase Commit (2PC) | Saga Pattern |
|-----------|------------------------|--------------|
| **Consistency** | Strong Consistency (ACID) | Eventual Consistency (BASE) |
| **Locks** | Long-held locks (low throughput) | Short-lived local locks (high throughput) |
| **System Bounds** | Best for databases/internal systems | Best for microservices & external APIs |
| **Rollback** | Automatic (Engine level) | Manual coding of compensating actions |

---

## Check yourself

1. Why is 2PC considered a blocking protocol? What happens if the coordinator dies?
2. What is a compensating transaction in a Saga? How does it differ from a database rollback?
3. Compare Orchestration vs. Choreography in Sagas. When would you choose one over the other?
4. How do Sagas handle isolation violations (e.g., another client reads dirty data before a saga rolls back)?

---

## Key takeaway

Use **2PC** only when you require absolute, strong consistency and the operations are fast and internal. For business workflows involving microservices, network borders, or external APIs (e.g. Stripe, Twilio), use the **Saga Pattern**.
