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

/* 06. Employees Hired After */
   SELECT [e].[FirstName], [e].[LastName], [e].[HireDate], [d].[Name] AS [DeptName]
	 FROM Employees AS [e]
LEFT JOIN [Departments] AS [d]
	   ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE [e].[HireDate] > '1999-01-01' AND [d].[Name] IN ('Sales', 'Finance')
 ORDER BY [e].[HireDate]

/* 07. Employees With Project */
SELECT TOP (5) [e].[EmployeeID], [e].[FirstName], [p].[Name] AS ProjectName
      FROM Employees AS [e]
 LEFT JOIN [EmployeesProjects] as [ep]
	    ON [e].[EmployeeID] = [ep].[EmployeeID]
 LEFT JOIN [Projects] AS [p]
	    ON [ep].[ProjectID] = [p].[ProjectID]
	 WHERE [p].[StartDate] > '2002-08-13' AND [p].[EndDate] IS NULL
	 ORDER BY [e].[EmployeeID]

/* 08. Employee 24 */
SELECT [e].[EmployeeID], [e].[FirstName],
  CASE WHEN DATEPART(YEAR, p.StartDate) > '2004' THEN NULL
  ELSE [p].[Name]
   END AS [ProjectName]
  FROM Employees AS [e]
  LEFT JOIN [EmployeesProjects] AS [ep]
    ON [e].[EmployeeID] = [ep].[EmployeeID]
  LEFT JOIN [Projects] as [p]
    ON [ep].[ProjectID] = [p].[ProjectID]
 WHERE [e].[EmployeeID] = 24

/* 09. Employee Manager */
    SELECT [e].[EmployeeID],
		   [e].[FirstName],
		   [m].[EmployeeID] AS [ManagerID],
		   [m].[FirstName] AS [ManagerName]
	  FROM [Employees] AS [e]
INNER JOIN [Employees] AS [m]
		ON [e].[ManagerID] = [m].[EmployeeID]
	 WHERE [m].[EmployeeID] IN (3, 7)
  ORDER BY [e].[EmployeeID]

/* 10. Employees Summary */
	SELECT TOP (50) [e].[EmployeeID]
		   ,CONCAT([e].[FirstName], ' ', [e].[LastName]) AS [EmployeeName]
		   ,CONCAT([m].[FirstName], ' ', [m].[LastName]) AS [ManagerName]
		   ,[d].[Name] AS [DepartmentName]
	  FROM [Employees] AS [e]
INNER JOIN [Employees] AS [m]
		ON [e].[ManagerID] = [m].[EmployeeID]
 LEFT JOIN [Departments] AS [d]
		ON [e].[DepartmentID] = [d].[DepartmentID]

/* 12. Highest Peaks in Bulgaria */
	SELECT [mc].[CountryCode],
		   [m].[MountainRange],
		   [p].[PeakName],
		   [p].[Elevation]
	  FROM [Peaks] AS [p]
INNER JOIN [Mountains] AS [m]
		ON [p].[MountainId] = [m].[Id]
INNER JOIN [MountainsCountries] AS [mc]
		ON [m].[Id] = [mc].[MountainId]
	 WHERE [mc].[CountryCode] = 'BG' AND [p].[Elevation] > 2835
  ORDER BY [p].[Elevation] DESC

/* 13. Count Mountain Ranges */
    SELECT [c].[CountryCode],
	      COUNT([mc].[MountainId]) AS [MountainRanges]
     FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc]
	   ON [c].[CountryCode] = [mc].[CountryCode]
	WHERE [c].[CountryName] IN ('Bulgaria', 'Russia', 'United States')
 GROUP BY [c].[CountryCode]

/* 14. Countries With or Without Rivers */
   SELECT TOP (5) [c].[CountryName], [r].[RiverName]
	 FROM [Countries] AS [c]
LEFT JOIN [CountriesRivers] AS [cr]
	   ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS [r]
	   ON [cr].[RiverId] = [r].[Id]
LEFT JOIN [Continents] AS [cont]
	   ON [c].[ContinentCode] = [cont].[ContinentCode]
	WHERE [cont].[ContinentName] = 'Africa'
 ORDER BY [c].[CountryName]

/* 15. Continents and Currencies */
SELECT
    ContinentCode,
    CurrencyCode,
    CurrencyUsage
FROM (SELECT
          ContinentCode,
          CurrencyCode,
          DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(*) DESC) AS Ranking,
          COUNT(*) AS CurrencyUsage
      FROM Countries
      GROUP BY ContinentCode, CurrencyCode) AS RankedTable
WHERE Ranking = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode, CurrencyCode

/* 16. Countries Without any Mountains */
   SELECT COUNT([c].[CountryName]) AS [Count]
     FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc]
	   ON [c].[CountryCode] = [mc].[CountryCode]
LEFT JOIN [Mountains] AS [m]
	   ON [mc].[MountainId] = [m].[Id]
	WHERE [m].[MountainRange] IS NULL