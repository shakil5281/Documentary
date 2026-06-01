# Topic 5: Rate Limiting & API Gateways

## Why Rate Limit?

Rate limiting is the practice of restricting the number of requests a client can make to a system within a given timeframe. It is critical for:
- Preventing **DDoS (Distributed Denial of Service)** attacks.
- Saving **infrastructure costs** by blocking resource-hogging scripts or bots.
- Preventing **cascading failures** by ensuring app servers are not overloaded beyond capacity.

---

## Rate Limiting Algorithms

### 1. Token Bucket
- **Mechanism**: A bucket holds up to $N$ tokens. Tokens are added at a constant rate $R$ per second. Each request consumes one token. If no tokens are left, the request is dropped (or queued).
- **Pros**: Simple, memory-efficient. Allows **bursts** of traffic (up to the bucket size $N$).
- **Cons**: Difficult to tune the fill rate and capacity parameters properly.

```
       [Fill: R tokens/sec]
              │
              ▼
       ┌─────────────┐
       │   Tokens    │  ◄── Capacity: N
       └─────────────┘
              │
    Request ──┴──► [Available? Consume 1] ──► Forward
```

### 2. Leaky Bucket (Queue-based)
- **Mechanism**: Requests enter a FIFO queue (the bucket) of capacity $C$. Requests are processed at a constant rate $W$ per second. If the queue is full, new requests are discarded.
- **Pros**: Smooths out traffic spikes; provides a stable outflow rate.
- **Cons**: Increases response latency since requests are buffered in a queue.

### 3. Sliding Window Log
- **Mechanism**: Store every request timestamp in a sorted set (like Redis ZSET). When a request arrives, delete all timestamps older than `current_time - window_size`. The request is allowed if the count of remaining timestamps is less than the limit.
- **Pros**: Highly accurate.
- **Cons**: Extremely memory-intensive since we store timestamps for every single request.

### 4. Sliding Window Counter
- **Mechanism**: Divide time into fixed-size windows (e.g., 1 minute). To calculate requests in the current sliding window, estimate using:
$$\text{Requests} = \text{Count}_{\text{prev}} \times \left(1 - \frac{\text{Time}_{\text{current}}}{\text{Window Size}}\right) + \text{Count}_{\text{current}}$$
- **Pros**: Minimal memory (only two integer counters per user per window). Fast and scalable.

---

## Distributed Rate Limiting & Race Conditions

When scaling rate limiters across multiple app servers, you cannot store rates in application memory. You must use a central store, typically **Redis**.

```
App Server A ──[1. GET rate_limit:user_123 = 9]─┐
                                               ▼
                                            [Redis]
                                               ▲
App Server B ──[2. GET rate_limit:user_123 = 9]─┘
```

### The Race Condition:
If two app servers check the rate limit of `user_123` simultaneously, both read `9` (limit is 10), increment it to `10`, and allow the request. But the user has now sent 11 requests!

### Solutions:
1. **Redis Lua Scripts**: Lua scripts execute atomically in Redis. No other command can run until the script finishes.
2. **Redis sorted sets (ZSET)**: Use Redis `ZADD` and `ZREMRANGEBYSCORE` atomic operations to implement sliding window logs.

---

## API Gateways

An **API Gateway** acts as the single entry point for all client requests. It handles cross-cutting concerns before forwarding requests to microservices.

```
Client ──► [API Gateway] ──┬──► User Service
              │            ├──► Payment Service
              ▼            └──► Search Service
         Auth, SSL,
      Rate Limiting, Log
```

### Core Functions:
1. **Authentication and Authorization**: Verifies JWTs or API keys once, rather than in every single downstream service.
2. **SSL Termination**: Decrypts incoming HTTPS requests at the edge; downstream communication is fast HTTP/gRPC.
3. **Request Routing / Reverse Proxy**: Maps paths (e.g., `/api/v1/payments`) to correct downstream internal hostnames.
4. **Header Manipulation**: Strips unsafe headers or injects tracing correlation IDs (`X-Correlation-ID`) for distributed tracing.

---

## Check yourself

1. Compare Token Bucket and Leaky Bucket. Which one is better for handling bursts of API traffic?
2. Explain the sliding window counter algorithm. Why is it more memory efficient than sliding window log?
3. How does executing a Lua script inside Redis solve the rate limiter concurrency race condition?
4. What is SSL termination, and what are its performance benefits for backend microservices?

---

## Key takeaway

Rate limiters protect downstream resources from overloads. For high-volume services, the **Token Bucket** (managed via atomic **Redis Lua scripts**) or **Sliding Window Counter** offers the best balance of performance and memory footprint.
