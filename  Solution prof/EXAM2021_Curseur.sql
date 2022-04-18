USE [AdventureWorks2017]


/************************************************************************************************************
  CURSEUR dans un Curseur qui liste les personnes qui ont été vaccinés
 F et M
 
-- Dans le cadre de la vaccination du COVID19, une campagne a été mise en place.
-- Questionnaire A --> Prendre uniquement les personnes qui sont nées avant 1969
-- Questionnaire B --> Prendre uniquement les perosnnes qui ont née après 1969

-- On remarque que la colonne Gender est NULL et donc il convient de la compléter en fonction du Gender.
-- si Gender : M alors Ms ou Mr.
***********************************************************************************************************/



Select * from [dbo].[tbl_employee] -- firstname, Lastname, birthdate, Gender  -- 290 personnes

GO
drop table #temp1
Select * into #temp1 from  [dbo].[tbl_employee]
Select * from #temp1 -- 290 records

/*
IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1

*/

drop table #temp2
declare @Mr as varchar(3) 
declare @Ms as varchar(3)

SET @Mr = 'Mr.'
SET @Ms = 'Ms.'
Select BusinessEntityId, Firstname Prenom, Lastname Nom, 
CASE
 WHEN Gender = 'M' THEN @Mr
  ELSE @Ms
 
   END 
  Title,
Birthdate [Date_de_naissance], Gender 
into #temp2 from #temp1

Select * from #temp2  -- populate  2

-- Création de la base de donnée

 IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_Mike_Bernair')
 DROP DATABASE EXAMEN_Mike_Bernair -- Quelque soit la situation de la table, je la vide ! 
 GO
 CREATE DATABASE EXAMEN_Mike_Bernair  -- Je la recrée à nouveau une nouvelle table
 GO


USE EXAMEN_Mike_Bernair 
Drop table tbl_Mike_Bernair_Employee
Select * into tbl_Mike_Bernair_Employee from #temp2
  Select * from #temp2 


drop table #temp3
Select * into #temp3 from tbl_Mike_Bernair_Employee 
ALTER Table #temp3 add Rappel_Vaccin varchar(1)

Select * from #temp3

Drop table #temp4
Select * into #temp4 from #temp3

Select * from #temp4   -- RappelVaccin

-- Dans une table en DUR
Drop table tbl_Mike_Bernair_EmployeeBIS
Select * into tbl_Mike_Bernair_EmployeeBIS from  #temp4

Select * from tbl_Mike_Bernair_EmployeeBIS


-- Prendre que les 10 premières valeurs

Drop table #temp5
Select TOP (10) * into #temp5 from tbl_Mike_Bernair_EmployeeBIS
Select * from #temp5

drop table tbl_Mike_Bernair_EmployeeBIS
Select * into tbl_Mike_Bernair_EmployeeBIS from #temp5
Select * from tbl_Mike_Bernair_EmployeeBIS



/*******************************************************************************
  -- Création d'une table des gens qui ont été vaccinés sur les 15 premmiers  --
*/

-- http://axway.cluster013.ovh.net/ifosup_5IBD3-1/db/download/GO_SQL_student_MB.pdf
-- Page 25 / 26 -> pour Exemple
CREATE TABLE tbl_IdVaccin
( 
BusinessEntityID INT IDENTITY (1,1),
Vaccin nvarchar(1),
ROWID uniqueidentifier
)

/*
 Creation de la table des personnes qui ont eu un VACCIN... une personne sur 2
*/
Select * from tbl_IdVaccin
GO
INSERT INTO Tbl_IdVaccin
 (ROWID) VALUES (NEWID())
 GO 10


 -- J'ai mes 10 valeurs : NULL et x
Select * from tbl_IdVaccin

-- Populate ces 10 champs
-- Si pair => 1, sinon impair 0
--   populate la table des vaccins sur 20 valeurs
 DECLARE @num INT = 1;
 DECLARE @j INT

 WHILE @num < 11
  BEGIN
   UPDATE tbl_IdVaccin
    SET [Vaccin] = 'x'
    WHERE [BusinessEntityID] = @num
    PRINT ('Insertion de données' + ' ' + 'Pour le BusinessEntityID n°: ' + cast (@num as nvarchar(10)))
    SET @num = @num + 2;
 END

 Select * from tbl_IdVaccin

-- Les 'x' sont ceux qui ont été vaccinés
-- Les autres ayant NULL ne l'on pas été.

/*
  ECRIRE un curseur qui met à jour la table 
*/

