-- 01. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
		 AS
	  BEGIN
			 SELECT FirstName
					,LastName
			   FROM Employees
			  WHERE Salary > 35000
	    END

EXEC dbo.usp_GetEmployeesSalaryAbove35000


-- 02. Employees with Salary Above Number
GO
CREATE PROC usp_GetEmployeesSalaryAboveNumber (@Number DECIMAL(18, 4))
		 AS
	  BEGIN
			SELECT FirstName,LastName
			  FROM Employees
			 WHERE Salary >= @Number
		END

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100


-- 03. Town Names Starting With
GO
CREATE PROC usp_GetTownsStartingWith @String VARCHAR(10)
		 AS
	  BEGIN
			SELECT [Name] AS Town
			  FROM Towns
			 WHERE LOWER([Name]) LIKE CONCAT(@String, '%')
		END

EXEC dbo.usp_GetTownsStartingWith 'b'


-- 04. Employees from Town
GO
CREATE PROC usp_GetEmployeesFromTown @Town VARCHAR(50)
		 AS
	  BEGIN
			SELECT e.FirstName
				   ,e.LastName
			  FROM Addresses AS a
			  JOIN Employees AS e
			    ON a.AddressID = e.AddressID
			  JOIN Towns AS t
			    ON a.TownID = t.TownID
			 WHERE t.[Name] = @Town
		END

EXEC dbo.usp_GetEmployeesFromTown 'Sofia'


-- 05. Salary Level Function
GO
CREATE FUNCTION ufn_GetSalaryLevel (@salary DECIMAL(18,4))
		RETURNS VARCHAR(8)
			 AS
		  BEGIN
				DECLARE @salary_range VARCHAR(8)
				SET @salary_range = 'Average'
				IF @salary < 30000 SET @salary_range = 'Low'
				ELSE IF @salary > 50000 SET @salary_range = 'High'
		 RETURN @salary_range
			END
GO

SELECT dbo.ufn_GetSalaryLevel(13500)


-- 06. Employees by Salary Level
GO
CREATE PROC usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(10)
		 AS
	  BEGIN
			SELECT FirstName
				   ,LastName
			  FROM Employees
			 WHERE dbo.ufn_GetSalaryLevel (Salary) = @salaryLevel
	    END

EXEC dbo.usp_EmployeesBySalaryLevel 'High'


-- 07. Define Function
GO
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
    RETURNS BIT
             AS
          BEGIN
                DECLARE @wordIndex INT = 1;
                WHILE (@wordIndex <= LEN(@word))
                BEGIN
                      DECLARE @currentCharacter CHAR = SUBSTRING(@word, @wordIndex, 1);
                      IF CHARINDEX(@currentCharacter, @setOfLetters) = 0
                      BEGIN
							RETURN 0;
                      END
                            SET @wordIndex += 1;
                END
                    RETURN 1;
            END
GO
SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'h!alves')


-- 08. Delete Employees and Departments
GO
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT
              AS
           BEGIN
                 DECLARE @employeesToDelete TABLE ([Id] INT);            
                 INSERT INTO @employeesToDelete
                        SELECT [EmployeeID] 
                          FROM [Employees]
                         WHERE [DepartmentID] = @departmentId
 
                  DELETE FROM [EmployeesProjects]
                   WHERE [EmployeeID] IN (
                                          SELECT * 
                                            FROM @employeesToDelete
                                           )

                  ALTER TABLE [Departments]
                  ALTER COLUMN [ManagerID] INT
                    
                  UPDATE [Departments]
                     SET [ManagerID] = NULL
                   WHERE [ManagerID] IN (
                                         SELECT *
                                           FROM @employeesToDelete
                                          )

                   UPDATE [Employees]
                      SET [ManagerID] = NULL
                    WHERE [ManagerID] IN (
                                           SELECT *
                                             FROM @employeesToDelete
                                          )
 
                   DELETE
                     FROM [Employees]
                    WHERE [DepartmentID] = @departmentId
 
                   DELETE 
                     FROM [Departments]
                    WHERE [DepartmentID] = @departmentId
 
                   SELECT COUNT(*)
                     FROM [Employees]
                    WHERE [DepartmentID] = @departmentId
             END
GO
 
EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 7


-- 09. Find Full Name
GO
CREATE PROC usp_GetHoldersFullName
	AS
 BEGIN
	   SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
	   FROM AccountHolders
   END

EXEC dbo.usp_GetHoldersFullName


-- 10. People with Balance Higher Than
GO
CREATE PROC usp_GetHoldersWithBalanceHigherThan @amount MONEY
	AS
 BEGIN
		SELECT ah.FirstName
			   ,ah.LastName
		  FROM AccountHolders AS ah
	 LEFT JOIN Accounts AS a
			ON ah.Id = a.AccountHolderId
	  GROUP BY FirstName, LastName
	    HAVING SUM(a.Balance) > @amount
	  ORDER BY ah.FirstName, ah.LastName
  END

 EXEC dbo.usp_GetHoldersWithBalanceHigherThan 20000


-- 11. Future Value Function
GO
CREATE or alter FUNCTION ufn_CalculateFutureValue (@sum MONEY, @yearlyInterestRate FLOAT, @numberOfYears INT)
		RETURNS DECIMAL(15, 4)
			 AS
		  BEGIN
				DECLARE @futureValue DECIMAL(15, 4)
				SET @futureValue = @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)
				RETURN @futureValue
			END
GO

SELECT dbo.ufn_CalculateFutureValue (1000, 0.1, 5)


-- 12. Calculating Interest
--CREATE PROC usp_CalculateFutureValueForAccount 
GO
CREATE PROC usp_CalculateFutureValueForAccount @AccountId INT, @interestRate FLOAT
	AS
 BEGIN
	   SELECT a.Id AS [Account Id]
			  ,ah.FirstName AS [First Name]
			  ,ah.LastName AS [Last Name]
			  ,a.Balance AS [Current Balance]
			  ,dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) AS [Balance in 5 years]
		 FROM AccountHolders AS ah
		 JOIN Accounts AS a ON ah.Id = a.AccountHolderId
		WHERE a.Id = @AccountId
  END

EXEC dbo.usp_CalculateFutureValueForAccount 2, 0.1


-- 13. *Scalar Function: Cash in User Games Odd Rows
GO
CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))
  RETURNS TABLE
             AS
         RETURN
                (
                    SELECT SUM([Cash])
                        AS [SumCash]
                      FROM (
                                SELECT [g].[Name],
                                       [ug].[Cash],
                                       ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)
                                    AS [RowNumber]
                                  FROM [UsersGames]
                                    AS [ug]
                            INNER JOIN [Games]
                                    AS [g]
                                    ON [ug].[GameId] = [g].[Id]
                                 WHERE [g].[Name] = @gameName
                           ) 
                        AS [RankingSubQuery]
                     WHERE [RowNumber] % 2 <> 0
                )

GO
 
SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')
DROP DATABASE SoftUni