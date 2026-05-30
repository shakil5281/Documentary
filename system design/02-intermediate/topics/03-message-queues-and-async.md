# Topic 3: Message Queues & Async Processing

## The problem with synchronous everything

```
User uploads video → App transcodes → App generates thumbnail → App updates DB → Response
                     (30 seconds — user waits, connection timeout)
```

Some work is **slow**, **unreliable**, or **spiky**. Message queues decouple producers from consumers.

---

## Core concepts

```
[Producer] → [Queue/Topic] → [Consumer(s)]
   App           Kafka/SQS         Worker
```

| Term | Meaning |
|------|---------|
| **Producer** | Sends messages |
| **Consumer** | Processes messages |
| **Queue** | Messages stored until consumed (point-to-point) |
| **Topic** | Messages broadcast to multiple consumer groups (pub/sub) |
| **Broker** | Server that stores and routes messages (Kafka, RabbitMQ) |

---

## Why use a queue?

| Benefit | Example |
|---------|---------|
| **Decoupling** | API service doesn't know about email service |
| **Async processing** | Return 202 immediately, process in background |
| **Load leveling** | Spike of 100K events buffered; workers process steadily |
| **Reliability** | Message persisted if worker crashes; retry on failure |
| **Scalability** | Add more workers independently |

---

## Common use cases

| Use case | Flow |
|----------|------|
| **Email/SMS** | Order placed → queue → notification worker sends email |
| **Image processing** | Upload → queue → resize/thumbnail workers |
| **Search indexing** | DB write → queue → Elasticsearch indexer |
| **Analytics** | Click event → queue → aggregation pipeline |
| **Feed fan-out** | New post → queue → fan-out workers update timelines |

---

## Delivery guarantees

| Guarantee | Meaning | Example |
|-----------|---------|---------|
| **At-most-once** | Message may be lost, never duplicated | Metrics (loss OK) |
| **At-least-once** | Message delivered ≥1 times; may duplicate | Most common default |
| **Exactly-once** | Processed exactly once | Hard; Kafka transactions + idempotent consumers |

**Reality:** Most systems use **at-least-once + idempotent consumers** (Topic 4).

---

## Kafka vs RabbitMQ vs SQS (quick guide)

| | Kafka | RabbitMQ | AWS SQS |
|--|-------|----------|---------|
| **Model** | Distributed log (topic) | Queue + routing | Managed queue |
| **Retention** | Days/weeks (replay possible) | Until consumed | 14 days max |
| **Throughput** | Very high (millions/sec) | Moderate | High (managed) |
| **Ordering** | Per partition | Per queue | FIFO queue option |
| **Best for** | Event streaming, logs, replay | Task queues, routing | AWS-native async jobs |

**Default for event streaming at scale:** Kafka  
**Default for simple job queues:** SQS or RabbitMQ

---

## Consumer groups (Kafka)

```
Topic: "new-posts"
  ├── Consumer Group A (feed workers) — 3 consumers, each gets subset of partitions
  └── Consumer Group B (search indexer) — independent, reads same topic separately
```

Each partition processed by **one consumer in the group** — enables parallel processing with ordering per partition.

---

## Backpressure

When producers outpace consumers, the queue grows.

**Signals:**
- Queue depth increasing
- Consumer lag (Kafka: messages behind latest offset)
- Processing latency rising

**Fixes:**
- Scale consumers horizontally
- Rate-limit producers
- Drop/degrade low-priority messages
- Dead letter queue (DLQ) for poison messages

---

## Dead letter queue (DLQ)

Messages that fail after N retries go to a **DLQ** for manual inspection.

```
Main Queue → Worker (fail 3×) → DLQ → Alert on-call engineer
```

Prevents one bad message from blocking the entire queue.

---

## Event-driven architecture pattern

```
                    ┌→ Feed Service
Order Service → Event Bus ─┼→ Email Service
                    └→ Inventory Service
                    └→ Analytics Service
```

Services communicate via **events**, not direct HTTP calls.

**Pros:** Loose coupling, easy to add new consumers  
**Cons:** Harder debugging, eventual consistency, need schema registry for events

---

## Sync vs async decision guide

| Use sync (HTTP) | Use async (queue) |
|-----------------|-------------------|
| User waiting for result | User doesn't need immediate result |
| Strong consistency required | Eventual consistency OK |
| Simple request-response | Heavy processing (video, ML) |
| Low latency critical path | Spike absorption needed |

---

## Check yourself

1. Name three benefits of message queues.
2. At-least-once vs exactly-once — which is most common and why?
3. What is a dead letter queue?
4. When would you choose Kafka over SQS?
5. What is consumer lag and what does it indicate?

## Key takeaway

Move slow, spiky, or non-critical work off the request path. Use **at-least-once delivery + idempotent workers**. Monitor queue depth and consumer lag.
