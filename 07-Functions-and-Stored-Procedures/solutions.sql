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
CREATE PROC usp_GetEmployeesFromTown @Town VARCHAR(100)
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