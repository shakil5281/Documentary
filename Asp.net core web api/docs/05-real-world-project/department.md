# Employee Management API - Department Module

## Learning Goal
Design the Department module of a real-world Employee Management API from features to endpoints, database ideas, validation, service flow, and diagrams.

## Simple Explanation
The Department module is one business area of the Employee Management API. A strong API design starts with user needs, then turns them into endpoints, tables, request/response DTOs, validation rules, and service logic.

বাংলা সারাংশ: এই পাঠটি সহজভাবে ধারণা, ব্যবহার, ভুল এবং বাস্তব অনুশীলন বুঝতে সাহায্য করবে।

## Feature List
- Create department
- Assign manager
- List department employees

## API Endpoint List
- `/api/departments`
- `/api/departments/{id}`
- `/api/departments/{id}/employees`

## Database Table Idea
- `Departments`: stores departments data.

## Request/Response Example
Request:
```json
{
  "name": "Example Name",
  "description": "Sample request"
}
```

Response:
```json
{
  "id": 1,
  "message": "Operation completed successfully"
}
```

## Validation Rules
- Required fields must not be empty.
- Text fields should have maximum length limits.
- Foreign keys must reference existing records.
- Business rules should be checked in the service layer.
- Unauthorized users must not access protected module operations.

## Service Flow
1. Controller receives request DTO.
2. Validator checks shape and basic rules.
3. Service checks business rules and permissions.
4. Repository reads or writes database records.
5. Service returns response DTO.
6. Controller returns the correct HTTP status code.

## Simple Explanation
For this module, keep controller code small. The service should own the business decision, and the repository should own data access. This separation makes the project easier to test and maintain.

## Real-world Example
In a company HR system, the Department module supports daily HR operations while keeping employee data consistent and auditable.

## Code Example
```csharp
[ApiController]
[Route("api/department")]
public sealed class DepartmentController : ControllerBase
{
    private readonly IDepartmentService service;

    public DepartmentController(IDepartmentService service)
    {
        this.service = service;
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateDepartmentRequest request)
    {
        var result = await service.CreateAsync(request);
        return CreatedAtAction(nameof(Create), result);
    }
}
```

## Common Mistakes
- Designing endpoints before understanding the business workflow.
- Mixing unrelated module responsibilities in one controller.
- Skipping validation because the frontend already validates.
- Forgetting audit fields such as CreatedAt and UpdatedAt.

## Best Practices
- Keep module boundaries clear.
- Use request and response DTOs.
- Add indexes for common search fields.
- Log important business events.
- Write tests for service rules.

## Practice Task
Create one extra endpoint for the Department module. Define the URL, HTTP method, request body, response body, validation rules, and service method name.

## Mermaid Diagram
```mermaid
flowchart TD
    UI[Frontend or Mobile App] --> Controller[Department Controller]
    Controller --> Validator[Request Validation]
    Validator --> Service[Department Service]
    Service --> Repository[Department Repository]
    Repository --> DB[(Departments)]
    Service --> Response[Response DTO]
    Response --> UI
```
