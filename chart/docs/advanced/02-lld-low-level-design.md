# LLD Low Level Design

## Learning Objective
By the end of this lesson, you will convert high-level architecture into implementation-ready detail.

## What is LLD Low Level Design?
A Low Level Design describes classes, functions, validations, tables, APIs, sequence flows, errors, and edge cases for a feature or module.

## Why it is important?
At advanced level, documentation must guide decisions, not only describe screens. It should help teams understand tradeoffs, risks, module boundaries, performance, deployment, and long-term maintenance.

## ERP Example
Leave approval LLD defines request states, validation methods, approval policy, tables, API payloads, and audit records.

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
Create a two-page architecture note for LLD Low Level Design. Include problem, decision, diagram, risks, alternatives, and review checklist.

## Summary
LLD Low Level Design helps you move from feature documentation to architecture-level thinking.
