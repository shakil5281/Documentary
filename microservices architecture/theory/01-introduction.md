# 01 — Introduction to Microservices

**Level:** Beginner  
**Estimated reading time:** 20 minutes  
**Previous:** —  
**Next:** [02 — Monolith vs Microservices](./02-monolith-vs-microservices.md)

---

## What Is a Microservice?

A **microservice** is a small, independently deployable software component that implements a single business capability. It runs as its own process, communicates over a network (typically HTTP or messaging), and owns its own data.

Microservices are not a technology — they are an **architectural style**. You can build them in Java, Go, Node.js, Python, or any language. The defining characteristics are organizational and structural, not syntactic.

---

## Historical Context

Before microservices, most applications were built as **monoliths** — one large codebase deployed as a single unit. This worked well for small teams and early-stage products.

As systems grew, monoliths became harder to:

- Deploy (every change required redeploying everything)
- Scale (you had to scale the entire app, not just the busy part)
- Maintain (large codebases become tangled and slow to change)

Microservices emerged as a response to these scaling problems — both technical and organizational. The term gained popularity around 2014, influenced by companies like Netflix, Amazon, and Spotify that had already been decomposing systems for years.

---

## Core Characteristics

| Characteristic | Meaning |
|----------------|---------|
| **Single responsibility** | Each service does one business job (e.g., billing, inventory, notifications) |
| **Independent deployment** | You can release one service without redeploying others |
| **Decentralized data** | Each service owns and manages its own data store |
| **Loose coupling** | Services interact through well-defined APIs or events, not shared code or databases |
| **Organized around business capabilities** | Boundaries follow domain concepts, not technical layers |
| **Failure isolation** | A crash in one service should not bring down the entire system |

---

## Key Vocabulary

| Term | Definition |
|------|------------|
| **Service** | An independently running application component with a defined interface |
| **API (Application Programming Interface)** | The contract through which a service exposes its capabilities to others |
| **Endpoint** | A specific URL or address where a service accepts requests |
| **Client** | Any component that calls another service (can be a frontend, another service, or a gateway) |
| **Bounded context** | A domain boundary within which a particular model and terminology apply (from Domain-Driven Design) |
| **Orchestration** | One service coordinates a workflow by calling others in sequence |
| **Choreography** | Services react to events independently without a central coordinator |
| **Eventual consistency** | Data across services will become consistent over time, but not instantly |
| **Service discovery** | A mechanism for services to find each other's network locations dynamically |

---

## A Simple Example: Online Bookstore

Imagine an online bookstore built with microservices:

```
                    ┌─────────────────┐
                    │   Web / Mobile   │
                    │     Frontend     │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   API Gateway   │
                    └────────┬────────┘
           ┌─────────────────┼─────────────────┐
           │                 │                 │
    ┌──────▼──────┐  ┌───────▼──────┐  ┌───────▼──────┐
    │    User     │  │   Catalog    │  │    Order     │
    │   Service   │  │   Service    │  │   Service    │
    └──────┬──────┘  └───────┬──────┘  └───────┬──────┘
           │                 │                 │
    ┌──────▼──────┐  ┌───────▼──────┐  ┌───────▼──────┐
    │  User DB    │  │  Catalog DB  │  │   Order DB   │
    └─────────────┘  └──────────────┘  └──────────────┘
```

- **User Service** — registration, login, profiles
- **Catalog Service** — books, search, categories
- **Order Service** — shopping cart, checkout, order history

Each service has its own database. The frontend talks to an API Gateway, which routes requests to the correct service.

---

## What Microservices Are NOT

| Misconception | Reality |
|---------------|---------|
| "Microservices = small code files" | Size is not the point. A service can be thousands of lines if it does one job well. |
| "Microservices = many REST APIs" | Communication style (REST, gRPC, events) is a detail. Architecture is about independence and boundaries. |
| "Microservices always mean better performance" | More network hops can add latency. The benefit is scalability and team autonomy, not raw speed. |
| "Microservices eliminate complexity" | They **move** complexity from code structure to network, data, and operations. |
| "Every project should use microservices" | Most early-stage products are better served by a well-structured monolith. |

---

## The Distributed Systems Reality

When you adopt microservices, you are building a **distributed system**. This introduces challenges that do not exist in a monolith:

- **Network failures** — calls between services can time out or fail
- **Partial failures** — one service down does not mean all are down, but the user experience may degrade
- **Data consistency** — you cannot use a single database transaction across services
- **Operational complexity** — you now manage many deployable units, not one

Understanding these challenges is essential. Microservices trade **development simplicity** for **operational and architectural flexibility**.

---

## Summary

- Microservices are independently deployable services organized around business capabilities.
- They solve scaling and team coordination problems at the cost of distributed-system complexity.
- Key concepts: service boundaries, independent deployment, decentralized data, loose coupling.
- They are an architectural choice, not a default best practice.

---

**Next:** [02 — Monolith vs Microservices →](./02-monolith-vs-microservices.md)
