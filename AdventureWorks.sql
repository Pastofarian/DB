

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
-- pas complet

--------------------------------------------------------------------------

USE AdventureWorks2017
GO
SELECT * FROM HumanResources.Department
GO
BEGIN TRANSACTION
INSERT INTO HumanResources.Department
(Name, GroupName)
VALUES ('TEST_TeamBuilding', 'TEST_WellBeingTeam')
COMMIT


SELECT * FROM [HumanResources].[Department]




