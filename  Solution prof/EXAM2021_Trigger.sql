
/* 
3 type de vaccins contre le COVID19 sont : AstrZeneca, Moderna, Pfizer-BioNTech
Ces 3 types de vaccin peuvent �tre admiistr� en fonction de l'�ge de la personne.
Nous construirons une table qui reprend le r�f�rentiel Vaccin fonction de la plage d'�ge dans laquelle la personne s'y trouve.

*/


-- Etape n�1
------------
-- Veuillez cr�er la base de donn�es comme suite, � l'�ffigie de nom et pr�nom :
-- C'est-�-dire : EXAMEN_REEL_030420201_Prenom_Nom
-- On testera l'existance de la base de donn�es

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_REEL_03042021_Mike_Bernair')
 DROP DATABASE EXAMEN_REEL_03042021_Mike_Bernair  -- Quelque soit la situation de la table, je la vide ! 
 GO
 CREATE DATABASE EXAMEN_REEL_03042021_Mike_Bernair  -- Je la recr�e � nouveau une nouvelle table
 GO
USE EXAMEN_REEL_03042021_Mike_Bernair
GO

-- Etape n�2 : Cr�ation de la table Vaccin & test de l'existence de la  -> Premi�re solution
---------------------------------------------------------------------------------------------

USE EXAMEN_REEL_03042021_Mike_Bernair  -- utilisation de la DB
 IF EXISTS (SELECT * FROM tbl_vaccin.sys.tables WHERE name = 'tbl_vaccin')
 DROP TABLE T_CURSOR
GO

-- Deuxi�me solution pour nous �viter les Warning 
---> Le code sera : IF OBJECT_ID ('tbl_vaccin', 'U') is not null drop table tbl_vaccin

CREATE Table Tbl_vaccin
(
�ge INT IDENTITY (1,1),
Type_Vaccin nvarchar(30),
ROWID uniqueidentifier
)
GO
Select * from Tbl_vaccin   -- la table Tbl_vaccin est vide � ce stade

-- Etape n�3 : "Populer", ins�rer 100 lignes des donn�es dans cette table en fonction de l'�ge
--              avec la commande Go de Microsoft SQL Server
-----------------------------------------------------------------------------------------------
GO
INSERT INTO Tbl_vaccin
 (ROWID) VALUES (NEWID())
 GO 100                           -- Autoincr�mentation
Select * from Tbl_vaccin       -- A ce stade, nous avons 100 lignes, num�rot� de 1 � 100

-- Etape n�4
-------------------------------------------------------------------------
-- En fonction de l'�ge, la valeur du champ Vaccin selon la tranche d'�ge
-- La tranche d'�ge >= 70 ==> Nous administrerons le vaccin : AstraZeneca 
-- La tranche d'�ge de 51 < x < 70  Nous administrerons le vaccin :Moderna
-- La tranche d'�ge =< 50 ==> Nous administrerons le vaccin : Pfizer-BioNTech
-- Algorithme : WHILE ....BETWEEN....
-- Pour les 3 tranches d'�ges, vous pouvez factoriser 3 fois le code pour chaque tranche d'�ge

/*** -- Pour supprimer le contenu d'une table uniquement mais la table, sa structure continue a exister !

Truncate table Tbl_vaccin 
 GO
 INSERT INTO Tbl_vaccin
 (ROWID) VALUES (NEWID())
 GO 100
 Select * from Tbl_vaccin     

***************************************************************/

-- Remplir la table Vaccin en fonction de l'�ge en tenant compte des 3 tranches d'�ge


