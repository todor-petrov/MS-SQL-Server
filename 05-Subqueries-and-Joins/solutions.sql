/* 01. Employee Address */
   SELECT TOP (5) [e].[EmployeeID], [e].[JobTitle], [e].[AddressID], [a].[AddressText]
	 FROM [Employees] AS [e]
LEFT JOIN [Addresses] AS [a]
	   ON [e].[AddressID] = [a].[AddressID]
 ORDER BY [a].[AddressID]

/* 02. Addresses with Towns */
   SELECT TOP (50) [e].[FirstName], [e].[LastName], [t].[Name] AS Town, [a].[AddressText]
	 FROM [Employees] AS [e]
LEFT JOIN [Addresses] AS [a]
	   ON [e].[AddressID] = [a].[AddressID]
LEFT JOIN [Towns] as [t]
	   ON [a].[TownID] = [t].[TownID]
 ORDER BY [e].[FirstName], [e].[LastName]

/* 03. Sales Employees */
   SELECT [EmployeeID], [FirstName], [LastName], [d].[Name] AS DepartmentName
     FROM [Employees] AS [e]
LEFT JOIN [Departments] AS [d]
	   ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE [d].[Name] = 'Sales'
 ORDER BY [e].[EmployeeID]

/* 04. Employee Departments */
SELECT TOP (5) [EmployeeID], [FirstName], [Salary], [d].[Name] AS DepartmentName
	  FROM [Employees] AS [e]
INNER JOIN [Departments] AS [d]
		ON [e].[DepartmentID] = [d].[DepartmentID]
	 WHERE [e].[Salary] > 15000
  ORDER BY [d].[DepartmentID]

/* 05. Employees Without Projects */
SELECT TOP (3) [e].[EmployeeID], [e].[FirstName]
	  FROM Employees AS [e]
 LEFT JOIN [EmployeesProjects] AS [ep]
		ON [e].[EmployeeID] = [ep].EmployeeID
	 WHERE [ep].[EmployeeID] IS NULL
  ORDER BY [e].[EmployeeID]