--CREATE DATABASE Service
--GO
--USE Service

--1. Table design
/*
CREATE TABLE Users (Id INT PRIMARY KEY IDENTITY,
					Username VARCHAR(30) UNIQUE NOT NULL,
					[Password] VARCHAR(50) NOT NULL,
					[Name] VARCHAR(50),
					Birthdate DATETIME,
					Age INT,
					CHECK (Age BETWEEN 14 AND 110),
					Email VARCHAR(50) NOT NULL
					)
CREATE TABLE Departments (Id INT PRIMARY KEY IDENTITY,
						  [Name] VARCHAR(50) NOT NULL
						  )
CREATE TABLE Employees (Id INT PRIMARY KEY IDENTITY,
						FirstName VARCHAR(25),
						LastName VARCHAR(25),
						Birthdate DATETIME,
						Age INT,
						CHECK (Age BETWEEN 18 AND 110),
						DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
						)
CREATE TABLE Categories (Id INT PRIMARY KEY IDENTITY,
						 [Name] VARCHAR(50) NOT NULL,
						 DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
						 )
CREATE TABLE [Status] (Id INT PRIMARY KEY IDENTITY,
					   Label VARCHAR(30) NOT NULL
					   )
CREATE TABLE Reports (Id INT PRIMARY KEY IDENTITY,
					  CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
					  StatusId INT FOREIGN KEY REFERENCES [Status](Id) NOT NULL,
					  OpenDate DATETIME NOT NULL,
					  CloseDate DATETIME,
					  [Description] VARCHAR(200) NOT NULL,
					  UserId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
					  EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
					  )
*/

--02. Insert
/*
INSERT INTO Employees (FirstName, LastName, Birthdate, DepartmentId)
	 VALUES
			('Marlo', 'O''Malley', '1958-9-21', 1),
			('Niki', 'Stanaghan', '1969-11-26', 4),
			('Ayrton', 'Senna', '1960-03-21', 9),
			('Ronnie', 'Peterson', '1944-02-14', 9),
			('Giovanna', 'Amati', '1959-07-20', 5)
INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
	 VALUES 
			(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
			(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
			(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
			(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)
*/

--03. Update
/*
UPDATE Reports
   SET CloseDate = CURRENT_TIMESTAMP
 WHERE CloseDate IS NULL
*/

--04. Delete
/*
DELETE FROM child
FROM Reports AS child
INNER JOIN [Status] AS parent ON child.StatusId = parent.Id
WHERE parent.Id = 4

DELETE FROM parent
FROM [Status] AS parent
WHERE parent.Id = 4
*/

--05. Unassigned Reports
/*
  SELECT [Description], FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
	FROM Reports
   WHERE EmployeeId IS NULL
ORDER BY Reports.OpenDate, [Description]
*/

--06. Reports & Categories
/*
	SELECT r.[Description], c.[Name] AS CategoryName
	  FROM Reports AS r
INNER JOIN Categories AS c
		ON r.CategoryId = c.Id
  ORDER BY r.[Description], c.[Name]
*/

--07. Most Reported Category
/*
   SELECT TOP 5 c.[Name], COUNT(c.Id) AS ReportsNumber
	 FROM Categories AS c
LEFT JOIN Reports AS r
	   ON c.Id = r.CategoryId
 GROUP BY c.[Name]
 ORDER BY COUNT(c.Id) DESC, c.Name
*/

--08. Birthday Report
/*
   SELECT u.Username, c.[Name] AS CategoryName
	 FROM Reports AS r
LEFT JOIN Users AS u
	   ON r.UserId = u.Id
LEFT JOIN Categories AS c
	   ON r.CategoryId = c.Id
	WHERE FORMAT(r.OpenDate, 'dd/MM') = FORMAT(u.Birthdate, 'dd/MM')
 ORDER BY u.Username, c.[Name]
*/

--09. Users per Employee
/*
   SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, COUNT(DISTINCT u.Id) AS UsersCount
	 FROM Employees AS e
LEFT JOIN Reports AS r
	   ON e.Id = r.EmployeeId
LEFT JOIN Users AS u
	   ON r.UserId = u.Id
 GROUP BY CONCAT(e.FirstName, ' ', e.LastName)
 ORDER BY COUNT(u.Id) DESC, CONCAT(e.FirstName, ' ', e.LastName)
*/

--10. Full Info
/*
   SELECT ISNULL(e.FirstName + ' '  + e.LastName, 'None') AS Employee,
		  ISNULL(d.[Name], 'None') AS Department,
		  c.[Name] AS Category,
		  r.[Description],
		  FORMAT(r.OpenDate, 'dd.MM.yyyy') AS [OpenDate],
		  s.Label AS [Status],
		  u.[Name] AS [User]
	 FROM Reports AS r
LEFT JOIN Employees AS e
	   ON r.EmployeeId = e.Id
LEFT JOIN Categories AS c
	   ON r.CategoryId = c.Id
LEFT JOIN Departments AS d
	   ON e.DepartmentId = d.Id
LEFT JOIN Status AS s
	   ON r.StatusId = s.Id
LEFT JOIN Users AS u
	   ON r.UserId = u.Id
 ORDER BY e.FirstName DESC,
		  e.LastName DESC,
		  d.[Name],
		  c.[Name],
		  r.[Description],
		  r.OpenDate,
		  s.Label,
		  u.[Name]
*/

--11. Hours to Complete
/*
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
		RETURN ISNULL(DATEDIFF(HOUR, @StartDate, @EndDate), 0)
END
*/

--12. Assign Employee
/*
CREATE PROCEDURE usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
IF (
	SELECT DepartmentId
	  FROM Reports AS r
 LEFT JOIN Categories AS c
		ON r.CategoryId = c.Id
	 WHERE r.Id = @ReportId
	 ) = (
	SELECT DepartmentId
	  FROM Employees AS e
 LEFT JOIN Departments AS d
		ON e.DepartmentId = d.Id
	 WHERE e.Id = @EmployeeId
			)
	UPDATE Reports
	   SET EmployeeId = @EmployeeId
	 WHERE Id = @ReportId
ELSE
	THROW 60000, 'Employee doesn''t belong to the appropriate department!', 1
*/