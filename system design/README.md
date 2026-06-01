# System Design & Deep Learning Systems Mastery Roadmap

Welcome! This repository is a comprehensive, self-paced handbook designed to take you from a **System Design Beginner** to an **Advanced Engineer** capable of designing global-scale services and **Deep Learning / Machine Learning Systems**.

Start with the full study plan: [FULL_LEARNING_PROCESS.md](FULL_LEARNING_PROCESS.md)

For the complete end-to-end documentary, read: [COMPLETE_SYSTEM_DESIGN_DOCUMENTARY.md](COMPLETE_SYSTEM_DESIGN_DOCUMENTARY.md)

---

## 🗺️ Learning Path

The curriculum is structured into four sequential modules. Each module builds on top of the concepts established in the previous ones.

```
┌─────────────────────────────────┐
│       01 - Basics               │
│  (Load Balancers, Caching, DBs) │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│       02 - Intermediate         │
│ (Partitioning, Queues, Designs) │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│       03 - Advanced             │
│ (Consensus, Ledgers, Streaming) │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│  04 - Deep Learning / ML Systems │
│  (serving, training, vector DB) │
└─────────────────────────────────┘
```

---

## 📚 Curriculum Breakdown

### [Module 01: Basics](01-basics/README.md)
*Focus: Core building blocks of web applications.*
- **Topics**: Introduction to System Design, Scalability, Load Balancing, Caching, Database Fundamentals, Networking & APIs, Back-of-envelope Math.
- **Hands-on**: URL Shortener prep exercise.

### [Module 02: Intermediate](02-intermediate/README.md)
*Focus: Data layout, reliability, and fundamental designs.*
- **Topics**: Consistency & Replication, Partitioning & Sharding, Message Queues & Async processing, Idempotency & Reliability.
- **System Designs**: News Feed, Chat System, Notification System.

### [Module 03: Advanced](03-advanced/README.md)
*Focus: Distributed systems guarantees, streaming, financial consistency, and global scale.*
- **Topics**: Distributed Consensus (Paxos/Raft), Distributed Transactions (2PC/Sagas), Multi-Region & Global Latency, Payment Systems & Ledger Design, Rate Limiting & API Gateways, Stream Processing & Event Sourcing, Security & Auth at Scale.
- **System Designs**: Payment Gateway (Stripe-like), Collaborative Editor (Google Docs-like).

### [Module 04: Deep Learning & ML Systems](04-deep-learning/README.md)
*Focus: Distributed ML training, model serving, search, and generative AI pipelines.*
- **Topics**: Introduction to ML/DL Systems, Distributed Training, Model Serving & Inference, Vector Search & Vector Databases, Recommendation Systems, LLM Serving & Systems, Audio/Video Deep Learning Pipelines.
- **System Designs**: TikTok Feed Recommendation, Enterprise LLM Chatbot serving.

---

## 🧠 Study Methodology

For every topic, follow the **Active Learning** approach:
1. **Read the Note (15–30 min)**: Read through the topic file carefully. Pay close attention to structural trade-offs.
2. **Explain Out Loud (2 min)**: Close the file. Explain the topic's core concept, benefits, and drawbacks to an imaginary colleague.
3. **Do the "Check Yourself" Questions**: Answer the questions at the bottom of the note without looking back.
4. **Hands-on Exercises**: Spend the full suggested time on each design challenge, drawing the components and walking through the read/write paths, before looking at the reference solution.

---

Let's begin! Open [Module 01: Basics](01-basics/README.md) to start your system design journey.
