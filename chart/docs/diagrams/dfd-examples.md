# DFD Examples

## Learning Objective
By the end of this lesson, you will practice data movement diagrams at context and level-0 views.

## What is DFD Examples?
DFD examples show how data travels between actors, processes, stores, and reports.

## Why it is important?
Diagram practice builds visual thinking. The goal is not to draw beautiful pictures; the goal is to explain a system clearly enough that business and technical people can agree.

## ERP Example
Payroll DFD uses employee master, attendance, salary rules, tax rules, bank file, and payslip records.

## Step-by-step Explanation
1. Choose the question the diagram must answer.
2. List the actors, modules, data, or infrastructure nodes.
3. Draw the simplest useful version first.
4. Add labels that explain real business meaning.
5. Review the diagram and remove unnecessary noise.

## Diagram

```mermaid
flowchart TD
    A[Start Business Event] --> B[Validate Input]
    B --> C{Approved?}
    C -->|Yes| D[Update ERP Record]
    C -->|No| E[Return Exception]
    D --> F[Generate Report]
```

## Key Points
- Every diagram should answer one main question.
- Labels should use business language.
- Examples should include normal and exception paths.
- Diagrams improve when reviewed with real scenarios.

## Common Mistakes
- Adding too many unrelated concepts.
- Using generic names that hide meaning.
- Not showing where data is stored or changed.
- Skipping rejected and failed cases.

## Practice Task
Create your own DFD Examples for an ERP module such as HR, Inventory, Sales, Finance, or Procurement.

## Summary
DFD Examples gives you reusable visual patterns for documenting ERP systems.
