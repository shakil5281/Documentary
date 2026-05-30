# Topic 1: Consistency & Replication

## Why this matters

In a distributed system, data exists on **multiple machines**. They can disagree. Consistency models define **what users see** when reads and writes hit different nodes.

---

## Consistency spectrum

```
Strong ◄──────────────────────────────────────► Eventual
  │                                                    │
Bank balance                              Social media like count
Inventory stock                           View counter
```

### Strong consistency
After a write succeeds, **every** read returns the new value.

```
Write x=5 → Read x → always 5 (on any replica)
```

**Cost:** Slower writes (must replicate before acknowledging).  
**Use when:** Money, inventory, booking seats.

### Eventual consistency
Replicas **converge over time**. Reads may return stale data briefly.

```
Write x=5 → Read x → might be 3 for 200ms → then 5
```

**Cost:** Application must tolerate stale reads.  
**Use when:** Feeds, likes, analytics, non-critical counters.

### Read-your-writes consistency
A user always sees **their own** updates, but may not see others' immediately.

```
Alice posts → Alice's feed shows her post immediately
Alice may not see Bob's post for a few seconds
```

Good middle ground for social apps.

---

## Replication strategies

### Single-leader (primary-replica)

```
         WRITES
           ↓
       [Leader] ──async/sync──→ [Replica 1]
           │                    [Replica 2]
       READS (optional)
```

| Replication type | Behavior | Trade-off |
|------------------|----------|-----------|
| **Sync** | Leader waits for replica ack before responding | Stronger consistency, higher latency |
| **Async** | Leader responds immediately, replicates later | Faster, risk of lost writes if leader crashes |

**Replication lag:** Time between write on leader and appearance on replica. Typical: 1–500 ms.

### Multi-leader
Multiple nodes accept writes (e.g., one leader per region).

```
[Leader US] ←──sync──→ [Leader EU]
     ↓                       ↓
 Replicas               Replicas
```

**Pros:** Lower write latency per region  
**Cons:** Write conflicts when same data edited in two regions simultaneously

**Conflict resolution:** Last-write-wins (LWW), version vectors, or application merge.

### Leaderless (Dynamo-style)
Any node accepts reads/writes. Client reads from **multiple nodes** and picks latest (quorum).

```
Write to 3 nodes, ack when 2 respond (W=2)
Read from 3 nodes, compare versions (R=2)
If R + W > N → strong-ish consistency
```

Used by: Cassandra, DynamoDB (with tunable consistency).

---

## Quorum reads and writes

For N replicas:

- **W** = nodes that must ack a write
- **R** = nodes contacted for a read

| Setting | Effect |
|---------|--------|
| R + W > N | Overlap guarantees fresh read |
| W = 1, R = 1 | Fastest, weakest consistency |
| R = N, W = N | Strongest, slowest |

**Example:** N=3, W=2, R=2 → at least one node has latest data on every read.

---

## Handling replication lag in apps

Problem: User updates profile → read replica still has old data → user sees stale profile.

**Fixes:**

1. **Read from leader** after user's own write
2. **Track version** — client sends last seen version; server waits until replica catches up
3. **Cache user's own data** in session after write
4. **Monotonic reads** — route same user to same replica

---

## CAP theorem (intermediate level)

During a **network partition** (nodes can't communicate):

- **C** (Consistency) — all nodes agree
- **A** (Availability) — every request gets a response
- **P** (Partition tolerance) — system keeps running despite network splits

**You must pick C or A during a partition.** Real systems choose per feature:

| Feature | Choice |
|---------|--------|
| Payment ledger | CP — reject requests rather than show wrong balance |
| Product catalog | AP — show slightly stale prices, stay online |
| Session store | Often AP with TTL |

---

## Check yourself

1. Strong vs eventual consistency — give one use case for each.
2. What is replication lag and why does it matter?
3. Sync vs async replication trade-offs?
4. What does R + W > N guarantee in quorum systems?
5. How do you prevent a user from seeing their own stale write?

## Key takeaway

Pick consistency **per feature**, not globally. Most user-facing apps use **eventual consistency + read-your-writes** for social data, and **strong consistency** for money and inventory.
