/* 01. Find Names of All Employees by First Name */
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE LEFT([FirstName], 2) = 'Sa'

/* 02. Find Names of All Employees by Last Name */
SELECT [FirstName], [LastName]
  FROM Employees
 WHERE [LastName] LIKE '%ei%'

/* 03. Find First Names of All Employees */
SELECT [FirstName]
  FROM Employees
 WHERE [DepartmentID] IN (3, 10) AND DATEPART(YEAR, [HireDate]) BETWEEN 1995 AND 2005

/* 04. Find All Employees Except Engineers */
SELECT [FirstName], [LastName]
  FROM Employees
 WHERE [JobTitle] NOT LIKE '%engineer%'

/* 05. Find Towns with Name Length */
  SELECT [Name]
    FROM Towns
   WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name]

/* 06. Find Towns Starting With */
  SELECT *
    FROM [Towns]
   WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

/* 07. Find Towns Not Starting With */
  SELECT *
    FROM [Towns]
   WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

/* 08. Create View Employees Hired After 2000 Year */
CREATE VIEW [V_EmployeesHiredAfter2000] AS
	 SELECT [FirstName], [LastName]
	   FROM [Employees]
	  WHERE DATEPART(YEAR, [HireDate]) > 2000

/* 09. Length of Last Name */
SELECT [FirstName], [LastName]
  FROM [Employees]
 WHERE LEN(LastName) = 5

/* 10. Rank Employees by Salary */
  SELECT [EmployeeID], [FirstName], [LastName], [Salary],
	     DENSE_RANK() OVER (PARTITION BY [Salary] ORDER BY [EmployeeID])
    FROM [Employees]
   WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

/* 11. Find All Employees with Rank 2 */
SELECT *
   FROM (
		  SELECT [EmployeeID], [FirstName], [LastName], [Salary],
				 DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])
			  AS [Rank]
			FROM [Employees]
		   WHERE [Salary] BETWEEN 10000 AND 50000
	     )
	  AS [RankingSubquery]
   WHERE [Rank] = 2
ORDER BY [Salary] DESC

/* 12. Countries Holding 'A' 3 or More Times */
  SELECT [CountryName], [IsoCode]
    FROM [Countries]
   WHERE LOWER([CountryName]) LIKE '%a%a%a%'
ORDER BY [IsoCode]

/* 12. Countries Holding 'A' 3 or More Times */
  SELECT [CountryName], [IsoCode]
    FROM [Countries]
   WHERE LOWER([CountryName]) LIKE '%a%a%a%'
ORDER BY [IsoCode]

/* 13. Mix of Peak and River Names */
  SELECT [p].[PeakName], [r].[RiverName],
	     LOWER(CONCAT(LEFT([p].[PeakName], LEN([p].[PeakName]) - 1), [r].[RiverName]))
	  AS [Mix]
    FROM [Rivers] AS [r],
	     [Peaks] AS [p]
   WHERE RIGHT([p].[PeakName], 1) = LEFT([r].[RiverName], 1)
ORDER BY [Mix]

/* 14. Games From 2011 and 2012 Year */
  SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
	FROM [Games]
   WHERE DATEPART(YEAR, [Start]) BETWEEN '2011' AND '2012'
ORDER BY [Start], [Name]

/* 15. User Email Providers */
  SELECT [Username],
	     SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]))
	  AS [Email Provider]
    FROM [Users]
ORDER BY [Email Provider], [Username]