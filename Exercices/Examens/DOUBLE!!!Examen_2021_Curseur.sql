/******************************************************************
Nom : ____________
Prénom : _____________
Questionnaire : A
IFOSUPWAVRE – examen réel – 03/04/2021
*******************************************************************/

USE AdventureWorks2017;  
GO 

SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]

IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

SELECT P.BusinessEntityID , Firstname AS Prénom, Lastname AS Nom, Birthdate AS [Date_de_naissance], Gender,
CASE Gender
    WHEN 'M'THEN 'Mr.'
    WHEN 'F'THEN 'Ms.'
END AS Title
INTO #temp1 FROM [HumanResources].[Employee] AS H 
INNER JOIN [Person].[Person] AS P
ON P.BusinessEntityID = H.BusinessEntityID
GO

SELECT * FROM #temp1  --290 lignes

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_EX2_Nom_Prenom')
DROP DATABASE EXAMEN_EX2_Nom_Prenom 
GO
CREATE DATABASE EXAMEN_EX2_Nom_Prenom
GO

USE EXAMEN_EX2_Nom_Prenom
GO


IF Object_Id('tbl_Nom_Prenom_EmployeeBIS') IS NOT NULL
DROP table tbl_Nom_Prenom_EmployeeBIS

SELECT * 
INTO tbl_Nom_Prenom_EmployeeBIS
FROM #temp1
GO

SELECT * 
INTO #temp2
FROM #temp1
GO

ALTER TABLE #temp2
ADD Rappel_Vaccin VARCHAR(1)

--SELECT * FROM #temp2

IF Object_Id('tbl_Nom_Prenom_EmployeeBIS') IS NOT NULL
DROP table tbl_Nom_Prenom_EmployeeBIS

SELECT TOP(10) BusinessEntityID, Prénom, Nom, Title, Date_de_naissance, Gender, Rappel_Vaccin
INTO tbl_Nom_Prenom_EmployeeBIS
FROM #temp2
GO

SELECT * FROM tbl_Nom_Prenom_EmployeeBIS

IF Object_Id('tbl_IdVaccin') IS NOT NULL
DROP table tbl_IdVaccin

CREATE TABLE tbl_IdVaccin
(
BusinessEntityID INT IDENTITY (1,1),
Vaccin nvarchar(1),
ROWID uniqueidentifier
)
Select * from tbl_IdVaccin

INSERT INTO Tbl_IdVaccin
(ROWID) VALUES (NEWID())
GO 10

UPDATE tbl_IdVaccin
SET Vaccin = 'x'
WHERE BusinessEntityID %2=1

----------------------------------------------- Lost -------------------------------------

DECLARE @a INT,
        @b NVARCHAR(50),
        @c VARCHAR(3),
        @d DATE,
        @f NVARCHAR(1),
        @g VARCHAR(1)
DECLARE @test1 INT        

DECLARE cur1 CURSOR FOR (SELECT BusinessEntityID, Prénom, Nom, Title, Date_de_naissance, Gender, Rappel_Vaccin FROM tbl_Nom_Prenom_EmployeeBIS) 

OPEN cur1            

FETCH cur1 INTO @a, @b, @c, @d, @e, @f, @g
SET @test1 = @a                        

WHILE @@fetch_Status = 0  

BEGIN
DECLARE cur2 CURSOR FOR (SELECT BusinessEntityId, Vaccin FROMtbl_IdVaccin)

DECLARE @c1 INT,
        @c2 NVARCHAR(1),
        @test2 INT
OPEN cur2

    FETCH cur2 INTO @c1, @c2
    SET @test2 = @c1
WHILE @@FETCH_STATUS = 0                         
BEGIN

IF(@c2 IS NULL)
    BEGIN
              Select BusinessEntityId, Vaccin from  tbl_IdVaccin
                 WHERE BusinessEntityID = @c1
          UPDATE  [tbl_Mike_Bernair_EmployeeBIS]
          SET @g = 'x' WHERE @test2 = @test1   ---,a    --- @c1 = @a
          Select @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
        END 
        ELSE
         UPDATE  [tbl_Mike_Bernair_EmployeeBIS]
         SET @g = 'n' WHERE @test2 = @test1
         Select @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
    FETCH cur1 INTO @a , @b, @c, @d, @e, @f, @g  -- je passe au prochain enregistrement
    FETCH cur2 INTO @c1, @c2
  END    -- BEGIN 1

CLOSE cur1         --  Fermeture du curseur n°1 puisqu'il est le premier qui a commencé dans l'ordre des opérations
DEALLOCATE cur1    --  Je libère la mémoire de mon curseur n°1

      END          --  Fermeture du curseur n°2 puisqu'il suit le curseur n°1
    CLOSE cur2
    DEALLOCATE cur2

