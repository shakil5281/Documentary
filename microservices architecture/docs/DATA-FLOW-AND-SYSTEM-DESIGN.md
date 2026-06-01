# Data Flow Diagrams & System Design (Microservices)

> **Reference guide** — read after Module 04, before or with Modules 05–10  
> **Related:** [05 Communication](./part-02-core-architecture/05-communication-patterns.md) · [06 Data Management](./part-02-core-architecture/06-data-management.md) · [21 Capstone](./part-04-advanced/21-capstone-architecture-projects.md)

## Learning outcomes

After this guide you can:

1. Draw context and Level 1 data flow diagrams for a microservices system
2. Produce a system design with services, databases, and message flows
3. Distinguish sync request flow vs async event flow
4. Document read path, write path, and checkout saga flow

---

## Part 1 — Data Flow Diagram (DFD) basics

A **Data Flow Diagram** shows how **data moves** between external entities, processes, and data stores. It answers: *who sends what to whom?*

### DFD levels

| Level | Shows | Microservices equivalent |
|-------|-------|--------------------------|
| **Context (0)** | Whole system + external actors | Platform boundary + users/partners |
| **Level 1** | Major processes inside system | Services or bounded contexts |
| **Level 2+** | Detail inside one process | Internal service logic (optional) |

### Symbols

| Symbol | Name | Microservices example |
|--------|------|------------------------|
| Rectangle / actor | External entity | Customer, Admin, Payment Gateway |
| Circle / process | Process | Order Service, Payment Service |
| Open box / cylinder | Data store | Order DB, Catalog DB |
| Arrow | Data flow | OrderRequest, PaymentCompleted event |

**Note:** In microservices, each **data store** belongs to **one service** only. No shared database arrows between services.

---

## Part 2 — Context diagram (Level 0)

E-commerce platform as one system boundary:

```mermaid
flowchart LR
    Customer([Customer])
    Admin([Admin])
    PaymentGW([Payment Gateway])

    subgraph Platform["E-Commerce Platform"]
        System((Microservices Platform))
    end

    Customer -->|"Browse, Order, Pay"| System
    System -->|"Confirmation, Tracking"| Customer
    Admin -->|"Manage catalog, reports"| System
    System -->|"Analytics dashboards"| Admin
    System -->|"Charge request"| PaymentGW
    PaymentGW -->|"Auth result"| System
```

---

## Part 3 — Level 1 DFD (microservices processes)

Each process maps to a **service**. Data stores are **per service**.

```mermaid
flowchart TB
    Customer([Customer])

    P1[1.0 User Service]
    P2[2.0 Catalog Service]
    P3[3.0 Order Service]
    P4[4.0 Payment Service]
    P5[5.0 Inventory Service]
    P6[6.0 Notification Service]

    D1[(D1: User DB)]
    D2[(D2: Catalog DB)]
    D3[(D3: Order DB)]
    D4[(D4: Payment DB)]
    D5[(D5: Inventory DB)]

    PG([Payment Gateway])

    Customer -->|"Login / profile"| P1
    P1 <-->|"User data"| D1

    Customer -->|"Search products"| P2
    P2 <-->|"Products"| D2

    Customer -->|"Place order"| P3
    P3 <-->|"Orders"| D3
    P3 -->|"Product snapshot"| P2
    P3 -->|"Charge"| P4
    P4 <-->|"Payments"| D4
    P4 -->|"Process payment"| PG
    PG -->|"Result"| P4
    P3 -->|"Reserve stock"| P5
    P5 <-->|"Stock"| D5
    P3 -->|"OrderCreated event"| P6
    P6 -->|"Email"| Customer
```

### Data flow labels (checkout)

| Flow | From → To | Data |
|------|-----------|------|
| F1 | Customer → Order | OrderRequest (items, address) |
| F2 | Order → Catalog | ProductIds (read snapshot) |
| F3 | Order → Payment | ChargeRequest (amount, idempotency key) |
| F4 | Payment → Gateway | Card token / payment intent |
| F5 | Order → Inventory | ReserveRequest (sku, qty) |
| F6 | Order → Broker → Notification | OrderCreated event |

---

## Part 4 — System design architecture

### 4.1 High-level system design (containers)

