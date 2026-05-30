# School Management Database — Bonus Project

Practice everything after the main course with a **SchoolDB** schema.

---

## ERD

```mermaid
erDiagram
    STUDENT ||--o{ ENROLLMENT : has
    COURSE ||--o{ ENROLLMENT : includes
    TEACHER ||--o{ COURSE : teaches
    STUDENT {
        int StudentId PK
        string StudentCode UK
        string FullName
    }
    TEACHER {
        int TeacherId PK
        string EmployeeCode UK
        string FullName
    }
    COURSE {
        int CourseId PK
        string CourseCode UK
        int TeacherId FK
    }
    ENROLLMENT {
        int EnrollmentId PK
        int StudentId FK
        int CourseId FK
        decimal Grade
    }
```

---

## Run

```text
sql/18-school-database.sql
```

---

## Your tasks

1. List students in course **CS101**
2. Average grade per course
3. Teachers with no courses (`LEFT JOIN`)
4. Add role `School_ReportReader` — SELECT only on views
5. Draw Level 0 DFD: Student, Registrar, School System

---

## Solutions (try first)

<details>
<summary>Show</summary>

```sql
-- Students in CS101
SELECT s.FullName, e.Grade
FROM school.Student s
JOIN school.Enrollment e ON e.StudentId = s.StudentId
JOIN school.Course c ON c.CourseId = e.CourseId
WHERE c.CourseCode = N'CS101';

-- Avg grade per course
SELECT c.CourseCode, AVG(e.Grade) AS AvgGrade
FROM school.Course c
JOIN school.Enrollment e ON e.CourseId = c.CourseId
GROUP BY c.CourseCode;
```

</details>
