/*
 Ecrire une procédure stockée
*/

USE AdventureWorks2017
GO
Select * from [HumanResources].[Department] --DepartmentID, Name, GroupName
Select * from [HumanResources].[Employee]
GO


/*****************
  ETAPE n°1 
*****************/

-- Etape n°1a : j'aime bien sauver mes tables dans un table temporaire #1
IF object_id('tempdb.dbo.#temp1') 
 is not NULL  -- -Ceci m'évitera les Warnings lors de l'exécution du code avec les Tbl.Temporaires
 drop table #temp1
Select BusinessEntityID, NationalIDNumber, LoginID, OrganizationLevel, JobTitle, Birthdate, MaritalStatus, Gender,
HireDate into #temp1 from [HumanResources].[Employee]
Select * from #temp1 -- #temp1 = copie de la table  [HumanResources].[Employee]
GO
-- Etape n°1b : je fais directement la jointure
 --Ceci m'évitera les Warnings lors de l'exécution du code avec les Tbl.Temporaires
IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
Select T.BusinessEntityID, P.Title, P.Firstname, P.Lastname, T.NationalIDNumber, 
T.LoginID, T.OrganizationLevel, T.JobTitle, T.Birthdate, T.MaritalStatus, T.Gender, T.HireDate
into #temp2 from #temp1 T left join [Person].[Person] P on T.BusinessEntityID = P.BusinessEntityID
Select * from #temp2 -- 290 records Select 
GO
-- Etape n°1c : Renommage des champs
IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
Select BusinessEntityID ID, Title titre, Firstname Prenom, Lastname Nom,
NationalIDNumber numero_national, LoginID, JobTitle Titre_Job, Birthdate Date_naissance, MaritalStatus Status_marital, Gender Genre,
HireDate Date_embauche
into #temp3 from #temp2
Select * from #temp3
GO
-- Etape°1.d --> Jointure avec les tables de téléphone
USE AdventureWorks2017
GO
Select * from [Person].[PersonPhone]
Select * from [Person].[PhoneNumberType]
GO
-- Etape n°1.e  --> Jointure avec [Person].[PersonPhone]
IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4
Select P.PhoneNumber, P.PhoneNumberTypeID,  T.*
 into #temp4 from [Person].[PersonPhone] P inner join #temp3 T on 
 T.Id = P.BusinessEntityID
 Select * from #temp4
 GO
-- Etape n°1.f --> Jointure avec [Person].[PhoneNumberType]
IF object_id ('tempdb.dbo.#temp5') is not null drop table #temp5
Select P.Name,  T.*
 into #temp5 from [Person].[PhoneNumberType] P inner join #temp4 T on 
 T.PhoneNumberTypeId = P.PhoneNumberTypeId
 Select * from #temp5
GO
-- Etape n°1.g  --> Copie de la table temporaire 
IF object_id ('tempdb.dbo.#temp6') is not null drop table #temp6
Select Name Type_telephone, PhoneNumber n_telephone, PhoneNumberTypeID, ID, titre, Prenom, Nom, numero_national, LoginID, Titre_job, Date_naissance, Status_marital,Genre, Date_embauche
 into #temp6 from #temp5
 Select * from #temp6
 
 GO

 
 /********************** 
        Etape n°2
 **********************/
 -- CASE WHEN
 -- Changement de CELL => GSM.Perso 
 --               HOME => Tel.Perso
 --               Work => Tel.Travail
IF object_id ('tempdb.dbo.#temp7') is not null drop table #temp7
DECLARE @WORK nvarchar(50)
SET @WORK = 'Tel.Travail'
Select ID, titre =
CASE Genre
 WHEN  'M' THEN 'Mr.'
  ELSE 'Ms.' 
   END 
, Prenom, Nom, numero_national, Type_telephone = 
CASE Type_telephone
 WHEN 'Work' THEN 'Tel.Travail'
 WHEN 'Cell' THEN 'GSM'
 WHEN 'Home' THEN 'Tel.Maison'
END , 
 n_telephone, LoginID, Titre_job, Date_naissance, Status_marital,Genre, Date_embauche
 into #temp7 from #temp6
 Select * from #temp7

 /*****************
  ETAPE n°3

 *************/

-- Ne prendre que les 9 premiers enregistrements
 IF object_id ('tempdb.dbo.#temp8') is not null drop table #temp8
 Select TOP (9) * into #temp8 FROM #temp7
 Select * from #temp8
 GO
 
 /**************************************************************
  ETAPE n°4 - Mettre à blanc le contenu du champ LoginID3
 *************************************************************/
 
 -- Effacer le champ LoginID pour le reconstituer.
  IF object_id ('tempdb.dbo.#temp9') is not null drop table #temp9
  GO
 Select ID, titre, Prenom, Nom, numero_national,Type_telephone,n_telephone,
 LoginID = 
 CASE LoginID
  WHEN 'adventure%' THEN ''
 END
 ,Titre_job, Date_naissance, Status_marital,Genre, Date_embauche
 into #temp9 from #temp8
 Select * from #temp9   -- Le champs LoginID is NULL -- Ne prendre que les 9 premiers enregistrements
 GO
  IF object_id ('tempdb.dbo.#temp10') is not null drop table #temp10
  Select * into #temp10 from #temp9
  Select * from #temp10


 /**************************************************************
  ETAPE n°5 - Veuillez insérer vos propre coordonnées sauf pour le prénom et le nom
   Laissez à blanc le champ loginID à vide.
 *************************************************************/