-- Mise à jour du fichier Table
-- A la ecture de la table des personnes ayant été vacciné, flag au niveau du champ Vaccin, les autres ayant un champ égale à NULL
-- Par un curseur veuillez aller lire les 2 tables simultanées.
-- Il s'agit ici d'aller d'inclure un curseur dans un autre curseur.
-- La condition est la suivante : pour un vaccin, on mettra la valeur OK si le champ vaccin de la table tbl_IdVaccin
-- est nulle.

 -- Curseur va parcourir chaque ligne de la table et va modifier la ligne lorsqu'il rencontrera Microsoft ou Amazon
 -- en leur augmentant leur action boursière

 -- CE QUE L'ON VA DEVOIR METTRE A JOUR, c'est 
 -- 2, 4, 6, 8 ,10


 /******************************
 
  * Déclaration de mon curseur  *

 **************************************/


 --
Select * from [dbo].[tbl_IdVaccin]
Select * from [dbo].[tbl_Mike_Bernair_EmployeeBIS]


 -- Début des déclarations des curseurs

DECLARE @a INT,            -- BusinessEntityId - - 2 valeurs qui vont récupérer le contenu des mes enregistrements de chaque ligne
        @b nvarchar(50),   -- prenom
		@c nvarchar(50),   -- nom
		@d varchar(3),     -- Title
		@e date,           -- Date
		@f nvarchar(1),    -- Gender
		@g varchar(1)      -- Rappel_Vaccin
 DECLARE @test1 int
 
 DECLARE cur1 CURSOR FOR (Select BusinessEntityId, Prenom, Nom, Title, Date_de_naissance, Gender, Rappel_Vaccin 
                           from [dbo].[tbl_Mike_Bernair_EmployeeBIS])
 OPEN cur1 -- initialisation de mon curseur
 PRINT ' '
 PRINT 'Ce curseur montre que l''on peut modifier en cours de lecture les lignes d''enregistrement'
 PRINT ' '
 
 FETCH cur1 INTO @a, @b, @c, @d, @e, @f, @g
  SET @test1 = @a
  WHILE @@FETCH_STATUS = 0  -- Tant que l'on n'est pas à la fin de la table, la variable @@fetch_status prendra toujours
                            -- la valeur 0, on boucle
							-- A la fin de la table, cette valeur prend 1 et on sort de la boucle WHILE
  BEGIN  -- BEGIN 1
	PRINT 'Hello le premier curseur'
	--Select @a as [BusinessEntityId], @b Prenom, @c Nom, @d Title, @e [Date_de_naissance], @f Gender, @g [Rappel_Vaccin]
	PRINT 'n°: ' + cast(@a as nvarchar(10)) + ' ' + 'Le nom est: ' + @b + ' ' + 'Le prenom: ' + @c

	/* Nouveau Curseur n°2*/

	Declare cur2 CURSOR FOR (Select BusinessEntityId, Vaccin from tbl_IdVaccin )
	                                                                 
	Declare  @c1 INT,
	         @c2 nvarchar(1),
			 @test2 INT
    Open cur2
	 FETCH cur2 INTO @c1, @c2
	 set @test2 = @c1
	 print 'N°'+ '  '  + cast (@test2 as nvarchar(1))
	  WHILE @@Fetch_STATUS = 0
	  BEGIN
	  Print 'Hello IFOSUPWAVRE, je suis dans le deuxième curseur'
	    IF (@c2 is null)  
	     BEGIN
	      Select BusinessEntityId, Vaccin from  tbl_IdVaccin
	             WHERE BusinessEntityID = @c1
	      UPDATE  [tbl_Mike_Bernair_EmployeeBIS]
	      SET @g = 'x' WHERE @test2 = @test1   ---,a    --- @c1 = @a
		  Select @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
		END 
		ELSE
		 UPDATE  [tbl_Mike_Bernair_EmployeeBIS]
		 SET @g = 'n' WHERE @test2 = @test1
		 Select @a BusinessEnityId, @b prenom, @c nom, @d Title, @e Date_de_naissance, @f Genre, @g Rappel_Vaccin
		
	   --END

   /*  Fin du curseur n°2 */

    FETCH cur1 INTO @a , @b, @c, @d, @e, @f, @g  -- je passe au prochain enregistrement
	FETCH cur2 INTO @c1, @c2
  END    -- BEGIN 1

CLOSE cur1         --  Fermeture du curseur n°1 puisqu'il est le premier qui a commencé dans l'ordre des opérations
DEALLOCATE cur1    --  Je libère la mémoire de mon curseur n°1

	  END          --  Fermeture du curseur n°2 puisqu'il suit le curseur n°1
	CLOSE cur2
	DEALLOCATE cur2

--- Select * from  [dbo].[tbl_Mike_Bernair_EmployeeBIS]












