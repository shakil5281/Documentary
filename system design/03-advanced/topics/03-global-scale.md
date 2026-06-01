# Topic 3: Multi-Region & Global Latency

## Routing Users Globally

When building a system for a global audience, speed is limited by the speed of light. A packet traveling from London to Sydney and back takes ~300ms of pure fiber transit time. To achieve sub-100ms latency, systems must run in multiple regions.

How do we route users to the nearest physical datacenter?

```
User (London)  ──[GeoDNS]──> Resolve IP: 1.1.1.1 (London DC)
User (Sydney)  ──[GeoDNS]──> Resolve IP: 2.2.2.2 (Sydney DC)
```

### 1. GeoDNS
DNS servers resolve a hostname to different IP addresses based on the client's DNS resolver location.
- **Pros**: Easy to configure, supported by major registrars.
- **Cons**: Coarse routing (IP geography databases are imperfect), DNS caching can keep users routed to a far region if they travel or if a region fails.

### 2. Anycast BGP Routing
Multiple servers in different geographic locations share the exact same IP address. Routers on the internet route packets along the shortest path using BGP (Border Gateway Protocol).
- **Pros**: Instant failover (if a DC goes down, BGP routes traffic to the next closest DC), no DNS caching issues.
- **Cons**: High network complexity, expensive IP allocations.

---

## Multi-Region Database Deployments

Once user traffic reaches the nearest region, the local app servers need to query databases.

```
       Active-Passive (Read Replica)                Active-Active (Multi-Leader)
 ┌───────────────┐     ┌───────────────┐      ┌───────────────┐     ┌───────────────┐
 │ US-East (Pri) │     │  EU-West (Sec)│      │    US-East    │     │    EU-West    │
 │   [Writes]    │     │    [Reads]    │      │   [Writes]    │     │   [Writes]    │
 └───────┬───────┘     └───────▲───────┘      └───────┬───────┘     └───────▲───────┘
         │ (Asynchronous Sync) │                      │    (Async Sync)     │
         └─────────────────────┘                      └─────────────────────┘
```

### 1. Active-Passive (Single Leader)
- Writes are sent to a single primary region (e.g., US-East).
- Databases in other regions (e.g., EU-West) are passive read-replicas.
- **Trade-off**: High write latency for international users (EU writes must go to US). **Read-after-write inconsistency**: A user writes to US, then reads from a delayed EU replica, failing to see their write.

### 2. Active-Active (Multi-Leader)
- Every region has a local primary database that accepts reads and writes locally.
- Databases replicate writes to each other asynchronously.
- **Trade-off**: Local writes are fast (<50ms). However, this introduces **write conflicts**.

---

## Write Conflict Resolution in Active-Active

If User A updates a username to "Alice" in the US, and User B updates it to "Bob" in the EU at the same millisecond, the databases must reconcile the difference.

### 1. Last-Write-Wins (LWW)
- The update with the latest timestamp is chosen.
- **Danger**: Clocks across servers are never perfectly synchronized (**Clock Skew**). LWW can silently discard updates that actually happened later because of a slow system clock.

### 2. Conflict-free Replicated Data Types (CRDTs)
- Mathematical structures that merge updates deterministically without conflict.
- **Examples**: Grow-Only Counter, LWW-Register, Observed-Removed Set.
- **Usage**: Used heavily in distributed collaborative editors, shopping carts, and databases like Cassandra.

### 3. Vector Clocks / Version Vectors
- Tracks logical causality rather than physical time.
- If concurrent writes are detected, the system stores both versions and forces the application (or user) to resolve the conflict (like Git merge conflicts).

---

## Regulatory and Compliance Challenges

Multi-region architecture is not just a performance choice; it is a legal requirement.
- **Data Residency (GDPR/CCPA)**: European citizen data must stay within the EU boundary.
- **Implementation**: Database partitioning by user country/region (data sharded to local regional DBs, with no global replication of sensitive fields).

---

## Check yourself

1. Compare GeoDNS and Anycast. How does Anycast handle regional outages faster?
2. What is read-after-write consistency, and why does active-passive database replication break it?
3. What is clock skew, and why does it make Last-Write-Wins (LWW) conflict resolution dangerous?
4. How do database partitions enforce compliance with data residency laws like GDPR?

---

## Key takeaway

Multi-region architecture reduces read latency globally but forces you to choose between **high write latency** (Active-Passive) or **eventual consistency write conflicts** (Active-Active).
