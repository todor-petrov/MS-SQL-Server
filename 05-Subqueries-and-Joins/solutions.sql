-- 01. Employee Address
  SELECT TOP 5
		 e.EmployeeID
		 ,e.JobTitle
		 ,e.AddressID
		 ,a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	  ON e.AddressID = a.AddressID
ORDER BY a.AddressID

-- 02. Addresses with Towns
  SELECT TOP 50
		 e.FirstName
		 ,e.LastName
		 ,t.[Name]
		 ,a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	  ON e.AddressID = a.AddressID
	JOIN Towns AS t
	  ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

-- 03. Sales Employees
  SELECT e.EmployeeID
		 ,e.FirstName
		 ,e.LastName
		 ,d.[Name] AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	  ON e.DepartmentID = d.DepartmentID
   WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

-- 04. Employee Departments
  SELECT TOP 5
		 e.EmployeeID
		 ,e.FirstName
		 ,e.Salary
		 ,d.[Name]
	FROM Employees AS e
	JOIN Departments AS d
	  ON e.DepartmentID = d.DepartmentID
   WHERE e.Salary > 15000
ORDER BY d.DepartmentID

-- 05. Employees Without Projects
   SELECT TOP 3
		  e.EmployeeID
		  ,e.FirstName
	 FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
	   ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p
	   ON ep.ProjectID = p.ProjectID
	WHERE p.ProjectID IS NULL
 ORDER BY e.EmployeeID

-- 06. Employees Hired After
  SELECT e.FirstName
		 ,e.LastName
		 ,e.HireDate
		 ,d.[Name]
	FROM Employees AS e
	JOIN Departments AS d
	  ON e.DepartmentID = d.DepartmentID
   WHERE e.HireDate > '1999-01-01' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate

-- 07. Employees With Project
   SELECT TOP 5
		  e.EmployeeID
		  ,e.FirstName
		  ,p.[Name]
	 FROM Employees AS e
LEFT JOIN Departments AS d
	   ON e.DepartmentID = d.DepartmentID
LEFT JOIN EmployeesProjects AS ep
	   ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p
	   ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
 ORDER BY e.EmployeeID

-- 08. Employee 24
   SELECT e.EmployeeID
		  ,e.FirstName
		  ,CASE
				WHEN YEAR(p.StartDate) >= 2005 THEN NULL
				ELSE p.[Name]
		  END AS ProjectName
	 FROM Employees AS e
LEFT JOIN Departments AS d
	   ON e.DepartmentID = d.DepartmentID
LEFT JOIN EmployeesProjects AS ep
	   ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p
	   ON ep.ProjectID = p.ProjectID
	WHERE e.EmployeeID = 24

-- 09. Employee Manager
  SELECT e.EmployeeID
		 ,e.FirstName
		 ,e.ManagerID
		 ,m.FirstName AS ManagerName
	FROM Employees AS e
	JOIN Employees AS m
	  ON m.EmployeeID = e.ManagerID
   WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

-- 10. Employees Summary
  SELECT TOP 50
		 e.EmployeeID
		 ,CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName
		 ,CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
		 ,d.[Name] AS DepartmentName
	FROM Employees AS e
	JOIN Employees AS m
	  ON m.EmployeeID = e.ManagerID
	JOIN Departments AS d
	  ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- 11. Min Average Salary
   SELECT TOP 1
		  AVG(e.Salary) AS MinAverageSalary
	 FROM Employees AS e
LEFT JOIN Departments AS d
	   ON e.DepartmentID = d.DepartmentID
 GROUP BY d.[Name]
 ORDER BY AVG(e.Salary)

