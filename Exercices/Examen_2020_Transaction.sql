USE AdventureWorks2017;  
GO 

SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]

SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1
GO

SELECT P.BusinessEntityID, NationalIDNumber, BirthDate, MaritalStatus, Gender, Title, FirstName, LastName 
INTO #temp1
FROM [HumanResources].[Employee] AS H 
INNER JOIN [Person].[Person] AS P
ON P.BusinessEntityID = H.BusinessEntityID
GO

SELECT * FROM #temp1

IF Object_Id('tempdb.#temp2') is not null
DROP table #temp2
GO

SELECT T.*, PP.PhoneNumber, PP.PhoneNumberTypeID
INTO #temp2 
FROM #temp1 AS T
INNER JOIN [Person].[PersonPhone] AS PP
ON PP.BusinessEntityID = T.BusinessEntityID
GO

SELECT * FROM #temp2

IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3

SELECT T.*,PT.Name
INTO #temp3
FROM #temp2 AS T
INNER JOIN [Person].[PhoneNumberType] PT
ON  PT.PhoneNumberTypeId = T.PhoneNumberTypeId
GO

SELECT * FROM #temp3

IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4

SELECT TOP(10) *
INTO #temp4
FROM #temp3 AS T
GO

SELECT * FROM #temp4

IF object_id ('tempdb.dbo.#temp5') is not null drop table #temp5

SELECT BusinessEntityID AS ID, NationalIDNumber AS Numéro_national, CAST (BirthDate AS NVARCHAR) AS Date_de_naissance, MaritalStatus AS Status_marital, Gender AS Sexe, Title AS Titre, FirstName AS Prenom, LastName AS Nom, PhoneNumber AS Numéro_de_téléphone, Name AS Type_telephone
INTO #temp5
FROM #temp4

SELECT * FROM #temp5

---------------------------------------------

DECLARE @dateLimit NVARCHAR(4)
SET @dateLimit = '1900'

	IF @dateLimit = (SELECT  SUBSTRING (CAST (Date_de_Naissance AS NVARCHAR(4)),1,4) AS test
					FROM #temp5 WHERE ID = 5) 

  SELECT 'OK'             
ELSE
SELECT 'non OK'

---------------------------------------------Rollback ne fonctionne pas, la donnée est encodée???------------------------------

DECLARE @error int -- Déclaration de la variable Error du type Int -> parce qu'elle va retourner un nombre qui correspond en fait à une erreur classique
Declare @Date_pivotT nvarchar(4)
SET @Date_pivotT = '1900'
BEGIN TRANSACTION  -- Je commence une Transaction T1
   INSERT #temp300 (Id, Numéro_national, Date_de_Naissance, Status_marital,
	 Sexe, Titre, Prenom, nom, Numéro_de_téléphone, Type_telephone )  
    VALUES ('15','879342154',	'1900-12-31',	'M',	'M', 'Mr', 'Mike', 'Bern', '000-111-2222', 'Work')
	
	IF @Date_pivotT = (Select  substring ( cast (Date_de_Naissance as nvarchar(4)),1,4) as test
					FROM #temp5 where  BusinessEntityID = 15) 
	 BEGIN
	   ROLLBACK TRANSACTION
	   RAISERROR ('Cette entrée n''est pas possible car la personne est née avant 1900',1,1)
	 END

-- Je gère les erreurs comme suit
Gestion_des_erreurs:
If @error <> 0
BEGIN
Rollback TRANSACTION
PRINT  @Error  -- Affiche le numéro de l'erreur, ici 2601
END
If @error =0
BEGIN
COMMIT TRANSACTION
END
select count (*) [Nombre_de_donnees_apres_InSERT] from #temp300  