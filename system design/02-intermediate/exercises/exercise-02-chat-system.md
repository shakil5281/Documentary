# Exercise 2: Design a Chat System (45 min)

Timed practice. Do not look at Topic 6 until finished.

---

## Prompt

Design a real-time 1:1 and group messaging system like WhatsApp.

**Scale:** 20M DAU, 30 messages/user/day, groups up to 256 members.

**Requirements:**
- Send/receive messages in real time
- Message history (last 30 days scrollable)
- Online/offline presence
- Push notification when recipient offline

---

## Your design

### Step 1: Estimates (8 min)

| Metric | Value |
|--------|-------|
| Message write QPS | |
| 30-day storage | |

### Step 2: Why WebSockets? (5 min)

Why not HTTP polling or long polling?

<!-- Your answer -->

### Step 3: Architecture (12 min)

How do messages route between users on different servers?

<!-- Your answer + diagram -->

### Step 4: Data model (10 min)

Conversation ID for 1:1 chat — how generated?

Message storage — which DB and shard key?

<!-- Your answer -->

### Step 5: Offline & reconnect (10 min)

User was offline for 2 hours. What happens on reconnect?

<!-- Your answer -->

---

## Self-check (after comparing with Topic 6)

- [ ] WebSockets for real-time, REST for history/auth
- [ ] Redis for presence + connection routing
- [ ] Pub/sub between connection servers
- [ ] Messages persisted before ack to sender
- [ ] Sharded by conversation_id (Cassandra/HBase style)
- [ ] Push notifications for offline users
- [ ] Sync missed messages on reconnect

**Score 6–7:** Strong intermediate level.  
**Score 4–5:** Re-read Topics 3, 4, and 6.  
**Score 0–3:** Review 01-basics and Topic 3 (queues) first.
