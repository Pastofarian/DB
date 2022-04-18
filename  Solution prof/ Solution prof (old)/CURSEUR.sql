
/*
 -- SQL_CURSOR_MJACQUET_Syllabus.sql --

 Exemple du Syllabus de Marc Jacquet : retranscription en Microsoft SQL Server

*/


/*****************************************************************************
 1) test de l'existence de la pr�sence ou non de la base de donn�es tests
*****************************************************************************/
USE Master
GO
--si DB existe -> je la vide et je la recr�e
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR_JACQUET')
DROP DATABASE IFOSUP_CURSOR_JACQUET  -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE IFOSUP_CURSOR_JACQUET  -- Je la recr�e � nouveau une nouvelle table
GO
/*************************************************************
 2) test de l'existence de la pr�sence de la table T_TRANS
**************************************************************/
GO
USE IFOSUP_CURSOR_JACQUET  -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_CURSOR_JACQUET.sys.tables WHERE name = 'T_CLIENTS')
DROP TABLE T_CLIENTS
GO
CREATE TABLE T_CLIENTS (cli_code int, cli_societe varchar(255) )
GO
/*
3) Insertion de donn�e
*/
--  INSERT INTO T_TRANS (colum_name) VALUES ('Deuxi�me transaction')
-- Populate la table
USE IFOSUP_CURSOR_JACQUET
GO
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('1','MICROSOFT') 	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('2','IBM')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('3','ORACLE')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('4','AMAZON')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('5','FACEBOOK')	
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('6','ALPHABET')	
GO
--SELECT * FROM T_CLIENTS
GO

/*
 4. Cr�ation d'un curseur
*/
-- D�finition d'un curseur 

DECLARE @done INT
SET @done = 0
DECLARE @a as INT
DECLARE @b as VARCHAR(255)

--Declaration d'un curseur
DECLARE cur1 CURSOR FOR (SELECT cli_code,cli_societe FROM T_clients) 

OPEN cur1            -- initialisation du curseur

-- je le remplis avec mes 1eres variable @a, @b retourn� par la requ�te --> donc lecture de 1 - Microsoft
FETCH cur1 INTO @a, @b
      PRINT @a                           -- En fait, ce print ne se voit pas !
	  PRINT @b
/* Pour parcourir un curseur, on peut employer une boucle WHILE qui teste la valeur de la fonction @@FETCH_STATUS
   qui renvoie 0 tant que l'on n'est pas � la fin. 
*/

WHILE @@fetch_Status = 0  -- Tant que l'on n'est pas � la fin du select > cela renvoit toujours la valeur 0 
                          -- donc je boucle !
BEGIN
      PRINT 'hello the cursor'

/* Explication :      	 
 Je le remplis avec les variables @a, @b suivant retourn� par la requ�te :
 Autrement dits, je r�cup�re les valeurs actuelles contenues dans le curseur, il faut employer : 
 FETCH name INTO @value1, @value2 � 
 Cela va stocker les valeurs actuelles de l'enregistrement courant dans les variables @valueX,
 qu'il conviendra de d�clarer, ce que nous avons fait pour @a, @b. 
*/
      FETCH cur1 INTO @a, @b 
	  SELECT @a,@b                     -- Affichage des donn�es de a et de b
	  PRINT @a                          
	  PRINT @b
END
CLOSE cur1
DEALLOCATE cur1  -- Je lib�re la m�moire allou�e � ce curseur
Print '----------------- Termin� ------------------------'
--SELECT * FROM T_CLIENTS
Print '---- ok ----'
Print @a
PRINT @b


