# Learning Checklist — Full Curriculum (Modules 00–21)

Use with [SYLLABUS.md](SYLLABUS.md). Check when you can do each item **without looking at solutions**.

---

## Part I — Foundations

### Module 00 — Distributed systems basics
- [ ] Explain client-server vs distributed system
- [ ] Name four fallacies of distributed computing
- [ ] Define latency, throughput, and partial failure
- [ ] Explain why network calls are unreliable

### Module 01 — Introduction
- [ ] Define microservice in your own words
- [ ] List six core characteristics of microservices
- [ ] Draw a simple 3-service architecture diagram
- [ ] Name three things microservices are NOT

### Module 02 — Monolith vs microservices
- [ ] Compare monolith and microservices on 5 dimensions
- [ ] Explain modular monolith as middle ground
- [ ] List three valid migration triggers
- [ ] Argue when NOT to split into microservices

### Module 03 — Core principles & DDD
- [ ] Explain single responsibility for services (business capability)
- [ ] Draw a context map with two bounded contexts
- [ ] Explain database-per-service rule
- [ ] State Conway's Law and its implication

### Module 04 — API & networking fundamentals
- [ ] Explain HTTP methods and status codes (200, 400, 404, 500)
- [ ] Describe request/response lifecycle
- [ ] Explain DNS, TCP, TLS at high level
- [ ] Define idempotency for POST/PUT

---

## Part II — Core Architecture

### Module 05 — Communication patterns
- [ ] Compare sync vs async communication
- [ ] Draw checkout sequence diagram (see [DATA-FLOW guide](docs/DATA-FLOW-AND-SYSTEM-DESIGN.md))
- [ ] Explain REST vs gRPC trade-offs
- [ ] Design pub/sub flow for OrderCreated event
- [ ] Choose orchestration vs choreography for a scenario

### Module 06 — Data management
- [ ] Explain CAP theorem and typical microservices choice
- [ ] Describe Saga with compensating transactions
- [ ] Explain Outbox pattern purpose
- [ ] Define eventual consistency with example

### Module 07 — Reliability & resilience
- [ ] Configure timeout/retry/circuit breaker rationale
- [ ] Explain bulkhead pattern
- [ ] Design graceful degradation for one service down
- [ ] Define liveness vs readiness probes

### Module 08 — Scalability patterns
- [ ] Compare vertical vs horizontal scaling
- [ ] Explain stateless vs stateful service scaling
- [ ] Choose sharding vs read replica for a scenario
- [ ] Describe cache-aside pattern
- [ ] Explain independent per-service scaling benefit

### Module 09 — Performance engineering
- [ ] Decompose a 300ms latency budget across services
- [ ] Explain p50 vs p99 and why average misleads
- [ ] Identify sync chain latency penalty
- [ ] List three ways to reduce chatty APIs

### Module 10 — Time complexity
- [ ] State complexity of k-hop sequential sync chain
- [ ] Compare parallel fan-out vs sequential chain
- [ ] Analyze saga step and compensation complexity
- [ ] Explain why microservices can hurt request-path latency

---

## Part III — Production

### Module 11 — Security
- [ ] Distinguish authentication vs authorization
- [ ] Explain JWT and OAuth2/OIDC at high level
- [ ] Describe zero trust for service-to-service calls
- [ ] List three secrets management rules

### Module 12 — Observability & SLOs
- [ ] Name three pillars: logs, metrics, traces
- [ ] Define SLI, SLO, error budget
- [ ] Explain traceId correlation across services
- [ ] Design one actionable alert (not noisy)

### Module 13 — Deployment & DevOps
- [ ] Explain container vs orchestrator role
- [ ] Compare rolling, blue-green, canary deployment
- [ ] Describe CI/CD pipeline per service
- [ ] Explain HPA autoscaling trigger

### Module 14 — Flexibility & evolvability
- [ ] Explain independent deployment benefits
- [ ] Describe Strangler Fig migration
- [ ] List API backward-compatibility rules
- [ ] Explain polyglot persistence trade-off

### Module 15 — Testing & contracts
- [ ] Distinguish unit, integration, contract, E2E tests
- [ ] Explain consumer-driven contract testing
- [ ] Design test pyramid for microservices
- [ ] Name what to mock vs run real in tests

---

## Part IV — Advanced

### Module 16 — Advanced patterns
- [ ] Explain CQRS read/write split
- [ ] Describe event sourcing vs CRUD
- [ ] When to use API Gateway vs BFF
- [ ] Explain Sidecar pattern

### Module 17 — Gateway & service mesh
- [ ] List API Gateway responsibilities
- [ ] Compare mesh vs library-based resilience
- [ ] Explain mTLS automation via mesh
- [ ] When mesh is worth the complexity

### Module 18 — Multi-region HA & DR
- [ ] Compare active-active vs active-passive
- [ ] Explain RPO and RTO
- [ ] Describe multi-region data consistency challenges
- [ ] Design failover strategy outline

### Module 19 — Capacity planning & cost
- [ ] Estimate QPS from daily active users
- [ ] Calculate instances needed from per-node throughput
- [ ] Identify cost drivers in microservices ops
- [ ] Plan load test before launch

### Module 20 — Trade-offs & decisions
- [ ] Complete decision framework questionnaire
- [ ] Name five anti-patterns
- [ ] Write a one-page ADR
- [ ] Explain Microservices Premium concept

### Module 21 — Capstone
- [ ] Design full e-commerce microservices architecture
- [ ] Include context DFD, Level 1 DFD, system design, sequence + event flows
- [ ] Document latency budget and complexity analysis
- [ ] Include scalability, security, observability sections
- [ ] Present trade-offs and rejected alternatives

---

## Course complete

When all boxes are checked, review [appendices/D-interview-prep.md](docs/appendices/D-interview-prep.md) and redo capstone from scratch timed (2 hours).
