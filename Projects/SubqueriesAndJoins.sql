--01. Employee Address

--  SELECT TOP 5
--		 e.EmployeeId
--		 ,e.JobTitle
--		 ,e.AddressId
--		 ,a.AddressText
--	FROM Employees AS e
--	JOIN Addresses AS a
--	  ON e.AddressID = a.AddressID
--ORDER BY e.AddressID


--02. Addresses with Towns

--  SELECT TOP 50
--		 e.FirstName
--		 ,e.LastName
--		 ,t.[Name]
--		 ,a.AddressText
--	FROM Employees AS e
--	JOIN Addresses AS a
--	  ON e.AddressID = a.AddressID
--	JOIN Towns AS t
--	  ON a.TownID = t.TownID
--ORDER BY e.FirstName, e.LastName


--03. Sales Employee

--  SELECT e.EmployeeID
--		 ,e.FirstName
--		 ,e.LastName
--		 ,d.[Name]
--	FROM Employees AS e
--	JOIN Departments AS d
--	  ON e.DepartmentID = d.DepartmentID
--   WHERE d.[Name] = (
--					 SELECT [Name]
--					   FROM Departments
--					  WHERE [Name] = 'Sales'
--					 )
--ORDER BY e.EmployeeID


--04. Employee Departments

--  SELECT TOP 5
--		 e.EmployeeID
--		 ,e.FirstName
--		 ,e.Salary
--		 ,d.[Name]
--	FROM Employees AS e
--	JOIN Departments AS d
--	  ON e.DepartmentID = d.DepartmentID
--   WHERE e.Salary > 15000
--ORDER BY e.DepartmentID


--05. Employees Without Project

--   SELECT TOP 3
--		  e.EmployeeID
--		  ,e.FirstName
--	 FROM Employees AS e
--LEFT JOIN EmployeesProjects AS ep
--	   ON e.EmployeeID = ep.EmployeeID
--LEFT JOIN Projects AS p
--	   ON ep.ProjectID = p.ProjectID
--	WHERE p.ProjectID IS NULL
-- ORDER BY e.EmployeeID


--06. Employees Hired After

--  SELECT e.FirstName
--		 ,e.LastName,
--		 e.HireDate,
--		 d.[Name]
--	FROM Employees AS e
--	JOIN Departments AS d
--	  ON e.DepartmentID = d.DepartmentID
--   WHERE d.[Name] IN ('Sales', 'Finance') AND e.HireDate > '1999-01-01'
--ORDER BY e.HireDate


--07. Employees with Project

--  SELECT TOP 5
--		 e.EmployeeID
--		 ,e.FirstName
--		 ,p.[Name]
--	FROM Employees AS e
--	JOIN EmployeesProjects AS ep
--	  ON e.EmployeeID = ep.EmployeeID
--	JOIN Projects AS p
--	  ON ep.ProjectID = p.ProjectID
--   WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
--ORDER BY e.EmployeeID


--08. Employee 24

--   SELECT e.EmployeeID
--		  ,e.FirstName
--		  ,CASE WHEN p.StartDate > '2005-01-01' THEN NULL
--				ELSE p.[Name]
--			END AS ProjectName
--	 FROM Projects AS p
--LEFT JOIN EmployeesProjects AS ep
--	   ON p.ProjectID = ep.ProjectID
--LEFT JOIN Employees AS e
--	   ON ep.EmployeeID = e.EmployeeID
--	WHERE e.EmployeeID = 24


--09. Employee Manager

--  SELECT e.EmployeeID
--		 ,e.FirstName
--		 ,e.ManagerID
--		 ,m.FirstName AS ManagerName
--	FROM Employees AS e
--	JOIN Employees AS m
--	  ON e.ManagerID = m.EmployeeID
--   WHERE e.ManagerID IN (3, 7)
--ORDER BY e.EmployeeID


--10. Employees Summary

--  SELECT TOP 50
--		 e.EmployeeID
--		 ,CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName
--		 ,CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
--		 ,d.[Name]
--	FROM Employees AS e
--	JOIN Employees AS m
--	  ON e.ManagerID = m.EmployeeID
--	JOIN Departments AS d
--	  ON e.DepartmentID = d.DepartmentID
--ORDER BY e.EmployeeID


--11. Min Average Salary

--  SELECT TOP 1 AVG(Salary) AS MinAverageSalary
--	FROM Employees
--GROUP BY DepartmentID
--ORDER BY MinAverageSalary


--12. Highest Peaks in Bulgaria

