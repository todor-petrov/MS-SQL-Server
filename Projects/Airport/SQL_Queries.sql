/*
CREATE DATABASE Airport
GO
USE Airport
*/
--01. Database design
/*
CREATE TABLE Passengers (
						 Id INT PRIMARY KEY IDENTITY,
						 FullName VARCHAR(100) NOT NULL,
						 Email VARCHAR(50) NOT NULL
						 )
CREATE TABLE Pilots (
					 Id INT PRIMARY KEY IDENTITY,
					 FirstName VARCHAR(30) NOT NULL,
					 LastName VARCHAR(30) NOT NULL,
					 Age TINYINT NOT NULL,
					 CHECK (Age BETWEEN 21 AND 62),
					 Rating FLOAT,
					 CHECK (Rating BETWEEN 0.0 AND 10.0)
					 )
CREATE TABLE AircraftTypes (
							Id INT PRIMARY KEY IDENTITY,
							TypeName VARCHAR(30) UNIQUE NOT NULL
							)
CREATE TABLE Aircraft (
					   Id INT PRIMARY KEY IDENTITY,
					   Manufacturer VARCHAR(25) NOT NULL,
					   Model VARCHAR(30) NOT NULL,
					   [Year] INT NOT NULL,
					   FlightHours INT,
					   Condition CHAR(1) NOT NULL,
					   TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
					   )
CREATE TABLE PilotsAircraft (
							 AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
							 PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
							 PRIMARY KEY(AircraftId, PilotId)
							 )
CREATE TABLE Airports (
					   Id INT PRIMARY KEY IDENTITY,
					   AirportName VARCHAR(70) UNIQUE NOT NULL,
					   Country VARCHAR(100) UNIQUE NOT NULL
					   )
CREATE TABLE FlightDestinations (
								 Id INT PRIMARY KEY IDENTITY,
								 AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
								 [Start] DATETIME NOT NULL,
								 AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
								 PassengerId INT FOREIGN KEY REFERENCES Passengers(ID) NOT NULL,
								 TicketPrice DECIMAL(18, 2) DEFAULT 15 NOT NULL
								 )
*/

--02. Insert
/*
INSERT INTO Passengers (FullName, Email)
	 SELECT CONCAT(p.FirstName, ' ', p.LastName),
			CONCAT(p.FirstName, p.LastName, '@gmail.com')
	   FROM Pilots AS p
	  WHERE p.Id BETWEEN 5 AND 15
*/

--03. Update
/*
UPDATE Aircraft
   SET Condition = 'A'
 WHERE (Condition = 'C' OR Condition = 'B')
   AND (FlightHours IS NULL OR FlightHours BETWEEN 0 AND 100)
   AND [Year] >= 2013
*/

--04. Delete
/*
DELETE FROM child
	   FROM FlightDestinations AS child
 INNER JOIN Passengers AS parent ON child.PassengerId = parent.Id
	  WHERE LEN(parent.FullName) <= 10

DELETE FROM parent
	   FROM Passengers AS parent
	  WHERE LEN(parent.FullName) <= 10
*/

--05. Aircraft
/*
  SELECT Manufacturer, Model, FlightHours, Condition
	FROM Aircraft
ORDER BY FlightHours DESC
*/

--06. Pilots and Aircraft
/*
   SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours
	 FROM Pilots AS p
LEFT JOIN PilotsAircraft AS pa
	   ON p.Id = pa.PilotId
LEFT JOIN Aircraft AS a
	   ON pa.AircraftId = a.Id
	WHERE a.FlightHours IS NOT NULL AND a.FlightHours < 304
 ORDER BY a.FlightHours DESC, p.FirstName
 */

 --07. Top 20 Flight Destinations
 /*
   SELECT TOP 20 fd.Id AS DestinationId, fd.[Start], p.FullName, a.AirportName, fd.TicketPrice
	 FROM FlightDestinations AS fd
LEFT JOIN Passengers AS p
	   ON fd.PassengerId = p.Id
LEFT JOIN Airports AS a
	   ON fd.AirportId = a.Id
	WHERE DATEPART(DAY, Start) % 2 = 0
 ORDER BY fd.TicketPrice DESC, a.AirportName
*/

--08. Number of Flights for Each Aircraft
/*
   SELECT a.Id,
		  a.Manufacturer,
		  a.FlightHours,
		  COUNT(fd.Id) AS FlightDestinationsCount,
		  ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
	 FROM Aircraft AS a
LEFT JOIN FlightDestinations AS fd
	   ON a.Id = fd.AircraftId
 GROUP BY a.Id, a.Manufacturer, a.FlightHours
   HAVING COUNT(fd.Id) >= 2
 ORDER BY COUNT(fd.Id) DESC, a.Id
*/

--09. Regular Passengers
/*
   SELECT p.FullName, COUNT(a.Id) AS CountOfAircraft, SUM(fd.TicketPrice) AS TotalPayed
	 FROM Passengers AS p
LEFT JOIN FlightDestinations AS fd
	   ON p.Id = fd.PassengerId
LEFT JOIN Aircraft AS a
	   ON fd.AircraftId = a.Id
 GROUP BY p.FullName
   HAVING COUNT(a.Id) > 1 AND p.FullName LIKE '_a%'
 ORDER BY p.FullName
*/

--10. Full Info for Flight Destinations
/*
   SELECT a.AirportName,
		  fd.[Start],
		  fd.TicketPrice,
		  p.FullName,
		  plain.Manufacturer,
		  plain.Model
	 FROM FlightDestinations AS fd
LEFT JOIN Airports AS a
	   ON fd.AirportId = a.Id
LEFT JOIN Passengers AS p
	   ON fd.PassengerId = p.Id
LEFT JOIN Aircraft AS plain
	   ON fd.AircraftId = plain.Id
	WHERE DATEPART(HOUR, fd.Start) BETWEEN 6 AND 20 AND fd.TicketPrice > 2500
 ORDER BY plain.Model
*/

--11. Find all Destinations by Email Address
/*
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT AS
BEGIN
		DECLARE @result INT
		SET @result = 
					(SELECT COUNT(fd.Id) AS [Count]
					FROM FlightDestinations AS fd
					LEFT JOIN Passengers AS p
					ON fd.PassengerId = p.Id
					GROUP BY p.FullName, p.Email
					HAVING p.Email = @email)
		IF @result IS NULL
			SET @result = 0
		RETURN @result
END
*/

--12. Full Info for Airports
/*
CREATE PROCEDURE usp_SearchByAirportName (@airportName VARCHAR(70))
AS
BEGIN
    SELECT a.AirportName,
		   p.FullName,
		   CASE
			    WHEN fd.TicketPrice <= 400 THEN 'Low'
			    WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
			    ELSE 'High'
		    END
			AS
		   LevelOfTickerPrice,
		   plain.Manufacturer,
		   plain.Condition,
		   [at].TypeName
		   FROM Airports AS a
INNER JOIN FlightDestinations AS fd
		   ON a.Id = fd.AirportId
 LEFT JOIN Passengers AS p
		   ON fd.PassengerId = p.Id
 LEFT JOIN Aircraft AS plain
		   ON fd.AircraftId = plain.Id
 LEFT JOIN AircraftTypes AS [at]
		   ON plain.TypeId = at.Id
		   WHERE a.AirportName = @airportName
  ORDER BY plain.Manufacturer, p.FullName

END

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'
*/