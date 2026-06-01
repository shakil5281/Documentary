# 11 — Security

> **Part:** III Production | **Week:** 9 | **Exercises:** [module-11](../../exercises/module-11.md)

## Learning outcomes

After this module you can:

1. Explain zero trust vs perimeter security for microservices
2. Compare JWT, OAuth2/OIDC, and API keys for auth scenarios
3. Describe mTLS and token propagation for service-to-service calls
4. Apply secrets management and least-privilege principles

---

## Why security is harder

- Every service is an attack surface
- No trusted "inside" — all calls cross network boundaries
- More credentials, more endpoints, more policies

**Shift:** Perimeter security → **zero trust** (verify every request).

---

## Authentication vs authorization

| | Question | Example |
|---|----------|---------|
| AuthN | Who are you? | Login → JWT |
| AuthZ | What can you do? | Admin vs customer roles |

Enforce at **gateway AND each service** (defense in depth).

---

## JWT

Self-contained token: Header.Payload.Signature. Stateless validation across services.

**Pros:** Fast, scalable. **Cons:** Revocation before expiry is hard; token bloat.

---

## OAuth 2.0 / OIDC

Standard for delegated auth ("Login with Google"). Authorization code flow for web apps. OIDC adds identity profile.

---

## Service-to-service security

### mTLS
Both sides present certificates. Encrypted + authenticated. Automated via service mesh (Module 17).

### Token propagation
Forward user JWT through call chain, or use service-level tokens for internal calls.

---

## API Gateway as enforcer

Auth, rate limit, TLS termination, input validation at edge. **Do not** skip validation inside services.

---

## Secrets management

Never hardcode secrets. Use Vault, AWS Secrets Manager, K8s Secrets (encrypted at rest). Rotate regularly; least privilege per service.

---

## Compliance drivers

| Regulation | Microservice approach |
|------------|----------------------|
| PCI DSS | Isolated Payment Service |
| GDPR | User Service owns PII; deletion events propagate |
| HIPAA | Enhanced encryption + audit on health data service |

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Trust internal network | mTLS + network policies |
| Shared DB credentials | Unique creds per service |
| Secrets in git | Secrets manager |

---

## Exercises

See [exercises/module-11.md](../../exercises/module-11.md).

## Next module

[12 — Observability & SLOs →](./12-observability.md)
