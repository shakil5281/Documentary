# Topic 1: Introduction to System Design

## What is system design?

**System design** is the process of defining how software components work together to meet requirements — especially when many users, large data, or failures are involved.

You are not just picking technologies. You are answering:

- What does the system **do**? (features)
- How **fast**, **reliable**, and **available** must it be?
- What happens when traffic **spikes** or a server **crashes**?
- How does **data** flow from user action to storage and back?

## Two types of requirements

### Functional requirements
What the system must **do**.

> Example (URL shortener): User submits a long URL → system returns a short link → short link redirects to the original URL.

### Non-functional requirements (NFRs)
How well the system must **perform**. These drive architecture.

| NFR | Question it answers | Example target |
|-----|---------------------|----------------|
| **Latency** | How fast is a response? | p99 < 200 ms |
| **Throughput** | How many requests per second? | 10,000 writes/sec |
| **Availability** | Uptime percentage | 99.9% ("three nines") |
| **Durability** | Will data survive failures? | No lost URLs after write |
| **Scalability** | Can it grow with load? | 10× traffic without rewrite |

## The basic request path

Every web system follows a similar shape:

```
User → DNS → Load Balancer → App Server → (Cache) → Database
                                    ↓
                              External services
```

Understanding this path is the foundation for everything else.

## Core building blocks (preview)

| Block | One-line purpose |
|-------|------------------|
| **DNS** | Maps `example.com` to an IP address |
| **Load balancer** | Spreads traffic across many servers |
| **App server** | Runs your business logic |
| **Cache** | Stores hot data in fast memory |
| **Database** | Persistent storage |
| **CDN** | Serves static content from edge locations |
| **Message queue** | Decouples slow/async work |

You will learn each block in detail in upcoming topics.

## How to approach any design problem

Use this framework every time:

1. **Clarify requirements** — ask about scale, read/write ratio, consistency needs
2. **Estimate scale** — users, QPS, storage (Topic 7)
3. **High-level design** — draw boxes and arrows
4. **Deep dive** — pick 2–3 critical components
5. **Identify bottlenecks** — what breaks first at 10× traffic?
6. **Trade-offs** — why this choice over alternatives?

## Availability math (quick reference)

| Uptime | Downtime per year |
|--------|-------------------|
| 99% (two nines) | ~3.65 days |
| 99.9% (three nines) | ~8.7 hours |
| 99.99% (four nines) | ~52 minutes |
| 99.999% (five nines) | ~5 minutes |

Higher availability usually means **redundancy** (multiple copies of everything) and **automation** (failover without human intervention).

## Check yourself

1. What is the difference between functional and non-functional requirements?
2. Name five core building blocks and what each does.
3. What does 99.9% availability mean in downtime per year?
4. What are the six steps of the design framework?

## Key takeaway

System design = **requirements + architecture + trade-offs under scale and failure**.
