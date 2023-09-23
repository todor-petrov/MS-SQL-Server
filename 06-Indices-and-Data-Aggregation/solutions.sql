-- 01. Records’ Count
SELECT COUNT(*) AS [Count]
  FROM WizzardDeposits

-- 2. Longest Magic Wand
SELECT MAX(MagicWandSize)
	AS LongestMagicWand
  FROM WizzardDeposits

-- 03. Longest Magic Wand per Deposit Groups
  SELECT DepositGroup
		 ,MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits
GROUP BY DepositGroup

-- 04. Smallest Deposit Group per Magic Wand Size
 SELECT TOP 2 DepositGroup
   FROM (
			SELECT DepositGroup
				   ,AVG(MagicWandSize) AS AvgMagicWand
			  FROM WizzardDeposits
		  GROUP BY DepositGroup
		  ) AS dp
ORDER BY dp.AvgMagicWand

-- 05. Deposits Sum
  SELECT DepositGroup
		 ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
GROUP BY DepositGroup

-- 06. Deposits Sum for Ollivander Family
  SELECT DepositGroup
		 ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
  HAVING MagicWandCreator = 'Ollivander family'

-- 07. Deposits Filter
  SELECT DepositGroup
		 ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
  HAVING MagicWandCreator = 'Ollivander family' AND SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- 08. Deposit Charge
  SELECT DepositGroup
		 ,MagicWandCreator
		 ,MIN(DepositCharge) AS MinDepositCharge
	FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- 09. Age Groups
  SELECT ag.AgeGroup
		 ,COUNT(*) AS WizzardCount
	FROM
		 (SELECT
				 CASE
					  WHEN Age Between 0  AND 10 THEN '[0-10]'
					  WHEN Age Between 11 AND 20 THEN '[11-20]'
					  WHEN Age Between 21 AND 30 THEN '[21-30]'
					  WHEN Age Between 31 AND 40 THEN '[31-40]'
					  WHEN Age Between 41 AND 50 THEN '[41-50]'
					  WHEN Age Between 51 AND 60 THEN '[51-60]'
				 ELSE '[61+]'
				  END AS AgeGroup
		  FROM WizzardDeposits
				  ) AS ag
GROUP BY ag.AgeGroup
	
-- 10. First Letter
  SELECT LEFT(FirstName, 1) AS FirstLetter
	FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)

-- 11. Average Interest
  SELECT DepositGroup
		 ,IsDepositExpired
		 ,AVG(DepositInterest) AS AverageInterest
	FROM WizzardDeposits
   WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- 12. *Rich Wizard, Poor Wizard
SELECT SUM(base.[Difference]) AS SumDifference
  FROM (
		   SELECT host.FirstName AS [Host Wizzard]
				  ,host.DepositAmount AS [Host Wizzard Deposit]
				  ,guest.FirstName AS [Guest Wizard]
				  ,guest.DepositAmount AS [Guest Wizard Deposit]
				  ,host.DepositAmount - guest.DepositAmount AS [Difference]
			 FROM WizzardDeposits AS host
		LEFT JOIN WizzardDeposits AS guest
			   ON host.Id + 1 = guest.Id) AS base

-- 13. Departments Total Salaries
  SELECT DepartmentID
		 ,SUM(Salary) AS TotalSalary
	FROM Employees
GROUP BY DepartmentID

-- 14. Employees Minimum Salaries
  SELECT DepartmentID, MIN(Salary) AS MinimumSalary
	FROM Employees
   WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID

-- 15. Employees Average Salaries
SELECT *
  INTO NewTable
  FROM Employees
 WHERE Salary > 30000

DELETE FROM NewTable
 WHERE ManagerID = 42

UPDATE NewTable
   SET Salary += 5000
 WHERE DepartmentID = 1

  SELECT DepartmentID
		 ,AVG(Salary) AS AverageSalary
	FROM NewTable
GROUP BY DepartmentID

-- 16. Employees Maximum Salaries
  SELECT DepartmentID
		 ,MAX(Salary) AS MaxSalary
	FROM Employees
GROUP BY DepartmentID
  HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries
SELECT COUNT(*) AS [Count]
  FROM Employees
 WHERE ManagerID IS NULL

-- 18. *3rd Highest Salary
  SELECT s.DepartmentID
		 ,s.ThirdHighestSalary
	FROM (
		  SELECT DepartmentID
				 ,Salary AS ThirdHighestSalary
				 ,DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS salary_rank
			FROM Employees) AS s
   WHERE s.salary_rank = 3
GROUP BY DepartmentID, ThirdHighestSalary