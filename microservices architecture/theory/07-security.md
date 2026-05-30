# 07 — Security

**Level:** Intermediate–Advanced  
**Estimated reading time:** 30 minutes  
**Previous:** [06 — Reliability & Resilience](./06-reliability-and-resilience.md)  
**Next:** [08 — Observability](./08-observability.md)

---

## Why Security Is Harder in Microservices

In a monolith, security is a perimeter problem — authenticate at the edge, and everything inside is trusted. In microservices:

- Traffic flows between many services, not just client-to-server
- Each service is a potential attack surface
- There is no "inside" — every call crosses a network boundary
- More services = more endpoints to secure, more credentials to manage

The shift is from **perimeter security** to **zero trust** — never trust, always verify, even for internal calls.

---

## Authentication vs Authorization

| Concept | Question | Example |
|---------|----------|---------|
| **Authentication (AuthN)** | Who are you? | User logs in with email/password → receives JWT token |
| **Authorization (AuthZ)** | What can you do? | User with "admin" role can delete orders; "customer" role cannot |

Both must be enforced at the API Gateway (external traffic) and at each service (internal traffic).

---

## Common Authentication Mechanisms

### JWT (JSON Web Token)

A self-contained token that carries user identity and claims. Services validate the token without calling an auth server.

```
Client → API Gateway (validates JWT) → Service (validates JWT again)
```

Structure: `Header.Payload.Signature`

- **Header** — algorithm used
- **Payload** — user ID, roles, expiration time
- **Signature** — ensures token wasn't tampered with

**Pros:** Stateless, fast validation, works across services.  
**Cons:** Hard to revoke before expiration, token size grows with claims.

### OAuth 2.0 / OpenID Connect (OIDC)

Industry standard for delegated authorization. Used when third-party apps need access (e.g., "Login with Google").

Flow (Authorization Code):
```
1. User → Auth Server: "I want to log in"
2. Auth Server → User: "Enter credentials"
3. Auth Server → Client: "Here's an authorization code"
4. Client → Auth Server: "Exchange code for access token"
5. Client → Service: "Request with access token"
```

OIDC adds an identity layer on top of OAuth 2.0 (returns user profile info).

### API Keys

Simple tokens for service-to-service or machine-to-machine communication. Less secure than OAuth/JWT but simpler for internal APIs.

---

## Service-to-Service Security

External users are authenticated at the gateway. But services also call each other — those calls must be secured too.

### mTLS (Mutual TLS)

Both client and server present certificates to verify each other's identity. Every service-to-service call is encrypted and authenticated.

```
Service A ──(presents cert)──► Service B
Service A ◄──(presents cert)── Service B
Both verify each other's certificates before exchanging data
```

Used in service meshes (Istio, Linkerd) to automate certificate management.

### Token Propagation

When a user request flows through multiple services, the user's identity token must be forwarded:

```
Client → Gateway (JWT) → Order Service (JWT) → Payment Service (JWT)
```

Each service validates the token and checks authorization for the requested action.

Alternatively, services exchange their own service-level tokens (not the user's token) for internal calls.

---

## The API Gateway as Security Enforcer

The API Gateway is the single entry point and primary security checkpoint:

| Responsibility | How |
|---------------|-----|
| Authentication | Validate JWT/OAuth tokens |
| Authorization | Check roles/permissions before routing |
| Rate limiting | Prevent abuse and DDoS |
| Input validation | Reject malformed requests early |
| TLS termination | Handle HTTPS at the edge |
| IP whitelisting | Restrict access by source |

Internal services should **also** validate tokens — never assume gateway validation is sufficient (defense in depth).

---

## Secrets Management

Microservices need many secrets: database passwords, API keys, encryption keys, certificates.

**Never:**

- Hardcode secrets in source code
- Store secrets in environment variables without encryption
- Commit secrets to version control

**Instead, use a secrets manager:**

| Tool | Type |
|------|------|
| HashiCorp Vault | Self-hosted secrets manager |
| AWS Secrets Manager | Cloud-managed |
| Azure Key Vault | Cloud-managed |
| Kubernetes Secrets | Built-in (base64, not encrypted by default — use with encryption at rest) |

Best practices:

- Rotate secrets regularly
- Grant each service access only to its own secrets (least privilege)
- Audit secret access

---

## Zero Trust Architecture

Core principles applied to microservices:

1. **Verify explicitly** — authenticate and authorize every request, regardless of source
2. **Least privilege access** — each service gets minimum permissions needed
3. **Assume breach** — design as if an attacker is already inside the network

Practical implementation:

- mTLS between all services
- Network policies restricting which services can talk to which
- No shared credentials between services
- Audit logging of all access

---

## Common Security Anti-Patterns

| Anti-pattern | Risk | Fix |
|-------------|------|-----|
| Shared database credentials | One breach exposes all data | Unique credentials per service |
| Trusting internal network | Lateral movement after one compromise | mTLS + zero trust |
| No input validation at service level | Bypass gateway validation | Validate at every service |
| Logging sensitive data | Passwords/tokens in log files | Redact PII and secrets from logs |
| Long-lived tokens without rotation | Stolen token valid indefinitely | Short expiration + refresh tokens |

---

## Compliance Considerations

Some regulations require data isolation that naturally maps to microservices:

| Regulation | Requirement | Microservice approach |
|-----------|-------------|----------------------|
| PCI DSS | Payment data isolated | Dedicated Payment Service with restricted access |
| GDPR | Personal data control and deletion | User Service owns PII; deletion events propagate |
| HIPAA | Health data protected | Separate service with enhanced encryption and audit |

---

## Summary

- Shift from perimeter security to zero trust — verify every call.
- Authenticate users (JWT/OAuth) at the gateway and at each service.
- Secure service-to-service communication with mTLS or service tokens.
- Manage secrets with a dedicated secrets manager, never in code.
- Apply least privilege — each service accesses only what it needs.

---

**Next:** [08 — Observability →](./08-observability.md)
