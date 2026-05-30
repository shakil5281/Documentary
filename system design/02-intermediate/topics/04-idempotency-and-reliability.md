# Topic 4: Idempotency & Reliability

## Why retries break things

Networks fail. Clients retry. Queues redeliver. Without protection:

```
POST /transfer $100  → timeout → client retries → $200 transferred
```

Distributed systems must be designed for **failure and duplication**.

---

## Idempotency

An operation is **idempotent** if performing it multiple times has the **same effect** as performing it once.

| HTTP Method | Idempotent? |
|-------------|-------------|
| GET | Yes |
| PUT | Yes (replace) |
| DELETE | Yes |
| POST | **No** (creates new resource each time) |
| PATCH | Often no |

**Make non-idempotent operations idempotent** with an idempotency key.

---

## Idempotency keys

Client sends a unique key per logical operation:

```
POST /payments
Headers: Idempotency-Key: uuid-abc-123
Body: { amount: 100, to: "alice" }

Server:
  1. Check if uuid-abc-123 already processed
  2. If yes → return stored result (don't charge again)
  3. If no → process, store result keyed by uuid-abc-123
```

Storage: Redis or DB table with TTL (e.g., 24 hours).

Used by: Stripe, PayPal, most payment APIs.

---

## Idempotent consumers (queues)

Worker receives the same message twice (at-least-once delivery):

```
Message: { order_id: 42, action: "send_email" }

Worker:
  1. Check: already sent email for order 42?
  2. If yes → ack message, skip
  3. If no → send email, record in DB, ack
```

**Natural idempotency:** `UPDATE users SET name='Alice' WHERE id=5` — safe to run twice.  
**Not idempotent:** `INSERT INTO orders ...` without unique constraint — creates duplicates.

**Fix:** Unique constraints, upserts (`INSERT ... ON CONFLICT DO NOTHING`).

---

## Circuit breaker

When a downstream service fails repeatedly, stop calling it to prevent cascade failure.

```
States:
  CLOSED  → normal, requests pass through
  OPEN    → failures exceeded threshold → fail fast, don't call downstream
  HALF-OPEN → after timeout, allow one test request → success → CLOSED
                                              fail → OPEN
```

```
Service A → [Circuit Breaker] → Service B (down)
                ↓ OPEN
            Return cached fallback / error immediately
```

Prevents Service A from exhausting threads waiting on dead Service B.

---

## Retry with exponential backoff

```
Attempt 1 → fail → wait 1s
Attempt 2 → fail → wait 2s
Attempt 3 → fail → wait 4s
Attempt 4 → fail → wait 8s → give up / DLQ
```

Add **jitter** (random delay) to prevent all clients retrying simultaneously (thundering herd).

---

## Saga pattern (distributed transactions)

No single ACID transaction across microservices. Use a **saga** — sequence of local transactions with compensating actions.

**Example: Book flight + hotel**

```
Step 1: Book flight     ✓
Step 2: Book hotel      ✗ fails
Compensate: Cancel flight ✓
```

| Saga type | How it works |
|-----------|--------------|
| **Choreography** | Each service listens to events and reacts (decentralized) |
| **Orchestration** | Central coordinator tells each service what to do |

**Trade-off vs 2PC:** Sagas are available and scalable; temporarily inconsistent during execution.

---

## Two-phase commit (2PC) — know the concept

Coordinator asks all participants to **prepare**, then **commit** or **abort**.

**Pros:** Strong consistency across services  
**Cons:** Blocking, coordinator is SPOF, slow — rarely used in microservices at scale

**When mentioned in interviews:** Acknowledge it exists, prefer sagas or outbox pattern for most systems.

---

## Outbox pattern

Guarantee DB write and event publish happen together:

```
BEGIN TRANSACTION
  INSERT INTO orders ...
  INSERT INTO outbox (event: "order_created", payload: ...)
COMMIT

Separate poller reads outbox → publishes to Kafka → marks sent
```

Avoids: order saved in DB but event never published (or vice versa).

---

## Graceful degradation

When dependencies fail, reduce functionality instead of total outage:

| Failure | Degradation |
|---------|-------------|
| Recommendation service down | Show popular items instead |
| Search down | Browse categories only |
| Cache down | Serve from DB (slower but works) |
| Analytics down | Skip tracking, core app works |

Define **fallbacks** for every critical dependency.

---

## Check yourself

1. Why is POST not idempotent? How do you fix it?
2. Explain idempotency keys with an example.
3. What are the three states of a circuit breaker?
4. What is a saga and when do you use it over 2PC?
5. What problem does the outbox pattern solve?

## Key takeaway

Design every write path and queue consumer to be **safe under retry**. Use idempotency keys, unique constraints, circuit breakers, and sagas for multi-step workflows.
