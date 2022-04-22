/**************************************************************
  ETAPE n°1 
*************************************************************/
USE AdventureWorks2017
GO

SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]
SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT P.BusinessEntityID id, Title titre, FirstName prenom, LastName nom, 
NationalIDNumber numero_national, [name] type_telephone, LoginID, JobTitle titre_job, BirthDate date_naissance, 
MaritalStatus status_marital, Gender genre, HireDate date_embauche, Gender, PP.PhoneNumberTypeID
INTO #temp1
FROM [HumanResources].[Employee] H
INNER JOIN [Person].[Person] P
ON P.BusinessEntityID = H.BusinessEntityID
INNER JOIN [Person].[PersonPhone] PP
ON H.BusinessEntityID = PP.BusinessEntityID
INNER JOIN [Person].[PhoneNumberType] PT
ON PP.PhoneNumberTypeID = PT.PhoneNumberTypeID

SELECT * FROM #temp1

/**************************************************************
  ETAPE n°2 
*************************************************************/

IF object_id ('tempdb.dbo.#temp2') IS NOT NULL 
DROP TABLE #temp2
GO

SELECT id, titre =
    CASE 
        WHEN Gender = 'M' THEN 'Mr.'
        ELSE 'Ms.'
        END, prenom, nom, numero_national, type_telephone = 
    CASE   
         WHEN PhoneNumberTypeID = 1 THEN 'GSM' 
         WHEN PhoneNumberTypeID = 2 THEN 'Tel.maison'
         WHEN PhoneNumberTypeID = 3 THEN 'Tel.travail' 
    END, LoginID, titre_job, date_naissance, status_marital, genre, date_embauche   
INTO #temp2
FROM #temp1 
GO  

SELECT * FROM #temp2

/**************************************************************
  ETAPE n°3 
*************************************************************/

IF object_id ('tempdb.dbo.#temp3') IS NOT NULL 
DROP TABLE #temp3
GO

SELECT TOP(9) *
INTO #temp3
FROM #temp2


SELECT * FROM #temp3

/**************************************************************
  ETAPE n°4 
*************************************************************/

ALTER TABLE #temp3
ALTER COLUMN LoginID NVARCHAR(30) NULL

UPDATE #temp3
SET LoginID = NULL

SELECT * FROM #temp3

/**************************************************************
  ETAPE n°5 
*************************************************************/

ALTER TABLE #temp3
ALTER COLUMN genre NVARCHAR(30) NULL

INSERT INTO #temp3 (Id, titre,  prenom, nom, numero_national, type_telephone, LoginID, 
titre_job, date_naissance, status_marital, date_embauche) 
VALUES (10, 'Mr.', 'Chistophe', 'nom', '265458523', 'GSM', '', '', '1980-05-03', 'M', '');

SELECT * FROM #temp3

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

USE Examen_blanc20200523_prenom_nom
GO

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'Tbl_Mike_Bern')
DROP TABLE Tbl_Mike_Bern
GO

SELECT *
INTO Tbl_Mike_Bern
FROM #temp3

SELECT * FROM Tbl_Mike_Bern

/**************************************************************
  ETAPE n°6 
*************************************************************/

IF object_id ('tempdb.dbo.#temp4') IS NOT NULL 
DROP TABLE #temp4
GO

SELECT id, titre, prenom, nom, LEFT(prenom, 1) AS C1, RIGHT(nom, 2) 
AS C2,
numero_national, type_telephone, titre_job, date_naissance, status_marital, 
genre, date_embauche
INTO #temp4
FROM Tbl_Mike_Bern

SELECT * FROM #temp4

IF object_id ('tempdb.dbo.#temp5') IS NOT NULL 
DROP TABLE #temp5
GO

SELECT id, titre, prenom, nom, numero_national, type_telephone, 
LoginID = CONCAT(prenom, '.', nom, '.', C1, C2, '@ifosupwavre.be'),
titre_job, date_naissance, status_marital, 
genre, date_embauche
INTO #temp5
FROM #temp4

SELECT *
INTO Tbl_Mike_Bern
FROM #temp5

SELECT * FROM Tbl_Mike_Bern
------------------------------------------------------------------

IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.spGetNom' AND type = 'P')
DROP PROCEDURE dbo.spGetNom
GO

/************************************************************************************************************************/

--CREATE PROCEDURE spGetNom
ALTER PROCEDURE spGetNom

@id INT

AS 
BEGIN
    DECLARE @prenom VARCHAR(30) 
    DECLARE @nom VARCHAR(30)

    SET @nom = (SELECT nom FROM Tbl_Mike_Bern
    WHERE id = @id)
    SET @prenom = (SELECT prenom FROM Tbl_Mike_Bern
    WHERE id = @id)

    UPDATE Tbl_Mike_Bern 
    SET LoginID = @prenom + '.' + @nom + '.' + LEFT(@prenom, 1) + RIGHT(@nom, 2) + '@ifosupwavre.be'
    WHERE id = @id

END 
GO

EXECUTE spGetNom 10 

SELECT * FROM Tbl_Mike_Bern

PRINT ' Affichage de votre Nom et Prenom'
PRINT '---------------------------------'
PRINT @nom + '  ' + @prenom + ' ' + @email


/********************************* Test ********************************************************/

INSERT INTO Tbl_Mike_Bern
(id, nom, prenom, date_embauche, titre, numero_national, LoginID, titre_job, date_naissance, status_marital)
VALUES (20, 'Benjamin', 'Ster', GETDATE(), '', '', '', '', GETDATE(), '')

DECLARE @id INT
SET @id = (SELECT id FROM Tbl_Mike_Bern WHERE nom = 'Benjamin')

EXECUTE spGetNom @id