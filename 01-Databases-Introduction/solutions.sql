/* 04. Insert Records in Both Tables */
INSERT INTO [dbo].[Towns]
           ([Id]
           ,[Name])
     VALUES
           (1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [dbo].[Minions]
           ([Id]
           ,[Name]
           ,[Age]
           ,[TownId])
     VALUES
           (1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

/* Create Table People */
CREATE TABLE [People](
	[Id] BIGINT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(15, 2),
	[Weight] DECIMAL(15, 2),
	[Gender] CHAR(1),
	CHECK ([Gender] IN ('m', 'f')),
	[Birthdate] DATE NOT NULL,
	[Biography] VARCHAR(MAX)
)

INSERT INTO [People]([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) VALUES
	('John', NULL, 1.89, 85.43, 'm', '1989-01-15', NULL),
	('Jack', NULL, 1.91, 95.88, 'm', '1985-06-08', NULL),
	('Jenny', NULL, 1.78, 65.87, 'f', '1993-09-25', NULL),
	('Anna', NULL, 1.69, 60.59, 'f', '1994-12-11', NULL),
	('George', NULL, 1.73, 70.62, 'm', '1981-03-29', NULL)

/* 08. Create Table Users */
CREATE TABLE [Users](
	[Id] BIGINT PRIMARY KEY IDENTITY,
	[Username] NVARCHAR(30) UNIQUE NOT NULL,
	[Password] NVARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	CHECK (DATALENGTH([ProfilePicture]) <= 900000),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT NOT NULL
)

INSERT INTO [Users]([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted]) VALUES
('John','abracadabra',NULL,'1990-06-25',0),
('Jack','abracadabra',NULL,'1989-01-15',0),
('Anna','abracadabra',NULL,'1991-09-03',0),
('Felicia','abracadabra',NULL,'1988-11-11',0),
('George','abracadabra',NULL,'1989-07-22',0)

/* 13. Movies Database */
CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY IDENTITY,
	[DirectorName] VARCHAR(50) NOT NULL,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] VARCHAR(50) NOT NULL,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] VARCHAR(50) NOT NULL,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] VARCHAR(100) NOT NULL,
	[DirectorId] INT,
	[CopyrightYear] INT NOT NULL,
	[Length] TIME NOT NULL,
	[GenreId] INT,
	[CategoryId] INT,
	[Rating] INT,
	[Notes] VARCHAR(MAX)
)

INSERT INTO [Directors]([DirectorName]) VALUES
	('Stanley Kubrick'),
	('Alfred Hitchcock'),
	('Akira Kurosawa'),
	('Steven Spielberg'),
	('Martin Scorsese')

INSERT INTO [Genres](GenreName) VALUES
	('Action'),
	('Adventure'),
	('Comedy'),
	('Drama'),
	('Fantasy')

INSERT INTO [Categories]([CategoryName]) VALUES
	('Abcd'),
	('Efgh'),
	('Ijkl'),
	('Mnop'),
	('Qrst')

INSERT INTO [Movies]([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating]) VALUES
	('A space odyssey', 1, 1968, '1:35:00', 1, 1, 1),
	('The Godfather', 2, 1971, '2:35:00', 2, 2, 2),
	('3', 3, 1968, '1:35:00', 3, 3, 3),
	('4', 4, 1968, '1:35:00', 4, 4, 4),
	('5', 5, 1968, '1:35:00', 5, 5, 5)

/* 14. Car Rental Database */
CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] VARCHAR(20) NOT NULL,
	[DailyRate] INT,
	[WeeklyRate] INT,
	[MonthlyRate] INT,
	[WeekendRate] INT
)

CREATE TABLE[Cars](
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] VARCHAR(20) NOT NULL,
	[Manufacturer] VARCHAR(20) NOT NULL,
	[Model] VARCHAR(20) NOT NULL,
	[CarYear] SMALLINT,
	[CategoryId] INT NOT NULL,
	[Doors] TINYINT,
	[Picture] VARBINARY(MAX),
	[Condition] VARCHAR(20),
	[Available] VARCHAR(10)
)

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(20),
	[LastName] VARCHAR(20),
	[Title] VARCHAR(20),
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Customers](
	[Id] INT PRIMARY KEY IDENTITY,
	[DriverLicenceNumber] INT NOT NULL,
	[FullName] VARCHAR(50) NOT NULL,
	[Address] VARCHAR(200),
	[City] VARCHAR(30),
	[ZIPCode] INT,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [RentalOrders](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT NOT NULL,
	[CustomerId] INT NOT NULL,
	[CarId] INT NOT NULL,
	[TankLevel] INT,
	[KilometrageStart] INT,
	[KilometrageEnd] INT,
	[TotalKilometrage] INT,
	[StartDate] DATE,
	[EndDate] DATE,
	[TotalDays] INT,
	[RateApplied] INT,
	[TaxRate] INT,
	[OrderStatus] VARCHAR(20),
	[Notes] VARCHAR(MAX)
)

INSERT INTO [Categories]([CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate]) VALUES
	('Limo', 3, 4, 5, 6),
	('SportsCar', 1, 2, 3, 4),
	('PickUp', 2, 3, 4, 5)

INSERT INTO [Customers]([DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode]) VALUES
	(123456789, 'John Smith', 'Bulgaria Street 2011', 'Sofia', 1000),
	(987654321, 'Smith John', 'Sofia Street 11', 'Plovdiv', 3000),
	(654321789, 'John John', 'Plovdiv Street 20', 'Varna', 9000)

INSERT INTO [Cars]([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Condition], [Available]) VALUES
	('123A456B', 'Audi', 'A8', 2022, 2, 5, 'Excellent', 'Available'),
	('223A456B', 'BMW', 'Z1', 2021, 2, 5, 'Excellent', 'Available'),
	('123A4HHB', 'Kia', 'Sportage', 2019, 3, 2, 'Good', 'Available')

INSERT INTO [Employees]([FirstName], [LastName], [Title]) VALUES
	('Ivan', 'Ivanov', 'Driver'),
	('Peter', 'Petrov', 'Cleaner'),
	('George', 'Georgiev', 'Guard')

INSERT INTO [RentalOrders]([EmployeeId], [CustomerId], [CarId], [TankLevel], [KilometrageStart], [KilometrageEnd], [TotalKilometrage]) VALUES
	(1, 2, 3, 30, 120120, 120220, 120220),
	(2, 3, 4, 30, 120120, 120220, 120220),
	(3, 4, 5, 30, 120120, 120220, 120220)

/* Hotel Database */
CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(20),
	[LastName] VARCHAR(20),
	[Title] VARCHAR(20),
	[Notes] VARCHAR(MAX)
)

