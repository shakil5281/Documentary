# 06 — Reliability & Resilience

**Level:** Intermediate  
**Estimated reading time:** 30 minutes  
**Previous:** [05 — Data Management](./05-data-management.md)  
**Next:** [07 — Security](./07-security.md)

---

## Failure Modes in Distributed Systems

In a monolith, failure is binary — the app works or it doesn't. In microservices, failure is **partial and cascading**:

| Failure type | Example |
|-------------|---------|
| **Service crash** | Payment Service runs out of memory and dies |
| **Network timeout** | Order Service calls Payment Service; network is slow; call hangs |
| **Slow response** | Catalog Service is overloaded; responses take 30 seconds |
| **Partial data** | User Service is down; Order Service can't fetch customer name |
| **Cascading failure** | Service A waits for B, B waits for C, C is down → A and B also become unresponsive |

Every inter-service call is a potential failure point. Resilience patterns exist to handle these gracefully.

---

## Timeouts

**Never wait forever for a response.** Set a maximum wait time on every outbound call.

Without timeouts:
```
Order Service → calls Payment Service → waits... waits... waits... (thread blocked)
  → thread pool exhausted → Order Service stops accepting requests
    → cascading failure
```

With timeouts:
```
Order Service → calls Payment Service → waits 3 seconds → timeout
  → returns error to user or triggers fallback
  → thread is freed immediately
```

Guidelines:

- Set timeouts based on measured latency (p99 + buffer), not arbitrary values
- Typical starting point: 1–5 seconds for synchronous HTTP calls
- Always shorter than the caller's own timeout (if Gateway timeout is 10s, service timeouts should be 3–5s)

---

## Retries

When a call fails due to a transient error (network blip, temporary overload), retrying may succeed.

```
Attempt 1 → fail (503 Service Unavailable)
  wait 100ms
Attempt 2 → fail (503)
  wait 200ms
Attempt 3 → success (200 OK)
```

### Retry Strategies

| Strategy | Behavior |
|----------|----------|
| **Fixed interval** | Wait same time between retries (e.g., 500ms) |
| **Exponential backoff** | Wait 100ms, 200ms, 400ms, 800ms... |
| **Exponential backoff + jitter** | Add randomness to prevent thundering herd |

### Retry Rules

- Only retry **idempotent** operations (or use idempotency keys)
- Limit max retries (typically 2–3)
- Do not retry on client errors (4xx) — retrying a 400 Bad Request won't help
- Do retry on server errors (5xx) and timeouts

---

## Circuit Breaker

When a downstream service is failing repeatedly, stop calling it temporarily to prevent cascading failure.

Three states:

```
        failures exceed threshold
CLOSED ──────────────────────────► OPEN
  ▲                                  │
  │                           (wait timeout)
  │                                  │
  │                                  ▼
  └──────── success ──────── HALF-OPEN
                              (allow one test call)
```

| State | Behavior |
|-------|----------|
| **Closed** | Normal operation. Calls pass through. Failures are counted. |
| **Open** | Calls fail immediately without reaching the downstream service. Returns fallback or error. |
| **Half-Open** | After a cooldown period, allow one test call. If it succeeds → Closed. If it fails → Open again. |

Example: Payment Service is down. After 5 failures in 10 seconds, the circuit opens. Order Service immediately returns "Payment temporarily unavailable" instead of waiting 3 seconds per request. After 30 seconds, one test call is allowed.

---

## Bulkhead

Isolate resources so failure in one area doesn't consume all resources.

Named after ship bulkheads — watertight compartments that prevent a hull breach from sinking the entire ship.

```
Without bulkhead:
  All 100 threads shared → Payment calls consume all 100 → Order queries starve

With bulkhead:
  Payment calls: max 20 threads
  Catalog calls: max 30 threads
  Other calls: max 50 threads
  → Payment failure only affects its 20 threads
```

Implementation approaches:

- Separate thread pools per downstream service
- Separate connection pools
- Separate message queue consumers per service

---

## Fallback & Graceful Degradation

When a dependency is unavailable, provide a reduced experience instead of total failure.

| Scenario | Fallback |
|----------|----------|
| Recommendation Service down | Show popular items instead of personalized recommendations |
| Review Service down | Show product without reviews |
| User profile unavailable | Show order with user ID instead of name |
| Payment Service down | Allow "Pay Later" or queue the order |

The key question: **What is the minimum acceptable experience when this service fails?**

---

## Rate Limiting

Protect services from being overwhelmed by too many requests.

| Algorithm | How it works |
|-----------|-------------|
| **Token bucket** | Tokens refill at a fixed rate; each request consumes a token |
| **Fixed window** | Allow N requests per time window (e.g., 100/minute) |
| **Sliding window** | Smoother version of fixed window |

Rate limiting can be applied at:

- API Gateway (protect the entire system)
- Individual service (protect specific endpoints)
- Per-client basis (prevent one client from monopolizing resources)

---

## Health Checks

Every service should expose health endpoints so orchestrators and load balancers know its state.

| Endpoint | Purpose | Checks |
|----------|---------|--------|
| **Liveness** | Is the process alive? | App is running, not deadlocked |
| **Readiness** | Can it accept traffic? | Database connected, dependencies reachable |
| **Startup** | Has it finished initializing? | Migrations done, cache warmed |

Kubernetes uses these to decide whether to restart a container (liveness) or route traffic to it (readiness).

---

## The Bulkhead of Failure Isolation

Design principle: **limit the blast radius**.

| Technique | Effect |
|-----------|--------|
| Circuit breaker | Stops calling a failing service |
| Bulkhead | Limits resource consumption per dependency |
| Timeout | Prevents indefinite blocking |
| Async communication | Removes synchronous dependency entirely |
| Fallback | Provides degraded but functional experience |

Combined, these ensure that one failing service degrades the system gracefully rather than causing total outage.

---

## Summary

- Assume every network call will fail. Design for it.
- Timeouts prevent thread exhaustion; retries handle transient failures.
- Circuit breaker stops calling persistently failing services.
- Bulkhead isolates resource consumption per dependency.
- Fallbacks and graceful degradation keep the system usable during partial failures.
- Health checks (liveness/readiness) enable automated recovery.

---

**Next:** [07 — Security →](./07-security.md)
