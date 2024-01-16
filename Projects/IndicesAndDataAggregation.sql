--01. Records’ Count

--SELECT COUNT(*) AS [Count]
--  FROM WizzardDeposits


--02. Longest Magic Wand

--SELECT MAX(MagicWandSize) AS LongestMagicWand
--FROM WizzardDeposits


--03. Longest Magic Wand per Deposit Groups

--  SELECT DepositGroup
--		 ,MAX(MagicWandSize) AS LongestMagicWand
--	FROM WizzardDeposits
--GROUP BY DepositGroup

--04. Smallest Deposit Group Per Magic Wand Size

--SELECT TOP(2) a.DepositGroup
--  FROM (
--		  SELECT DepositGroup, AVG(MagicWandSize) AS AverageMagicWandSize
--		    FROM WizzardDeposits
--		GROUP BY DepositGroup
--		) AS a
--ORDER BY a.AverageMagicWandSize

--05. Deposits Sum

--  SELECT DepositGroup
--		 ,SUM(DepositAmount) AS TotalSum
--	FROM WizzardDeposits
--GROUP BY DepositGroup

--06. Deposits Sum for Ollivander Family

--  SELECT DepositGroup
--		 ,SUM(DepositAmount) AS TotalSum
--	FROM WizzardDeposits
--   WHERE MagicWandCreator = 'Ollivander family'
--GROUP BY DepositGroup, MagicWandCreator


--07. Deposits Filter

--  SELECT DepositGroup
--		 ,SUM(DepositAmount) AS TotalSum
--	FROM WizzardDeposits
--   WHERE MagicWandCreator = 'Ollivander family'
--GROUP BY DepositGroup
--  HAVING SUM(DepositAmount) < 150000
--ORDER BY TotalSum DESC


--08. Deposit Charge

--  SELECT DepositGroup
--		 ,MagicWandCreator
--		 ,MIN(DepositCharge) AS MinDepositCharge
--	FROM WizzardDeposits
--GROUP BY DepositGroup, MagicWandCreator
--ORDER BY MagicWandCreator, DepositGroup