CREATE TABLE[Customers](
	[AccountNumber] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(20),
	[LastName] VARCHAR(20),
	[PhoneNumber] VARCHAR(20),
	[EmergencyName] VARCHAR(20),
	[EmergencyNumber] VARCHAR(20),
	[Notes] VARCHAR(MAX)
)

CREATE TABLE[RoomStatus](
	[RoomStatus] INT PRIMARY KEY IDENTITY,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [RoomTypes](
	[RoomType] INT PRIMARY KEY IDENTITY,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [BedTypes](
	[BedType] INT PRIMARY KEY IDENTITY,
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Rooms](
	[RoomNumber] INT PRIMARY KEY IDENTITY,
	[RoomType] VARCHAR(20),
	[BedType] VARCHAR(20),
	[Rate] VARCHAR(20),
	[RoomStatus] VARCHAR(20),
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Payments](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT UNIQUE NOT NULL,
	[PaymentDate] DATE,
	[AccountNumber] INT UNIQUE NOT NULL,
	[FirstDateOccupied] DATE,
	[LastDateOccupied] DATE,
	[TotalDays] INT,
	[AmountCharged] DECIMAL(15, 2),
	[TaxRate] INT,
	[TaxAmount] DECIMAL(15, 2),
	[PaymentTotal] DECIMAL(15, 2),
	[Notes] VARCHAR(MAX)
)

CREATE TABLE [Occupancies](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT UNIQUE NOT NULL,
	[DateOccupied] DATE,
	[AccountNumber] INT UNIQUE NOT NULL,
	[RoomNumber] INT,
	[RateApplied] DECIMAL(15, 2),
	[PhoneCharge] DECIMAL(15, 2),
	[Notes] VARCHAR(MAX)
)

INSERT INTO [BedTypes]([Notes]) VALUES
	('rst'),
	('uvw'),
	('xyz')

INSERT INTO [Customers]([FirstName]) VALUES
	('Pesho'),
	('Gosho'),
	('Ivan')

INSERT INTO [Employees]([FirstName]) VALUES
	('Peter'),
	('George'),
	('Jack')

INSERT INTO [Occupancies]([EmployeeId], [AccountNumber]) VALUES
	(678, 987),
	(456, 789),
	(654, 321)

INSERT INTO [Payments]([EmployeeId], [AccountNumber]) VALUES
	(345, 678),
	(123, 456),
	(987, 654)

INSERT INTO [Rooms]([RoomType]) VALUES
	('Single'),
	('Double'),
	('Triple')

INSERT INTO [RoomStatus]([Notes]) VALUES
	('Single'),
	('Double'),
	('Triple')

INSERT INTO [RoomTypes]([Notes]) VALUES
	('abc'),
	('def'),
	('ghi')

/* 19. Basic Select All Fields */
SELECT * FROM [Towns]

SELECT * FROM [Departments]

SELECT * FROM [Employees]

/* 20. Basic Select All Fields and Order Them */
SELECT * FROM [Towns] ORDER BY [Name] ASC

SELECT * FROM [Departments] ORDER BY [Name] ASC

SELECT * FROM [Employees] ORDER BY [Salary] DESC

/* 21. Basic Select Some Fields */
SELECT [Name] FROM [Towns] ORDER BY [Name] ASC

SELECT [Name] FROM [Departments] ORDER BY [Name] ASC

SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees] ORDER BY [Salary] DESC

/* 22. Increase Employees Salary */
UPDATE [Employees]
SET [Salary] = [Salary] * 1.1

SELECT [Salary] FROM [Employees]

/* 23. Decrease Tax Rate */
UPDATE [Payments]
SET [TaxRate] = [TaxRate] * 0.97

SELECT [TaxRate] FROM [Payments]

/* 24. Delete All Records */
TRUNCATE TABLE [Occupancies]