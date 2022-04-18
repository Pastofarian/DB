
/***********************************************************************************************
  Ecrire une procédure stockée qui doit retourner votre nom et prenom, sexe 
   et qui retourne la date système et votre sexe.
   Ces données (nom, prénom, sexe,, date/heure système) auront été insérée dans une table au préalable
   que l'on nommera comme suit : tbl_<nom_prenom>
   Exemple :  je m'appelle Mike Bern -> donc la table sera : tbl_mike_bern
   Cette table tbl_<nom_prenom> appartiendra à une base de donnée qu'il conviendra de créer, nommée comme suit :
   Examen_blanc_nom_prenom.
   Exemple : Examen_blanc_micke_bern

   Consigne pour la création de la table, composé de : 
   --------------------------------------------------
   - Une incrémentale (Id),
   - nom est un champ de 30 caractères non nul
   - Prénom est un champ de 30 caractères non nul,
   - une identité sexe basée : entier (prendra la valeur 1 ou 2) : 1 si vous êtes un garçon, 2 si vous êtes une Fille.
   La table devra être remplie de votre nom, prenom, sexe, et du champ remarque :   
   , enfin un champ nommé Remarque sur 30 caractères : 
    ('1','Bernair', 'Michel', '1','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non présente à l''examen')
Je souhaite que vous fassiez, en fonction de votre sexe, de remplier la table de 2 données
 - votre nom, prenom
 - Et la donnée opposée à votre sexe c'est-à-dire pour le Homme
    ('1','Bernair', 'Michel', '1','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non présente à l''examen')
 Si vous êtes une Femme
    ('1','Ride','Sally','2','Présente à l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
	('2','Marc', 'Jacquet', '1','Non présent à l''examen') 
Cette insertion se fera via un IF BEGIN ELSE END... fonction que vous êtes 1 ou 2.

La table résultat de cette insrtion, on fer une copie de celle-ci.


  il va sans dire que l'on testera l'existance de la base donnée, de la table
  de la procéure de la base de données.

  Bon travail.
*************************************************************************************************/


/*************************************************************
  ETAPE n°1 : création de la base de données et de la table
**************************************************************/

--Création de votre base de donnée Examen_blanc20192020_bernair_michel
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20192020_bernair_michel')
DROP DATABASE Examen_blanc20192020_bernair_michel -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE Examen_blanc20192020_bernair_michel -- Je la recrée à nouveau une nouvelle table
GO

-- Création votre table où votre nom et prenom se retrouveront dans celle-ci
-- Faites un test de son existence
-- 
USE Examen_blanc20192020_bernair_michel 
		CREATE TABLE tbl_Bernair_Michel
		(
		Id INT IDENTITY (1,1) PRIMARY KEY,  -- incrémentale => à chaque enregistrement de l'id = 1, 2, 3,etc.
		Nom nvarchar(30) NOT NULL,
		Prenom nvarchar(30) NOT NULL,
		Sexe int,
		Remarque nvarchar(30) NOT NULL       -- Présent à l''examen
		)

GO

/**************************************************************************************
* ETAPE n°2 : Insertion des données selon que vous êtes une Femme (2) ou un Homme (1)
***************************************************************************************/

--  DROP TABLE tbl_Bernair_Michel
USE [Examen_blanc20192020_bernair_michel]
GO
Declare @sexeMF nvarchar(1)
SET @sexeMF = 'M' -- Je suis un Homme

 -- J'insère mon indentité et l"identité opposée cad la ligne suivante
 --    "Sally Ride"
SET IDENTITY_INSERT tbl_Bernair_Michel ON
IF @sexeMF = 'M'
  BEGIN
 INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES  	  
	('1','Bern', 'Mike', '1','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non présente à l''examen')
  END