GO
-- On va boucler 3 fois : 
-- Tranche d'�ge =< 50  (50 ans inclus)
		 DECLARE @num1 INT = 1;
		 DECLARE @type1 as nvarchar(30)
		 SET @type1 = 'Pfizer-BioNTech'
		 WHILE @num1 < 51
		   BEGIN
		   UPDATE tbl_Vaccin    
			SET [Type_Vaccin] = 'Pfizer-BioNTech'
			WHERE �ge BETWEEN '1' AND '50'
			   PRINT ('Insertion de donn�es' + ' ' + @type1  + 'pour la tranche d''�ge n�: ' + cast (@num1 as nvarchar(10)) + ' ' + 'an')
			SET @num1 = @num1 + 1;
		 END

		Select * from Tbl_vaccin
		 GO
		-- Deuxi�me tranche d'�ge > 50 - < 70
		 DECLARE @num2 INT = 51;
		 DECLARE @type2 as nvarchar(30)
		 SET @type2 = 'Moderna'
		 WHILE @num2 < 70
		  BEGIN
		   UPDATE tbl_Vaccin
			SET [Type_Vaccin] = 'Moderna'
			WHERE �ge BETWEEN '51' AND '69'
			  PRINT ('Insertion de donn�es' + ' ' + @type2  + 'pour la tranche d''�ge n�: ' + cast (@num2 as nvarchar(10)) + ' ' + 'an')
			SET @num2 = @num2 + 1;
		 END
		 Select * from Tbl_vaccin
		 GO
		 -- Troisi�me tranche d'�ge >= 70 ans (70 ans inclus)
		 DECLARE @num3 INT = 70;
		 DECLARE @type3 as nvarchar(30)
		 SET @type3 = 'AstrZeneca'
		 WHILE @num3 < 101
		  BEGIN
		   UPDATE tbl_Vaccin
			SET [Type_Vaccin] = 'AstrZeneca'
			WHERE �ge BETWEEN '70' AND '100'
			   PRINT ('Insertion de donn�es' + ' ' + @type3  + 'pour la tranche d''�ge n�: ' + cast (@num3 as nvarchar(10)) + ' ' + 'an')
			SET @num3 = @num3 + 1;
		 END
		 Select * from Tbl_vaccin


GO
Select * from Tbl_vaccin
GO

--- Etape n�5 : copie de la table Tbl_vaccin vers une table temporaire
--  Et test de l'existence des tables temporaires
-----------------------------------------------------------------------
 IF object_id ('tempdb.dbo.#temp1') is not null drop table #temp1
 Select �ge, Type_Vaccin into #temp1 from  Tbl_vaccin
 GO
IF OBJECT_ID ('tbl_vaccin', 'U') is not null drop table tbl_vaccin
Select * into tbl_vaccin from #temp1
GO
Select * from tbl_vaccin  -- Table de r�f�rence des tranches d'�ge associ�e aux diff�rents vaccins
GO


/*  ECRIRE un TRIGGER
Veuillez tester 3 patients pour les 3 tranches d'�ges �voqu�s : 
La contrainte m�tier voudrait que lorsque l'on ins�re une personne, entend par l� un nouveau patient, dans une table tbl_ en fonction de son �ge,
elle lui attribuera automatiquement le bon vaccin associ� � sa tranche d'�ge.

Tranche d'�ge :
* Plus petit que < 50 -> le patient se verra attribu� le vaccin de type Pfizer-BioNTech
* Plus grand que 51- 69 -> le patient se verra attribu� le vaccin de type Moderna
* plus grand que 70 - 100 -> le patient se verra attribu� le vaccin de type AstraZeneca 
*/

-- Etape n�6 : 
-- Sur la base de l'exercice n�1 (proc�dure stock�e), veuillez reprendre la table Tbl_Proc_Mike_bern 
--  qui est une jointure des 2 tables [HumanResources].[Employee] et [Person].[Person]
--  Faire le test de l'existence des tables temporaires si vous deviez � nouveau reconstruire ces tables r�sultantes.

----------------------------------------------------------------------------------------------------


USE Adventureworks2017
GO
-- Etape n�1 : j'aime bien sauver mes tables dans un table temporaire #1
IF object_id('tempdb.dbo.#temp1') 
 is not NULL  -- -Ceci m'�vitera les Warnings lors de l'ex�cution du code avec les Tbl.Temporaires
 drop table #temp1
Select BusinessEntityID, NationalIDNumber, LoginID, OrganizationLevel, JobTitle, Birthdate, MaritalStatus, Gender,
HireDate into #temp1 from [HumanResources].[Employee]
Select * from #temp1 -- #temp1 = copie de la table  [HumanResources].[Employee]
GO

