# Topic 6: Stream Processing & Event Sourcing

## Event Sourcing

Traditional systems overwrite data in the database (e.g., updating a user's address). **Event Sourcing** takes a different approach: instead of storing the *current state*, the system stores a sequence of *state-changing events* in an append-only **Event Store**.

```
Traditional DB State:
[User: 123 | Status: VIP | Balance: $80]

Event Sourced Log:
1. UserCreated (id=123, status=Normal)
2. DepositMade (id=123, amount=$100)
3. StatusUpgraded (id=123, status=VIP)
4. OrderPlaced (id=123, cost=$20)
```

### Replaying State:
To find the current state (e.g., current balance of $80), the system reads all events for `user_123` from the beginning and applies them sequentially.
- **Snapshotting**: To avoid replaying millions of events for old accounts, the system periodically saves a "snapshot" of the state (e.g., State at Event #1000). To read, it loads the snapshot and replays only subsequent events.

---

## CQRS (Command Query Responsibility Segregation)

Because replaying events to query data is slow, Event Sourcing is almost always paired with **CQRS**.

CQRS splits the application into two paths:
- **Write Path (Commands)**: Handles updates, enforces business invariants, writes events to the Event Store.
- **Read Path (Queries)**: Queries read-optimized databases (denormalized views, search indexes) to show UI screens.

```
                  ┌──────────────► Write DB ────┐
                  │              (Event Store)  │
                  │                             ▼
User ──► [App Server]                     [Event Publisher]
                  ▲                             │ (Async Replication)
                  │                             ▼
                  └──────────────◄  Read DB  ◄──┘
                                (Elastic/Redis)
```

- **Pros**: Highly performant; read and write databases can scale independently; schemas are highly optimized for their specific tasks.
- **Cons**: **Eventual consistency** between the write and read stores; increased operational complexity.

---

## Ordering Guarantees in Apache Kafka

Apache Kafka is a distributed streaming platform structured as an append-only commit log. 

```
Topic: user-clicks
┌─────────────────────────────────┐
│ Partition 0: [E1] [E3] [E5] ... │ ──► Consumed by Worker A
├─────────────────────────────────┤
│ Partition 1: [E2] [E4] [E6] ... │ ──► Consumed by Worker B
└─────────────────────────────────┘
```

### Partitioning & Order:
- Kafka guarantees total order **only within a single partition**. If events are spread across multiple partitions, they can be processed out of order.
- **Solution**: Set a **Partition Key** (e.g., `user_id`). Kafka hashes this key to route all events for `user_123` to the exact same partition. Thus, that user's actions are processed in perfect chronological order.

---

## Stream Processing (Flink & Spark)

While Kafka stores streams, engines like **Apache Flink** or **Apache Spark Streaming** process streams in real-time (e.g., calculating fraud score, telemetry trends).

### Windowing Types:
To perform aggregations (like averages or sums) on an infinite stream of data, we slice it using time windows:

```
Tumbling Windows (Non-overlapping, fixed-size):
[ 00:00 - 00:10 ] [ 00:10 - 00:20 ] [ 00:20 - 00:30 ]

Sliding Windows (Overlapping, fixed-size):
[ 00:00 - 00:10 ]
     [ 00:05 - 00:15 ]
          [ 00:10 - 00:20 ]

Session Windows (Gap-based):
[ Event..Event ] <--- Gap of inactivity ---> [ Event..Event ]
```

### Event-Time vs. Processing-Time:
- **Event-Time**: The time when the event originally occurred on the client device (contained in the payload).
- **Processing-Time**: The time when the event reaches the processing server.
- Stream engines use **Watermarks** to handle out-of-order events caused by network delays, allowing the system to wait for late-arriving event-time data before closing a time window.

---

## Check yourself

1. What is snapshotting in Event Sourcing, and why is it necessary?
2. Explain how CQRS separates the write path from the read path. What is the major trade-off?
3. How does Apache Kafka guarantee order for events related to a specific entity?
4. What is a Watermark in stream processing, and what problem does it solve?

---

## Key takeaway

**Event Sourcing** provides an absolute historical audit trail, while **CQRS** makes querying that history fast. When processing events, Kafka guarantees **per-partition order**, and stream processors like Flink use **windows** to analyze infinite data streams.
