USE Master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_REEL_030420201_EX2_Mike_Bern')
DROP DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern 
GO
CREATE DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

USE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

IF EXISTS(SELECT * FROM EXAMEN_REEL_030420201_EX2_Mike_Bern.sys.tables WHERE NAME = 'Tbl_Vaccin')
DROP TABLE Tbl_Vaccin
GO

CREATE TABLE Tbl_Vaccin  
(
age INT IDENTITY (1,1) PRIMARY KEY, 
TypeDeVaccin VARCHAR (30),
Rowid uniqueidentifier,    
)
GO

SELECT * FROM Tbl_Vaccin
GO

INSERT INTO Tbl_vaccin
(ROWID) VALUES (NEWID())
GO 100

DECLARE @age INT
DECLARE @i INT =1
DECLARE @nbligne INT
SET @nbLigne = (SELECT COUNT(age) FROM Tbl_Vaccin)

WHILE @i <= @nbligne
    BEGIN
        SET @age = (SELECT age FROM Tbl_Vaccin WHERE @i = age)
        IF @age >= 70
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Opel AstraZENECA' WHERE @i = age 
            END
        ELSE IF @age BETWEEN 52 AND 69
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Moderna' WHERE @i = age 
            END
        ELSE IF @age <= 51
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Pfizer' WHERE @i = age 
            END
        ELSE
            BEGIN
                PRINT 'ERROR'
            END
        SET @i = @i + 1;
    END


SELECT * FROM Tbl_Vaccin;

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT * 
INTO #temp1
FROM Tbl_Vaccin

SELECT * FROM #temp1

USE AdventureWorks2017
GO

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee

SELECT P.BusinessEntityID id, Title titre, FirstName Prenom, LastName Nom, BirthDate Date_naissance, Gender Genre 
INTO #temp2
FROM [Person].[Person] P
INNER JOIN [HumanResources].[Employee] H
ON p.BusinessEntityID = H.BusinessEntityID

USE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

SELECT * 
INTO Tbl_trig_Prenom_Nom
FROM AdventureWorks2017.dbo.#temp2

SELECT TOP(10)*
INTO #temp3
FROM Tbl_trig_Prenom_Nom

SELECT * FROM Tbl_trig_Prenom_Nom

ALTER TABLE #temp3 ADD vaccin VARCHAR(30)

SELECT * FROM #temp3

ALTER TABLE #temp3
ALTER COLUMN age INT

UPDATE #temp3
SET age = DATEDIFF(YEAR, Date_naissance, GETDATE())

IF EXISTS(SELECT * FROM EXAMEN_REEL_030420201_EX2_Mike_Bern.sys.tables WHERE NAME = 'Tbl_trig_Prenom_Nom')
DROP TABLE Tbl_trig_Prenom_Nom
GO

SELECT * INTO Tbl_trig_Prenom_Nom
FROM #temp3

SELECT * FROM Tbl_trig_Prenom_Nom
GO

ALTER TRIGGER tr_Vaccin_FOR_INSERT_Prenom_Nom
--CREATE TRIGGER tr_Vaccin_FOR_INSERT_Prenom_Nom
ON Tbl_trig_Prenom_Nom
FOR INSERT 
    AS BEGIN
    DECLARE @age INT = (SELECT age FROM inserted)
    DECLARE @id INT = (SELECT id FROM inserted)
       
        IF @age >= 70
            BEGIN
                UPDATE Tbl_trig_Prenom_Nom 
                SET vaccin = 'Opel AstraZENECA' 
                WHERE id = @id 
            END
        ELSE IF @age BETWEEN 52 AND 69
            BEGIN
                UPDATE Tbl_trig_Prenom_Nom 
                SET vaccin = 'Moderna' 
                WHERE id = @id  
          END
        ELSE IF @age <= 51
            BEGIN
                UPDATE Tbl_trig_Prenom_Nom 
                SET vaccin = 'Pfizer' 
                WHERE id = @id  
         END
END

---------------------- renvoie une erreur -------------------------------------------------

INSERT INTO Tbl_trig_Prenom_Nom
VALUES (14, 'Mr', 'Paul', 'Durand', '1981-12-05', 'M', '', '41')

SELECT * FROM Tbl_trig_Prenom_Nom
GO