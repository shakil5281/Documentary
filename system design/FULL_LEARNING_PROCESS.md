# Full Learning Process: System Design to Deep Learning Systems

This document is your complete study process. Follow it like a training plan: learn one concept, explain it, design something small, review the trade-offs, then move forward.

## Goal

Become able to design backend, distributed, and ML/deep learning systems with clear reasoning about scale, reliability, cost, latency, consistency, observability, and operational risk.

## How to Study

Use this loop for every lesson:

1. Read the topic note.
2. Write a 5-line summary in your own words.
3. Draw the architecture on paper or a whiteboard.
4. Explain the read path and write path out loud.
5. List bottlenecks and failure cases.
6. Answer the check-yourself questions.
7. Redesign the system with one new constraint, such as 10x traffic, global users, strict consistency, or lower cost.

## Roadmap Overview

| Phase | Module | Main Skill |
|---|---|---|
| 1 | 01-basics | Understand web-scale building blocks |
| 2 | 02-intermediate | Combine components into reliable systems |
| 3 | 03-advanced | Handle distributed systems and global scale |
| 4 | 04-deep-learning | Design ML, deep learning, recommendation, vector, and LLM systems |

## 12-Week Study Plan

### Weeks 1-2: Basics

- Study scalability, latency, throughput, load balancing, caching, databases, APIs, and back-of-envelope math.
- Practice explaining why a system becomes slow.
- Design a simple URL shortener.

Deliverable: one complete design document for a URL shortener.

### Weeks 3-5: Intermediate Systems

- Study consistency, replication, sharding, queues, async jobs, idempotency, and retries.
- Practice read-heavy and write-heavy designs.
- Design a news feed, chat system, and notification system.

Deliverable: three design documents with API, database schema, scaling plan, and failure handling.

### Weeks 6-8: Advanced Distributed Systems

- Study consensus, distributed transactions, multi-region systems, ledgers, rate limiting, streams, event sourcing, and security.
- Practice making trade-offs between correctness, availability, latency, and cost.
- Design a payment gateway and collaborative editor.

Deliverable: two advanced design documents with failure scenarios and recovery plans.

### Weeks 9-12: Deep Learning and ML Systems

- Study ML system architecture, training pipelines, model serving, vector databases, recommendation systems, LLM systems, and audio/video pipelines.
- Practice separating offline training, online serving, feature storage, model registry, monitoring, and feedback loops.
- Design a TikTok-style recommendation system and an enterprise LLM chatbot.

Deliverable: two ML system design documents with data flow, model lifecycle, serving path, evaluation, and monitoring.

## System Design Answer Template

Use this structure for every design:

1. Requirements
   - Functional requirements
   - Non-functional requirements
   - Out of scope
2. Capacity Estimation
   - Users
   - QPS
   - Storage
   - Bandwidth
   - Latency target
3. APIs
   - Main endpoints or events
   - Request and response shape
4. Data Model
   - Tables, documents, indexes, or object storage layout
5. High-Level Architecture
   - Client
   - API gateway
   - Services
   - Cache
   - Database
   - Queue
   - Workers
6. Deep Dive
   - Read path
   - Write path
   - Hot keys
   - Consistency
   - Failure handling
7. Scaling Plan
   - Caching
   - Sharding
   - Replication
   - Async processing
   - Multi-region strategy
8. Observability
   - Metrics
   - Logs
   - Traces
   - Alerts
9. Trade-offs
   - What you optimized
   - What you sacrificed
   - What changes at 10x scale

## Deep Learning System Design Template

Use this for ML and AI systems:

1. Product Goal
   - What prediction, generation, ranking, or detection problem are we solving?
2. Data Sources
   - User events
   - Labels
   - Content metadata
   - External data
3. Offline Pipeline
   - Ingestion
   - Cleaning
   - Feature generation
   - Training
   - Evaluation
   - Model registry
4. Online Serving
   - API service
   - Feature store
   - Model server
   - Cache
   - Fallback logic
5. Feedback Loop
   - Logs
   - User behavior
   - Human review
   - Retraining trigger
6. Monitoring
   - Latency
   - Error rate
   - Model quality
   - Data drift
   - Bias and safety
7. Trade-offs
   - Accuracy vs latency
   - Freshness vs cost
   - Personalization vs privacy
   - Large model quality vs serving cost

## Practice Routine

Daily:

- 30 minutes reading
- 20 minutes drawing
- 10 minutes explaining out loud
- 20 minutes solving one small design question

Weekly:

- Complete one full design.
- Review your design and rewrite the weak parts.
- Compare your architecture against real-world engineering blogs or open-source references.

## Mastery Checklist

You are ready for advanced system design when you can:

- Estimate traffic and storage without guessing randomly.
- Explain read and write paths clearly.
- Choose SQL, NoSQL, cache, queue, stream, or object storage for the right reason.
- Explain consistency, availability, latency, and cost trade-offs.
- Design idempotent retries and failure recovery.
- Handle hot keys, fanout, rate limits, and multi-region latency.
- Design model training, serving, monitoring, retraining, and rollback.
- Explain vector search, recommendations, and LLM serving at a practical level.

## Best Way to Use This Repository

Start with [01-basics](01-basics/README.md). Do not rush. System design becomes easy when the small building blocks become automatic. After every module, create one design document in your own words. Your final goal is not only to read notes; it is to think like a system designer.