-- Etape n�2 : je fais directement la jointure
 --Ceci m'�vitera les Warnings lors de l'ex�cution du code avec les Tbl.Temporaires
IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
Select T.BusinessEntityID, P.Title, P.Firstname, P.Lastname, T.NationalIDNumber, 
T.LoginID, T.OrganizationLevel, T.JobTitle, T.Birthdate, T.MaritalStatus, T.Gender, T.HireDate
into #temp2 from #temp1 T left join [Person].[Person] P on T.BusinessEntityID = P.BusinessEntityID
Select * from #temp2 -- 290 records Select 
GO

IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
Select TOP(10) BusinessEntityID ID, Title titre, Firstname Prenom, Lastname Nom,
NationalIDNumber numero_national, Birthdate Date_naissance, Gender Genre
into #temp3 from #temp2 order by Nom ASC
Select  * from #temp3
GO

-- Etape n�7 : 
-- Reprendre votre base de donn�e
USE EXAMEN_REEL_03042021_Mike_Bernair
GO
IF OBJECT_ID ('Tbl_Trig_Mike_Bern', 'U') is not null drop table Tbl_Trig_Mike_Bern
Select * into Tbl_Trig_Mike_Bern from #temp3
Select * from Tbl_Trig_Mike_Bern
-------------------------------------------


/*
/*

Select * from tbl_mike_bern
drop table #temp20
Select YEAR (cast ([Date_naissance]) as date) as test , * 
into #temp20
from tbl_mike_bern
Select * from #temp20

-- R�f�rence pour la comparaison entre 2 dates : DATEDIFF
https://docs.microsoft.com/en-us/sql/t-sql/functions/datediff-transact-sql?view=sql-server-ver15
-- On pensera � prendre la date du jour repr�sent�e par la fonction GETDATE()
drop table #temp21
Select DATEDIFF (year, date_naissance, GETDATE() ) as [�ge], *
into #temp21 from #temp20
Select * from #temp21

*/

/***********************************
* Etape final avant le TRIGGER !
***********************************/
Select * from tbl_mike_bern
-- Selection uniquement de champs suivants :
--  id, titre, Prenom, Nom, numero_national, Date_naissance, genre
GO
IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
Select id, titre, Prenom, Nom, numero_national, Date_naissance, genre into #temp2 from tbl_mike_bern
Select * from #temp2

*/


-- Etape n�8 : 
-- Veuillez ajouter le champ [Type_vaccin] de type nvarchar(30) � la table Tbl_Trig_Mike_Bern
-- 

IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4
Select * into #temp4 from #temp3
Select * from #temp4
GO
ALTER TABLE #temp4 ADD [vaccin] nvarchar(30)
GO
Select * from #temp4
GO
Drop table Tbl_Trig_Mike_Bern 
IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
Select id, titre, Prenom, Nom, numero_national, Date_naissance, genre, vaccin
 into Tbl_Trig_Mike_Bern from #temp4
 GO
Select * from Tbl_Trig_Mike_Bern
GO

-- Calcul de l'�ge avec la fonction DATEDIFF
-- 
IF object_id ('tempdb.dbo.#temp5') is not null drop table #temp5
Select id, titre, Prenom, Nom, numero_national,Date_naissance,DATEDIFF (year, date_naissance, GETDATE() ) as [�ge], genre, [vaccin]
into #temp5 from Tbl_Trig_Mike_Bern
Select * from #temp5   -- le nouveau champ �ge a �t� ins�r� � ce stade du code SQL
GO
-- En dur avant le TRIGGER : 
drop table tbl_Trig_mike_bern
Select * into tbl_Trig_mike_bern from #temp5
GO
Select * from tbl_Trig_mike_bern
GO

-- LEs 2 tables pour construire le Trigger
Select * from tbl_Trig_mike_bern
Select * from tbl_vaccin

