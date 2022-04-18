/**************************************************************
  ETAPE n°1
 *************************************************************/

USE AdventureWorks2017
GO

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT P.BusinessEntityID, Title, Firstname, Lastname, NationalIDNumber,
LoginID, OrganizationLevel, JobTitle, Birthdate, MaritalStatus, Gender, HireDate Date_embauche
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

SELECT T1.BusinessEntityID, Title, Firstname, Lastname, NationalIDNumber,
LoginID, OrganizationLevel, JobTitle, Birthdate, MaritalStatus, Gender, CONVERT(VARCHAR(10), Date_embauche, 103) AS Date_embauche
INTO #temp2
FROM #temp1 T1

SELECT * FROM #temp2

/**************************************************************
  ETAPE n°3
 *************************************************************/

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_EX1_Mike_Bern')
DROP DATABASE IFOSUP_EX1_Mike_Bern 
GO
CREATE DATABASE IFOSUP_EX1_Mike_Bern
GO

USE IFOSUP_EX1_Mike_Bern
GO

IF EXISTS (SELECT * FROM IFOSUP_EX1_Mike_Bern.sys.tables WHERE name = 'tbl_micke_bern')
DROP TABLE tbl_micke_bern
GO

SELECT * 
INTO tbl_micke_bern
FROM #temp2

SELECT * FROM tbl_micke_bern

/**************************************************************
  ETAPE n°4
 *************************************************************/

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'NbrOfEmployees' AND type = 'P')
  DROP PROCEDURE NbrOfEmployees
GO

CREATE PROC NbrOfEmployees

@gender NVARCHAR(1),
@date1 NVARCHAR(30),
@date2 NVARCHAR(30),
@count INT OUT 

AS 
BEGIN
    SELECT @count = COUNT(BusinessEntityID) FROM tbl_micke_bern
    WHERE Gender = @gender 
    AND SUBSTRING ((Date_embauche), 7, 4) > @date1 AND SUBSTRING ((Date_embauche), 7, 4) < @date2
END
GO

DECLARE @gender NVARCHAR(1), 
        @date1 NVARCHAR(30),
        @date2 NVARCHAR(30),
        @count INT

EXECUTE NbrOfEmployees 'M', '2009', '2012', @count OUTPUT

SELECT @count AS ['Nombre d'employés']

Print 'Michel Bernair, voici mon résultat:' + '  ' + cast (@count as nvarchar(2))