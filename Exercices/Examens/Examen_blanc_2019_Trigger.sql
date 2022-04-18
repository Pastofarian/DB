/**************************************************************
  ETAPE n°1 
 *************************************************************/
USE AdventureWorks2017
GO 

SELECT * FROM Person.person
SELECT * FROM Person.EmailAddress
SELECT * FROM Person.PersonPhone
SELECT * FROM person.PhoneNumberType

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

SELECT P.BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender
INTO #temp1
FROM Person.Person P
INNER JOIN HumanResources.Employee HR
ON P.BusinessEntityID = HR.BusinessEntityID

SELECT * FROM #temp1
-----------------------------------------------------

IF object_id ('tempdb.dbo.#temp2') IS NOT NULL 
DROP TABLE #temp2
GO

SELECT T1.BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress 
INTO #temp2
FROM #temp1 T1
INNER JOIN Person.EmailAddress PE
ON T1.BusinessEntityID = PE.BusinessEntityID

SELECT * FROM #temp2
-------------------------------------------------------

IF object_id ('tempdb.dbo.#temp3') IS NOT NULL 
DROP TABLE #temp3
GO

SELECT T2.BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, PhoneNumber, PhoneNumberTypeID
INTO #temp3
FROM #temp2 T2
INNER JOIN Person.PersonPhone PP
ON T2.BusinessEntityID = PP.BusinessEntityID

SELECT * FROM #temp3
------------------------------------------------------

IF object_id ('tempdb.dbo.#temp4') IS NOT NULL 
DROP TABLE #temp4
GO

SELECT T3.BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, PhoneNumber, Name
INTO #temp4
FROM #temp3 T3
INNER JOIN Person.PhoneNumberType PPN
ON T3.PhoneNumberTypeID = PPN.PhoneNumberTypeID

SELECT * FROM #temp4

---------------------------------------------------------

/**************************************************************
  ETAPE n°2 
 *************************************************************/

IF object_id ('tempdb.dbo.#temp5') IS NOT NULL 
DROP TABLE #temp5
GO

 SELECT * 
 INTO #temp5
 FROM #temp4
 WHERE Title IS NOT NULL
 GO

SELECT * FROM #temp5

 /**************************************************************
  ETAPE n°3 
 *************************************************************/

USE DB_IFOSUP_EXERCICE_TRIG
GO 

DROP TABLE IF EXISTS [dbo].[tbl_cat];
GO

SELECT * 
INTO tbl_cat
FROM #temp5 

 /**************************************************************
  ETAPE n°4 
 *************************************************************/

DROP Table tbl_audit_hr
GO

CREATE TABLE tbl_audit_hr
(
id nvarchar(10),
auditData nvarchar(255)
)
GO

 /**************************************************************
  ETAPE n°5 
 *************************************************************/

SELECT * FROM tbl_cat

 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER tgr_testLength
   ON  Tbl_Cat 
   AFTER INSERT
AS 
BEGIN
       SET NOCOUNT ON;

       DECLARE @length VARCHAR(50)
	   DECLARE @id INT
	   SET @id = (SELECT BusinessEntityID FROM INSERTED)
       SET @length = (SELECT LEN(NationalIDNumber) FROM INSERTED)
	   
    -- Insertion du Trigger
       IF @length > 9
        BEGIN
        UPDATE tbl_cat
		SET NationalIDNumber = 999999999
		WHERE BusinessEntityID = @id
        END
END
GO

 /**************************************************************
  ETAPE n°6 
 *************************************************************/
--SELECT CAST(BirthDate AS CHAR (10))
--FROM tbl_cat

ALTER TABLE tbl_cat
ALTER COLUMN Birthdate VARCHAR(255)
GO 

INSERT INTO tbl_cat(BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, PhoneNumber, name)
VALUES ('291','Mr.','XXXX','XXXX','12345678910','1968-07-
05','M','M','xxxxx@xxxx.com','1111111','Work')

INSERT INTO tbl_cat(BusinessEntityID, Title, FirstName, LastName, NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, PhoneNumber, name)
VALUES ('292','Mr.','XXXX','XXXX','123456','1968-07-
05','M','M','xxxxx@xxxx.com','1111111','Work')

SELECT * FROM tbl_cat ORDER BY BusinessEntityID DESC