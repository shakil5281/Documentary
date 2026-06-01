# Appendix D — Interview & Design Prep

Common microservices architecture questions with answer frameworks.

---

## Fundamentals

**Q: What is a microservice?**  
A: Independently deployable component implementing one business capability, owning its data, communicating over network.

**Q: Monolith vs microservices?**  
A: Monolith simpler, ACID, fast in-process. Microservices: independent deploy/scale, team autonomy, distributed complexity. Start monolith unless clear triggers.

**Q: What is database-per-service?**  
A: Each service owns its DB; others access via API only. Enables independence; complicates cross-service queries.

---

## Scalability & performance

**Q: How do microservices scale differently?**  
A: Horizontal scale per service — e.g., Order 20 instances, Admin 2. Requires stateless design, load balancing, async where possible.

**Q: Explain latency budget.**  
A: Allocate total user-facing time across hops; parallel paths use max branch not sum; enforce cascading timeouts.

**Q: Why can microservices be slower?**  
A: Network hops add ms each; k sequential sync calls → O(k) latency. Mitigate: parallel fan-out, cache, async, gRPC.

**Q: p99 vs average latency?**  
A: Average hides slow tail; p99 reflects user pain. SLOs should use percentiles.

---

## Data & consistency

**Q: Explain CAP theorem.**  
A: Under partition, choose consistency or availability. Microservices often AP + eventual consistency.

**Q: What is Saga?**  
A: Sequence of local transactions with compensating actions on failure. Orchestrated vs choreographed.

**Q: What is Outbox pattern?**  
A: Write event to outbox table in same DB tx as business data; relay publishes to broker atomically from app view.

---

## Communication

**Q: Sync vs async?**  
A: Sync when immediate answer needed; async for decoupling, multiple subscribers, peak buffering.

**Q: Orchestration vs choreography?**  
A: Orchestration: central boss, clear rollback. Choreography: event reactions, loose coupling, harder trace.

---

## Resilience

**Q: Circuit breaker states?**  
A: Closed (normal) → Open (fail fast) → Half-Open (test one call).

**Q: How prevent cascading failure?**  
A: Timeouts, circuit breakers, bulkheads, async, fallbacks.

---

## Design exercise framework

1. **Requirements** — functional + NFR (QPS, p99, availability)
2. **Estimate** — back-of-envelope QPS, storage
3. **API/services** — bounded contexts, service list
4. **Data** — DB per service, events, Saga if needed
5. **Communication** — sync/async diagram
6. **Scale** — what scales, cache, sharding
7. **Failure** — timeouts, fallbacks, degradation
8. **Trade-offs** — what you rejected and why

---

## Sample design prompt

*"Design an e-commerce checkout flow with payment and inventory."*

Checklist: Order Service orchestrates or events; Payment isolated (PCI); Saga for failure; idempotent payment; 300ms budget; async notification; p99 SLO.

---

Review [21-capstone-architecture-projects.md](../part-04-advanced/21-capstone-architecture-projects.md) for full practice.