```mermaid
flowchart TB
    subgraph clients [Clients]
        Web[Web App]
        Mobile[Mobile App]
    end

    subgraph edge [Edge]
        CDN[CDN]
        GW[API Gateway]
    end

    subgraph services [Microservices]
        UserSvc[User Service]
        CatalogSvc[Catalog Service]
        CartSvc[Cart Service]
        OrderSvc[Order Service]
        PaymentSvc[Payment Service]
        InvSvc[Inventory Service]
        SearchSvc[Search Service]
        NotifySvc[Notification Service]
    end

    subgraph messaging [Messaging]
        Broker[Event Bus / Kafka]
    end

    subgraph data [Data Stores]
        UserDB[(User DB)]
        CatalogDB[(Catalog DB)]
        OrderDB[(Order DB)]
        PaymentDB[(Payment DB)]
        InvDB[(Inventory DB)]
        Redis[(Redis Cache)]
        ES[(Elasticsearch)]
    end

    Web --> CDN
    Mobile --> GW
    CDN --> GW
    GW --> UserSvc
    GW --> CatalogSvc
    GW --> CartSvc
    GW --> OrderSvc
    GW --> SearchSvc

    UserSvc --> UserDB
    CatalogSvc --> CatalogDB
    CatalogSvc --> Redis
    OrderSvc --> OrderDB
    PaymentSvc --> PaymentDB
    InvSvc --> InvDB
    SearchSvc --> ES

    OrderSvc --> PaymentSvc
    OrderSvc --> InvSvc
    OrderSvc --> Broker
    Broker --> NotifySvc
    Broker --> SearchSvc
```

### 4.2 Layer responsibilities

| Layer | Components | Responsibility |
|-------|------------|----------------|
| Client | Web, Mobile | UI, user interaction |
| Edge | CDN, API Gateway | TLS, auth, rate limit, routing |
| Services | User, Order, Payment… | Business logic, own data |
| Messaging | Kafka/RabbitMQ | Async events, decoupling |
| Data | DB per service, cache, search | Persistence, read optimization |

---

## Part 5 — Request data flow (synchronous)

### 5.1 Product detail page (parallel fan-out)

```mermaid
sequenceDiagram
    participant Client
    participant GW as API Gateway
    participant Catalog
    participant Reviews
    participant Inv as Inventory

    Client->>GW: GET /products/123
    par Parallel calls
        GW->>Catalog: GET product
        GW->>Reviews: GET reviews
        GW->>Inv: GET stock
    end
    Catalog-->>GW: product JSON
    Reviews-->>GW: reviews JSON
    Inv-->>GW: stock JSON
    GW-->>Client: merged response
```

**Time complexity:** O(1) wall-clock ≈ slowest branch (Module 10).

### 5.2 Checkout (sequential + parallel)

```mermaid
sequenceDiagram
    participant Client
    participant GW as Gateway
    participant Order
    participant Payment
    participant Inv as Inventory
    participant Broker

    Client->>GW: POST /checkout
    GW->>Order: create order
    Order->>Order: save PENDING

    par Payment and Inventory
        Order->>Payment: charge
        Order->>Inv: reserve
    end

    Payment-->>Order: PaymentCompleted
    Inv-->>Order: InventoryReserved
    Order->>Order: mark CONFIRMED
    Order->>Broker: OrderConfirmed
    Order-->>GW: 201 Created
    GW-->>Client: order id
```

---

## Part 6 — Event data flow (asynchronous)

### 6.1 Choreographed checkout events

```mermaid
flowchart LR
    OrderSvc[Order Service] -->|"OrderCreated"| Broker[Event Bus]
    Broker -->|"OrderCreated"| PaymentSvc[Payment Service]
    Broker -->|"OrderCreated"| InvSvc[Inventory Service]
    Broker -->|"OrderCreated"| AnalyticsSvc[Analytics]

    PaymentSvc -->|"PaymentCompleted"| Broker
    InvSvc -->|"InventoryReserved"| Broker
    Broker -->|"PaymentCompleted"| OrderSvc
    Broker -->|"InventoryReserved"| OrderSvc
    Broker -->|"OrderConfirmed"| NotifySvc[Notification]
    NotifySvc -->|"Email"| Customer([Customer])
```

### 6.2 Event-carried state transfer

```
OrderCreated {
  orderId: "ORD-123",
  customerId: "USR-456",
  items: [{ sku, name, price, qty }],
  total: 99.99
}
```

Notification Service acts **without** calling Order Service again.

---

## Part 7 — Read path vs write path (CQRS-style)

