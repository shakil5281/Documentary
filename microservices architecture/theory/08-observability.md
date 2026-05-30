# 08 — Observability

**Level:** Intermediate–Advanced  
**Estimated reading time:** 30 minutes  
**Previous:** [07 — Security](./07-security.md)  
**Next:** [09 — Deployment & DevOps](./09-deployment-and-devops.md)

---

## Why Observability Matters More in Microservices

In a monolith, debugging is straightforward — one log file, one stack trace, one process. In microservices:

- A single user request may traverse 5–10 services
- Failures can be intermittent and service-specific
- Performance bottlenecks can be in any service or the network between them
- No single place to look

**Observability** is the ability to understand the internal state of a system by examining its outputs. It goes beyond traditional monitoring (is it up?) to answer: **why is it slow? why did it fail? what will fail next?**

---

## The Three Pillars

### 1. Logging

**What happened, and when?**

Logs are discrete records of events. Each service produces its own logs.

| Log level | Use for |
|-----------|---------|
| ERROR | Failures that need attention |
| WARN | Unexpected but handled situations |
| INFO | Significant business events (order created, payment processed) |
| DEBUG | Detailed technical info for troubleshooting |

**Structured logging** (JSON format) is essential:

```json
{
  "timestamp": "2026-05-30T10:15:00Z",
  "level": "INFO",
  "service": "order-service",
  "traceId": "abc-123",
  "message": "Order created",
  "orderId": "ORD-456",
  "userId": "USR-789"
}
```

**Centralized logging** aggregates logs from all services into one searchable system (ELK Stack: Elasticsearch, Logstash, Kibana; or Grafana Loki).

Without centralized logging, debugging a request across 5 services means SSH-ing into 5 servers and correlating timestamps manually.

### 2. Metrics

**How is the system performing?**

Metrics are numeric measurements collected over time.

| Metric type | Examples |
|-------------|----------|
| **Counter** | Total requests, total errors (always increases) |
| **Gauge** | Current memory usage, active connections (can go up or down) |
| **Histogram** | Request latency distribution (p50, p95, p99) |

Key metrics to track per service:

| Category | Metrics |
|----------|---------|
| **Traffic** | Requests per second, active connections |
| **Latency** | Response time (p50, p95, p99) |
| **Errors** | Error rate (4xx, 5xx), timeout rate |
| **Saturation** | CPU, memory, disk, thread pool usage |

**Prometheus** is the most common metrics collection system. **Grafana** visualizes metrics in dashboards.

### 3. Distributed Tracing

**How did a request flow through the system?**

A **trace** represents the full journey of a request across services. Each service call within the trace is a **span**.

```
Trace: abc-123 (total: 450ms)
├── Span: API Gateway        (50ms)
│   ├── Span: Order Service  (300ms)
│   │   ├── Span: Payment Service  (150ms)
│   │   └── Span: Inventory Service (100ms)
│   └── Span: Notification Service (80ms, async)
```

Each span records: service name, operation, start time, duration, status, and metadata.

**OpenTelemetry** is the vendor-neutral standard for instrumenting, generating, and exporting traces. Backends include Jaeger, Zipkin, and Grafana Tempo.

**Trace context propagation:** A `traceId` is generated at the entry point (API Gateway) and passed to every downstream service via HTTP headers. This is how you connect spans into a single trace.

---

## Correlation: Connecting the Three Pillars

The power of observability comes from connecting logs, metrics, and traces:

```
Alert: Error rate spike on order-service (METRIC)
  → Open trace for a failed request (TRACE)
    → See Payment Service span failed with timeout (TRACE)
      → Read Payment Service logs for that traceId (LOG)
        → Find: "Connection pool exhausted" (ROOT CAUSE)
```

The **traceId** is the correlation key that links all three pillars.

---

## SLIs, SLOs, and SLAs

| Term | Definition | Example |
|------|-----------|---------|
| **SLI** (Service Level Indicator) | A metric that measures service quality | "Percentage of requests completing in < 500ms" |
| **SLO** (Service Level Objective) | Target value for an SLI | "99.9% of requests complete in < 500ms" |
| **SLA** (Service Level Agreement) | Contract with consequences if SLO is missed | "If availability drops below 99.9%, customer gets credit" |

Example SLOs for an e-commerce system:

| Service | SLI | SLO |
|---------|-----|-----|
| API Gateway | Availability | 99.95% |
| Order Service | Latency (p99) | < 1 second |
| Payment Service | Success rate | 99.99% |
| Search Service | Latency (p95) | < 200ms |

**Error budget:** If your SLO is 99.9% availability, you have 0.1% budget for failures. When the budget is exhausted, stop releasing features and focus on reliability.

---

## Alerting

Alerts notify humans when something needs attention. Good alerts are:

| Principle | Bad alert | Good alert |
|-----------|-----------|------------|
| **Actionable** | "CPU is at 60%" | "Error rate > 5% for 5 minutes on payment-service" |
| **Not noisy** | Alert on every error | Alert when error rate exceeds SLO threshold |
| **Context-rich** | "Service down" | "payment-service: 3/5 pods failing readiness check since 10:15 UTC" |

Alert severity levels:

| Level | Response |
|-------|----------|
| **Critical** | Page on-call engineer immediately (service down, data loss) |
| **Warning** | Investigate during business hours (elevated latency, disk filling) |
| **Info** | Log for awareness (deployment completed, scaling event) |

---

## Observability Architecture

```
┌──────────┐  ┌──────────┐  ┌──────────┐
│ Service A│  │ Service B│  │ Service C│
│ (logs,   │  │ (logs,   │  │ (logs,   │
│  metrics,│  │  metrics,│  │  metrics,│
│  traces) │  │  traces) │  │  traces) │
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │              │              │
     └──────────┬───┴──────────────┘
                │
     ┌──────────▼──────────┐
     │  OpenTelemetry       │
     │  Collector           │
     └──────────┬──────────┘
                │
     ┌──────────┼──────────────┐
     │          │              │
  ┌──▼──┐  ┌───▼───┐  ┌──────▼──────┐
  │ Loki│  │Prometheus│ │   Tempo    │
  │(logs)│  │(metrics)│ │  (traces)  │
  └──┬──┘  └───┬───┘  └──────┬──────┘
     │          │              │
     └──────────┼──────────────┘
                │
          ┌─────▼─────┐
          │  Grafana   │
          │ (dashboards│
          │  & alerts) │
          └───────────┘
```

---

## What to Instrument from Day One

Even before you need it, add these to every service:

1. **Structured JSON logging** with traceId, service name, and timestamp
2. **Health endpoints** (liveness and readiness)
3. **Basic metrics** — request count, error count, latency histogram
4. **Trace propagation** — pass traceId in outbound calls

Adding observability later is much harder than building it in from the start.

---

## Summary

- Observability = logs + metrics + traces, connected by a correlation ID (traceId).
- Logs tell you what happened; metrics tell you how the system performs; traces show request flow across services.
- Define SLIs and SLOs to measure reliability objectively.
- Alert on symptoms (error rate, latency), not causes (CPU usage).
- Instrument every service from day one — retrofitting is painful.

---

**Next:** [09 — Deployment & DevOps →](./09-deployment-and-devops.md)
