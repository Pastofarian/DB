
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

 SELECT PP.BusinessEntityID, NationalIDNumber, BirthDate AS [Date_de_naissance], MaritalStatus, Gender, 
 Title, FirstName, LastName 
 INTO #temp1
 FROM [HumanResources].[Employee] HE
 INNER JOIN [Person].[Person] PP
 ON PP.BusinessEntityID = HE.BusinessEntityID

 SELECT * FROM #temp1

 --------------------------------------------------------
IF object_id ('tempdb.dbo.#temp2') IS NOT NULL 
DROP TABLE #temp2
GO

 SELECT T1.*, PhoneNumber, PhoneNumberTypeID
 INTO #temp2
 FROM #temp1 T1
 INNER JOIN Person.PersonPhone P
 ON T1.BusinessEntityID = P.BusinessEntityID

 SELECT * FROM #temp2
 ----------------------------------------------------------

 IF object_id ('tempdb.dbo.#temp3') IS NOT NULL 
DROP TABLE #temp3
GO

 SELECT T2.*, name
 INTO #temp3
 FROM #temp2 T2
 INNER JOIN Person.PhoneNumberType PT
 ON T2.PhoneNumberTypeID = PT.PhoneNumberTypeID

  SELECT * FROM #temp3

/**************************************************************
  ETAPE n°2
 *************************************************************/

IF object_id ('tempdb.dbo.#temp4') IS NOT NULL 
DROP TABLE #temp4
GO

SELECT TOP(10) *
INTO #temp4
FROM #temp3

SELECT * FROM #temp4

/**************************************************************
  ETAPE n°3
 *************************************************************/
DROP TABLE IF EXISTS [dbo].[EXAMEN_REEL_030420201_EX2_Mike_Bern];
GO

 SELECT BusinessEntityID, NationalIDNumber, CAST(Date_de_naissance AS NVARCHAR(10)) Date_de_naissance, MaritalStatus, Gender, 
 Title, FirstName, LastName, PhoneNumber, [name] Type_telephone
 INTO EXAMEN_REEL_030420201_EX2_Mike_Bern
 FROM #temp4 

 SELECT * FROM EXAMEN_REEL_030420201_EX2_Mike_Bern

 /**************************************************************
  ETAPE n°4
 *************************************************************/ 

 		DECLARE @date NVARCHAR(10)
        DECLARE @error int
        SET @error = @@ERROR
        SET @date = '1900'

BEGIN TRANSACTION  

    INSERT EXAMEN_REEL_030420201_EX2_Mike_Bern (BusinessEntityId, NationalIDNumber,
    [Date_de_Naissance], MaritalStatus, Gender, Title, FirstName, LastName, PhoneNumber,
    [Type_telephone] )
    VALUES ('12','879342154', '1850-12-31', 'M', 'M', 'Mr', 'Mike', 'Bern', '000-111-2222',
    'Work')
            IF @date >= (SELECT SUBSTRING(CAST(Date_de_naissance AS NVARCHAR(10)),1,4) AS Date_de_naissance FROM EXAMEN_REEL_030420201_EX2_Mike_Bern WHERE BusinessEntityID = 12)
            
        BEGIN
            ROLLBACK TRANSACTION
            RAISERROR ('Cette entrée n''est pas possible car la personne est née avant 1900',1,1)
        END
  
If @error <> 0
BEGIN
Rollback TRANSACTION
PRINT  @Error  
END
If @error = 0
BEGIN
COMMIT TRANSACTION
END