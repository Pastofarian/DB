USE AdventureWorks2017
GO

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT P.BusinessEntityID, Title, Firstname, Lastname, Birthdate, Gender
INTO #temp1
FROM Person.Person P
INNER JOIN HumanResources.Employee H 
ON P.BusinessEntityID = H.BusinessEntityID

SELECT * FROM #temp1

/**************************************************************
  ETAPE n°2
 *************************************************************/

IF object_id ('tempdb.dbo.#temp2') IS NOT NULL 
DROP TABLE #temp2
GO

SELECT BusinessEntityID, Title = 
    CASE
        WHEN Gender = 'M' THEN 'Mr'
        WHEN Gender = 'F' THEN 'Ms'
    END, FirstName, LastName, BirthDate, Gender 
INTO #temp2
FROM #temp1 

SELECT * FROM #temp2

/**************************************************************
  ETAPE n°3
 *************************************************************/

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_EX2_Nom_Prenom')
DROP DATABASE EXAMEN_EX2_Nom_Prenom 
GO
CREATE DATABASE EXAMEN_EX2_Nom_Prenom
GO

USE EXAMEN_EX2_Nom_Prenom
GO

/**************************************************************
  ETAPE n°4
 *************************************************************/
 
IF EXISTS (SELECT * FROM EXAMEN_EX2_Nom_Prenom.sys.tables WHERE name = 'Tbl_Mike_Bern_EmployeeBIS')
DROP TABLE Tbl_Mike_Bern_EmployeeBIS
GO

IF object_id ('tempdb.dbo.#temp3') IS NOT NULL 
DROP TABLE #temp3
GO

SELECT * 
INTO Tbl_Mike_Bern_EmployeeBIS
FROM #temp2

SELECT * 
INTO #temp3
FROM Tbl_Mike_Bern_EmployeeBIS

SELECT * FROM #temp3

/**************************************************************
  ETAPE n°5
 *************************************************************/

ALTER TABLE #temp3 ADD Rappel_Vaccin VARCHAR(1)

SELECT * FROM #temp3

IF EXISTS (SELECT * FROM EXAMEN_EX2_Nom_Prenom.sys.tables WHERE name = 'Tbl_Mike_Bern_EmployeeBIS')
DROP TABLE Tbl_Mike_Bern_EmployeeBIS
GO

SELECT TOP(10) *
INTO Tbl_Mike_Bern_EmployeeBIS
FROM #temp3

SELECT * FROM Tbl_Mike_Bern_EmployeeBIS


/**************************************************************
  ETAPE n°6
*************************************************************/

IF EXISTS (SELECT * FROM EXAMEN_EX2_Nom_Prenom.sys.tables WHERE name = 'tbl_IdVaccin')
DROP TABLE tbl_IdVaccin
GO

CREATE TABLE tbl_IdVaccin
(
BusinessEntityID INT IDENTITY (1,1),
Vaccin nvarchar(1),
ROWID uniqueidentifier
)
Select * from tbl_IdVaccin

-----------------------------------------

GO
INSERT INTO Tbl_IdVaccin
(ROWID) VALUES (NEWID())
GO 10

Select * from tbl_IdVaccin

/**************************************************************
  ETAPE n°7
*************************************************************/

UPDATE tbl_IdVaccin
SET Vaccin = 'x'
WHERE BusinessEntityID % 2 = 1

--------Ou-----------------------------------------

DECLARE @id INT
DECLARE @i INT
SET @i = 1
DECLARE @nbligne INT
SET @nbLigne = (SELECT COUNT(BusinessEntityID) FROM Tbl_IdVaccin)

WHILE @i <= @nbligne
    BEGIN 
        SET @id = (SELECT BusinessEntityID FROM tbl_IdVaccin)
        IF @id % 2 = 1
            BEGIN
                UPDATE tbl_IdVaccin
                SET Vaccin = 'x'
                WHERE @i = BusinessEntityID
            END
            SET @i = @i + 1;
    END

Select * from tbl_IdVaccin

/**************************************************************
  ETAPE n°8
*************************************************************/

SELECT * FROM Tbl_Mike_Bern_EmployeeBIS

DECLARE 
@a AS INT,
@b AS VARCHAR(30),
@c AS VARCHAR(30),
@d AS VARCHAR(30),
@e AS DATE,
@f AS VARCHAR(30),
@g AS VARCHAR(30), 
@test1 INT

DECLARE cur1 CURSOR FOR (SELECT BusinessEntityID, Title, Firstname, Lastname, Birthdate, Gender, Rappel_Vaccin FROM Tbl_Mike_Bern_EmployeeBIS)

OPEN cur1

FETCH cur1 INTO @a, @b ,@c, @d, @e, @f, @g
SET @test1 = @a

WHILE @@FETCH_STATUS = 0

BEGIN
    DECLARE cur2 CURSOR FOR (SELECT BusinessEntityID, Vaccin FROM tbl_IdVaccin)

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

                    SELECT BusinessEntityId, Vaccin FROM tbl_IdVaccin
                    WHERE BusinessEntityID = @c1
                    UPDATE  [Tbl_Mike_Bern_EmployeeBIS]
                    SET @g = 'x' WHERE @test2 = @test1  
                    SELECT @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
                END 

                ELSE
                UPDATE  [Tbl_Mike_Bern_EmployeeBIS]
                SET @g = 'n' WHERE @test2 = @test1
                SELECT @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
                FETCH cur1 INTO @a , @b, @c, @d, @e, @f, @g  -- je passe au prochain enregistrement
                FETCH cur2 INTO @c1, @c2
            END    -- BEGIN 1

            CLOSE cur1         --  Fermeture du curseur n°1 puisqu'il est le premier qui a commencé dans l'ordre des opérations
            DEALLOCATE cur1    --  Je libère la mémoire de mon curseur n°1

END          --  Fermeture du curseur n°2 puisqu'il suit le curseur n°1
CLOSE cur2
DEALLOCATE cur2