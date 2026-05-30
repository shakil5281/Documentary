# 09 — Deployment & DevOps

**Level:** Advanced  
**Estimated reading time:** 35 minutes  
**Previous:** [08 — Observability](./08-observability.md)  
**Next:** [10 — Advanced Patterns](./10-advanced-patterns.md)

---

## The Deployment Challenge

A monolith = one artifact to build, test, and deploy. Microservices = N artifacts, each with its own pipeline, versioning, and runtime. Without strong DevOps practices, the operational cost of microservices becomes unmanageable.

---

## Containers

A **container** packages an application with all its dependencies into a single, portable unit that runs consistently anywhere.

```
┌─────────────────────────┐
│       Container        │
│  ┌───────────────────┐  │
│  │   Your Service    │  │
│  │   + Runtime       │  │
│  │   + Dependencies  │  │
│  └───────────────────┘  │
│  Container Runtime (Docker/containerd) │
└─────────────────────────┘
│         Host OS         │
└─────────────────────────┘
```

Why containers for microservices:

- **Consistency** — runs the same in dev, staging, and production
- **Isolation** — each service runs in its own container
- **Portability** — deploy to any cloud or on-premises
- **Efficiency** — lighter than virtual machines, start in seconds

Each microservice typically has its own container image.

---

## Container Orchestration (Kubernetes)

When you have 20+ services, manually managing containers is impractical. An **orchestrator** automates deployment, scaling, networking, and recovery.

**Kubernetes (K8s)** is the dominant orchestrator.

Key concepts:

| Concept | What it is |
|---------|-----------|
| **Pod** | Smallest deployable unit — one or more containers sharing network/storage |
| **Deployment** | Manages pod replicas, rolling updates, rollbacks |
| **Service** | Stable network endpoint for a set of pods (load balancing) |
| **Namespace** | Logical isolation (e.g., `production`, `staging`) |
| **ConfigMap / Secret** | External configuration and sensitive data injected into pods |
| **Ingress** | External HTTP routing into the cluster |

How a microservice runs on Kubernetes:

```
Deployment: order-service (3 replicas)
  ├── Pod: order-service-abc (container: order-service:v2.1)
  ├── Pod: order-service-def (container: order-service:v2.1)
  └── Pod: order-service-ghi (container: order-service:v2.1)

Service: order-service (ClusterIP, port 8080)
  → load balances across the 3 pods

Ingress: api.example.com/orders → order-service:8080
```

---

## CI/CD Pipeline per Service

Each microservice should have its own **Continuous Integration / Continuous Deployment** pipeline.

```
Developer pushes code
       │
       ▼
  ┌─────────┐
  │  Build   │  Compile, run unit tests
  └────┬────┘
       ▼
  ┌─────────┐
  │  Test    │  Integration tests, contract tests
  └────┬────┘
       ▼
  ┌─────────┐
  │  Package │  Build container image, push to registry
  └────┬────┘
       ▼
  ┌─────────┐
  │  Deploy  │  Deploy to staging → smoke test → deploy to production
  └─────────┘
```

Key principles:

- **Independent pipelines** — deploying Order Service should not trigger Payment Service's pipeline
- **Automated testing** — unit, integration, and contract tests run on every commit
- **Immutable artifacts** — the same container image promoted from staging to production (never rebuild for production)
- **Automated rollback** — if health checks fail after deployment, automatically revert

---

## Deployment Strategies

### Rolling Update (Default)

Replace instances one at a time. Zero downtime, but two versions run simultaneously during rollout.

```
v1 v1 v1 v1  →  v2 v1 v1 v1  →  v2 v2 v1 v1  →  v2 v2 v2 v1  →  v2 v2 v2 v2
```

Risk: if v2 has a bug, some users experience it before rollback completes.

### Blue-Green Deployment

Run two identical environments. Switch traffic instantly.

```
Traffic → [Blue: v1]     (active)
          [Green: v2]    (idle, tested)

After validation:
Traffic → [Blue: v1]     (idle, kept for rollback)
          [Green: v2]    (active)
```

Pros: instant rollback (switch back to Blue).  
Cons: requires double infrastructure during deployment.

### Canary Deployment

Route a small percentage of traffic to the new version. Gradually increase if metrics look good.

```
95% traffic → v1
 5% traffic → v2  (monitor error rate, latency)

If v2 is healthy:
75% traffic → v1
25% traffic → v2

Eventually:
100% traffic → v2
```

Pros: limits blast radius of bad deployments.  
Cons: requires traffic splitting capability and good metrics.

---

## Infrastructure as Code (IaC)

Define infrastructure (servers, networks, databases, K8s resources) in version-controlled files, not manual clicks.

| Tool | Purpose |
|------|---------|
| Terraform | Provisions cloud infrastructure (VMs, networks, databases) |
| Helm | Packages Kubernetes manifests as reusable charts |
| Kustomize | Overlays for environment-specific K8s configurations |
| Ansible | Configuration management on servers |

Benefits:

- Reproducible environments (dev = staging = production structure)
- Changes are reviewed in pull requests
- Disaster recovery — rebuild infrastructure from code

---

## Service Discovery

Services need to find each other dynamically (IPs change when containers restart).

| Approach | How |
|----------|-----|
| **DNS-based** (K8s Services) | Each service gets a stable DNS name (`order-service.default.svc.cluster.local`) |
| **Client-side discovery** | Client queries a registry (Consul, Eureka), gets list of instances, load balances |
| **Server-side discovery** (K8s Ingress, AWS ALB) | Load balancer queries registry and routes traffic |

In Kubernetes, this is built-in — Services get stable DNS names and load balancing automatically.

---

## Configuration Management

Each service may need different configuration per environment (database URL, feature flags, API keys).

| Approach | Example |
|----------|---------|
| **Environment variables** | `DATABASE_URL=postgres://...` |
| **ConfigMaps** (K8s) | Non-sensitive config injected into pods |
| **Secrets** (K8s / Vault) | Encrypted sensitive config |
| **External config server** | Spring Cloud Config, Consul — centralized config with change notifications |

Rule: **never bake environment-specific config into container images.** The same image should run in dev, staging, and production with different config injected at runtime.

---

## Autoscaling

Scale services based on demand:

| Type | Trigger | Example |
|------|---------|---------|
| **Horizontal Pod Autoscaler (HPA)** | CPU/memory/custom metrics | Scale Order Service from 3 to 10 pods when CPU > 70% |
| **Vertical Pod Autoscaler (VPA)** | Right-size resource requests | Increase memory limit if pod is OOM-killed |
| **Cluster Autoscaler** | Pending pods can't be scheduled | Add nodes to the cluster |

This is a key microservices advantage — scale only the services under load during peak hours.

---

## GitOps

An operational model where Git is the single source of truth for both application code and deployment state.

```
Developer → pushes code → CI builds image → updates manifest in Git repo
                                                      │
Platform team ← Git repo (K8s manifests) ← automated sync ← Kubernetes cluster
```

Tools: ArgoCD, Flux

Benefits: every deployment is a Git commit (auditable, revertable), drift detection (cluster state vs Git state).

---

## Summary

- Containers package each service for consistent, portable deployment.
- Kubernetes orchestrates containers — scaling, networking, self-healing.
- Each service has its own CI/CD pipeline with automated testing and rollback.
- Choose deployment strategy based on risk tolerance: rolling (default), blue-green (safe), canary (gradual).
- Infrastructure as Code ensures reproducible environments.
- Never bake environment config into images; inject at runtime.

---

**Next:** [10 — Advanced Patterns →](./10-advanced-patterns.md)
