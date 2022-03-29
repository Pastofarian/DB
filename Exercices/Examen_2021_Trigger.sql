/******************************************************************
Nom : ____________
Prénom : _____________
Questionnaire : A
IFOSUPWAVRE – examen réel – 03/04/2021
*******************************************************************/
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_REEL_030420201_EX2_Mike_Bern')
DROP DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern 
GO
CREATE DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

USE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

CREATE Table Tbl_vaccin
(
âge INT IDENTITY (1,1),
Type_Vaccin nvarchar(30),
ROWID uniqueidentifier
)
GO

INSERT INTO Tbl_vaccin
(ROWID) VALUES (NEWID())
GO 100

SELECT * FROM Tbl_vaccin

DECLARE @age3 INT = 70;
    DECLARE @type2 AS NVARCHAR(30) 
SET @type3 = 'AstraZeneca'
WHILE @age3 < 100
BEGIN  
   UPDATE Tbl_vaccin  
      SET [Type_Vaccin] = 'AstraZeneca'
      WHERE [âge] BETWEEN '70' AND '100'
      PRINT ('Insertion de données du type de vaccin' + ' ' + @type3 + 'pour l''age :' + cast(@age3 as NVARCHAR(10)) + ' ' + 'an');
      SET @age3 = @age3 + 1;
END
PRINT 'Fin de l''insertion des données dans la table'; 
GO

DECLARE @age2 INT = 51;
    DECLARE @type2 AS NVARCHAR(30) 
SET @type2 = 'Moderna'
WHILE @age2 < 70
BEGIN  
   UPDATE Tbl_vaccin  
      SET [Type_Vaccin] = 'Moderna'
      WHERE [âge] BETWEEN '51' AND '69'
      PRINT ('Insertion de données du type de vaccin' + ' ' + @type2 + 'pour l''age :' + cast(@age2 as NVARCHAR(10)) + ' ' + 'an');
      SET @age2 = @age2 + 1;
END
PRINT 'Fin de l''insertion des données dans la table'; 
GO

DECLARE @age1 INT = 1;
    DECLARE @type1 AS NVARCHAR(30) 
SET @type1 = 'Pfizer-BioNTech'
WHILE @age1 < 51
BEGIN  
   UPDATE Tbl_vaccin  
      SET [Type_Vaccin] = 'Moderna'
      WHERE [âge] BETWEEN '1' AND '50'
      PRINT ('Insertion de données du type de vaccin' + ' ' + @type1 + 'pour l''age :' + cast(@age1 as NVARCHAR(10)) + ' ' + 'an');
      SET @age1 = @age1 + 1;
END
PRINT 'Fin de l''insertion des données dans la table'; 
GO

SELECT * FROM Tbl_vaccin 
INTO #temp1

SELECT * FROM tbl_Nom_Prenom_EmployeeBIS

USE AdventureWorks2017
GO
SELECT * FROM HumanResources.Employee
SELECT  * FROM Person.Person

IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2

SELECT P.BusinessEntityID AS id, Title AS titre, Firstname AS Prénom, Lastname AS Nom, NationalIDNumber AS numero_national, Birthdate AS [Date_de_naissance], Gender,
CASE Gender
    WHEN 'M'THEN 'Mr.'
    WHEN 'F'THEN 'Ms.'
END AS Title
INTO #temp2 FROM [HumanResources].[Employee] AS H 
INNER JOIN [Person].[Person] AS P
ON P.BusinessEntityID = H.BusinessEntityID
GO

USE EXAMEN_EX2_Nom_Prenom
GO

ALTER TABLE #temp2
ADD Vaccin VARCHAR(1)

SELECT * FROM #temp4

ALTER TABLE #temp2
ADD âge VARCHAR(30)

SELECT id, titre, Prénom, Nom, numero_national, 
CONVERT(NVARCHAR, Date_de_naissance, 103) AS Date_naissance, 
DATEDIFF(yy, Date_de_naissance, GETDATE()) AS âge, 
Gender AS genre, 
Vaccin
INTO #temp4
FROM #temp2

-- Etape 9 TRIGGER lost !