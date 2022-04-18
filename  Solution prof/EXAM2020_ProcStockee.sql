
/***********************************************************************************************
  Ecrire une proc�dure stock�e qui doit retourner votre nom et prenom, sexe 
   et qui retourne la date syst�me et votre sexe.
   Ces donn�es (nom, pr�nom, sexe,, date/heure syst�me) auront �t� ins�r�e dans une table au pr�alable
   que l'on nommera comme suit : tbl_<nom_prenom>
   Exemple :  je m'appelle Mike Bern -> donc la table sera : tbl_mike_bern
   Cette table tbl_<nom_prenom> appartiendra � une base de donn�e qu'il conviendra de cr�er, nomm�e comme suit :
   Examen_blanc_nom_prenom.
   Exemple : Examen_blanc_micke_bern

   Consigne pour la cr�ation de la table, compos� de : 
   --------------------------------------------------
   - Une incr�mentale (Id),
   - nom est un champ de 30 caract�res non nul
   - Pr�nom est un champ de 30 caract�res non nul,
   - une identit� sexe bas�e : entier (prendra la valeur 1 ou 2) : 1 si vous �tes un gar�on, 2 si vous �tes une Fille.
   La table devra �tre remplie de votre nom, prenom, sexe, et du champ remarque :   
   , enfin un champ nomm� Remarque sur 30 caract�res : 
    ('1','Bernair', 'Michel', '1','Pr�sent � l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non pr�sente � l''examen')
Je souhaite que vous fassiez, en fonction de votre sexe, de remplier la table de 2 donn�es
 - votre nom, prenom
 - Et la donn�e oppos�e � votre sexe c'est-�-dire pour le Homme
    ('1','Bernair', 'Michel', '1','Pr�sent � l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non pr�sente � l''examen')
 Si vous �tes une Femme
    ('1','Ride','Sally','2','Pr�sente � l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
	('2','Marc', 'Jacquet', '1','Non pr�sent � l''examen') 
Cette insertion se fera via un IF BEGIN ELSE END... fonction que vous �tes 1 ou 2.

La table r�sultat de cette insrtion, on fer une copie de celle-ci.


  il va sans dire que l'on testera l'existance de la base donn�e, de la table
  de la proc�ure de la base de donn�es.

  Bon travail.
*************************************************************************************************/


/*************************************************************
  ETAPE n�1 : cr�ation de la base de donn�es et de la table
**************************************************************/

--Cr�ation de votre base de donn�e Examen_blanc20192020_bernair_michel
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20192020_bernair_michel')
DROP DATABASE Examen_blanc20192020_bernair_michel -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE Examen_blanc20192020_bernair_michel -- Je la recr�e � nouveau une nouvelle table
GO

-- Cr�ation votre table o� votre nom et prenom se retrouveront dans celle-ci
-- Faites un test de son existence
-- 
USE Examen_blanc20192020_bernair_michel 
		CREATE TABLE tbl_Bernair_Michel
		(
		Id INT IDENTITY (1,1) PRIMARY KEY,  -- incr�mentale => � chaque enregistrement de l'id = 1, 2, 3,etc.
		Nom nvarchar(30) NOT NULL,
		Prenom nvarchar(30) NOT NULL,
		Sexe int,
		Remarque nvarchar(30) NOT NULL       -- Pr�sent � l''examen
		)

GO

/**************************************************************************************
* ETAPE n�2 : Insertion des donn�es selon que vous �tes une Femme (2) ou un Homme (1)
***************************************************************************************/

--  DROP TABLE tbl_Bernair_Michel
USE [Examen_blanc20192020_bernair_michel]
GO
Declare @sexeMF nvarchar(1)
SET @sexeMF = 'M' -- Je suis un Homme

 -- J'ins�re mon indentit� et l"identit� oppos�e cad la ligne suivante
 --    "Sally Ride"
SET IDENTITY_INSERT tbl_Bernair_Michel ON
IF @sexeMF = 'M'
  BEGIN
 INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES  	  
	('1','Bern', 'Mike', '1','Pr�sent � l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','Non pr�sente � l''examen')
  END
