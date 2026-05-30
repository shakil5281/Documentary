# File and Folder Structure

This document explains how the learning materials in this repository are organized, why each part exists, and how to navigate them.

---

## Top-Level Layout

```
microservices architecture/
│
├── README.md                 # Entry point — learning path and module index
├── STRUCTURE.md              # This file — explains repository organization
│
└── theory/                   # All theory content lives here
    ├── 01-introduction.md
    ├── 02-monolith-vs-microservices.md
    ├── 03-core-principles.md
    ├── 04-communication-patterns.md
    ├── 05-data-management.md
    ├── 06-reliability-and-resilience.md
    ├── 07-security.md
    ├── 08-observability.md
    ├── 09-deployment-and-devops.md
    ├── 10-advanced-patterns.md
    └── 11-tradeoffs-and-decision-framework.md
```

---

## Why This Structure?

### Flat `theory/` folder with numbered files

Each module is a single Markdown file prefixed with a number (`01`, `02`, … `11`).

| Design choice | Reason |
|---------------|--------|
| **Numbered prefixes** | Enforces reading order. Microservices concepts are cumulative — you need boundaries before communication, communication before data management. |
| **One topic per file** | Keeps each module focused. You can read one concept deeply without scrolling through unrelated material. |
| **No nested subfolders per topic** | Theory content does not need code, configs, or assets. A flat list is easier to browse and maintain. |
| **No `src/`, `docs/`, or `examples/` folders** | This is a theory-only guide. Omitting implementation folders avoids confusion about whether you need to run anything. |

---

## File Descriptions

### Root files

| File | Purpose |
|------|---------|
| `README.md` | Main index. Lists all modules, reading order, prerequisites, and estimated time. Start here. |
| `STRUCTURE.md` | Meta-documentation. Explains the repository layout itself (this file). |

### Theory modules (`theory/`)

| File | Level | What it covers |
|------|-------|----------------|
| `01-introduction.md` | Beginner | Definition of microservices, vocabulary, architectural context |
| `02-monolith-vs-microservices.md` | Beginner | Side-by-side comparison, strengths, weaknesses, migration signals |
| `03-core-principles.md` | Beginner–Intermediate | Service boundaries, Domain-Driven Design, autonomy, loose coupling |
| `04-communication-patterns.md` | Intermediate | REST, gRPC, message queues, pub/sub, event-driven design |
| `05-data-management.md` | Intermediate | Database per service, CAP theorem, eventual consistency, Saga, Outbox |
| `06-reliability-and-resilience.md` | Intermediate | Failure modes, timeouts, retries, circuit breaker, bulkhead, graceful degradation |
| `07-security.md` | Intermediate–Advanced | Authentication, authorization, service-to-service security, secrets |
| `08-observability.md` | Intermediate–Advanced | The three pillars: logs, metrics, traces; SLOs and alerting |
| `09-deployment-and-devops.md` | Advanced | Containers, orchestration, CI/CD, deployment strategies, infrastructure as code |
| `10-advanced-patterns.md` | Advanced | API Gateway, BFF, CQRS, Event Sourcing, Service Mesh |
| `11-tradeoffs-and-decision-framework.md` | Advanced | When to adopt, anti-patterns, organizational impact, decision checklist |

---

## How Modules Relate to Each Other

```
01 Introduction
    │
    ▼
02 Monolith vs Microservices          ← foundational decision
    │
    ▼
03 Core Principles                    ← how to split services
    │
    ├──────────────┬──────────────┐
    ▼              ▼              ▼
04 Communication  05 Data Mgmt   06 Reliability
    │              │              │
    └──────────────┼──────────────┘
                   ▼
            07 Security
                   │
                   ▼
            08 Observability
                   │
                   ▼
            09 Deployment
                   │
                   ▼
            10 Advanced Patterns
                   │
                   ▼
            11 Trade-offs           ← synthesize everything
```

- **Modules 04, 05, 06** can be read in any order after 03, but reading 04 first is recommended because communication affects data and reliability design.
- **Module 11** should be read last — it assumes knowledge from all prior modules.

---

## What Is Intentionally Not Included

This repository is theory-only. The following are **deliberately absent**:

| Not included | Why |
|--------------|-----|
| Source code (`src/`, services) | Focus is conceptual understanding, not implementation |
| Docker / Kubernetes configs | Deployment concepts are explained in text in module 09 |
| Diagrams as image files | Architecture is described with ASCII diagrams inside each module |
| Quizzes or exercises | Can be added later if you want active recall practice |
| External links to paid courses | Keeps the guide self-contained |

---

## How to Extend This Guide Later

If you want to grow this into a fuller learning repository:

```
microservices architecture/
├── README.md
├── STRUCTURE.md
├── theory/                    # keep as-is
├── diagrams/                  # optional: exported architecture images
├── glossary.md                # optional: centralized term definitions
└── references.md              # optional: books, papers, talks
```

Add new theory modules as `12-<topic>.md` following the same numbering convention. Update `README.md` and this file when you do.

---

## Quick Navigation

- **New to microservices?** → Start at [theory/01-introduction.md](./theory/01-introduction.md)
- **Already know basics, want patterns?** → Jump to [theory/04-communication-patterns.md](./theory/04-communication-patterns.md)
- **Evaluating whether to adopt microservices?** → Read [theory/02-monolith-vs-microservices.md](./theory/02-monolith-vs-microservices.md) and [theory/11-tradeoffs-and-decision-framework.md](./theory/11-tradeoffs-and-decision-framework.md)
- **Confused about the repo layout?** → You are reading the right file.
