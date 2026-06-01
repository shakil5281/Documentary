# Appendix A — Glossary

100+ terms for the Microservices Architecture course.

---

## A

**Aggregate (DDD)** — Cluster of domain objects changed as one unit; has aggregate root.

**Anti-corruption layer** — Translation boundary protecting your model from external/legacy systems.

**API Gateway** — Single entry point routing, auth, rate limiting to backend services.

**Availability** — System responds to requests (CAP theorem).

**Autoscaling** — Automatic scale instances based on metrics (HPA).

---

## B

**Backpressure** — Slowing upstream when downstream is overloaded.

**Bounded context** — DDD boundary where a domain model applies consistently.

**Bulkhead** — Resource isolation limiting blast radius per dependency.

**BFF (Backend for Frontend)** — Dedicated API layer per client type (web/mobile).

---

## C

**Cache-aside** — App manages cache: read cache, on miss read DB and populate.

**Canary deployment** — Gradual traffic shift to new version with metric gates.

**CAP theorem** — Consistency, Availability, Partition tolerance — pick two under partition.

**Choreography** — Decentralized workflow via events without orchestrator.

**Circuit breaker** — Stop calling failing service; fail fast after threshold.

**CI/CD** — Continuous integration/deployment pipeline per service.

**Connection pooling** — Reuse TCP/TLS connections for performance.

**Consistency (strong)** — Every read sees latest write.

**Consumer-driven contract** — Consumer defines API expectations; provider verifies.

**Context map** — Diagram of relationships between bounded contexts.

**CQRS** — Separate read and write models.

---

## D

**Database-per-service** — Each microservice owns its data store exclusively.

**Deployment** — Process of releasing service version to environment.

**Distributed monolith** — Microservices that must deploy together (anti-pattern).

**Distributed tracing** — Track request across services via trace/spans.

**DNS** — Resolves hostnames to IP addresses.

---

## E

**Elasticity** — Scale resources up/down with demand.

**Error budget** — Allowed unreliability = 100% - SLO.

**Event-driven architecture** — Services communicate via domain events.

**Event sourcing** — Store state changes as event log; derive current state.

**Eventual consistency** — Data converges over time across services.

**Exponential backoff** — Increasing delay between retries.

---

## F

**Fail-fast** — Return error immediately (circuit open) vs waiting.

**Fan-out** — One request triggers parallel calls to many services.

**Feature flag** — Toggle behavior without redeploy.

**Flexibility** — Ease of changing, deploying, replacing system parts.

---

## G

**GitOps** — Git as source of truth for deployment state.

**Graceful degradation** — Reduced functionality when dependency fails.

**gRPC** — High-performance RPC over HTTP/2 with Protobuf.

---

## H

**Health check** — Liveness/readiness/startup probes for orchestrators.

**Horizontal scaling** — Add more instances (scale out).

**HPA** — Kubernetes Horizontal Pod Autoscaler.

**HTTP/2** — Multiplexed connections; used by gRPC.

---

## I

**Idempotency** — Repeated operation same result as once.

**Ingress** — Kubernetes external HTTP routing into cluster.

**Integration test** — Test service with real dependencies (DB, broker).

---

## J

**JWT** — JSON Web Token for stateless authentication.

---

## K

**Kubernetes (K8s)** — Container orchestration platform.

---

## L

**Latency** — Time for one operation to complete.

**Latency budget** — Allocated time per hop in user-facing path.

**Load balancer** — Distributes traffic across instances (L4/L7).

**Loose coupling** — Services interact via contracts; independent evolution.

---

## M

**mTLS** — Mutual TLS; both client and server authenticate.

**Message broker** — Middleware for async messaging (RabbitMQ, Kafka).

**Microservice** — Independently deployable service around one business capability.

**Modular monolith** — Single deploy with internal module boundaries.

---

## N

**Nano-services** — Over-split tiny services (anti-pattern).

---

## O

**OAuth 2.0** — Authorization framework for delegated access.

**Observability** — Understand system internals via logs, metrics, traces.

**OIDC** — OpenID Connect; identity layer on OAuth.

**Orchestration** — Central coordinator for multi-service workflow.

**Outbox pattern** — Atomic DB write + event row; relay publishes to broker.

---

## P

**Partition tolerance** — System operates despite network splits (CAP).

**p50/p95/p99** — Latency percentiles.

**Polyglot persistence** — Different DB technologies per service.

**Pub/sub** — Publish message to topic; multiple subscribers receive.

---

## Q

**QPS** — Queries (requests) per second.

---

## R

**Read replica** — Copy of DB for read scaling; eventual consistency.

**REST** — Representational State Transfer over HTTP.

**Retry** — Repeat failed request for transient errors.

**RPO** — Recovery Point Objective; max acceptable data loss.

**RTO** — Recovery Time Objective; max acceptable downtime.

---

## S

**Saga** — Multi-step transaction with compensating actions.

**Scalability** — Handle growth by adding resources.

**Service discovery** — Dynamic lookup of service network locations.

**Service mesh** — Infrastructure layer for service-to-service traffic (Istio).

**Sharding** — Horizontal partition of data across databases.

**Sidecar** — Helper container alongside main app container.

**SLI** — Service Level Indicator.

**SLO** — Service Level Objective.

**SLA** — Service Level Agreement with customer.

**Strangler Fig** — Incremental monolith replacement pattern.

**Structured logging** — JSON logs with consistent fields for search.

**Sync communication** — Caller waits for response.

**Stateless service** — No session in instance memory; any instance handles request.

---

## T

**Throughput** — Operations completed per unit time.

**Timeout** — Maximum wait for response before failure.

**Token propagation** — Forward auth token through call chain.

**Two-pizza team** — Small team (~5–9) owning service end-to-end.

---

## U

**Ubiquitous language** — Shared vocabulary between business and engineering.

---

## V

**Vertical scaling** — Add CPU/RAM to one machine (scale up).

---

## Z

**Zero trust** — Verify every request; no implicit internal trust.

---

See also: [B-pattern-catalog.md](B-pattern-catalog.md)
