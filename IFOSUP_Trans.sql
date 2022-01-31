USE Master
GO
--si DB existe --> je la videe et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_Trans')
DROP DATABASE IFOSUP_Trans 
GO
CREATE DATABASE IFOSUP_Trans --Je la recrée à nouvveau
GO

----------------------------------------
GO
USE IFOSUP_Trans -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_Trans.sys.tables WHERE name = 'T_Trans')
DROP TABLE T_TRANS 
GO
CREATE TABLE T_TRANS (colum_name varchar(255))
SELECT * FROM T_Trans
GO
-----------------------------------------

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction')
COMMIT TRANSACTION
SELECT colum_name FROM T_TRANS

------------------------------------------

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction')
-- COMMIT TRANSACTION
ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

--------------------------------------------
DROP TABLE T_TRANS
-------------------------------------------
-- recréer la table avec précédent code

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
COMMIT TRANSACTION

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

--------------------------------------------

TRUNCATE TABLE T_TRANS  --Vide la table de ses valeurs, supprime le contenu de la table

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
--COMMIT TRANSACTION
ROLLBACK TRANSACTION

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

-------------------------------------------






-- 28/01/22

TRUNCATE TABLE T_TRANS

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')
	SAVE TRANSACTION S1;

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
--COMMIT TRANSACTION
ROLLBACK TRANSACTION S1

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION S1
SELECT colum_name FROM T_TRANS

-----------------------------------------------------

SELECT * FROM master.sys.databases; --infos sur master voir toutes les BDD

-----------------------------------------------------

/*
Etude d'une transaction BEGIN / COMMIT /ROLLBACK
*/
USE [AdventureWorks2017]
GO
--Je vais aller lire le nombred'enregistreent dans la table HumanResources
-- Le nombre est placé dans un champ, ic BeforeCount
SELECT COUNT (*) BeforeCount FROM [HumanResources].[Department] -- 16 occurences

----------------------------------------------------------------------------------


-- Si je regarde la tête de la table et de leur champ :
SELECT * FROM [HumanResources].[Department]

------------------------------------------------------------


BEGIN TRANSACTION
INSERT INTO HumanResources.Department
(Name, GroupName)
VALUES ('TEST_Accounts Payable', 'TEST_Accounting')
COMMIT


SELECT * FROM [HumanResources].[Department]

------------------------------------------------------------------------------------

-- Gestion d'une erreur dans T-SQL

BEGIN TRY  
     { sql_statement | statement_block }  
END TRY  
BEGIN CATCH  
     [ { sql_statement | statement_block } ]  
END CATCH  
[ ; ]

--------------------------------------------------------------------

-- Gestion d'une erreur dans T-SQL

USE AdventureWorks2017
GO
BEGIN TRY  
     -- Generate a divide-by-zero error.
     SELECT 1/0 test;
END TRY  
BEGIN CATCH  
    SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage
END CATCH ;
GO 

-------------------------------------------------------------------------------


-- Gestion d'une erreur dans T-SQL

GO
DECLARE @Error INT
BEGIN TRANSACTION 

BEGIN TRY  
    INSERT HumanResources.Department
    (Name, GroupName)
    VALUES('TEST_Accounts Payable', 'TEST_Accounting') -- Ce champ existe déjà dans la DB et donc génere une erreur !

END TRY  
BEGIN CATCH  
    SELECT --Une série de variables "systèmes" qui renseigne sur la nature de l'erreur en question
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage

--ERROR_MESSAGE() -->
--Returns the complete text of the error message. The text includes the values supplied for any subsistuables parametres

IF @@TRANCOUNT > 0 -- Returns the number of BEGIN TRANSACTION statements that have occured on the current connection.
    ROLLBACK TRANSACTION;
    SELECT * FROM HumanResources.Department
END CATCH ;
GO 

---------------------------------------------------------------------

GO
SELECT * FROM HumanResources.Department
DECLARE @Error INT
SET @Error = @@ERROR
BEGIN TRANSACTION
IF (@ERROR <> 0) GOTO Error_Handler
    INSERT HumanResources.Department (Name, GroupName)
    VALUES ('Engineering', 'Research and Development')
    -- Pas complet

    ---------------------------------------------------------------

 USE AdventureWorks2017
SELECT * FROM [Production].[Product]
SELECT * FROM [Production].[ProductInventory]

/* jointure:
production.Product :
[Produ]
*/
IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1

SELECT P.ProductID, P.Name [Nom], P.ProductNumber, P.SafetyStockLevel, P.ReorderPoint,
I.Quantity, I.ModifiedDate
INTO #temp1 FROM [Production].[Product] AS P JOIN --crée la table avec INTO
[Production].[ProductInventory] AS I ON P.ProductID = I.ProductID
SELECT * FROM #temp1 -- 1070 lignes
