# Software Development Process

## Learning Objective
By the end of this lesson, you will understand how a software idea becomes a tested, deployed, and maintained application.

## What is Software Development Process?
The software development process is the organized path a team follows from business need to working software. It includes discovery, requirement analysis, design, development, testing, deployment, and maintenance.

## Why it is important?
ERP systems touch many departments. If HR, Finance, Inventory, and Sales do not agree on requirements before development, one change can break payroll, stock valuation, invoices, or reports.

## ERP Example
A company wants automatic overtime calculation. The team must confirm attendance rules, approval rules, payroll impact, test cases, report changes, and deployment timing before releasing it.

## Step-by-step Explanation
1. Collect the business problem and expected outcome.
2. Write functional requirements and acceptance criteria.
3. Design process flow, data model, API contracts, and UI behavior.
4. Develop the feature in small reviewable parts.
5. Test normal cases, edge cases, permissions, and reports.
6. Deploy with rollback and monitoring plan.

## Diagram

```mermaid
flowchart LR
    A[Business Need] --> B[Requirement Analysis]
    B --> C[Design Documents]
    C --> D[Development]
    D --> E[Testing]
    E --> F[Deployment]
    F --> G[Maintenance]
```

## Key Points
- Requirements explain what to build.
- Design explains how the solution will work.
- Testing proves business rules are correct.
- Maintenance handles change after release.

## Common Mistakes
- Starting development before requirements are approved.
- Ignoring edge cases such as holidays, late approvals, or missing data.
- Deploying ERP changes without user communication.
- Treating documentation as optional.

## Practice Task
Choose a feature such as leave approval or sales invoice posting. Write a mini SDLC plan with requirement, design, build, test, deployment, and support activities.

## Summary
A strong development process reduces confusion and protects ERP workflows from accidental damage.
