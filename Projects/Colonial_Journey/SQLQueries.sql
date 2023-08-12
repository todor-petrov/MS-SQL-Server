--CREATE DATABASE ColonialJourney
--GO
--USE ColonialJourney

--01. DDL
/*
CREATE TABLE Planets (
					  Id INT PRIMARY KEY IDENTITY,
					  [Name] VARCHAR(30) NOT NULL
					  )
CREATE TABLE Spaceports (
						 Id INT PRIMARY KEY IDENTITY,
						 [Name] VARCHAR(50) NOT NULL,
						 PlanetId INT FOREIGN KEY REFERENCES Planets(Id) NOT NULL

						 )
CREATE TABLE Spaceships (
						 Id INT PRIMARY KEY IDENTITY,
						 [Name] VARCHAR(50) NOT NULL,
						 Manufacturer VARCHAR(30) NOT NULL,
						 LightSpeedRate INT DEFAULT 0
						 )
CREATE TABLE Colonists (
						Id INT PRIMARY KEY IDENTITY,
						FirstName VARCHAR(20) NOT NULL,
						LastName VARCHAR(20) NOT NULL,
						Ucn VARCHAR(10) UNIQUE NOT NULL,
						BirthDate DATE NOT NULL
						)
CREATE TABLE Journeys (
					   Id INT PRIMARY KEY IDENTITY,
					   JourneyStart DATETIME NOT NULL,
					   JourneyEnd DATETIME NOT NULL,
					   Purpose VARCHAR(11),
					   CHECK (Purpose IN ('Medical', 'Technical', 'Educational', 'Military')),
					   DestinationSpaceportId INT FOREIGN KEY REFERENCES Spaceports(Id) NOT NULL,
					   SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id)
					   )
CREATE TABLE TravelCards (
						  Id INT PRIMARY KEY IDENTITY,
						  CardNumber VARCHAR(10) NOT NULL,
						  CHECK (LEN(CardNumber) = 10),
						  JobDuringJourney VARCHAR(8),
						  CHECK (JobDuringJourney IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
						  ColonistId INT FOREIGN KEY REFERENCES Colonists(Id) NOT NULL,
						  JourneyId INT FOREIGN KEY REFERENCES Journeys(Id) NOT NULL
						  )
*/

--02.Insert
/*
INSERT INTO Planets ([Name])
	 VALUES ('Mars'), ('Earth'), ('Jupiter'), ('Saturn')

INSERT INTO Spaceships ([Name], Manufacturer, LightSpeedRate)
	  VALUES ('Golf', 'VW', 3),
			 ('WakaWaka', 'Wakanda', 4),
			 ('Falcon9', 'SpaceX', 1),
			 ('Bed', 'Vidolov', 6)
*/

--03. Update
/*
UPDATE Spaceships
   SET LightSpeedRate = LightSpeedRate + 1
 WHERE Id BETWEEN 8 AND 12
*/

--04. Delete
/*
DELETE FROM TravelCards WHERE JourneyId BETWEEN 1 AND 3
DELETE FROM Journeys WHERE Id BETWEEN 1 AND 3
*/

--05. Select All Military Journeys
/*
  SELECT Id,
		 FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart,
		 FORMAT(JourneyEnd, 'dd/MM/yyyy') as JourneyEnd
	FROM Journeys
   WHERE Purpose = 'Military'
ORDER BY JourneyStart
*/

--06. Select All Pilots
/*
   SELECT c.Id, CONCAT(FirstName, ' ', LastName) AS full_name
	 FROM Colonists AS c
LEFT JOIN TravelCards AS tc
	   ON c.Id = tc.ColonistId
	WHERE tc.JobDuringJourney = 'Pilot'
 ORDER BY Id
*/

--07. Count Colonists
/*
   SELECT COUNT(*) AS [count]
	 FROM Colonists AS c
LEFT JOIN TravelCards AS tc
	   ON c.Id = tc.ColonistId
LEFT JOIN Journeys AS J
	   ON tc.JourneyId = J.Id
	WHERE j.Purpose = 'Technical'
*/

--08. Select Spaceships With Pilots
/*
	SELECT s.[Name], s.Manufacturer
	  FROM Spaceships AS s
INNER JOIN Journeys AS j
		ON s.Id = j.SpaceshipId
INNER JOIN TravelCards AS tc
		ON j.Id = tc.JourneyId
INNER JOIN Colonists AS c
		ON tc.ColonistId = c.Id
	 WHERE FORMAT(c.BirthDate, 'yyyy-MM-dd')  > '1989/01/01'
		   AND tc.JobDuringJourney = 'Pilot'
  ORDER BY s.[Name]
*/

--09. Select all planets and their journey count
/*
	SELECT p.[Name], COUNT(p.Id) AS JourneysCount
	  FROM Planets AS p
INNER JOIN Spaceports AS s
		ON p.Id = s.PlanetId
INNER JOIN Journeys AS j
		ON s.Id = j.DestinationSpaceportId
  GROUP BY p.[Name]
  ORDER BY COUNT(p.Id) DESC, p.[Name]
*/

--10. Select Second Oldest Important Colonist
/*
  SELECT k.JobDuringJourney, c.FirstName + ' ' + c.LastName AS FullName, k.JobRank
	FROM (
		  SELECT tc.JobDuringJourney AS JobDuringJourney,
				 tc.ColonistId,
				 DENSE_RANK() OVER (PARTITION BY tc.JobDuringJourney ORDER BY co.Birthdate ASC) AS JobRank
	FROM TravelCards AS tc
	JOIN Colonists AS co
	  ON co.Id = tc.ColonistId
GROUP BY tc.JobDuringJourney, co.Birthdate, tc.ColonistId
    ) AS k
    JOIN Colonists AS c ON c.Id = k.ColonistId
   WHERE k.JobRank = 2
ORDER BY k.JobDuringJourney
*/

--11. Get Colonists Count
/*
 CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT AS
  BEGIN
 RETURN	  (SELECT COUNT(*)
			 FROM Planets AS p
		LEFT JOIN Spaceports AS s
			   ON p.Id = s.PlanetId
		LEFT JOIN Journeys AS j
			   ON s.Id = j.DestinationSpaceportId
		LEFT JOIN TravelCards AS tc
			   ON j.Id = tc.JourneyId
		LEFT JOIN Colonists AS c
			   ON tc.ColonistId = c.Id
			WHERE p.[Name] = @PlanetName)
	END
*/

--12. Change Journey Purpose
/*
--SELECT * FROM Journeys
CREATE PROCEDURE usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
If @JourneyId NOT IN (SELECT Id FROM Journeys)
THROW 51000, 'The journey does not exist!', 1
If @NewPurpose = (SELECT Purpose FROM Journeys WHERE Id = @JourneyId)
THROW 51000, 'You cannot change the purpose!', 1
UPDATE Journeys
SET Purpose = @NewPurpose
WHERE Id = @JourneyId
*/