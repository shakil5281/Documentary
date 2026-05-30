# Topic 3: Load Balancing

## Why load balancing?

When one server cannot handle all traffic — or you need redundancy — a **load balancer** sits in front of multiple servers and **distributes incoming requests**.

```
                    ┌─── App Server 1
Clients → LB ───────├─── App Server 2
                    └─── App Server 3
```

Benefits:

- **Higher throughput** — parallel processing
- **High availability** — if one server dies, others keep serving
- **Easier deployments** — roll out updates one server at a time

## Layer 4 vs Layer 7 load balancing

| | Layer 4 (Transport) | Layer 7 (Application) |
|--|---------------------|----------------------|
| **Operates on** | IP + port (TCP/UDP) | HTTP headers, URL path, cookies |
| **Speed** | Faster (less inspection) | Slightly slower, smarter routing |
| **Routing** | By IP/port only | By `/api/users`, `Host` header, etc. |
| **Example** | AWS NLB | AWS ALB, Nginx |

**L7 example:** Send `/images/*` to image servers, `/api/*` to API servers.

## Load balancing algorithms

| Algorithm | How it works | Best for |
|-----------|--------------|----------|
| **Round robin** | Rotate through servers in order | Equal-capacity, similar request cost |
| **Weighted round robin** | More traffic to stronger servers | Mixed hardware |
| **Least connections** | Send to server with fewest active connections | Long-lived requests (WebSockets) |
| **IP hash** | Same client IP → same server | Sticky sessions without cookies |
| **Random** | Random server | Simple, surprisingly effective |

## Health checks

Load balancers must detect **dead servers** and stop sending traffic to them.

- **Active check:** LB sends periodic ping/HTTP request → expects 200 OK
- **Passive check:** LB notices failed responses and marks server unhealthy

Without health checks, users hit dead servers and see errors.

```
Healthy:   Server 1 ✓  Server 2 ✓  Server 3 ✓  → traffic to all
Failure:   Server 1 ✓  Server 2 ✗  Server 3 ✓  → traffic to 1 and 3 only
```

## Sticky sessions (session affinity)

Some apps require the same user to hit the **same server** every time (in-memory session).

- LB sets a cookie or uses IP hash
- **Downside:** Uneven load, harder to scale down, server crash loses session

**Better approach:** Store sessions in Redis — any server can serve any user.

## Load balancer placement

### External (client-facing)
Between internet and your app servers. Terminates SSL, DDoS protection.

```
Internet → [External LB] → App Servers
```

### Internal (service-to-service)
Between microservices inside your data center.

```
API Service → [Internal LB] → User Service
                             → Order Service
```

## DNS load balancing

DNS can return **multiple IP addresses** for one domain. Clients connect to different servers.

- **Pros:** Simple, geographic routing possible
- **Cons:** DNS caching causes slow failover; not fine-grained

Often used **together with** hardware/software load balancers, not instead of them.

```
User queries api.example.com
DNS returns: 1.2.3.4, 1.2.3.5, 1.2.3.6
User picks one (or round-robins)
```

## Redundancy for the load balancer itself

The LB can become a single point of failure.

Solutions:

- **Active-passive pair** — standby takes over on failure
- **DNS failover** — point domain to backup LB
- **Cloud-managed LB** — AWS ELB, GCP LB (provider handles redundancy)

## Check yourself

1. Why do we need a load balancer?
2. L4 vs L7 — when would you use each?
3. Explain least connections vs round robin.
4. What happens without health checks?
5. Why is sticky session often a bad idea? What's the alternative?

## Key takeaway

Load balancers distribute traffic, enable horizontal scaling, and improve availability — always pair them with health checks and avoid sticky sessions when possible.