--  SELECT c.CountryCode
--		 ,m.MountainRange
--		 ,p.PeakName
--		 ,p.Elevation
--	FROM Countries AS c
--	JOIN MountainsCountries AS mc
--	  ON c.CountryCode = mc.CountryCode
--	JOIN Mountains AS m
--	  ON mc.MountainId = m.Id
--	JOIN Peaks AS p
--	  ON m.Id = p.MountainId
--   WHERE c.CountryName = 'Bulgaria' AND p.Elevation > 2835
--ORDER BY p.Elevation DESC


--13. Count Mountain Ranges

--  SELECT c.CountryCode
--		 ,COUNT(m.MountainRange) AS MountainRanges
--	FROM Countries AS c
--	JOIN MountainsCountries AS mc
--	  ON c.CountryCode = mc.CountryCode
--	JOIN Mountains AS m
--	  ON mc.MountainId = m.Id
--   WHERE c.CountryName IN ('United States', 'Russia', 'Bulgaria')
--GROUP BY c.CountryCode


--14. Countries With or Without Rivers

--   SELECT TOP 5
--		  c.CountryName
--		  ,r.RiverName
--	 FROM Countries AS c
--	 JOIN Continents AS cont
--	   ON c.ContinentCode = cont.ContinentCode 
--LEFT JOIN CountriesRivers AS cr
--	   ON c.CountryCode = cr.CountryCode
--LEFT JOIN Rivers AS r
--	   ON cr.RiverId = r.Id
--	WHERE cont.ContinentName = 'Africa'
-- ORDER BY c.CountryName


--15. *Continents and Currencies

--SELECT ContinentCode,CurrencyCode,Currency_Count as CurrencyUsage
--  FROM (
--		   SELECT ContinentCode
--			      ,CurrencyCode, COUNT(CurrencyCode) as Currency_Count
--			      ,DENSE_RANK() OVER( PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS rn
--		     FROM Countries 
--		 GROUP BY ContinentCode, CurrencyCode
--		 ) AS p
--   WHERE rn = 1 AND Currency_Count > 1
--ORDER BY ContinentCode


--16. Countries Without Any Mountains

--   SELECT COUNT(*) AS [Count]
--	 FROM Countries AS c
--LEFT JOIN MountainsCountries AS mc
--	   ON c.CountryCode = mc.CountryCode
--	WHERE mc.MountainId IS NULL


--17. Highest Peak and Longest River by Country

--SELECT TOP 5 * 
--  FROM (
--		   SELECT c.[CountryName]
--				  ,MAX(p.Elevation) AS HighestPeakElevation
--				  ,MAX(r.[Length]) AS LongestRiverLength
--			 FROM Countries AS c
--		LEFT JOIN MountainsCountries AS mc
--			   ON c.CountryCode = mc.CountryCode
--		LEFT JOIN Mountains AS m
--			   ON mc.MountainId = m.Id
--		LEFT JOIN Peaks AS p
--			   ON m.Id = p.MountainId
--		LEFT JOIN CountriesRivers AS cr
--			   ON c.CountryCode = cr.CountryCode
--		LEFT JOIN Rivers AS r
--			   ON cr.RiverId = r.Id
--		 GROUP BY c.CountryName) AS b
--ORDER BY b.HighestPeakElevation DESC, b.LongestRiverLength DESC, b.CountryName


--18. Highest Peak Name and Elevation by Country

--  SELECT *
--    FROM
--	     (
--		     SELECT TOP 5
--			        c.CountryName AS Country
--			        ,CASE WHEN p.PeakName IS NULL THEN '(no highest peak)'
--			        ELSE p.PeakName
--			        END AS [Highest Peak Name]
--			        ,CASE WHEN MAX(p.Elevation) IS NULL THEN '0'
--			        ELSE MAX(p.Elevation)
--			        END AS [Highest Peak Elevation]
--			        ,CASE WHEN m.MountainRange IS NULL THEN '(no mountain)'
--			        ELSE m.MountainRange
--			        END AS Mountain
--		       FROM Countries AS c
--	      LEFT JOIN MountainsCountries AS mc
--			     ON c.CountryCode = mc.CountryCode
--	      LEFT JOIN Mountains AS m
--			     ON mc.MountainId = m.Id
--	      LEFT JOIN Peaks AS p
--			     ON m.Id = p.MountainId
--	       GROUP BY c.CountryName, p.PeakName, m.MountainRange
--		 ) AS a
--ORDER BY a.Country, a.[Highest Peak Name]