```mermaid
flowchart TB
    subgraph writePath [Write Path - Commands]
        ClientW[Client] --> GWW[Gateway]
        GWW --> OrderW[Order Service]
        OrderW --> OrderDBW[(Order DB)]
        OrderW -->|"OrderCreated"| BrokerW[Event Bus]
    end

    subgraph readPath [Read Path - Queries]
        ClientR[Client] --> GWR[Gateway]
        GWR --> ReadAPI[Order Read API]
        ReadAPI --> ReadDB[(Read Model DB)]
        BrokerW -->|"project events"| ReadDB
    end
```

| Path | Optimized for | Consistency |
|------|---------------|-------------|
| Write | Validations, transactions | Strong within service |
| Read | Fast lists, dashboards | Eventual (ms–seconds lag) |

---

## Part 8 — Saga failure data flow

When inventory fails after payment succeeds:

```mermaid
flowchart TB
    Start([OrderCreated]) --> Pay[Payment: Charge OK]
    Pay --> Inv[Inventory: Reserve FAIL]
    Inv --> CompPay[Compensate: Refund]
    CompPay --> CompOrder[Compensate: Cancel Order]
    CompOrder --> End([Order CANCELLED])

    Pay -.->|"PaymentCompleted"| Inv
    Inv -.->|"InventoryFailed"| CompPay
    CompPay -.->|"PaymentRefunded"| CompOrder
```

---

## Part 9 — Deployment system design

```mermaid
flowchart TB
    subgraph internet [Internet]
        Users[Users]
    end

    subgraph cloud [Cloud Region]
        LB[Load Balancer]
        subgraph k8s [Kubernetes Cluster]
            GWpod[Gateway pods]
            Orderpods[Order pods x N]
            Paypods[Payment pods x N]
            Otherpods[Other services]
        end
        subgraph managed [Managed Services]
            RDS1[(Order DB)]
            RDS2[(Payment DB)]
            Kafka[Kafka Cluster]
            RedisCluster[Redis]
        end
    end

    Users --> LB
    LB --> GWpod
    GWpod --> Orderpods
    GWpod --> Paypods
    Orderpods --> RDS1
    Paypods --> RDS2
    Orderpods --> Kafka
    Orderpods --> Paypods
```

---

## Part 10 — Scalability data flow (peak traffic)

Black Friday — queue absorbs write spike:

```mermaid
flowchart LR
    Spike[Traffic Spike] --> GW[API Gateway]
    GW --> OrderSvc[Order Service]
    OrderSvc -->|"enqueue"| Queue[Order Queue]
    Queue --> Worker1[Order Worker 1]
    Queue --> Worker2[Order Worker N]
    Worker1 --> OrderDB[(Order DB)]
    Worker2 --> OrderDB
```

---

## Part 11 — Document your system design

For every project, maintain:

| Artifact | Purpose |
|----------|---------|
| Context DFD | Scope and external actors |
| Level 1 DFD | Services and data stores |
| System design diagram | Containers, gateway, broker, DBs |
| Sequence diagram | Critical sync flows (checkout, login) |
| Event flow diagram | Async choreography |
| Deployment diagram | K8s, regions, load balancers |
| Latency budget table | Per-hop ms allocation (Module 09) |

Template checklist for capstone: [21-capstone-architecture-projects.md](./part-04-advanced/21-capstone-architecture-projects.md)

---

## Part 12 — Common mistakes

| Mistake | Fix |
|---------|-----|
| Shared DB on DFD between services | One data store per service; use API/events |
| DFD shows HTTP methods | DFD shows **data**, not REST verbs |
| No event flows on diagram | Add broker + subscribers for async paths |
| One diagram for everything | Separate context, system design, sequence, event flow |

---

## Practice exercises

1. Draw a **context DFD** for a food delivery app (Customer, Restaurant, Driver, Payment).
2. Draw **Level 1 DFD** with at least 5 services and 5 data stores.
3. Draw **sequence diagram** for login → browse → checkout.
4. Label which flows are **sync** vs **async**.
5. Add **failure saga** path for payment success + inventory fail.

Solutions approach: [exercises/module-05.md](../exercises/module-05.md) · Capstone: [module-21.md](../exercises/module-21.md)

---

## Next reading

- [05 — Communication Patterns](./part-02-core-architecture/05-communication-patterns.md)
- [08 — Scalability Patterns](./part-02-core-architecture/08-scalability-patterns.md)
- [21 — Capstone Architecture Projects](./part-04-advanced/21-capstone-architecture-projects.md)
