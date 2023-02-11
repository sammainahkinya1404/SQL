1.
SELECT Fname, Minit, Lname
FROM EMPLOYEE
WHERE Ssn NOT IN (SELECT Essn FROM DEPENDENT);


2.
SELECT Fname, Minit, Lname
FROM EMPLOYEE
WHERE Ssn IN (SELECT Mgr_ssn FROM DEPARTMENT);


3.
SELECT Fname, Minit, Lname
FROM EMPLOYEE
WHERE Ssn IN (
  SELECT Essn
  FROM DEPENDENT
  WHERE Relationship = 'Spouse'
  GROUP BY Essn
  HAVING COUNT(Dependent_name) > 1
);

4.
SELECT DISTINCT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
JOIN PROJECT P ON W.Pno = P.Pnumber
WHERE (P.Pname = 'Computerization' OR P.Pname = 'Reorganization') AND W.Hours > 20;

5.
WITH AllProjects AS (
  SELECT Pno
  FROM PROJECT
),
AllEmployees AS (
  SELECT DISTINCT Essn
  FROM WORKS_ON
),
EmployeesInAllProjects AS (
  SELECT Essn
  FROM AllEmployees
  WHERE NOT EXISTS (
    SELECT 1
    FROM AllProjects
    WHERE NOT EXISTS (
      SELECT 1
      FROM WORKS_ON
      WHERE Essn = AllEmployees.Essn AND Pno = AllProjects.Pno
    )
  )
)
SELECT Fname, Minit, Lname
FROM EMPLOYEE
WHERE Ssn IN (SELECT Essn FROM EmployeesInAllProjects);

6.
WITH HoustonProjects AS (
  SELECT Essn
  FROM WORKS_ON W
  JOIN PROJECT P ON W.Pno = P.Pnumber
  WHERE P.Plocation = 'Houston'
),
StaffordProjects AS (
  SELECT Essn
  FROM WORKS_ON W
  JOIN PROJECT P ON W.Pno = P.Pnumber
  WHERE P.Plocation = 'Stafford'
)
SELECT E.Fname, E.Minit, E.Lname, M.Fname || ' ' || M.Minit || ' ' || M.Lname AS Manager
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
JOIN EMPLOYEE M ON D.Mgr_ssn = M.Ssn
WHERE E.Ssn IN (SELECT Essn FROM HoustonProjects)
AND E.


