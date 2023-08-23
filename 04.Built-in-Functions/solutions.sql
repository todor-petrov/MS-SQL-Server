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

/*  */