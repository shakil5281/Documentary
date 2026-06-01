# 16 — Advanced Patterns

> **Part:** IV Advanced | **Week:** 12 | **Exercises:** [module-16](../../exercises/module-16.md)

## Learning outcomes

After this module you can:

1. Explain CQRS, event sourcing, BFF, and Sidecar patterns
2. Choose when advanced patterns justify their complexity
3. Relate CQRS/event sourcing to scalability and performance
4. Apply Strangler Fig and anti-corruption layer in migration

---

## API Gateway & BFF (summary)

Gateway: single entry, routing, auth, rate limit.  
BFF: one backend per client type (web/mobile/admin) — tailored aggregation, reduces chatty clients.

---

## CQRS

Separate **write model** (commands, business rules) from **read model** (optimized queries).

| Benefit | Cost |
|---------|------|
| Independent read/write scaling | Complexity, eventual consistency |
| Fast complex queries | Sync between models |

**Performance:** Read path O(1) lookup from denormalized store vs O(k) API composition.

---

## Event sourcing

Store events, not just current state. Replay to rebuild state.

| Benefit | Cost |
|---------|------|
| Full audit trail | Schema evolution, replay O(n) |
| Temporal queries | Learning curve |

Often paired with CQRS.

---

## Strangler Fig

Incremental monolith replacement via facade routing (see Module 14).

---

## Sidecar pattern

Helper container alongside main container (mesh proxy, log shipper). Used heavily in service mesh (Module 17).

---

## When NOT to use advanced patterns

Simple CRUD, small team, unclear domain → avoid CQRS/event sourcing overhead.

---

## Exercises

See [exercises/module-16](../../exercises/module-16.md).

## Next module

[17 — API Gateway & Service Mesh →](./17-gateway-and-service-mesh.md)