GO
 INSERT INTO #temp10 (id,titre, Prenom, Nom, numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche) 
  VALUES ('1000','Mr.','Mike','Bern','','','','Informaticien','','','M','')
-- Remarque importante pour l'insertion de votre identité dans la table: 
--  Laisser la valeur à blanc pour tous les champs autres que ceux ID, titre, prenom, nom, titre_job
Select * from #temp10

 /******************************************************************************
     Ecrire une procédure stockée qui doit :
     Afficher non seulement votre Prenom, nom suivi de votre numéro Titre_job
 *******************************************************************************/

 /*

 -- Tester la longueur d'un champ
 drop table #temp11
 Select id,titre, Prenom, Nom,
 LEN(Prenom) AS L1_Prenom, LEN(Nom) AS L2_Nom, 
 numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche
 into #temp11 from #temp10

 Select * from #temp11

 */
 -- Aller lire le  1Premier champ du prenom 

 -- https://docs.microsoft.com/fr-fr/sql/t-sql/functions/right-transact-sql?view=sql-server-ver15
 GO
  IF object_id ('tempdb.dbo.#temp11') is not null drop table #temp11
 Select id,titre, Prenom, Nom,
  substring(Prenom,1,1) as C1, RIGHT(Nom,2) AS C2,                       -- 2 derniers caractères les plus à droite du nom
 numero_national, type_telephone,LoginId,Titre_job, Date_naissance,Status_marital,Genre,Date_embauche
 into #temp11 from #temp10
 GO
 Select * from #temp11

 --Dans une table en dur avec
 GO
 IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_REEL_03042021_EX1_Mike_Bernair')
 DROP DATABASE EXAMEN_REEL_03042021_EX1_Mike_Bernair -- Quelque soit la situation de la table, je la vide ! 
 GO
 CREATE DATABASE EXAMEN_REEL_03042021_EX1_Mike_Bernair -- Je la recrée à nouveau une nouvelle table
 GO

 USE EXAMEN_REEL_03042021_EX1_Mike_Bernair
 GO
  IF EXISTS ('tbl_Mike_Bern') is not null drop table tbl_mike_bern
Select * into tbl_mike_bern from #temp11
Select * from tbl_mike_bern
GO



/* Construction de l'email *
   nom.prenom_numero_national@ifosup.wavre.be
*/

-- Je souhaite vontairement que la loginID
-- Prendre 
-- LoginId
--    Première lettre et dernier lettre du prénom de votre nom
--    Savoir le longueur de votre Prénom et sur cette base là....
--    Exemple : ifosup.wavre\KN.nom

--  https://docs.microsoft.com/fr-fr/sql/t-sql/functions/concat-transact-sql?view=sql-server-ver15


-- 
GO
Select * from tbl_Mike_bern
GO
IF object_id ('tempdb.dbo.#temp12') is not null drop table #temp12
 Declare @point as nvarchar(1)
 set @point = '.' 
Select id,titre, Prenom, Nom, numero_national, type_telephone, LoginId = CONCAT (prenom, '.', Nom, @point,C1, C2,'@ifosupwavre.be'),
 titre_job, Date_naissance,Status_marital, Date_embauche 
 into #temp12 from tbl_mike_bern
Select * from #temp12
 
 GO
IF OBJECT_ID ('tbl_Mike_Bern', 'U') is not null drop table tbl_mike_bern
Select * into tbl_mike_bern from #temp12
Select * from tbl_mike_bern
GO

CREATE PROC spLoginID_Mike_Bern
--   ALTER PROC spLoginID_Mike_Bern
 	
---	@genre_proc nvarchar(1),  -- genre M ou F 
	@id_proc int,   -- 1000
	@prenom_proc nvarchar(30) OUT,
 	@nom_proc nvarchar(30) OUT,  -- Ce paramètre est un paramètre de sortie -> Ma procédure stockée me renvoit quelque chose
						   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
	@loginId_proc nvarchar(30) OUT
    
AS
 BEGIN   -- 
			--SET @id_proc = (Select loginID FROM tbl_Mike_Bern 
			--WHERE Genre = @genre_proc ) -- Lecture de la table
			SET @loginID_proc = (Select loginID FROM tbl_Mike_Bern 
			WHERE id = @id_proc )   
			SET @nom_proc = (Select nom FROM tbl_Mike_Bern 
			WHERE id = @id_proc ) -- Lecture de la table
			SET @prenom_proc = (Select prenom FROM tbl_Mike_Bern 
			WHERE id = @id_proc ) -- Lecture de la table
	
 END

---Declare @Mon_nom_prenom1 nvarchar(255) 
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