ELSE  --  je suis une fille
 BEGIN
	 INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES
	 ('1','Ride','Sally','2','Présente à l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
	 ('2','Marc', 'Jacquet', '1','Non présent à l''examen') 
 END

SELECT *  from tbl_Bernair_Michel
SET IDENTITY_INSERT tbl_Bernair_Michel  OFF

Select * from tbl_Bernair_Michel


/*
SET IDENTITY_INSERT tbl_Bernair_Michel ON
INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES
('1','Bernair', 'Michel', '1','Présent à l''examen'), 
('2','Ride','Sally','2','Nom présent à l''examen')
SELECT *  from tbl_Bernair_Michel
SET IDENTITY_INSERT tbl_Bernair_Michel  OFF
Select * from tbl_Bernair_Michel
*/

/***************************************************************************
ETAPE n°3 : Insertion du champ Date_et_Heure à la table tbl_prenom_nom
             Ajout du champ date système
***************************************************************************/
ALTER TABLE tbl_Bernair_Michel ADD Date_et_Heure Datetime
Select * from tbl_Bernair_Michel     -- Date_et_Heure

-- Source : https://docs.microsoft.com/fr-fr/sql/t-sql/statements/alter-table-transact-sql?view=sql-server-ver15

/***************************************************************************
ETAPE n°4 : Copie de la table tbl_prenom_nom 
        vers une autre table tbl_prenom_nom_BIS
***************************************************************************/

-- DROP Table tbl_Bernair_Michel_BIS    -- ça s'est pour le deuxième passage lorsque la table a été créée
Select * INTO tbl_Bernair_Michel_BIS FROM tbl_Bernair_Michel
Select * FROM tbl_Bernair_Michel_BIS
-- Ajouter l'heure et la date via une fonction
-- Qui retourne l'heure et qui viendra populer le champ Date_et_Heure 
--  de la table tbl_<nom>_<prenom>


/*************************************************************************************************
 ETAPE n°5 : 
 Mise à jour du champ Date_et_Heure par la fonction système de Microsoft GETDATE()
**************************************************************************************************/

-- Première Mise à jour de la table, là où le champ Date_et_Heure est de valeur NULL (pas de donnée)
-- 
-- Source : 
DECLARE @num INT = 1;
WHILE @num < 3
BEGIN  
   UPDATE  tbl_Bernair_Michel_BIS  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [Date_et_Heure] = getdate()
   WHERE [id] = 1 OR ID = 2
   PRINT 'Insertion de la donnée DATE/Heure' + ' ' + 'pour le codeclient cli_code n° : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des données Date/Heure dans la table ';
GO
Select * FROM tbl_Bernair_Michel_BIS


/* on réexécute le code 2x fois de suite
UPDATE tbl_Bernair_Michel_BIS
 SET [Date_et_Heure] = getdate()
  WHERE id = 1  --2
*/

Select * FROM tbl_Bernair_Michel_BIS

-- Deuxième manière de mettre à jour la table où nous avons un champ < NULL >

/*
DROP Table tbl_Bernair_Michel_BIS    -- ça s'est pour le deuxième passage lorsque la table a été créée
Select * INTO tbl_Bernair_Michel_BIS FROM tbl_Bernair_Michel
Select * FROM tbl_Bernair_Michel_BIS      -- NULL

DROP TABLE #temp1
Select ID, Nom, Prenom, Sexe, Remarque,
CASE  
 WHEN [Date_et_Heure] is null THEN getdate()            --- is NULL !!!
 ELSE ''
END [Date_et_Heure] 
INTO #temp1
FROM tbl_Bernair_Michel_BIS
*/


/********************************************************
ETAPE n°6 : la tbale tbl_prenom_nom_BIS est comme suit 
 Voici les champs que nous avons < tbl_Bernair_Michel_BIS >
  Id |  Nom  |  Nom  |  Prenom  |  Sexe   | Remarque  |  Date_et_heure
*************************************************************************/
Select * FROM tbl_Bernair_Michel_BIS


/**************************************************************************************************
 ETAPE n°7 : Creation de la procédure Stockée 

 Cette procédure doit lister la table tbl_prenom_nom_BIS qui en fonction 
 que vous soyez une homme ou une femme retournera votre nom, prénom et la date et l’heure.
  Il faut donc passer en paramètre votre identifiant (sexe) 1 ou 2.

**************************************************************************************************/
/*
USE [Examen_blanc20192020_bernair_michel]
Select * FROM tbl_Bernair_Michel_BIS
GO
--DROP PROCEDURE affichage_prenom_nom 
USE [Examen_blanc20192020_bernair_michel]

-- Select sexe, (nom + ', ' + prenom) AS Mon_Nom_Prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 

GO
CREATE PROCEDURE affichage_prenom_nom               -- Procédure stockée
---  ALTER PROCEDURE affichage_prenom_nom  

		@sexe_proc INT  -- sexe 1 ou 0
		---@Mon_nom_prenom nvarchar(255) out,
        --@nom nvarchar(255) out,
		--@prenom nvarchar(255) out,
		--@DateHeure DateTime out
		AS
		BEGIN
		-- , DateMB, getdate() as datePROC 
		 --Select sexe, (nom + ', ' + prenom) AS Mon_Nom_Prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 
		
		Select sexe, nom ,  prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 
		 WHERE sexe = @sexe_proc -- Lecture de la table
		END

-- Je déclare ce que j'ai mis en OUTPUT
 -- cette variable recevra la valeur retournée par la procédure
---Declare @sexe1 INT
Declare @Mon_nom_prenom1 nvarchar(255) 

Declare @nom1 nvarchar(255) 
Declare @prenom1 nvarchar(255) 
Declare @Date_et_Heure1 DATETIME 

EXEC [affichage_prenom_nom] 2            ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
*/




/**********************************************************************************
  ETAPE n°7b.: avec l'ensemble des paramètres demandées
   - nom, prenom, date et heure
   avec passage en paramètre, le sexe de la personne.
  On récupére les champs nom (output) et prenom (output), date heure (output)
 *********************************************************************************/


USE [Examen_blanc20192020_bernair_michel]
Select * FROM tbl_Bernair_Michel_BIS
GO
--  DROP PROCEDURE affichage_prenom_nomBIS 

CREATE PROCEDURE affichage_prenom_nomBIS               -- Procédure stockée
---  ALTER PROCEDURE affichage_prenom_nomBIS  

		@sexe_proc INT,  -- sexe 1 ou 0
        @nom_proc nvarchar(255) out,
        @prenom_proc nvarchar(255) out,
 		@DateHeure_proc DateTime out
		AS
		BEGIN
		-- , DateMB, getdate() as datePROC 
	--Select sexe, (nom + ', ' + prenom) AS Mon_Nom_Prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 
		
			SET @nom_proc = (Select nom FROM tbl_Bernair_Michel_BIS 
			WHERE sexe = @sexe_proc ) -- Lecture de la table
			SET @prenom_proc = (Select prenom FROM tbl_Bernair_Michel_BIS 
			WHERE sexe = @sexe_proc ) -- Lecture de la table
			SET @DateHeure_proc = (Select Date_et_Heure FROM tbl_Bernair_Michel_BIS 
			WHERE sexe = @sexe_proc )
		END

-- Je déclare ce que j'ai mis en OUTPUT
 -- cette variable recevra la valeur retournée par la procédure
---Declare @sexe1 INT
Declare @Mon_nom_prenom1 nvarchar(255) 
Declare @nom1 nvarchar(255) 
Declare @prenom1 nvarchar(255) 
Declare @Date_et_Heure1 DATETIME 
-- si vous êtes
EXEC [affichage_prenom_nomBIS] 1, @nom1 output, @prenom1 output, @Date_et_Heure1 output        ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
Print ' Affichage de votre Nom et Prenom'
Print '---------------------------------'
Print @nom1 + '  ' + @prenom1 + ' ' + cast( @Date_et_Heure1 as nvarchar(30))
Select @nom1 as nom, @prenom1 as prenom, @date_et_heure1 as date_heure














