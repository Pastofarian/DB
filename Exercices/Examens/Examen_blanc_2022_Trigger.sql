/**************************************************************
  ETAPE n°1 
*************************************************************/

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

/**************************************************************
  ETAPE n°2 
*************************************************************/
USE AdventureWorks2017
GO

SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT top(20) P.BusinessEntityID, NationalIDNumber NumeroNational, LoginID, JobTitle
TitreDuJob, BirthDate DateDeNaissance, Gender Genre, HireDate DateEmbauche, P.Title Titre, 
FirstName Prenom, LastName Nom 
INTO #temp1
FROM [Person].[Person] P
INNER JOIN [HumanResources].[Employee] H
ON P.BusinessEntityID = H.BusinessEntityID

/**************************************************************
  ETAPE n°3 
*************************************************************/

ALTER TABLE #temp1 ADD Nationalite CHAR(5)
ALTER TABLE #temp1 ADD Access CHAR(1)

SELECT * FROM #temp1

/**************************************************************
  ETAPE n°4 
*************************************************************/
USE Examen_blanc20200523_prenom_nom
GO

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'TBL_NOM_PRENOM')
DROP TABLE TBL_NOM_PRENOM
GO

SELECT *
INTO TBL_NOM_PRENOM
FROM #temp1

/**********************Simple Update****************************************************/
UPDATE TBL_NOM_PRENOM
SET Nationalite = 'US'
WHERE BusinessEntityID %2=0

UPDATE TBL_NOM_PRENOM
SET Nationalite = 'BE'
WHERE BusinessEntityID %2=1

UPDATE TBL_NOM_PRENOM
SET Access = 'x'

SELECT * FROM TBL_NOM_PRENOM

/********************CASE WHEN*******************************************/
SELECT BusinessEntityID, NumeroNational, LoginID,
TitreDuJob, DateDeNaissance, Genre, DateEmbauche, Titre, 
Prenom, Nom, Nationalite =
  CASE 
    WHEN BusinessEntityID % 2 = 0 THEN 'US'
    ELSE 'BE'
    END, Access
INTO #temp2
FROM TBL_NOM_PRENOM
GO 

UPDATE TBL_NOM_PRENOM
SET Access = 'x'
 
 SELECT * FROM #temp2

/*******************Boucle While**********************************************/

DECLARE @nbLigne INT
SET @nbLigne = (SELECT COUNT(BusinessEntityID) FROM TBL_NOM_PRENOM)
DECLARE @i Int = 1

WHILE (@i<= @nbLigne)
    BEGIN
        UPDATE TBL_NOM_PRENOM

          SET Nationalite = 
            (CASE 
              WHEN BusinessEntityID %2 = 0 THEN 'US'
              ELSE 'BE'
              END
            )
        WHERE BusinessEntityID = @i
        SET @i=@i+1
    END
GO

UPDATE TBL_NOM_PRENOM
SET Access = 'x'

SELECT * FROM TBL_NOM_PRENOM

/**************************************************************
  ETAPE n°5 - 6
*************************************************************/

IF EXISTS (SELECT 1 FROM sys.triggers 
           WHERE Name = 'tgr_test')
DROP TRIGGER tgr_test
GO

IF EXISTS 
(SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'TBL_Audit')
DROP TABLE TBL_Audit
GO

CREATE TABLE TBL_Audit (
    id VARCHAR(10),
    audit_data NVARCHAR(255)
)
GO

----------------------------------------------------------


CREATE TRIGGER tgr_test
ON TBL_NOM_PRENOM
AFTER INSERT
  AS 
      SET NOCOUNT ON;

      DECLARE @id INT
      DECLARE @nom VARCHAR(30)
      DECLARE @prenom VARCHAR(30)

      SET @id = (SELECT BusinessEntityID FROM inserted)
      SET @nom = (SELECT nom FROM inserted)
      SET @prenom = (SELECT prenom FROM inserted)

      UPDATE TBL_NOM_PRENOM
      SET LoginID = 'adventure-works' + @prenom + '.' + @nom + '@ifosup.wavre.be' 
      INSERT into TBL_Audit VALUES(cast(@id as varchar (10)), 'Nouvel employé Ajouté : '+cast (getdate() as varchar(20)) ) --manque les champs après TBL_Audit ? INSERT into TBL_Audit (id, audit_data) VALUES...
      
GO
  
INSERT INTO TBL_NOM_PRENOM
VALUES ('1001','', '','','','','','','Mike','Bern','BE','x')
GO

SELECT * FROM TBL_NOM_PRENOM