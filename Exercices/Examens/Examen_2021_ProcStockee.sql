USE AdventureWorks2017;  
GO 

SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]

SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

SELECT Top(10) H.BusinessEntityID ID, 
CASE Gender
    WHEN 'M'THEN 'Mr.'
    WHEN 'F'THEN 'Ms.'
END AS titre, Firstname Prenom, Lastname Nom,
NationalIDNumber numero_national, 
CASE PhoneNumberTypeID
    WHEN '1' THEN 'Tel.travail'
    WHEN '2' THEN 'GSM'
    WHEN '3' THEN 'Tel.Maison'
END AS Type_telephone, PhoneNumber n_telephone,
LoginID, JobTitle Titre_Job, Birthdate Date_naissance, MaritalStatus Status_marital, Gender Genre, HireDate Date_embauche
INTO #temp1 
FROM [HumanResources].[Employee] AS H 
INNER JOIN [Person].[Person] AS P
ON P.BusinessEntityID = H.BusinessEntityID
INNER JOIN [Person].[PersonPhone]
ON P.BusinessEntityID = PersonPhone.BusinessEntityID
--LEFT JOIN [Person].[PhoneNumberType]
--ON PersonPhone.BusinessEntityID = PhoneNumberType.PhoneNumberTypeID
GO

SELECT * FROM #temp1  --290 lignes

UPDATE #temp2
SET LoginID = ''; -- ou doit créer une table et SET LoginID = NULL; car #temp1 n'accepte pas NULL

SELECT RIGHT(Prenom, 5) AS 'First Name'  
FROM #temp1 
WHERE BusinessEntityID < 5  
ORDER BY FirstName;  
GO  

IF OBJECT_ID('tempdb.dbo.#temp2') IS NOT NULL DROP TABLE #temp2

SELECT id,titre, Prenom, Nom,
SUBSTRING(Prenom,1,1) AS C1, RIGHT(Nom,2) AS C2,                       -- 2 derniers caractères les plus à droite du nom
numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche
INTO #temp2 from #temp1
GO

Select * from #temp2

 IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
Select TOP(9) * into #temp3 from #temp2
Select * from #temp3

INSERT INTO #temp3 (id,titre, Prenom, Nom, numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche) 
  VALUES ('1000','Mr.','Mike','Bern','','','','Informaticien','','','M','')
-- Remarque importante pour l'insertion de votre identité dans la table: 
--  Laisser la valeur à blanc pour tous les champs autres que ceux ID, titre, prenom, nom, titre_job
Select * from #temp3

drop table #temp4
GO
  IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4
 Select id,titre, Prenom, Nom,
  substring(Prenom,1,1) as C1, RIGHT(Nom,2) AS C2,                       -- 2 derniers caractères les plus à droite du nom
 numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche
 into #temp4 from #temp3
 GO

 Select * from #temp4

 GO
IF object_id ('tempdb.dbo.#temp5') is not null drop table #temp5
 Declare @point as nvarchar(1)
 set @point = '.' 
Select id,titre, Prenom, Nom, numero_national, type_telephone, LoginId = CONCAT (prenom, '.', Nom, @point,C1, C2,'@ifosupwavre.be'),
 titre_job, Date_naissance,Status_marital, Date_embauche 
 into #temp5 from #temp4
Select * from #temp5

CREATE PROC spLoginID_Mike_Bern
	@id_proc int,   -- 1000
	@prenom_proc nvarchar(30) OUT,
 	@nom_proc nvarchar(30) OUT,  
	@loginId_proc nvarchar(30) OUT
    AS
 BEGIN   -- 
			--SET @id_proc = (Select loginID FROM tbl_Mike_Bern 
			--WHERE Genre = @genre_proc ) -- Lecture de la table
			SET @loginID_proc = (Select loginID FROM #temp5 
			WHERE id = @id_proc )   
			SET @nom_proc = (Select nom FROM #temp5 
			WHERE id = @id_proc ) -- Lecture de la table
			SET @prenom_proc = (Select prenom FROM #temp5 
			WHERE id = @id_proc ) -- Lecture de la table
	
 END

 GO
Declare @ID1 nvarchar(30)
Declare @prenom1 nvarchar(255)
Declare @nom1 nvarchar(255) 
Declare @loginID1 nvarchar(30) 
EXEC [spLoginID_Mike_Bern] 1000,  @prenom1 output, @nom1 output, @loginID1 output        ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
Print ' Affichage de votre Nom et Prenom'
Print '---------------------------------'
PRINT GETDATE()
Print @nom1 + '  ' + @prenom1 + ' ' + @loginID1 -----cast( @Date_et_Heure1 as nvarchar(30))
Select @nom1 as nom, @prenom1 as prenom, @loginID1 as login