-- 12. Highest Peaks in Bulgaria
  SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
	FROM Countries AS c
	JOIN MountainsCountries AS mc
	  ON c.CountryCode = mc.CountryCode
	JOIN Mountains AS m
	  ON mc.MountainId = m.Id
	JOIN Peaks AS p
	  ON m.Id = p.MountainId
   WHERE c.CountryName = 'Bulgaria' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- 13. Count Mountain Ranges
  SELECT c.CountryCode
		 ,COUNT(m.MountainRange) AS MountainRanges
	FROM Countries AS c
	JOIN MountainsCountries AS mc
	  ON c.CountryCode = mc.CountryCode
	JOIN Mountains AS m
	  ON mc.MountainId = m.Id
   WHERE c.CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode

-- 14. Countries With or Without Rivers
   SELECT TOP 5
		  c.CountryName
		  ,r.RiverName
	 FROM Countries AS c
LEFT JOIN Continents AS cont
	   ON c.ContinentCode = cont.ContinentCode
LEFT JOIN CountriesRivers AS cr
	   ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
	   ON cr.RiverId = r.Id
	WHERE cont.ContinentName = 'Africa'
 ORDER BY c.CountryName

-- 15. Continents and Currencies
  SELECT ContinentCode
		 ,CurrencyCode
		 ,CurrencyUsage
	FROM (
		 SELECT ContinentCode
		 ,CurrencyCode
		 ,DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(*) DESC) AS Ranking
		 ,COUNT(*) AS CurrencyUsage
		 FROM Countries
		 GROUP BY ContinentCode, CurrencyCode
		 ) AS RankedTable
   WHERE Ranking = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode, CurrencyCode

-- 16. Countries Without Any Mountains
   SELECT COUNT(*) AS [Count]
	 FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
	   ON c.CountryCode = mc.CountryCode
	WHERE mc.MountainId IS NULL

-- 17. Highest Peak and Longest River by Country
   SELECT TOP 5
		  c.CountryName
		  ,MAX(p.Elevation) AS HighestPeakElevation
		  ,MAX(r.[Length]) AS LongestRiverLength
	 FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
	   ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
	   ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
	   ON m.Id = p.MountainId
LEFT JOIN CountriesRivers AS cr
	   ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
	   ON cr.RiverId = r.Id
 GROUP BY c.CountryName
 ORDER BY HighestPeakElevation DESC
		  ,LongestRiverLength DESC
		  ,c.CountryName

-- 18. Highest Peak Name and Elevation by Country - I
  SELECT 
		  result.CountryName AS Country
	     ,ISNULL(result.PeakName, '(no highest peak)') AS [Highest Peak Name]
	     ,ISNULL(result.Elevation, '0') AS [Highest Peak Elevation]
	     ,ISNULL(result.MountainRange, '(no mountain)') AS Mountain
	FROM (
		    SELECT c.CountryName
			       ,p.PeakName
			       ,p.Elevation
			       ,DENSE_RANK() OVER (
								       PARTITION BY c.CountryName
								       ORDER BY p.Elevation DESC
								       ) AS elevation_rank
			       ,m.MountainRange
		      FROM Countries AS c
	     LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	     LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	     LEFT JOIN Peaks AS p ON m.Id = p.MountainId
	     ) AS result
   WHERE elevation_rank = 1
ORDER BY result.CountryName, result.PeakName


-- 18. Highest Peak Name and Elevation by Country - II
;WITH result AS (
		    SELECT c.CountryName
			       ,p.PeakName
			       ,p.Elevation
			       ,DENSE_RANK() OVER (
								       PARTITION BY c.CountryName
								       ORDER BY p.Elevation DESC
								       ) AS elevation_rank
			       ,m.MountainRange
		      FROM Countries AS c
	     LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	     LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	     LEFT JOIN Peaks AS p ON m.Id = p.MountainId
	     )
  SELECT 
		  CountryName AS Country
	     ,ISNULL(PeakName, '(no highest peak)') AS [Highest Peak Name]
	     ,ISNULL(Elevation, '0') AS [Highest Peak Elevation]
	     ,ISNULL(MountainRange, '(no mountain)') AS Mountain
	FROM result
   WHERE elevation_rank = 1
ORDER BY result.CountryName, result.PeakName