CREATE TRIGGER tr_Vaccin_For_INSERT
  ---       ALTER TRIGGER tr_Vaccin_For_INSERT
  -- DROP TRIGGER IF EXISTS  tr_Vaccin_For_INSERT
 ON tbl_Trig_mike_bern
 FOR INSERT 
 --AFTER INSERT 
 AS
 BEGIN                       -- Inserted est une table que le Trigger utilise uniquement dans son contexte
                             -- J'aurai pu avoir une table qui reprenne l'ensemble de mes insertions
							 -- que l'on nomme Audit (cfr.Etape n�2) -> tbl_employee_salary_audit
     --Select * From inserted  -- sur de ce qui a �t� ins�r�

	 -- Je peux aller chercher l'ID de ce qui a �t� ins�r�
	 Declare @id_tr INT
	 Declare @age_tr INT
	 Declare @vaccin_tr nvarchar(30)
	 
	 SELECT @Id_tr = id, @age_tr = �ge, @vaccin_tr = vaccin FROM Inserted
	 
	 -- Je veux une copie dans une autre table de ce qui a �t� ins�r�e > table tbl_employee_salary_audit
	 
	 ---IF (select distinct �ge from Inserted where id = @id_tr) <= 50
	 IF (select distinct �ge from Inserted where �ge = @age_tr)  <= 50
	  BEGIN
	    UPDATE tbl_Trig_mike_bern
   	   SET [vaccin] = (select TOP(1) Type_Vaccin from Tbl_vaccin where �ge <= 50 and id = @id_tr )  
		
	 END

	-- IF (select �ge from Inserted where id = @id_tr) > 50 and (select �ge from Inserted where id = @id_tr) < 70
   IF (select �ge from Inserted where �ge = @age_tr) > 50 and (select �ge from Inserted where �ge = @age_tr) < 70
	  BEGIN
	   UPDATE tbl_Trig_mike_bern
		SET [vaccin] = (select TOP(1) Type_Vaccin from Tbl_vaccin where �ge > 50 and �ge < 70 and id = @id_tr )
		
	  END

	 ----IF (select distinct �ge from Inserted where id = @id_tr) >= 70
	  IF (select distinct �ge from Inserted where �ge = @age_tr) >= 70
	  BEGIN
	    UPDATE tbl_Trig_mike_bern  -- distinct
		SET [vaccin] = (select distinct Type_Vaccin from Tbl_vaccin where �ge >= 70 and id = @id_tr )	
			 
	 END

END -- Fin du Trigger


---  TEST au niveau des dates pour la tranche d'�ge   ---------------------------------------
select distinct Type_Vaccin from Tbl_vaccin where �ge >= '70' and id = 70
Select * from tbl_vaccin

select distinct Type_Vaccin from Tbl_vaccin where �ge > '50' and
   �ge < '70'  ---- Me donnera uniquement le vaccin Moderna dans cette tranche d'�ge!
---------------------------------------------||----------------------------------------------





----id, titre, Prenom, Nom, numero_national,Date_naissance,[�ge], genre, [Type_vaccin]
 
 Select * from tbl_Trig_mike_bern

  -- TRUNCATE TABLE tbl_employee_salary_audit
 DELETE FROM tbl_Trig_mike_bern WHERE id in (1000,1001,1002,1003,1004,1005,1006,1007)

 --< Plus petit que 50 
 USE EXAMEN_REEL_03042021_Mike_Bernair
  GO
 Select * from tbl_Trig_mike_bern
 
 GO
 INSERT into tbl_Trig_mike_bern
 values ('1000','Mr.','Mike', 'Bern','658797007','1960-01-21','25','M','')
  Select * from tbl_Trig_mike_bern 

-- Plus grand que >=50 et <= 69 ans 
  INSERT into tbl_Trig_mike_bern
 values ('1001','Mr.','John', 'Young','00000007','1959-03-11','62','M','')
 Select * from tbl_Trig_mike_bern

-- Plus grand que 70 ans 
 INSERT into tbl_Trig_mike_bern
 values ('1002','Ms.','Janne', 'Calment','658797007','1900-01-01','121','F','')
 Select * from tbl_Trig_mike_bern
