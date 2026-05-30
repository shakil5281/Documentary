/*
================================================================================
 18 - SCHOOL MANAGEMENT DATABASE (BONUS PROJECT)
 Post-course practice: ERD, JOINs, aggregates, procedures
================================================================================
*/

USE master;
GO

IF DB_ID(N'SchoolDB') IS NOT NULL
BEGIN
    ALTER DATABASE SchoolDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SchoolDB;
END
GO

CREATE DATABASE SchoolDB;
GO

USE SchoolDB;
GO

CREATE SCHEMA school AUTHORIZATION dbo;
GO

CREATE TABLE school.Teacher (
    TeacherId      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    EmployeeCode   NVARCHAR(20)      NOT NULL UNIQUE,
    FullName       NVARCHAR(200)     NOT NULL,
    Department     NVARCHAR(100)     NOT NULL
);

CREATE TABLE school.Student (
    StudentId      INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StudentCode    NVARCHAR(20)      NOT NULL UNIQUE,
    FullName       NVARCHAR(200)     NOT NULL,
    EnrollDate     DATE              NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);

CREATE TABLE school.Course (
    CourseId       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CourseCode     NVARCHAR(20)      NOT NULL UNIQUE,
    Title          NVARCHAR(200)     NOT NULL,
    Credits        TINYINT           NOT NULL,
    TeacherId      INT               NOT NULL REFERENCES school.Teacher(TeacherId)
);

CREATE TABLE school.Enrollment (
    EnrollmentId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StudentId      INT               NOT NULL REFERENCES school.Student(StudentId),
    CourseId       INT               NOT NULL REFERENCES school.Course(CourseId),
    Semester       NVARCHAR(20)      NOT NULL,
    Grade          DECIMAL(5,2)      NULL,
    CONSTRAINT UQ_Enrollment UNIQUE (StudentId, CourseId, Semester),
    CONSTRAINT CK_Enrollment_Grade CHECK (Grade IS NULL OR (Grade >= 0 AND Grade <= 100))
);

CREATE NONCLUSTERED INDEX IX_Enrollment_CourseId ON school.Enrollment (CourseId) INCLUDE (Grade, StudentId);
GO

INSERT INTO school.Teacher (EmployeeCode, FullName, Department)
VALUES (N'T-01', N'Fatima Rahman', N'Computer Science'), (N'T-02', N'James Park', N'Mathematics');

INSERT INTO school.Student (StudentCode, FullName, EnrollDate)
VALUES
    (N'S-1001', N'Arif Hossain', '2024-09-01'),
    (N'S-1002', N'Nadia Islam', '2024-09-01'),
    (N'S-1003', N'Imran Khan', '2025-01-10');

INSERT INTO school.Course (CourseCode, Title, Credits, TeacherId)
VALUES
    (N'CS101', N'Introduction to SQL', 3, 1),
    (N'MA201', N'Calculus II', 4, 2),
    (N'CS201', N'Database Design', 3, 1);

INSERT INTO school.Enrollment (StudentId, CourseId, Semester, Grade)
VALUES
    (1, 1, N'2025-Spring', 88.5),
    (1, 3, N'2025-Spring', 92.0),
    (2, 1, N'2025-Spring', 95.0),
    (2, 2, N'2025-Spring', 87.0),
    (3, 1, N'2025-Fall', NULL);
GO

CREATE OR ALTER VIEW school.vw_StudentTranscript
AS
SELECT
    s.StudentCode,
    s.FullName AS StudentName,
    c.CourseCode,
    c.Title AS CourseTitle,
    e.Semester,
    e.Grade,
    t.FullName AS TeacherName
FROM school.Enrollment e
JOIN school.Student s ON s.StudentId = e.StudentId
JOIN school.Course c ON c.CourseId = e.CourseId
JOIN school.Teacher t ON t.TeacherId = c.TeacherId;
GO

CREATE OR ALTER PROCEDURE school.usp_EnrollStudent
    @StudentCode NVARCHAR(20),
    @CourseCode  NVARCHAR(20),
    @Semester    NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Sid INT, @Cid INT;

    SELECT @Sid = StudentId FROM school.Student WHERE StudentCode = @StudentCode;
    SELECT @Cid = CourseId FROM school.Course WHERE CourseCode = @CourseCode;

    IF @Sid IS NULL OR @Cid IS NULL
        THROW 53000, N'Invalid student or course code.', 1;

    INSERT INTO school.Enrollment (StudentId, CourseId, Semester, Grade)
    VALUES (@Sid, @Cid, @Semester, NULL);
END;
GO

-- Demo queries
SELECT * FROM school.vw_StudentTranscript ORDER BY StudentName, CourseCode;

SELECT c.CourseCode, AVG(e.Grade) AS AvgGrade, COUNT(*) AS StudentCount
FROM school.Course c
JOIN school.Enrollment e ON e.CourseId = c.CourseId
WHERE e.Grade IS NOT NULL
GROUP BY c.CourseCode;

EXEC school.usp_EnrollStudent @StudentCode = N'S-1003', @CourseCode = N'MA201', @Semester = N'2025-Fall';

PRINT N'SchoolDB ready. See docs/15-school-project.md for exercises.';
GO
