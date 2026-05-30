# Topic 6: Design — Chat System (WhatsApp/Slack)

Real-time messaging at scale. Tests WebSockets, ordering, presence, and sharding.

---

## Requirements

### Functional
- 1:1 and group messaging
- Real-time delivery (low latency)
- Message history (scroll back)
- Online/offline presence indicators
- Read receipts (optional)
- Push notifications when offline

### Non-functional (typical)
- 50M DAU, 50 messages/user/day
- Delivery latency < 200 ms when online
- Messages never lost (durability)
- Support group chats up to 500 members

---

## Estimates

```
Messages/day = 50M × 50 = 2.5 billion
Write QPS = 2.5B / 100K ≈ 25,000/sec (peak ~75,000)

Storage (5 years):
  2.5B/day × 200 bytes × 365 × 5 ≈ 900 TB
  → Shard by conversation_id
```

---

## High-level architecture

```
Mobile/Web App
      │
      ├── HTTPS (REST) ──→ API Gateway → Chat API Service
      │                                         │
      └── WebSocket ─────→ Connection Service ←─┘
                                    │
                    ┌───────────────┼───────────────┐
                    ↓               ↓               ↓
                 Redis           Cassandra/       Kafka
              (presence,        HBase            (message
               routing)         (messages)        pipeline)
                    ↓
              Push Notification Service (FCM/APNs)
```

---

## Connection layer (WebSockets)

HTTP is request-response. Chat needs **persistent bidirectional** connections.

```
Client ←──WebSocket──→ Connection Server
         (long-lived)
```

### Problem: scaling WebSockets

Each connection tied to one server. User A on Server 1, User B on Server 2 — how does A's message reach B?

**Solution: Pub/Sub routing layer**

```
1. User B connects → Server 2 registers: user_B → server_2 in Redis
2. User A sends message to B via Server 1
3. Server 1 looks up B's server in Redis → server_2
4. Server 1 publishes to Redis channel "server_2"
5. Server 2 receives, pushes to B's WebSocket
```

```
Redis:
  user:123 → connection_server_5
  user:456 → connection_server_2

Pub/Sub channels per connection server
```

---

## Message flow (1:1 chat)

```
Alice sends "Hello" to Bob:

1. Alice's client → WebSocket → Connection Server A
2. Server A validates, assigns message_id (UUID), timestamp
3. Server A publishes to Kafka: { msg_id, from: Alice, to: Bob, body, ts }
4. Server A acks to Alice immediately (optimistic UI)
5. Message worker:
   a. Persist to DB (conversation_id = hash(Alice, Bob))
   b. Lookup Bob's connection server in Redis
   c. Route to Bob via pub/sub
6. If Bob offline → queue push notification
```

**Durability:** Message persisted in Kafka + DB before considered delivered.

---

## Data model

### Conversations
```
conversations (
  id,                    -- hash of sorted participant ids for 1:1
  type,                  -- 'direct' | 'group'
  created_at
)

participants (conversation_id, user_id, joined_at)
```

**1:1 conversation_id:** `hash(min(user_a, user_b), max(user_a, user_b))` — same ID regardless of who initiates.

### Messages (sharded by conversation_id)
```
messages (
  message_id,           -- UUID, globally unique
  conversation_id,        -- shard key
  sender_id,
  body,
  created_at,
  status                  -- sent, delivered, read
)
INDEX: (conversation_id, created_at DESC)  — for history pagination
```

**Storage:** Cassandra or HBase — optimized for write-heavy, time-ordered queries per partition key.

---

## Message ordering

Messages in a conversation must appear in order.

**Within one sender:** Client assigns sequence numbers or server uses timestamp + sender_id.

**Across senders:** Use server-assigned monotonic timestamp per conversation (harder at scale).

**Practical approach:**
- Server assigns `(timestamp, message_id)` on receive
- Client sorts by this tuple
- Accept slight reordering under network partition (show in UI when detected)

For strict ordering: single partition in Kafka keyed by `conversation_id`.

---

## Group chat fan-out

500-member group: one message → 499 deliveries.

```
Option A: Fan-out on write
  Store message once → notify each member's connection server

Option B: Fan-out on read (for large groups)
  Store message in group conversation → each member fetches on open

Hybrid:
  < 100 members → fan-out on write (real-time push to all)
  > 100 members → fan-out on read + push notification to active members only
```

---

## Presence (online/offline)

```
User connects    → SET user:123:status online EX 60  (Redis TTL)
Heartbeat every 30s → refresh TTL
User disconnects → DEL or let TTL expire → offline

Friend queries presence → MGET user:456:status user:789:status
```

**Last seen:** Update `user:123:last_seen` timestamp on disconnect.

---

## Offline messages

```
User offline → message stored in DB
User comes online:
  1. WebSocket reconnect
  2. Client sends last_received_message_id
  3. Server fetches messages after that ID from DB
  4. Push missed messages + resume live stream
```

Sync on reconnect is simpler than guaranteed delivery during offline period.

---

## Push notifications

```
Message for offline user → Notification Service → FCM (Android) / APNs (iOS)

Payload: { title: "Alice", body: "Hello", conversation_id: "..." }
Rate limit pushes to avoid spamming user with 500 group messages
```

---

## End-to-end encryption (E2EE) — bonus

WhatsApp-style: server stores encrypted blobs, cannot read content.

- Keys exchanged via Signal protocol
- Server routes ciphertext only
- **Trade-off:** No server-side search, moderation harder

Mention in interviews if asked about privacy; not required for basic design.

---

## Check yourself

1. Why WebSockets instead of HTTP polling?
2. How does a message reach a user on a different connection server?
3. How do you generate a stable conversation_id for 1:1 chat?
4. Why Cassandra/HBase over PostgreSQL for messages?
5. How does presence work with Redis TTL?

## Key takeaway

Separate **connection layer** (WebSockets + Redis routing) from **storage layer** (Cassandra, sharded by conversation). Persist before ack. Use pub/sub to route across connection servers.
