/*CREATE DATABASE NationalTouristSitesOfBulgaria
GO
USE NationalTouristSitesOfBulgaria*/

--01. Database design
/*
CREATE TABLE Categories (
						 Id	INT PRIMARY KEY IDENTITY,
						 [Name] VARCHAR(50) NOT NULL
						 )
CREATE TABLE Locations (
						Id INT PRIMARY KEY IDENTITY,
						[Name] VARCHAR(50) NOT NULL,
						Municipality VARCHAR(50),
						Province VARCHAR(50)
						)
CREATE TABLE Sites (
					Id INT PRIMARY KEY IDENTITY,
					[Name] VARCHAR(100) NOT NULL,
					LocationId INT FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
					CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
					Establishment VARCHAR(15)
					)

CREATE TABLE Tourists (
					   Id INT PRIMARY KEY IDENTITY,
					   [Name] VARCHAR(50) NOT NULL,
					   Age INT NOT NULL,
					   CHECK (Age BETWEEN 0 AND 120),
					   PhoneNumber VARCHAR(20) NOT NULL,
					   Nationality VARCHAR(30) NOT NULL,
					   Reward VARCHAR(20)
					   )
CREATE TABLE SitesTourists (
							TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
							SiteId INT FOREIGN KEY REFERENCES Sites NOT NULL,
							PRIMARY KEY(TouristId, SiteId)
							)
CREATE TABLE BonusPrizes (
						  Id INT PRIMARY KEY IDENTITY,
						  [Name] VARCHAR(50) NOT NULL
						  )
CREATE TABLE TouristsBonusPrizes (
								  TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
								  BonusPrizeId INT FOREIGN KEY REFERENCES BonusPrizes(Id) NOT NULL,
								  PRIMARY KEY(TouristId, BonusPrizeId)
								  )
*/

--02. Insert
/*
INSERT INTO Tourists ([Name], Age, PhoneNumber, Nationality, Reward)
	 VALUES
			('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
			('Peter Bosh', 48, '+447911844141', 'UK', NULL),
			('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
			('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
			('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)
INSERT INTO Sites ([Name], LocationId, CategoryId, Establishment)
	 VALUES ('Ustra fortress', 90, 7, 'X'),
			('Karlanovo Pyramids', 65, 7, NULL),
			('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
			('Sinite Kamani Natural Park', 17, 1, NULL),
			('St. Petka of Bulgaria – Rupite', 92, 6, '1994')
*/

--03. Update
/*
UPDATE Sites
   SET Establishment = '(not defined)'
 WHERE Establishment IS NULL
*/

--04. Delete
/*
DELETE FROM TouristsBonusPrizes
	  WHERE BonusPrizeId = (
							SELECT Id FROM BonusPrizes
							 WHERE [Name] = 'Sleeping bag'
							 )
DELETE FROM BonusPrizes
	  WHERE [Name] = 'Sleeping bag'
*/

--05. Tourists
/*
  SELECT [Name], Age, PhoneNumber, Nationality
	FROM Tourists
ORDER BY Nationality, Age DESC, [Name]
*/

--06. Sites with Their Location and Category
/*
   SELECT s.[Name] AS [Site],
		  l.[Name] AS [Location],
		  s.Establishment,
		  c.[Name] AS Category
	 FROM Sites AS s
LEFT JOIN Locations AS l
	   ON s.LocationId = l.Id
LEFT JOIN Categories AS c
	   ON s.CategoryId = c.Id
 ORDER BY Category DESC, [Location], [Site]
*/

--07. Count of Sites in Sofia Province
/*
	SELECT l.Province,
		   l.Municipality,
		   l.[Name] AS [Location],
		   COUNT(l.Id) AS CountOfSites
	  FROM Locations AS l
INNER JOIN Sites AS s
		ON l.Id = s.LocationId
  GROUP BY l.Province, l.Municipality, l.[Name]
	HAVING l.Province = 'Sofia'
  ORDER BY CountOfSites DESC, [Location]
*/

--08. Tourist Sites established BC
/*
   SELECT s.[Name] AS [Site],
		  l.[Name] AS [Location],
		  l.Municipality,
		  l.Province,
		  s.Establishment
	 FROM Sites AS s
LEFT JOIN Locations AS l
	   ON s.LocationId = l.Id
	WHERE LEFT(l.[Name], 1) NOT IN ('B', 'M', 'D') AND s.Establishment LIKE '%BC'
 ORDER BY [Site]
*/

--09. Tourists with their Bonus Prizes
/*
   SELECT t.[Name],
		  t.Age, 
		  t.PhoneNumber,
		  t.Nationality,
		  CASE WHEN bp.[Name] IS NULL THEN '(no bonus prize)' 
		  ELSE bp.[Name] END AS Reward
	 FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tbp
	   ON t.Id = tbp.TouristId
LEFT JOIN BonusPrizes AS bp
	   ON tbp.BonusPrizeId = bp.Id
 ORDER BY t.[Name]
*/

--10. Tourists visiting History & Archaeology sites
/*
	SELECT DISTINCT SUBSTRING(t.[Name],
                 CHARINDEX(' ', t.[Name]) + 1,
                 LEN(t.[Name]) - CHARINDEX(' ', t.[Name])) AS LastName,
		   t.Nationality,
		   t.Age, t.PhoneNumber
	  FROM Tourists AS t
INNER JOIN SitesTourists AS st
		ON t.Id = st.TouristId
INNER JOIN Sites AS s
		ON st.SiteId = s.Id
INNER JOIN Categories AS c
		ON s.CategoryId = c.Id
	 WHERE c.[Name] = 'History and archaeology'
  ORDER BY LastName
*/

--11. Tourists Count on a Tourist Site
/*
CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
BEGIN
RETURN (SELECT COUNT(st.TouristId)
		  FROM Sites AS s
	INNER JOIN SitesTourists AS st
			ON s.Id = st.SiteId
	  GROUP BY s.Id, s.[Name]
		HAVING s.[Name] = @Site)
END
*/

--12. Annual Reward Lottery
/*
CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50)) AS
BEGIN
	DECLARE @visitedSites INT = (
	 SELECT COUNT(st.SiteId)
	   FROM Tourists AS t
 INNER JOIN SitesTourists AS st
		 ON t.Id = st.TouristId
   GROUP BY t.[Name]
	 HAVING t.[Name] = @TouristName)
	 UPDATE Tourists
		SET Reward = CASE
				 WHEN @visitedSites >= 100 THEN 'Gold badge'
				 WHEN @visitedSites BETWEEN 50 AND 99 THEN 'Silver badge'
				 WHEN @visitedSites BETWEEN 25 AND 49 THEN 'Bronze badge'
				 END
	 WHERE [Name] = @TouristName
	SELECT @TouristName AS [Name], Reward FROM Tourists
	 WHERE [Name] = @TouristName
END
*/