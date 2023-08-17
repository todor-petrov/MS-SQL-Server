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