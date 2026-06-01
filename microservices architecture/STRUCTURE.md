# File and Folder Structure

Full deep-learning course layout. Canonical content lives in `docs/`; `theory/` contains legacy redirect stubs.

---

## Top-level layout

```
microservices architecture/
│
├── README.md                 # Entry point
├── SYLLABUS.md               # 16-week curriculum (22 modules)
├── LEARNING-CHECKLIST.md     # Mastery checklist per module
├── DOC-INDEX.md              # Master index of all documents
├── QUICK-REFERENCE.md        # Formulas, patterns, complexity cheat sheet
├── STRUCTURE.md              # This file
│
├── docs/
│   ├── MODULE-TEMPLATE.md
│   ├── DATA-FLOW-AND-SYSTEM-DESIGN.md   # DFD + system design (full guide)
│   ├── part-01-foundations/       # Modules 00–04
│   ├── part-02-core-architecture/ # Modules 05–10
│   ├── part-03-production/        # Modules 11–15
│   ├── part-04-advanced/          # Modules 16–21
│   └── appendices/                # A–E reference
│       └── E-data-flow-and-system-design.md → full guide
│
├── exercises/
│   ├── module-00.md … module-21.md
│   ├── solutions/
│   └── README.md
│
├── web/                      # Interactive documentation viewer
│   ├── index.html
│   ├── files-manifest.json
│   ├── content-bundle.js
│   ├── manifest-bundle.js
│   ├── rebuild-all.ps1
│   └── serve.ps1 / serve.bat
│
├── WEB-VIEW.md               # Web viewer instructions
│
└── theory/                   # Legacy redirects → docs/
    └── 01-introduction.md … 11-tradeoffs…
```

---

## Part I — Foundations (`docs/part-01-foundations/`)

| File | Module | Topics |
|------|--------|--------|
| `00-distributed-systems-basics.md` | 00 | Fallacies, latency, partial failure, CAP intro |
| `01-introduction.md` | 01 | What microservices are, vocabulary, example |
| `02-monolith-vs-microservices.md` | 02 | Comparison, modular monolith, migration |
| `03-core-principles.md` | 03 | DDD, bounded context, Conway's Law |
| `04-api-networking-fundamentals.md` | 04 | HTTP, REST basics, DNS/TCP/TLS |

---

## Part II — Core Architecture (`docs/part-02-core-architecture/`)

| File | Module | Topics |
|------|--------|--------|
| `05-communication-patterns.md` | 05 | REST, gRPC, events, orchestration |
| `06-data-management.md` | 06 | DB per service, Saga, Outbox, CAP |
| `07-reliability-and-resilience.md` | 07 | Timeouts, circuit breaker, bulkhead |
| `08-scalability-patterns.md` | 08 | Scale out, sharding, caching, HPA |
| `09-performance-engineering.md` | 09 | Latency budget, percentiles, hot path |
| `10-time-complexity.md` | 10 | Big-O for distributed flows |

---

## Part III — Production (`docs/part-03-production/`)

| File | Module | Topics |
|------|--------|--------|
| `11-security.md` | 11 | Auth, zero trust, mTLS, secrets |
| `12-observability.md` | 12 | Logs, metrics, traces, SLOs |
| `13-deployment-and-devops.md` | 13 | K8s, CI/CD, deployment strategies |
| `14-flexibility-and-evolvability.md` | 14 | Versioning, Strangler Fig, polyglot |
| `15-testing-and-contracts.md` | 15 | Contract tests, test pyramid |

---

## Part IV — Advanced (`docs/part-04-advanced/`)

| File | Module | Topics |
|------|--------|--------|
| `16-advanced-patterns.md` | 16 | CQRS, event sourcing, BFF |
| `17-gateway-and-service-mesh.md` | 17 | Gateway, Istio/Linkerd |
| `18-multi-region-ha-dr.md` | 18 | DR, RPO/RTO, active-active |
| `19-capacity-planning-and-cost.md` | 19 | QPS math, load testing, cost |
| `20-tradeoffs-and-decision-framework.md` | 20 | ADRs, anti-patterns |
| `21-capstone-architecture-projects.md` | 21 | Full e-commerce architecture |

---

## Reading order

```
Part I (00→04) → Part II (05→10) → Part III (11→15) → Part IV (16→21)
```

Modules 08–10 are the **scalability / performance / complexity** block — read in order after 07.

---

## Exercises

Each module has `exercises/module-NN.md` and `exercises/solutions/module-NN.md`. Architecture and analysis focus (no code labs).

---

## Legacy `theory/` folder

Files `theory/01` through `theory/11` redirect to new `docs/` paths for backward compatibility.
