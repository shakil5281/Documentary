# 10 — Advanced Patterns

**Level:** Advanced  
**Estimated reading time:** 40 minutes  
**Previous:** [09 — Deployment & DevOps](./09-deployment-and-devops.md)  
**Next:** [11 — Trade-offs & Decision Framework](./11-tradeoffs-and-decision-framework.md)

---

## API Gateway

A single entry point that routes client requests to the appropriate backend services.

```
                    Clients
                      │
              ┌───────▼───────┐
              │  API Gateway  │
              │               │
              │ • Routing     │
              │ • Auth        │
              │ • Rate limit  │
              │ • SSL/TLS     │
              │ • Logging     │
              └───┬───┬───┬───┘
                  │   │   │
            ┌─────┘   │   └─────┐
            ▼         ▼         ▼
       User Svc   Order Svc  Catalog Svc
```

### Responsibilities

| Function | Detail |
|----------|--------|
| **Request routing** | `/users/*` → User Service, `/orders/*` → Order Service |
| **Authentication** | Validate tokens before forwarding |
| **Rate limiting** | Protect backend from overload |
| **Request/response transformation** | Adapt external API format to internal format |
| **SSL termination** | Handle HTTPS at the edge |
| **Caching** | Cache GET responses for frequently accessed data |
| **Load balancing** | Distribute requests across service instances |

### Popular Gateways

| Gateway | Notes |
|---------|-------|
| Kong | Plugin-rich, Lua-based |
| NGINX / NGINX Plus | High performance, widely deployed |
| AWS API Gateway | Managed, serverless-friendly |
| Envoy | Modern, used as data plane in service meshes |

### API Gateway vs Load Balancer

A load balancer distributes traffic across identical instances of one service. An API Gateway routes to **different** services based on the request path, method, or headers, and applies cross-cutting policies.

---

## Backend for Frontend (BFF)

When different client types (web, mobile, IoT) need different data shapes or aggregation, a single API Gateway becomes a bloated "god object."

**Solution:** One backend per frontend type.

```
Web App ──► Web BFF ──► User Service, Order Service, Catalog Service
Mobile  ──► Mobile BFF ──► User Service, Order Service (lighter payload)
Admin   ──► Admin BFF ──► All services (more data, admin operations)
```

Each BFF:

- Aggregates data from multiple services into the exact shape its client needs
- Handles client-specific logic (mobile gets compressed images, web gets full data)
- Reduces over-fetching and under-fetching

---

## CQRS (Command Query Responsibility Segregation)

Separate the **write model** (commands that change state) from the **read model** (queries that read state).

```
Commands (writes)                Queries (reads)
       │                               │
       ▼                               ▼
┌──────────────┐              ┌──────────────┐
│ Write Model  │── events ──► │  Read Model  │
│ (normalized, │              │ (denormalized│
│  business    │              │  optimized   │
│  rules)      │              │  for queries)│
└──────────────┘              └──────────────┘
```

Example: Order Service

- **Write side:** Accepts `CreateOrder` command, validates business rules, stores in normalized Order DB
- **Read side:** Maintains a denormalized view (order + customer name + product names) optimized for "show my orders" queries

Why use CQRS:

- Read and write workloads have different scaling needs
- Complex queries don't slow down writes
- Read models can be tailored per use case (admin dashboard vs customer view)

When NOT to use:

- Simple CRUD applications
- Read and write patterns are similar
- Added complexity isn't justified

---

## Event Sourcing

Instead of storing current state, store the **sequence of events** that led to the current state. Current state is derived by replaying events.

Traditional:
```
orders table: { id: 123, status: "CONFIRMED", total: 49.99 }
```

Event sourcing:
```
events table:
  1. OrderCreated     { id: 123, items: [...], total: 49.99 }
  2. PaymentCompleted { id: 123, paymentId: "PAY-456" }
  3. OrderConfirmed   { id: 123 }
  
Current state = replay events 1 → 2 → 3 → status: CONFIRMED
```

Benefits:

- **Complete audit trail** — every state change is recorded
- **Temporal queries** — "What was the order status at 3pm yesterday?"
- **Event replay** — rebuild read models or fix bugs by replaying events
- **Natural fit with event-driven architecture**

Drawbacks:

- Complexity — event schema evolution, snapshots for performance
- Eventually consistent read models
- Steeper learning curve for developers
- Not all domains benefit from full event history

