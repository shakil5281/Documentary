# Topic 7: Security & Auth at Scale

## Stateless Authentication with JWTs

Traditional systems use **Session-based Authentication**: the server generates a session ID, stores it in a database (like Redis), and returns it to the client in a cookie. For every request, the server must query the database to validate the session. 

At scale (100k+ QPS), querying a database for every single API request becomes a massive bottleneck. 

To solve this, we use stateless **JWT (JSON Web Token) Authentication**.

```
Session-Based:
Client ──► App Server ──► Session DB (Redis) ──► Validate

Stateless JWT:
Client ──► App Server ────► Decode JWT with Public Key (Self-Validating)
```

- **How it works**: An authentication server signs a JSON payload (containing user ID, roles, expiration time) using a private key. The token is sent to the client.
- **Validation**: App servers download the public key from the identity provider once and cache it. When the client makes a request with the JWT, the app server validates the cryptographic signature locally in memory. **No database query is needed**.

---

## The JWT Revocation Problem

Because JWTs are stateless and self-validating, they cannot be easily invalidated. If a user logs out, changes their password, or their token is stolen, the token remains valid until its expiration date (`exp` claim) passes.

### Solutions:
1. **Short-Lived Access Tokens & Refresh Tokens**:
   - Access tokens have a very short lifetime (e.g., 10 to 15 minutes).
   - When it expires, the client uses a long-lived **Refresh Token** (stored in the Auth DB) to request a new access token.
   - If a user logs out, the refresh token is deleted from the DB, preventing them from getting new access tokens once the current 10-minute access token expires.
2. **Revocation Blocklist (Redis)**:
   - When a token is explicitly revoked (logout/ban), its unique token ID (`jti` claim) is stored in a fast Redis cache with a TTL equal to the token's remaining lifetime.
   - App servers check the Redis blocklist during validation. This is still a network hop, but it is only queried for active sessions, which is faster than checking a primary database.

---

## SSL/TLS Termination

Encryption and decryption of packets using TLS (Transport Layer Security) is CPU-intensive.

```
Incoming HTTPS (Encrypted) ──► [ Load Balancer ] ──► HTTP (Decrypted) ──► App Server 1
                               (TLS Terminated)  ──► HTTP (Decrypted) ──► App Server 2
```

- **TLS Termination** is the process of decrypting HTTPS requests at the Edge Load Balancer or API Gateway, then passing decrypted HTTP/gRPC traffic through the secure internal private network to the app servers.
- **Benefits**: Offloads CPU-heavy cryptography work from application servers; centralizes certificate renewal (e.g. Let's Encrypt) to a single place.

---

## DDoS Mitigation

A **Distributed Denial of Service (DDoS)** attack attempts to exhaust network bandwidth, memory, or CPU by flooding the system with massive volume of dummy requests.

### Defense-in-Depth Architecture:
1. **Edge Anycast Routing**: Distributes the volumetric traffic across dozens of globally distributed edge servers, preventing any single datacenter pipeline from clogging.
2. **Web Application Firewall (WAF)**: Inspects HTTP payloads at the edge to block known attack signatures, SQL injections, and malicious user-agents.
3. **CDN Caching**: Serves static contents from CDNs to absorb GET floods without letting requests reach your servers.
4. **Rate Limiting**: Drop traffic matching suspicious burst rates.

---

## Secrets Management

Hardcoding database passwords, API keys, or JWT signing keys in source code leads to catastrophic credential leaks.
- **Secrets Managers** (like HashiCorp Vault, AWS Secrets Manager, Google Secret Manager) encrypt secrets at rest and control access using fine-grained IAM policies.
- Secrets are dynamically injected into application containers as environment variables at runtime, or fetched programmatically with automatic rotation.

---

## Check yourself

1. Explain the performance advantage of stateless JWT authentication over session-based authentication at scale.
2. What is the JWT revocation problem? Explain the "refresh token" pattern used to address it.
3. What is TLS termination, and where in the request path does it typically occur?
4. Why is hardcoding secrets in Git repositories dangerous, and how do secrets managers solve this?

---

## Key takeaway

Stateless JWT authentication enables **self-validating security** at scale but requires short lifetimes to manage revocation. Cryptographic overhead is offloaded from app servers via **SSL/TLS termination** at the edge load balancer.
