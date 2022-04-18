

/*
-- Utilisation d'un CURSEUR

*/


/*****************************************************************************
 1) test de l'existence de la présence ou non de la base de données tests
*****************************************************************************/
USE Master
GO
--si DB existe -> je la vide et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR')
DROP DATABASE IFOSUP_CURSOR  -- Quelque soit la situation de la table, je la vide ! 
GO
CREATE DATABASE IFOSUP_CURSOR  -- Je la recrée à nouveau une nouvelle table
GO

/*************************************************************
 2) test de l'existence de la présence de la table T_TRANS
**************************************************************/
GO
USE IFOSUP_CURSOR  -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_CURSOR .sys.tables WHERE name = 'T_CURSOR')
DROP TABLE T_CURSOR
GO
CREATE TABLE T_CURSOR (StudentID int not null, prenom varchar(255), 
nom varchar(255),note int, etat  varchar(255), remarque varchar (255)
)
GO

GO
SELECT * FROM T_CURSOR
GO
--  INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
-- Populate la table
INSERT INTO T_CURSOR(StudentID, prenom,nom,note, etat, remarque) VALUES ('1','AYOTTE', 'Victor H. O.','100','Admis','') 	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES ('2','CALO','Fabrizio','','Abandon','')	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES ('3','CLARAT','Arnaud D, J.','','Ajourné','Laboratoire: initiation aux bases de données')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES ('4','COUTELLE','Julien P','','Abandon','') 	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES ('5','CUGNON','Geoffrey G','79','Admis','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('6','DECUYPERE','Jules H, L.','82','Admis','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('7','DEVRESSE', 'Cindy G, R.','64','Admise','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('8','DONGMO', 'Christian O','61','Admis','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('9','FRANÇOIS','Shantou','57','Admis','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('10','GENICOT','Jerôme','100','Admis',''	)
INSERT INTO T_CURSOR  (StudentID, prenom,nom,note, etat, remarque) VALUES  ('11','GOEFFOET','Guillaume A, R.','','Abandon','' )	
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES   ('12','GORLIER','Laurent A, R.','93','Admis','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES   ('13','KOUAKOU','Victoria S, A.','','Abandon','' 	)
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('14','LETAWE','Isabelle G, E.','57','Admise','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES   ('15','LEVIS','Maxime C, V.','100','Admis','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('16','MOHIMONT','Gauthier C','93','Admis','')
INSERT INTO T_CURSOR  (StudentID, prenom,nom,note, etat, remarque) VALUES  ('17','MOREIRA GUEDES','Carlos F','100','Admis','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES   ('18','OUAHIB','Anyssa N','99','Admise','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('19','PIERRE','Korenthin P, I.','75','Admis','')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('20','PRINCE','Maxime V, D.','','Ajourné','Laboratoire: initiation aux bases de données')
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES  ('21','SANTOS CRISTOVAO',' Antonio J','57','Admis',''	)
INSERT INTO T_CURSOR (StudentID, prenom,nom,note, etat, remarque) VALUES ('22','SIDIME','Fode B.','' ,'Abandon','' 	)
INSERT INTO T_CURSOR  (StudentID, prenom,nom,note, etat, remarque) VALUES  ('23','TORFS','Corentin E, N.','99','Admis','')
GO
SELECT * FROM T_CURSOR   -- Sélection des élèves de ma table
GO
--ensuite, Autre tables qui reprend la situation des 
SELECT STUDENTID from T_CURSOR 
       WHERE ETAT='ADMIS'

/************************************************************************
 3) test de l'existence de la présence de l'autre table T_STUDENT_STATE
*************************************************************************/
GO
USE IFOSUP_CURSOR  -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_CURSOR .sys.tables WHERE name = 'T_STUDENT_STATE')
DROP TABLE T_STUDENT_STATE
GO
CREATE TABLE T_STUDENT_STATE (ID_STATE int not null, STATE varchar(255))
GO
INSERT INTO T_STUDENT_STATE (ID_STATE, STATE) VALUES  ('1','peut suivre le deuxième module sur les DB transacationnel')
INSERT INTO T_STUDENT_STATE (ID_STATE, STATE) VALUES  ('2','en attente de ses résultats de seconde session - ajournement')
INSERT INTO T_STUDENT_STATE (ID_STATE, STATE) VALUES  ('3','ne peut suivre le deuxième module car abandon')
GO
SELECT * FROM T_STUDENT_STATE



 GO
 DECLARE @CPT_ID as int--variable qui récupérera les CPT_ID DECLARE MyCursor CURSOR --mon curseur

 -- Pour tous les CPT_ID de UTILISATEUR qui ont un ETAT= FATIGUE

DECLARE MyCursor CURSOR FOR
 SELECT STUDENTID from T_CURSOR 
       WHERE ETAT='ADMIS'
 OPEN MyCursor -- j'initialise mon curseur

 -- je le rempli avec mon 1er CP_ID retourné par la requête 

FETCH MyCursor INTO @CPT_ID


-- Tant que je n'ai pas traité tous les CPT_ID de le requête 

WHILE @@fetch_Status = 0
BEGIN
      print @CPT_ID + ' - '
	  print 'hello the world'
      INSERT INTO T_STUDENT_STATE (ID_STATE,STATE)
      VALUES(@CPT_ID, 'OK seront admis')
	 
-- je le rempli avec le CP_ID suivant retourné par la requête
      FETCH MyCursor INTO @CPT_ID 
END

CLOSE myCursor -- je ferme mon curseur 

DEALLOCATE myCursor -- je libère la mémoire allouée à ce curseur 
Print '----------------- Terminé ------------------------'

GO
SELECT * FROM T_STUDENT_STATE

------------- Fin code-----------------------------------------------------------


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
 FETCH name INTO @value1, @value2  
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

------------Fin code --------------------------------------


/*
 ETUDE DES CURSEURS :

 Est-ce qu'il n'y aurait une technique qui me permet lorsqu'il y a un Select - il y a un déroulement
 de la totalité de la table, de la totalité de mes enregistrements (filtre WHERE).
 Est-ce que je dois attendre le déroulement de la totalité de mes données, de la table pour que je puisse
 enfin travailler avec ceux-ci.
 ? technique qui me permet d'aller travailler ligne par ligne au moment de mon Select.
Cette technique, c'est un curseur. 
*/

USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de référence 296 records
GO

-- Premier exemple
-- Je vais simuler le passage ligne par ligne de mon curseur dans une table.
--  Je vais refaire en fait un SELECT, une faactorisation du SELECT

USE Master
GO
--si DB existe -> je la vide et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR_2702021')
DROP DATABASE IFOSUP_CURSOR_2702201  -- Quelque soit la situation de la table, je la vide ! 
GO
      CREATE DATABASE IFOSUP_CURSOR_2702201  -- Je la recrée à nouveau une nouvelle table

/*************************************************************
 2) test de l'existence de la présence de la table T_TCLIENTS
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
3) Insertion de donnée
*/
--  INSERT INTO T_CLIENTS (colum_name) VALUES ('Deuxième transaction')
-- Populate la table
USE IFOSUP_CURSOR_2702201
GO
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('1','MICROSOFT')  
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('2','IBM')  
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('3','ORACLE')     
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('4','AMAZON')     
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('5','FACEBOOK')   
INSERT INTO T_CLIENTS (cli_code, cli_societe) VALUES ('6','ALPHABET')    -- Google
GO
Select * from T_CLIENTS -- 6 records.

-- Je vais créer un curseur et parcourir l'ensemble des enregistrements de ma table T_CLIENTS
DECLARE @a INT,      -- 2 valeurs qui vont récupérer le contenu des mes enregistrements de chaque ligne
        @b VARCHAR(255)
-- Pour <<créer>, le déclarer le curseur, c'est lui donner un nom -> cur1
DECLARE cur1 CURSOR FOR (Select cli_code, cli_societe from  T_CLIENTS) -- Déclarer mon curseur
-- Après avoir déclarer un curseur, je dois ouvrir un curseur
OPEN cur1

      -- Cosmétique au niveau SQL pour qu ece soit Joli !
      PRINT ''
      PRINT 'Ce curseur nous montre bêtement la lecture de tous les enregistrements d''une table'
      PRINT '-----------------------------------------------------------------------------------'
      PRINT ' '
      -- Fin de la cosmétique
-- Tu te postionnes sur le premier enregistrement
 FETCH cur1 INTO @a, @b     -- il récupère la valeur actuelle là où se trouve mon enregistrement
 
 -- Je devoir aller me balader dans ma table
 WHILE @@fetch_status = 0  -- Tant que l'on n'est pas à la fin de ma table, à la fin de mon select >cela revoit
                           --  une valeur de 0
                                       --- Quand, je suis à la fin, cette variable @@fetch_status prend la valeur 1 et
                                       -- et donc, je dois sortir de cette table puisque c'est la fin.
       BEGIN
        Print 'Hello the Cursor'
        Select @a, @b  ----Affichage de mes données cli_code en passant par la variable @a et cli_societe en passant
                       -- par la variable @b
        Print 'n°: ' + cast(@a as nvarchar(10)) + ' ' + 'L''enregistrement IT est : ' + @b
        FETCH cur1 INTO @a, @b
      END
CLOSE cur1          -- fermeture de mon curseur
DEALLOCATE cur1 -- Je dois libérer la mémoire


----------------Fin code ----------------------------------------------------------------



-- SQLQuery_curseur_exemple2 --

/******************************************
* Comprendre les curseurs et son utilité  *
*******************************************/
-- 

Use AdventureWorks2017

-- Nous allons travailler avec 2 tables
-- [Production].[Product]
-- [Production].[ProductInventory]

Select * from [Production].[Product] -- ProductID | Name | ProductNumber | ListPrice
Select * from [Production].[ProductInventory] -- ProductID | LocationId | Quantity

-- Mise en forme de ces tables.. je travaille avec des tables temporaires.

IF object_id ('tempdb.dbo.#temp1') is not null 
Drop table #temp1
Select ProductID, Name, ProductNumber, Color, ListPrice into #temp1 From [Production].[Product] Where ProductId like '7%' -- 94 lignes
Select * from #temp1 -- 10 lignes

Select * from [Production].[ProductInventory]


IF object_id ('tempdb.dbo.#temp2') is not null 
Drop table #temp2
Select ProductID, LocationId, Quantity into #temp2 from [Production].[ProductInventory] where ProductID like '7%'
Select * from #temp2

Select * from #temp1
Select * from #temp2

/* Voici mes 2 tables en dur :
tblProducts
tblProductSales

*/
Drop table tbl_Products
Select top (10) * into tbl_Products From #temp1  -- Prendre que les 10 premiers enregistrements

Drop table tbl_ProductSales
Select top (10) * into tbl_ProductSales From #temp2  --

Select  * from tbl_Products
Select  * from tbl_ProductSales


/*
-- Jointure entre les 2 tables
-- Je souhaite ici avoir le nom du produit associé à sa quantité de production -> table #temp3
*/

-- ProductId | Name | ProductNumber | ListPrice | Quantity
IF object_id ('tempdb.dbo.#temp3') is not null 
Drop table #temp3
Select P.ProductId, P.Name, P.ProductNumber,  P.ListPrice, S.Quantity
INTO #temp3 FROM tbl_Products P
JOIN tbl_ProductSales S on P.ProductID = S.ProductID
Where (P.Name = 'HL Road Frame - Red, 58' OR               -- ProductNumber
P.Name = 'Sport-100 Helmet, Red' OR P.Name = 'Sport-100 Helmet, Black')

Select * from #temp3 -- Résultat de la jointure
-- Si on voulait modifier la quantité de tel ou tel produit en fonction du ProductId, on le ferait via une jointure
-- Mais on peut aussi travailler avec un Curseur qui va lire les enregistrements d'une première table (tbl_Products)
-- et modifier la seconde (tbl_ProductSales) en tenant compte des critères



/*****************************************
  1er Création d'un curseur
  Lecture des enregistrements de la table
********************************************/
Declare @ProductID int
Declare @Name nvarchar(30)

Declare ProductCursor Cursor FOR
Select ProductID, Name from tbl_Products ---Where ProductID like '7%'
Open ProductCursor
WHILE (@@FETCH_STATUS = 0)  -- Tant que je ne suis pas à la fin > on boucle
            BEGIN
            Print 'Id ' + cast(@ProductID as nvarchar(30)) + ' Nom : ' + @Name
            Fetch Next from ProductCursor into @ProductID, @Name
                        END
CLOSE ProductCursor
DEALLOCATE ProductCursor
-- En fait, le code de ci-dessus ne fait que lister les données de la table 

Select * from #temp3  -- Name  |   ProductNumber   |   ListPrice   |  Quantity  


/******************************************************************************************************
* Création du second curseur
  L'idée, c'est de remplacer la jointure : 
  Je vais lire chaque enregistrement de la première table et modifier la seconde suivant certains critères
  en même temps, c'est l'atout même de l'utilité d'un curseur

-- Admettons maintenant que je souhaite mettre à jour aussi la table ProductSales en  
-- en modifiant la valeur de la quantité 
-- Si j'ai affaire à un ProductId 707 (ou à son ProductNumber) => j'ajoute la valeur de 10 au champ quantité
-- 708 -> "quantity" est augmenté de 20 unités
-- 709 -> "quantity" est augmenté de 10 unités, etc.
   Ces opérations de mise à jour auraient pu être faites via une jointure et des tables temporaires.
   ça prend du temps en termes de code SQL !
   Alors qu'ici, les opérations se font au fur et à mesure de la lecture des données !
*/

GO
DROP Table tbl_Products1
Select * into  tbl_Products1 From  tbl_Products
Select * from  tbl_Products1
Select * from tbl_ProductSales 

Declare @ProductID1 int,
        @Name1 nvarchar(30),
        @ProductNombre1 nvarchar(25),
            @Quantity1 smallint;
Declare testcurseur Cursor FOR
  ( Select ProductID,ProductNumber from tbl_Products1 )  
Open testcurseur
PRINT 'Mise à jour de la table tlb_ProductSales en parcourant ligne par ligne la table tbl_Product'
PRINT '-------------------------------------------------------------------------------------------'
FETCH Next From testcurseur INTO @ProductID1, @ProductNombre1  -- On se positionne ligne par ligne, la première ici !
PRINT 'Numero de depart: ' + cast (@ProductID1 as nvarchar(10))
WHILE (@@FETCH_STATUS = 0)  -- Tant que je ne suis pas à la fin > on boucle
            BEGIN  -- Begin 1
            --Print 'Id ' + cast(@ProductID as nvarchar(30)) + ' Nom : ' + @Name
            Print 'je suis dans le curseur'
            PRINT 'Numero dans le curseur : ' + cast (@ProductID1 as nvarchar(10))
            Print ' '
            IF ( @ProductNombre1 = 'FR-R92R-58' )   --- 
         BEGIN
             Select ProductID, Quantity from tbl_ProductSales WHERE ProductID = @ProductID1 
         UPDATE tbl_ProductSales SET Quantity = 298 WHERE ProductID = @ProductID1  -- Mise  jour de la table tbl_ProductSales
         END
        ELSE IF ( @ProductNombre1 = 'SO-B909-M' )   --- 709
         BEGIN
             Select ProductID, Quantity from tbl_ProductSales WHERE ProductID = @ProductID1 
         UPDATE tbl_ProductSales SET Quantity = 190 WHERE ProductID = @ProductID1  -- Mise  jour de la table tbl_ProductSales
         
            END

Fetch Next from testcurseur into @ProductID1, @ProductNombre1
      END   -- Fin du Begin 1
CLOSE testcurseur
DEALLOCATE testcurseur


-- Et voilà la mise à jour de la table tbl_ProductSales
-- Ici, seul le << ProductId = 790 >> a été mis à jour.
-- Sa quantité est passée de la valeur de 180 à 190.
Select * from tbl_ProductSales   









