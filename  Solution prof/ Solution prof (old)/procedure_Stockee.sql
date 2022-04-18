
/* Procédure stockée */
USE AdventureWorks2017
GO
Select * from [HumanResources].[Department] --DepartmentID, Name, GroupName
Select * from [HumanResources].[Employee]
GO

-- Etape n°1 : j'aime bien sauver mes tables dans un table temporaire #1
IF object_id('tempdb.dbo.#temp1') 
 is not NULL  -- -Ceci m'évitera les Warnings lors de l'exécution du code avec les Tbl.Temporaires
 drop table #temp1
Select BusinessEntityID, NationalIDNumber, LoginID, OrganizationLevel, JobTitle, Birthdate, MaritalStatus, Gender,
HireDate into #temp1 from [HumanResources].[Employee]
Select * from #temp1 -- #temp1 = copie de la table  [HumanResources].[Employee]

-- Etape n°2 : je fais directement la jointure
 --Ceci m'évitera les Warnings lors de l'exécution du code avec les Tbl.Temporaires
IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
Select T.BusinessEntityID, P.Title, P.Firstname, P.Lastname, T.NationalIDNumber, 
T.LoginID, T.OrganizationLevel, T.JobTitle, T.Birthdate, T.MaritalStatus, T.Gender, T.HireDate
into #temp2 from #temp1 T left join [Person].[Person] P on T.BusinessEntityID = P.BusinessEntityID
Select * from #temp2 -- 290 records Select 

-- Création d'une Base de données

IF EXists (Select * from master.sys.databases Where name = 'IFOSUP_EXA_Mike_Bern27032021')
 DROP DATABASE IFOSUP_EXA_Mike_Bern27032021
 GO
 CREATE DATABASE IFOSUP_EXA_Mike_Bern27032021
 GO

 USE IFOSUP_EXA_Mike_Bern27032021
 GO
 Drop table IFOSUP_EXA_Mike_bern
 GO
 Select * into IFOSUP_EXA_Mike_Bern FROM #temp2

 Select * from IFOSUP_EXA_Mike_Bern

 IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
 Select 
BusinessEntityID, Title Titre, Firstname Prenom, Lastname Nom, NationalIDNumber, 
LoginID, OrganizationLevel, JobTitle, 
[Birthdate] as Date_de_naissance, 
MaritalStatus, Gender, HireDate
into #temp3 from  IFOSUP_EXA_Mike_Bern
Select * from #temp3

-- Format date AAAA-MM-DD ==> JJ-MM-AAAA
---   https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4
select BusinessEntityID, Titre, Prenom, Nom, NationalIDNumber, 
LoginID, OrganizationLevel, JobTitle, 
convert(nvarchar, Date_de_naissance, 103) AS Date_de_naissance,
 MaritalStatus, Gender,
convert(nvarchar, HireDate, 103) Date_embauche
  into #temp4 from #temp3     ----  14/01/2009
select * from #temp4 -- Format Latin.

Drop table IFOSUP_EXA_Mike_Bern
Select * into IFOSUP_EXA_Mike_Bern from #temp4
Select * from IFOSUP_EXA_Mike_Bern

-- Procédure stockée
-- Faire passer en paramère 2 dates (début et fin) ==> 2 VARIABLES d'Entrée
-- Le genre (F ou M)  => 1 VARIABLES D'entrée
-- En sortie le nombre de personne qui ont été engagé durant cette période en fonction qu'il soit M ou F ==> EN SORTIE
CREATE PROC spGetEmployesEngagee_Mike_Bern
--   ALTER PROC spGetEmployesEngagee_Mike_Bern

	@gender1 nvarchar(1),  -- genre M ou F
	@annee1 nvarchar(30),   -- HierDate (Date d'embauche)
	@annee2 nvarchar(30),
	@employeeCount INT OUT -- ce paramètre est un paramètre de sortie -> Ma procédure stockée me renvoit quelque chose
						   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
    
AS
 BEGIN
 Print @gender1 -- affichage du genre que je passe en paramètre lors de l'appel de la procédure
 Print @annee1
 Print @annee2
  --Select @employeeCount = COUNT(BusinessEntityID) from Tbl_Employee_Engagee_Michel_Bernair  
  --                       where Gender = @gender1 AND Date_embauche > @annee1  

  Select @employeeCount = COUNT(BusinessEntityID) from IFOSUP_EXA_Mike_Bern 
                      where Gender = @gender1 
					  AND
					 -- SUBSTRING  ((date_embauche), 7,4) > '2009' and SUBSTRING  ((date_embauche), 7,4) < '2012'  
	         SUBSTRING  ((date_embauche), 7,4) > @annee1 and SUBSTRING  ((date_embauche), 7,4) < @annee2 	 
					 
					  -- between '@annee1' and '@annee2'

	 -- je compte le nombre de donnée que j'ai dans la table tbl_Employ....
    --lorsque je fais passer en paramètre d'entrée GENDER
	 -- Le tout est placé dans une variable déclarée au préalable dans ma procédure stockée : @employeeCount
END

-- Appel de la procédure

DECLARE @sexe nvarchar(1)
DECLARE @annee1_hors_proc nvarchar(4),
        @annee2_hors_proc nvarchar(4)
DECLARE @EmployeeTotal_meme_sexe INT 

EXECUTE spGetEmployesEngagee_Mike_Bern 'M', '2009', '2012', @EmployeeTotal_meme_sexe OUTPUT  --,
                                                         -- @PrintText OUTPUT
Select @EmployeeTotal_meme_sexe Nbr_total_employee

Print 'Michel Bernair, voici mon résultat:' + '  ' + cast (@EmployeeTotal_meme_sexe as nvarchar(2))








