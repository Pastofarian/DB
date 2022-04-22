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

SELECT P.BusinessEntityID, NationalIDNumber Numero_national, LoginID, JobTitle titre_du_job,
BirthDate date_de_naissance, MaritalStatus StatusMarital, HireDate Date_embauche, Title Titre,
Firstname Prenom, LastName Nom
INTO #temp1 
FROM [Person].[Person] AS P 
INNER JOIN [HumanResources].[Employee] AS H 
ON P.BusinessEntityId = H.BusinessEntityId 

SELECT * FROM #temp1

------------------------------------------------------------

SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]

IF object_id ('tempdb.dbo.#temp2') IS NOT NULL
DROP TABLE #temp2
GO

SELECT T1.BusinessEntityID, Numero_national, LoginID,  titre_du_job,
 date_de_naissance, StatusMarital, Date_embauche,  Titre,
Prenom,  Nom, DepartmentID
INTO #temp2
FROM #temp1 T1
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] HE
ON T1.BusinessEntityID = HE.BusinessEntityID

SELECT * FROM #temp2

-----------------------------------------------------------

SELECT * FROM [HumanResources].[Department]

IF object_id ('tempdb.dbo.#temp3') IS NOT NULL
DROP TABLE #temp3
GO

SELECT T2.BusinessEntityID, Numero_national, LoginID,  titre_du_job,
 date_de_naissance,  StatusMarital, Date_embauche,  Titre,
Prenom,  Nom, T2.DepartmentID, Name, GroupName
INTO #temp3
FROM #temp2 T2
LEFT JOIN [HumanResources].[Department] HD
ON T2.DepartmentID = HD.DepartmentID

SELECT * FROM #temp3

/**************************************************************
  ETAPE n°2 
*************************************************************/

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

-------------------------------------------------------------------

USE Examen_blanc20200523_prenom_nom
GO

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'TBL_NOM_PRENOM')
DROP TABLE TBL_NOM_PRENOM
GO

SELECT TOP(30) *
INTO TBL_NOM_PRENOM
FROM #temp3
GO

SELECT * FROM TBL_NOM_PRENOM

/**************************************************************
  ETAPE n°3 
*************************************************************/

IF OBJECT_ID(N'dbo.IFOSUP_NewFormatDate', N'FN')IS NOT NULL
DROP FUNCTION dbo.IFOSUP_NewFormatDate;
GO

--ALTER FUNCTION dbo.IFOSUP_NewFormatDate (@date VARCHAR(10))
CREATE FUNCTION dbo.IFOSUP_NewFormatDate (@date VARCHAR(10))
RETURNS NVARCHAR(10)
AS
BEGIN 
    DECLARE @result VARCHAR(10)
    DECLARE @a VARCHAR(2)
    DECLARE @b VARCHAR(2)
    DECLARE @c VARCHAR(4)

    SET @a = SUBSTRING (cast(@date AS varchar),9,2)
    SET @b = SUBSTRING (cast(@date AS varchar),6,2)
    SET @c = SUBSTRING (cast(@date AS varchar),1,4)

    SET @result = @a + '_' + @b + '_' + @c

    RETURN @result

END 
GO

/**************************************************************
  ETAPE n°4 
*************************************************************/

IF object_id ('tempdb.dbo.#temp4') IS NOT NULL
DROP TABLE #temp4
GO


SELECT BusinessEntityID, Numero_national, LoginID,  titre_du_job,
 dbo.IFOSUP_NewFormatDate(date_de_naissance) AS date_de_naissance,  StatusMarital, dbo.IFOSUP_NewFormatDate([Date_embauche]) AS date_embauche,  Titre,
Prenom,  Nom, DepartmentID, Name, GroupName
INTO #temp4
FROM TBL_NOM_PRENOM

SELECT * FROM #temp4

/**************************************************************
  ETAPE n°5 
*************************************************************/

SELECT *
INTO TBL_NOM_PRENOM
FROM #temp4

SELECT * FROM TBL_NOM_PRENOM

/**************************************************************
  ETAPE n°6 - 7
*************************************************************/

GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'dbo.GetEmployeeIFOSUP' AND type = 'P')
  DROP PROCEDURE dbo.GetEmployeeIFOSUP
GO

CREATE PROCEDURE dbo.GetEmployeeIFOSUP
--ALTER PROCEDURE dbo.GetEmployeeIFOSUP

@title VARCHAR(255)

AS
BEGIN
  SELECT *
  FROM TBL_NOM_PRENOM 
  WHERE [titre_du_job] LIKE @title 
END
GO  

EXECUTE dbo.GetEmployeeIFOSUP 'Research and Development%'