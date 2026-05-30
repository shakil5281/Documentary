# Topic 6: Networking & APIs

## How a web request travels

When you type `https://api.example.com/users/42`:

```
1. DNS lookup     → api.example.com → 203.0.113.50
2. TCP handshake  → establish connection (3-way)
3. TLS handshake  → encrypt (HTTPS)
4. HTTP request   → GET /users/42
5. Server process → load balancer → app → cache/DB
6. HTTP response  → 200 OK + JSON body
7. Connection close or keep-alive
```

Each hop adds latency. **Same-region** round trip ≈ 1–2 ms. **Cross-continent** ≈ 100–200 ms.

## HTTP basics

| Method | Purpose | Idempotent? |
|--------|---------|-------------|
| **GET** | Read data | Yes |
| **POST** | Create resource | No |
| **PUT** | Replace resource | Yes |
| **PATCH** | Partial update | No |
| **DELETE** | Remove resource | Yes |

**Idempotent** = calling twice has the same effect as calling once. Important for retries.

### Status codes to know

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad request (client error) |
| 401 | Unauthorized (not logged in) |
| 403 | Forbidden (logged in, no permission) |
| 404 | Not found |
| 429 | Too many requests (rate limited) |
| 500 | Server error |
| 503 | Service unavailable (overload/maintenance) |

## REST API design

**REST** = Represent resources as URLs, use HTTP methods.

```
GET    /users/42           → get user 42
POST   /users              → create user (body: JSON)
PUT    /users/42           → replace user 42
PATCH  /users/42           → update fields
DELETE /users/42           → delete user 42
GET    /users/42/posts     → list posts by user 42
```

### Good API practices

| Practice | Example |
|----------|---------|
| **Pagination** | `GET /posts?cursor=abc&limit=20` |
| **Filtering** | `GET /posts?author=42&status=published` |
| **Versioning** | `/v1/users` or `Accept: application/vnd.api+json;version=1` |
| **Consistent errors** | `{ "error": "not_found", "message": "User 42 not found" }` |

### Pagination: offset vs cursor

**Offset** — `?page=5&limit=20`  
Simple but slow at high offsets (DB scans skipped rows).

**Cursor** — `?cursor=last_seen_id&limit=20`  
Faster, stable under concurrent inserts. **Prefer cursor** at scale.

## Rate limiting

Protect your system from abuse and overload.

```
Client → [Rate Limiter: 100 req/min per user] → App
```

If exceeded → **429 Too Many Requests** + `Retry-After` header.

Algorithms (detail in intermediate): token bucket, sliding window.

## CDN (Content Delivery Network)

A **CDN** caches static content at **edge servers** worldwide, close to users.

```
Without CDN:  User (Tokyo) ──────────────→ Origin (US)  ~150 ms
With CDN:     User (Tokyo) → Edge (Tokyo) ~10 ms
                            ↓ cache miss only
                            Origin (US)
```

**Cache on CDN:** Images, videos, CSS, JS, static HTML  
**Do NOT cache:** Personalized API responses (unless keyed by user)

**Cache control header:**
```
Cache-Control: public, max-age=86400
```

## TCP vs UDP

| | TCP | UDP |
|--|-----|-----|
| **Reliability** | Guaranteed delivery, ordered | Best effort, may lose packets |
| **Connection** | Connection-oriented | Connectionless |
| **Use case** | HTTP, APIs, databases | Video streaming, gaming, DNS |

Most APIs use **TCP** (HTTP/HTTPS). Real-time media often uses **UDP**.

## WebSockets (brief)

HTTP is request-response. **WebSockets** open a persistent two-way connection.

```
Client ←──── ongoing messages ────→ Server
```

Used for: chat, live notifications, collaborative editing.

Requires **sticky sessions** or a **pub/sub layer** (Redis) when scaled across servers.

## Authentication vs authorization

| | AuthN | AuthZ |
|--|-------|-------|
| **Question** | Who are you? | What can you do? |
| **Example** | Login with password/OAuth | Admin can delete, user cannot |
| **Mechanism** | JWT, session cookie, API key | Role-based (RBAC), permissions |

**JWT flow (common):**
```
1. POST /login → server returns signed token
2. Client sends: Authorization: Bearer <token>
3. Server verifies signature → identifies user
```

## Check yourself

1. List the steps from URL typed in browser to HTTP response.
2. Which HTTP methods are idempotent?
3. Why prefer cursor pagination over offset at scale?
4. What content belongs on a CDN vs not?
5. Difference between authentication and authorization?

## Key takeaway

Design **RESTful APIs** with pagination, clear errors, and rate limits. Use **CDN** for static assets. Understand request path latency when estimating performance.
