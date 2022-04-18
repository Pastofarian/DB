
/*
 -- SQLQuery__curseur_exemple1.sql --
 Exemple du Syllabus de Marc Jacquet sous MySQL: retranscription en Microsoft SQL Server
 (c) MB - Ifosupwavre 2019-2020
*/


/*****************************************************************************
 1) test de l'existence de la présence ou non de la base de données tests
*****************************************************************************/
USE Master
GO
--si DB existe -> je la vide et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR_BERNAIR')
DROP DATABASE IFOSUP_CURSOR_BERNAIR  -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE IFOSUP_CURSOR_BERNAIR  -- Je la recrée à nouveau une nouvelle table
GO
/*************************************************************
 2) test de l'existence de la présence de la table T_TRANS
**************************************************************/
GO
USE IFOSUP_CURSOR_BERNAIR  -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_CURSOR_BERNAIR.sys.tables WHERE name = 'T_CLIENTS')
DROP TABLE T_CLIENTS
GO
CREATE TABLE T_CLIENTS (cli_code int, cli_societe varchar(255) )
GO
/*
3) Insertion de donnée
*/
--  INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
-- Populate la table
USE IFOSUP_CURSOR_BERNAIR
GO
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('1','MICROSOFT') 	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('2','IBM')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('3','ORACLE')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('4','AMAZON')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('5','FACEBOOK')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('6','ALPHABET')	
GO
-- SELECT * FROM T_CLIENTS
GO

/*****************************************************
 4. Création d'un curseur
    Lecture des enregistrements de la table T_CLIENTS
*****************************************************/

/* Explication :      	 
 Je le remplis avec les variables @a, @b suivant retourné par la requête :
 Autrement dits, je récupère les valeurs actuelles contenues dans le curseur, il faut employer : 
 FETCH name INTO @value1, @value2 … 
 Cela va stocker les valeurs actuelles de l'enregistrement courant dans les variables @valueX,
 qu'il conviendra de déclarer, ce que nous avons fait pour @a, @b. 
*/


USE IFOSUP_CURSOR_BERNAIR
GO
SELECT * FROM T_CLIENTS
GO

DECLARE @done INT
SET @done = 0
DECLARE @a as INT
DECLARE @b as VARCHAR(255)

DECLARE cur1 CURSOR FOR (SELECT cli_code,cli_societe FROM T_clients) --Declaration d'un curseur
OPEN cur1            -- initialisation du curseur

-- je le remplis avec mes 1eres variable @a, @b retourné par la requête --> donc lecture de 1 - Microsoft
Print ''
Print 'Ce curseur nous montre bêtement la lecture de tous les enregistrements d''une table'
Print '-----------------------------------------------------------------------------------'
Print '  '
FETCH cur1 INTO @a, @b -- Pour se positionner sur le premier enegistrement de la table !

WHILE @@fetch_Status = 0  -- Tant que l'on n'est pas à la fin du select > cela renvoit toujours la valeur 0 
                          -- donc je boucle !
	BEGIN
		  PRINT 'hello the cursor'      
		  SELECT @a,@b                     -- Affichage des données de a et de b
		  PRINT 'n°: ' + cast (@a as nvarchar (10)) + ' ' + 'L''entreprise IT est : ' + @b                       
		  --PRINT @b
		  FETCH cur1 INTO @a, @b     -- Pour prendre le prochain enregistrement !
	END
Print '----------------- Fin du curseur ------------------------'
CLOSE cur1       -- Fermeture du curseur
DEALLOCATE cur1  -- Je libère la mémoire allouée à ce dernier


/**************************************************************************************************************
*  Amélioration du curseur 
-   Ajout d'un nouveau champ
-   Insertion de valeur dans ce champ
- On va faire en sorte que lors de la lecture de la table, je puisse directement sur la ligne sur laquelle
  je suis en train de lire, ses champs, etc.
  Et donc y effectuer un traitement sur la donnée.
*****************************************************************************************************************/
SELECT * FROM T_CLIENTS
IF object_id ('tempdb.dbo.#temp1') is not null 
Drop table #temp1
Select * into #temp1 from  T_CLIENTS
Select * from #temp1 

-- Ajout d'un champ action_en_bourse
ALTER TABLE #temp1 ADD action_en_bourse money
Select * from #temp1  -- NULL
-- Je popule cette table de données
-- Boucle

DECLARE @num INT = 0;
WHILE @num < 10
BEGIN  
   UPDATE #temp1  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [action_en_bourse] = 1.0000
   WHERE [cli_code]  = @num   
   PRINT 'Insertion de données action_en_bourse ' + ' ' + 'pour le codeclient cli_code n° : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des données dans la table';