ELSE  --  je suis une fille
 BEGIN
	 INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES
	 ('1','Ride','Sally','2','Pr�sente � l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
	 ('2','Marc', 'Jacquet', '1','Non pr�sent � l''examen') 
 END

SELECT *  from tbl_Bernair_Michel
SET IDENTITY_INSERT tbl_Bernair_Michel  OFF

Select * from tbl_Bernair_Michel


/*
SET IDENTITY_INSERT tbl_Bernair_Michel ON
INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES
('1','Bernair', 'Michel', '1','Pr�sent � l''examen'), 
('2','Ride','Sally','2','Nom pr�sent � l''examen')
SELECT *  from tbl_Bernair_Michel
SET IDENTITY_INSERT tbl_Bernair_Michel  OFF
Select * from tbl_Bernair_Michel
*/

/***************************************************************************
ETAPE n�3 : Insertion du champ Date_et_Heure � la table tbl_prenom_nom
             Ajout du champ date syst�me
***************************************************************************/
ALTER TABLE tbl_Bernair_Michel ADD Date_et_Heure Datetime
Select * from tbl_Bernair_Michel     -- Date_et_Heure

-- Source : https://docs.microsoft.com/fr-fr/sql/t-sql/statements/alter-table-transact-sql?view=sql-server-ver15

/***************************************************************************
ETAPE n�4 : Copie de la table tbl_prenom_nom 
        vers une autre table tbl_prenom_nom_BIS
***************************************************************************/

-- DROP Table tbl_Bernair_Michel_BIS    -- �a s'est pour le deuxi�me passage lorsque la table a �t� cr��e
Select * INTO tbl_Bernair_Michel_BIS FROM tbl_Bernair_Michel
Select * FROM tbl_Bernair_Michel_BIS
-- Ajouter l'heure et la date via une fonction
-- Qui retourne l'heure et qui viendra populer le champ Date_et_Heure 
--  de la table tbl_<nom>_<prenom>


/*************************************************************************************************
 ETAPE n�5 : 
 Mise � jour du champ Date_et_Heure par la fonction syst�me de Microsoft GETDATE()
**************************************************************************************************/

-- Premi�re Mise � jour de la table, l� o� le champ Date_et_Heure est de valeur NULL (pas de donn�e)
-- 
-- Source : 
DECLARE @num INT = 1;
WHILE @num < 3
BEGIN  
   UPDATE  tbl_Bernair_Michel_BIS  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [Date_et_Heure] = getdate()
   WHERE [id] = 1 OR ID = 2
   PRINT 'Insertion de la donn�e DATE/Heure' + ' ' + 'pour le codeclient cli_code n� : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des donn�es Date/Heure dans la table ';
GO
Select * FROM tbl_Bernair_Michel_BIS


/* on r�ex�cute le code 2x fois de suite
UPDATE tbl_Bernair_Michel_BIS
 SET [Date_et_Heure] = getdate()
  WHERE id = 1  --2
*/

Select * FROM tbl_Bernair_Michel_BIS

-- Deuxi�me mani�re de mettre � jour la table o� nous avons un champ < NULL >

/*
DROP Table tbl_Bernair_Michel_BIS    -- �a s'est pour le deuxi�me passage lorsque la table a �t� cr��e
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
ETAPE n�6 : la tbale tbl_prenom_nom_BIS est comme suit 
 Voici les champs que nous avons < tbl_Bernair_Michel_BIS >
  Id |  Nom  |  Nom  |  Prenom  |  Sexe   | Remarque  |  Date_et_heure
*************************************************************************/
Select * FROM tbl_Bernair_Michel_BIS


/**************************************************************************************************
 ETAPE n�7 : Creation de la proc�dure Stock�e 

 Cette proc�dure doit lister la table tbl_prenom_nom_BIS qui en fonction 
 que vous soyez une homme ou une femme retournera votre nom, pr�nom et la date et l�heure.
  Il faut donc passer en param�tre votre identifiant (sexe) 1 ou 2.

**************************************************************************************************/
/*
USE [Examen_blanc20192020_bernair_michel]
Select * FROM tbl_Bernair_Michel_BIS
GO
--DROP PROCEDURE affichage_prenom_nom 
USE [Examen_blanc20192020_bernair_michel]

-- Select sexe, (nom + ', ' + prenom) AS Mon_Nom_Prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 

GO
CREATE PROCEDURE affichage_prenom_nom               -- Proc�dure stock�e
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

-- Je d�clare ce que j'ai mis en OUTPUT
 -- cette variable recevra la valeur retourn�e par la proc�dure
---Declare @sexe1 INT
Declare @Mon_nom_prenom1 nvarchar(255) 

Declare @nom1 nvarchar(255) 
Declare @prenom1 nvarchar(255) 
Declare @Date_et_Heure1 DATETIME 

EXEC [affichage_prenom_nom] 2            ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
*/




/**********************************************************************************
  ETAPE n�7b.: avec l'ensemble des param�tres demand�es
   - nom, prenom, date et heure
   avec passage en param�tre, le sexe de la personne.
  On r�cup�re les champs nom (output) et prenom (output), date heure (output)
 *********************************************************************************/


USE [Examen_blanc20192020_bernair_michel]
Select * FROM tbl_Bernair_Michel_BIS
GO
--  DROP PROCEDURE affichage_prenom_nomBIS 

CREATE PROCEDURE affichage_prenom_nomBIS               -- Proc�dure stock�e
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

-- Je d�clare ce que j'ai mis en OUTPUT
 -- cette variable recevra la valeur retourn�e par la proc�dure
---Declare @sexe1 INT
Declare @Mon_nom_prenom1 nvarchar(255) 
Declare @nom1 nvarchar(255) 
Declare @prenom1 nvarchar(255) 
Declare @Date_et_Heure1 DATETIME 
-- si vous �tes
EXEC [affichage_prenom_nomBIS] 1, @nom1 output, @prenom1 output, @Date_et_Heure1 output        ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
Print ' Affichage de votre Nom et Prenom'
Print '---------------------------------'
Print @nom1 + '  ' + @prenom1 + ' ' + cast( @Date_et_Heure1 as nvarchar(30))
Select @nom1 as nom, @prenom1 as prenom, @date_et_heure1 as date_heure