CQRS and Event Sourcing are often used together but can be used independently.

---

## Service Mesh

A dedicated infrastructure layer that handles service-to-service communication, removing this responsibility from application code.

```
┌─────────────────────────────────────────────┐
│              Service Mesh (data plane)       │
│                                              │
│  ┌────────┐  Sidecar   Sidecar  ┌────────┐  │
│  │Service │  Proxy     Proxy   │Service │  │
│  │   A    │◄─►│  ◄──────►  │◄─►│   B    │  │
│  └────────┘  Envoy    Envoy   └────────┘  │
│                                              │
│  Control Plane (Istiod / Linkerd controller) │
│  • mTLS certificate management               │
│  • Traffic routing rules                     │
│  • Observability config                      │
└─────────────────────────────────────────────┘
```

### What a Service Mesh Provides

| Feature | Without mesh | With mesh |
|---------|-------------|-----------|
| mTLS | Implement in each service | Automatic via sidecar proxy |
| Retries/timeouts | Code in each service | Configured in mesh |
| Circuit breaker | Library per language | Mesh-level policy |
| Traffic splitting (canary) | Custom implementation | Mesh routing rules |
| Observability | Instrument each service | Automatic metrics/traces from proxy |

### Popular Service Meshes

| Mesh | Notes |
|------|-------|
| Istio | Feature-rich, complex, widely adopted |
| Linkerd | Lightweight, simpler, Rust-based proxy |
| Consul Connect | HashiCorp ecosystem integration |

When to adopt: when you have 10+ services and cross-cutting communication concerns (mTLS, retries, tracing) become repetitive across services.

When to skip: small number of services, team lacks operational maturity for mesh complexity.

---

## Strangler Fig Pattern

A migration strategy for gradually replacing a monolith with microservices.

Named after strangler fig vines that gradually envelop a tree.

```
Phase 1:                    Phase 2:                    Phase 3:
┌──────────────┐            ┌──────┐ ┌──────────┐       ┌──────┐ ┌──────────┐
│   Monolith   │            │ New  │ │ Monolith │       │ New  │ │ Monolith │
│  (everything)│            │ Svc  │ │(shrinking)│       │ Svc  │ │(minimal) │
└──────────────┘            └──────┘ └──────────┘       └──────┘ └──────────┘
                                 ↑                          ↑
                            Facade routes              Most traffic
                            some traffic               to new services
                            to new service
```

Steps:

1. Place a facade (API Gateway) in front of the monolith
2. Identify a bounded context to extract (e.g., notifications)
3. Build the new microservice
4. Route specific requests from the facade to the new service
5. Gradually extract more contexts
6. Decommission the monolith when all functionality is migrated

---

## Sidecar Pattern

Deploy a helper container alongside the main service container in the same pod. The sidecar handles cross-cutting concerns.

```
Pod:
  ┌─────────────────┐  ┌─────────────────┐
  │  Main Container  │  │ Sidecar Container│
  │  (order-service) │  │ (Envoy proxy /   │
  │                  │  │  log shipper /   │
  │                  │  │  config sync)    │
  └─────────────────┘  └─────────────────┘
```

Used for: service mesh proxies, log collection, configuration synchronization, security agents.

---

## Anti-Corruption Layer (ACL)

When integrating with an external system or legacy service whose model doesn't match yours, place a translation layer between them.

```
Your Order Service ←→ [Anti-Corruption Layer] ←→ Legacy Billing System
                         (translates models,
                          hides legacy quirks)
```

The ACL:

- Translates external models into your domain model
- Protects your service from changes in the external system
- Isolates legacy complexity

---

## Summary

- **API Gateway** — single entry point with routing, auth, and rate limiting.
- **BFF** — dedicated backend per client type for tailored data aggregation.
- **CQRS** — separate read and write models for independent scaling and optimization.
- **Event Sourcing** — store events, derive state; full audit trail at the cost of complexity.
- **Service Mesh** — infrastructure layer for mTLS, retries, and observability across services.
- **Strangler Fig** — incremental monolith-to-microservices migration.
- Adopt advanced patterns only when simpler approaches are insufficient.

---

**Next:** [11 — Trade-offs & Decision Framework →](./11-tradeoffs-and-decision-framework.md)
