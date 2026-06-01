# Modular Monolith

## Learning Objective
By the end of this lesson, you will build one deployable ERP application with strong internal module boundaries.

## What is Modular Monolith?
A modular monolith keeps one deployment unit but separates modules by business capability and clear interfaces.

## Why it is important?
At advanced level, documentation must guide decisions, not only describe screens. It should help teams understand tradeoffs, risks, module boundaries, performance, deployment, and long-term maintenance.

## ERP Example
HR, Attendance, Payroll, Finance, and Inventory live in one codebase, but each module owns its models, services, and rules.

## Step-by-step Explanation
1. Define scope and business capability.
2. Identify users, modules, data, integrations, and constraints.
3. Document the main design decisions and alternatives.
4. Add diagrams that show structure and behavior.
5. Review non-functional requirements such as security, scale, reliability, and operations.
6. Create an implementation checklist.

## Diagram

```mermaid
flowchart LR
    A[Business Capability] --> B[Architecture Decision]
    B --> C[Module Boundary]
    C --> D[Data and Integration Design]
    D --> E[Deployment and Operations]
    E --> F[Review and Improve]
```

## Key Points
- Architecture is about tradeoffs.
- Advanced documents should include risks and assumptions.
- Module ownership prevents long-term confusion.
- Non-functional requirements must be explicit.

## Common Mistakes
- Creating diagrams without decision context.
- Ignoring operational concerns.
- Over-engineering before the business needs it.
- Copying architecture patterns without understanding cost.

## Practice Task
Create a two-page architecture note for Modular Monolith. Include problem, decision, diagram, risks, alternatives, and review checklist.

## Summary
Modular Monolith helps you move from feature documentation to architecture-level thinking.
