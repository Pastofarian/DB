
/*
 ETUDE DES CURSEURS :

 Est-ce qu'il n'y aurait pas une technique qui me permet lorsqu'il y a un Select - il y a un d�roulement
 de la totalit� de la table, de la totalit� de mes enregistrements (filtre WHERE).
 Est-ce que je dois attendre le d�roulement de la totalit� de mes donn�es, de la table pour que je puisse
 enfin travailler avec ceux-ci.
 ? technique qui me permet d'aller travailler ligne par ligne au moment de mon Select.
Cette technique, c'est un curseur. 
*/

USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de r�f�rence 296 records
GO

-- Premier exemple
-- Je vais simuler le passage ligne par ligne de mon curseur dans une table.
--  Je vais refaire en fait un SELECT, une factorisation du SELECT

USE Master
GO
--si DB existe -> je la vide et je la recr�e
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR_2702021')
DROP DATABASE IFOSUP_CURSOR_2702201  -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE IFOSUP_CURSOR_2702201  -- Je la recr�e � nouveau une nouvelle table

/*************************************************************
 2) test de l'existence de la pr�sence de la table T_TCLIENTS
**************************************************************/
GO
USE IFOSUP_CURSOR_2702201   -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_CURSOR_2702201 .sys.tables WHERE name = 'T_CLIENTS')
DROP TABLE T_CLIENTS
GO
CREATE TABLE T_CLIENTS (cli_code int, cli_societe varchar(255) )
GO

Select * from T_CLIENTS
/*
3) Insertion de donn�e
*/
--  INSERT INTO T_CLIENTS (colum_name) VALUES ('Deuxi�me transaction')
-- Populate la table
USE IFOSUP_CURSOR_2702201
GO
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('1','MICROSOFT') 	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('2','IBM')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('3','ORACLE')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('4','AMAZON')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('5','FACEBOOK')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('6','ALPHABET')	 -- Google
GO
Select * from T_CLIENTS -- 6 records.

-- Je vais cr�er un curseur et parcourir l'ensemble des enregistrements de ma table T_CLIENTS
DECLARE @a INT,      -- 2 valeurs qui vont r�cup�rer le contenu des mes enregistrements de chaque ligne
        @b VARCHAR(255)
-- Pour <<cr�er>, le d�clarer le curseur, c'est lui donner un nom -> cur1
DECLARE cur1 CURSOR FOR (Select cli_code, cli_societe from  T_CLIENTS) -- D�clarer mon curseur
-- Apr�s avoir d�clarer un curseur, je dois ouvrir un curseur
OPEN cur1

	-- Cosm�tique au niveau SQL pour qu ece soit Joli !
	PRINT ''
	PRINT 'Ce curseur nous montre b�tement la lecture de tous les enregistrements d''une table'
	PRINT '-----------------------------------------------------------------------------------'
	PRINT ' '
	-- Fin de la cosm�tique
-- Tu te postionnes sur le premier enregistrement
 FETCH cur1 INTO @a, @b     -- il r�cup�re la valeur actuelle l� o� se trouve mon enregistrement
 
 -- Je vais devoir aller me balader dans ma table
 WHILE @@fetch_status = 0  -- Tant que l'on n'est pas � la fin de ma table, � la fin de mon select >cela revoit
                           --  une valeur de 0
						   --- Quand, je suis � la fin, cette variable @@fetch_status prend la valeur 1 et
						   -- et donc, je dois sortir de cette table puisque c'est la fin.
	 BEGIN
	  Print 'Hello the Cursor'
	  Select @a, @b  ----Affichage de mes donn�es cli_code en passant par la variable @a et cli_societe en passant
	                 -- par la variable @b
	  Print 'n�: ' + cast(@a as nvarchar(10)) + ' ' + 'L''enregistrement IT est : ' + @b
	  FETCH cur1 INTO @a, @b
	END
CLOSE cur1          -- fermeture de mon curseur
DEALLOCATE cur1 -- Je dois lib�rer la m�moire












