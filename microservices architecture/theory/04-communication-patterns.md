# 04 — Communication Patterns

**Level:** Intermediate  
**Estimated reading time:** 35 minutes  
**Previous:** [03 — Core Principles](./03-core-principles.md)  
**Next:** [05 — Data Management](./05-data-management.md)

---

## Why Communication Design Matters

In a monolith, modules call each other via function calls — fast, reliable, transactional. In microservices, every interaction crosses a network. This means:

- Latency is measured in milliseconds, not nanoseconds
- Calls can fail, time out, or return stale data
- The communication pattern you choose affects coupling, consistency, and resilience

There are two fundamental styles: **synchronous** and **asynchronous**.

---

## Synchronous Communication

The caller sends a request and **waits** for a response before continuing.

```
Client ──request──► Service A ──request──► Service B
Client ◄─response── Service A ◄─response── Service B
```

### REST (Representational State Transfer)

The most common synchronous style. Uses HTTP methods and JSON payloads.

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Read data | `GET /orders/123` |
| POST | Create resource | `POST /orders` |
| PUT | Full update | `PUT /orders/123` |
| PATCH | Partial update | `PATCH /orders/123/status` |
| DELETE | Remove resource | `DELETE /orders/123` |

**Strengths:** Simple, widely understood, great tooling, cacheable (GET), human-readable.
**Weaknesses:** No built-in contract enforcement, overhead of HTTP/JSON, chatty if many calls needed.

### gRPC (Google Remote Procedure Call)

Uses HTTP/2 and Protocol Buffers (binary serialization). Defines strict contracts via `.proto` files.

**Strengths:** Fast (binary), strong typing, bi-directional streaming, auto-generated client/server code.
**Weaknesses:** Not browser-friendly (needs grpc-web proxy), harder to debug (binary payloads), steeper learning curve.

### When to Use Synchronous

- You need an immediate response (e.g., "Is this user authenticated?")
- The operation is a simple query or command
- The caller cannot proceed without the result
- Low latency is critical and the dependency is reliable

### Risks of Synchronous

- **Cascading failures** — if Service B is slow, Service A waits, and its callers wait too
- **Tight coupling** — caller must know callee's location, format, and availability
- **Latency accumulation** — a request touching 5 services synchronously adds 5x network latency

---

## Asynchronous Communication

The sender publishes a message or event and **does not wait** for the receiver to process it.

```
Service A ──publish event──► Message Broker ──deliver──► Service B
Service A continues working immediately
```

### Message Queue (Point-to-Point)

One sender, one receiver per message. Used for task distribution.

```
Producer ──► [Queue] ──► Consumer
```

Example: Order Service places a message "Process Payment for Order #123" on a queue. Payment Service picks it up and processes it.

### Publish/Subscribe (Pub/Sub)

One sender, many receivers. Used for broadcasting events.

```
Publisher ──► [Topic] ──► Subscriber A
                      ──► Subscriber B
                      ──► Subscriber C
```

Example: Order Service publishes "OrderCreated" event. Notification Service sends confirmation email, Inventory Service reserves stock, Analytics Service records the sale.

### Common Messaging Platforms

| Platform | Type | Notes |
|----------|------|-------|
| RabbitMQ | Message broker | Flexible routing, good for task queues |
| Apache Kafka | Event streaming | High throughput, event log, replay capability |
| Amazon SQS/SNS | Managed queue/pub-sub | AWS-native, serverless-friendly |
| Redis Pub/Sub | In-memory | Fast, but not durable (messages lost if no subscriber) |

### When to Use Asynchronous

- The operation can happen later (send email, update analytics)
- Multiple services need to react to the same event
- You want to decouple services (sender doesn't need to know receivers)
- Peak load buffering (queue absorbs traffic spikes)

---

## Event-Driven Architecture (EDA)

In EDA, services communicate by producing and consuming **domain events** — facts about things that happened in the business.

| Event | Meaning | Published by |
|-------|---------|-------------|
| `OrderCreated` | A new order was placed | Order Service |
| `PaymentCompleted` | Payment was successful | Payment Service |
| `InventoryReserved` | Stock was reserved | Inventory Service |
| `OrderShipped` | Order left the warehouse | Shipping Service |

Events are named in **past tense** because they describe something that already happened.

### Event Notification vs Event-Carried State Transfer

| Style | Payload | Use case |
|-------|---------|----------|
| **Event notification** | Minimal (just the event type and ID) | Receiver calls back for details if needed |
| **Event-carried state transfer** | Full data needed by consumers | Receiver can act without calling back |

Event-carried state transfer reduces coupling (no callback needed) but increases payload size and creates data duplication.

---

## Orchestration vs Choreography

When a business process spans multiple services, you need to coordinate the workflow.

### Orchestration (Central Coordinator)

One service (the orchestrator) tells others what to do and in what order.

```
Orchestrator ──► Payment Service: "Charge $50"
Orchestrator ◄── Payment Service: "Done"
Orchestrator ──► Inventory Service: "Reserve items"
Orchestrator ◄── Inventory Service: "Done"
Orchestrator ──► Notification Service: "Send confirmation"
```

**Pros:** Clear workflow, easy to understand, centralized error handling.  
**Cons:** Orchestrator becomes a bottleneck, tight coupling to orchestrator.

### Choreography (Decentralized)

Each service reacts to events and publishes its own events. No central coordinator.

```
Order Service ──publishes──► OrderCreated
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
              Payment Svc  Inventory Svc  Notification Svc
                    │           │
              PaymentCompleted  InventoryReserved
                    │           │
                    └─────┬─────┘
                          ▼
                   Order Service marks complete
```

**Pros:** Loose coupling, no single point of failure, services are autonomous.  
**Cons:** Harder to understand the full workflow, harder to debug, no central error handling.

### Choosing Between Them

| Factor | Prefer Orchestration | Prefer Choreography |
|--------|---------------------|---------------------|
| Workflow complexity | Complex, many steps | Simple, few steps |
| Error handling | Need centralized rollback | Each service handles its own |
| Visibility | Need to see full process state | Process is simple enough to trace via events |
| Team structure | One team owns the workflow | Each team owns its service independently |

---

## API Versioning

When a service's API changes, consumers may break. Strategies:

| Strategy | How | Trade-off |
|----------|-----|-----------|
| **URL versioning** | `/v1/orders`, `/v2/orders` | Explicit but clutters URLs |
| **Header versioning** | `Accept: application/vnd.myapp.v2+json` | Clean URLs, harder to test in browser |
| **Backward compatibility** | Add fields, never remove; deprecate old endpoints gradually | Best UX for consumers, requires discipline |

Rule of thumb: prefer backward-compatible changes. When breaking changes are unavoidable, support both versions during a transition period.

---

## Idempotency

An operation is **idempotent** if performing it multiple times produces the same result as performing it once.

Critical in microservices because messages may be delivered more than once (at-least-once delivery).

Example: `POST /payments` with an `Idempotency-Key: abc123` header. If the request is retried, the server recognizes the key and returns the original result instead of charging twice.

Every write operation that can be retried should be idempotent.

---

## Summary

- Synchronous (REST, gRPC) for immediate responses; asynchronous (queues, events) for decoupling.
- Event-driven architecture uses domain events to communicate state changes.
- Choose orchestration for complex workflows; choreography for simple, independent reactions.
- Version APIs carefully and design write operations to be idempotent.

---

**Next:** [05 — Data Management →](./05-data-management.md)
