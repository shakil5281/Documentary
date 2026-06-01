# Topic 1: Distributed Consensus & Coordination

## The Core Challenge: Split-Brain & Agreement

In a distributed system, servers fail, networks experience lag, and packets get dropped. A **network partition** occurs when communication between nodes fails, splitting the cluster into disconnected sub-clusters. 

If both sub-clusters continue serving writes independently, they will diverge. This is called the **split-brain scenario**.

```
    [Partition Line]
Cluster A          Cluster B
┌───────┐   X   ┌───────┐
│ Node 1│  ---  │ Node 3│
└───────┘       └───────┘
    │               │
┌───────┐       ┌───────┐
│ Node 2│       │ Node 4│
└───────┘       └───────┘
```

**Distributed Consensus** is the process of getting multiple independent nodes to agree on a single data value or system state (e.g., "Which node is the leader?", "Has transaction X committed?").

---

## Paxos vs. Raft

### 1. Paxos
The original consensus protocol. It is notoriously difficult to understand and implement because it was designed for a single consensus decision (Single-Decree Paxos) rather than a continuous stream of decisions (Multi-Paxos).
- **Phases**: Prepare/Promise (Phase 1) and Propose/Accept (Phase 2).

### 2. Raft
Designed specifically to be easier to understand and build. It decomposes consensus into three sub-problems:
- **Leader Election**: A single leader is chosen. A candidate must gather votes from a **quorum** (majority: `N/2 + 1` nodes) to become leader.
- **Log Replication**: The leader receives write commands, appends them to its log, and replicates them to followers. The leader commits an entry only after a quorum of followers have appended it to their logs.
- **Safety**: If a follower's log is more up-to-date than a candidate's log, the follower denies its vote. This ensures the elected leader always contains all committed entries.

---

## Quorums and Split-Brain Prevention

Consensus protocols rely on a **Quorum** to make decisions safely:
$$\text{Quorum Size} = \lfloor N/2 \rfloor + 1$$

If a cluster of 5 nodes splits into two parts:
- Sub-cluster A (2 nodes): Cannot form a quorum ($2 < 3$). It rejects writes or goes read-only.
- Sub-cluster B (3 nodes): Can form a quorum ($3 \ge 3$). It can safely elect a leader and accept writes.

This mathematically prevents split-brain. Once the partition heals, Sub-cluster A learns of the newer state from Sub-cluster B and catches up.

---

## ZooKeeper & etcd

Rather than writing custom consensus code (which is extremely error-prone), engineers use specialized, production-ready coordination services:

| Feature | Apache ZooKeeper | etcd |
|---------|------------------|------|
| **Implementation** | Java (Zab protocol) | Go (Raft protocol) |
| **Data Model** | Hierarchical Tree (Znode filesystem structure) | Flat Key-Value Space (with prefixes) |
| **APIs** | Native Client, gRPC via wrappers | Native gRPC / HTTP |

### Key Primitive Capabilities:
1. **Heartbeats & Sessions**: Clients maintain an active session with the consensus cluster by sending periodic heartbeat pings.
2. **Ephemeral Nodes**: Virtual nodes that exist only as long as the client session is alive. If the client fails or network partition lasts too long, the node is automatically deleted.
3. **Watches / Event Listeners**: Clients can subscribe to changes on a key/path. Instead of constant polling, the consensus cluster pushes notifications to the client.

### Core Industry Use Cases:
- **Leader Election**: Multiple app nodes attempt to create the same ephemeral node (`/active-leader`). The first to succeed becomes leader. Others set a *watch* on `/active-leader`. If the leader crashes, the ephemeral node is deleted, triggering a watch event, and a new node claims leadership.
- **Distributed Locks**: Coordinate exclusive access to shared resources across many nodes.
- **Service Discovery**: Service instances write their IPs to ephemeral nodes. Clients watch the directory to get an up-to-date, real-time list of healthy endpoints.

---

## Check yourself

1. Explain the split-brain scenario. How does quorum prevent it?
2. If you have a 4-node cluster, what is the maximum number of failed nodes the cluster can tolerate while still accepting writes? *(Hint: calculate quorum size first)*
3. What is an ephemeral node, and how is it used to implement leader election?
4. What is the purpose of the "watch" mechanism in ZooKeeper/etcd?

---

## Key takeaway

Consensus protocol systems (like etcd/ZooKeeper) trade performance for **strong consistency**. They are not meant to store massive amounts of user data, but rather small metadata essential for coordinating distributed services.
