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