GO

Select * from #temp1
DROP Table  T_CLIENTS_EN_BOURSE  --- Client en Bourse
Select * into T_CLIENTS_EN_BOURSE From #temp1
Select * from T_CLIENTS_EN_BOURSE

/*
Ecrire un curseur qui met à jour directement au moment de la lecture du "record" (de la ligne et de ses champs) de la table,
le record lui-même !
Exemple :  le montant de l'action Amazon, dû au Coronavirus COVID19 a augmenté puisque
           tous le monde préfère se fournier en ligne et ne plus se déplacer sur site !
		   Celle de Microsoft a bondit puisque Microsoft Team offre l'alternative pour le travail à distance 
  -> Utilité des curseurs
  -> On aurait pu passer par des tables temporaires...
  -> Cela se fera en ue seule fois.
*/

/* Nouveau Curseur */
USE IFOSUP_CURSOR_BERNAIR
GO
	DECLARE @aa as INT
	DECLARE @bb as VARCHAR(255)
	DECLARE @cc as Money
	DECLARE @valeur_actionM as Money
SET @valeur_actionM = 1000  -- Valeur pour Microsoft
    DECLARE @valeur_actionA as Money
SET @valeur_actionA = 2000  -- Valeur pour Amazon

DECLARE cur2 CURSOR FOR (SELECT cli_code,cli_societe, action_en_bourse FROM T_CLIENTS_EN_BOURSE) --Declaration d'un curseur
OPEN cur2           -- initialisation du curseur

-- je le remplis avec mes 1eres variable @a, @b retourné par la requête --> donc lecture de 1 - Microsoft
Print ''
Print 'Ce curseur nous montre que l''on peut en cours de lecture de le ligne enregistrements,' 
PRINT '   une modification de celle-ci'
Print '-----------------------------------------------------------------------------------'
Print '  '
FETCH cur2 INTO @aa, @bb, @cc -- Pour se positionner sur le premier enegistrement de la table !

WHILE @@fetch_Status = 0  -- Tant que l'on n'est pas à la fin du select > cela renvoit toujours la valeur 0 
                          -- donc je boucle !
	BEGIN
		  PRINT 'hello the cursor'      
		  SELECT @aa, @bb, @cc                     -- Affichage des données de a et de b
		  PRINT 'n°: ' + cast (@aa as nvarchar (10)) + ' ' + 'L''entreprise IT est : ' + @bb  
		  
		  IF ( @bb = 'Microsoft' )   --- code societe
			 BEGIN
			 Select cli_code, cli_societe, [action_en_bourse] from T_CLIENTS_EN_BOURSE WHERE cli_societe = @bb 
			 UPDATE T_CLIENTS_EN_BOURSE
				SET action_en_bourse = [action_en_bourse] * @valeur_actionM WHERE cli_societe = @bb  -- Mise  jour de la table tbl_ProductSales
			 END
           -- pour une autre donnée à mettre à jour, nous aurons ci-dessous...
		 ELSE IF ( @bb = 'Amazon')   --- code societe
           BEGIN
		   Select cli_code, cli_societe, [action_en_bourse] from T_CLIENTS_EN_BOURSE WHERE cli_societe = @bb 
			 UPDATE T_CLIENTS_EN_BOURSE
				SET action_en_bourse = [action_en_bourse] * @valeur_actionA WHERE cli_societe = @bb
		   END
	               
		  --PRINT @b
		  FETCH cur2 INTO @aa, @bb, @cc     -- Pour prendre le prochain enregistrement !
	END
Print '----------------- Fin du curseur ------------------------'
CLOSE cur2      -- Fermeture du curseur
DEALLOCATE cur2  -- Je libère la mémoire allouée à ce dernier

Select * From T_CLIENTS_EN_BOURSE  -- Les données ont donc bien été mise à jour au cours de la lecture de la donnée

-- ça s'est fait avec une seule table, sur la table elle-même, rien ne vous empêche
-- de faire une modification sur une autre table qui lui est jointe, forcément par une même clé


/****************************************
* Exemple de la mise à jour d'un donnée *
*****************************************/

Select * From T_CLIENTS_EN_BOURSE
Declare @valeur Money
SET @valeur = 100
  UPDATE T_CLIENTS_EN_BOURSE
		    SET action_en_bourse = (action_en_bourse * @valeur ) WHERE cli_societe = 'IBM' 

