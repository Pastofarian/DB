/*************************************************************************************************************************************************************
*   On souhaite travailler avec la base de données « AdventureWorks2017 ».
*   Nous travaillerons avec la table « HumanResources.Departement » :
*
*   Ecrire le code SQL qui nous montre une transaction avec quelques données insérées dans celle-ci (cfr.
*   Schéma de la table pour connaître les champs en question).
*   S’il devait y avoir une erreur au cours de l’insertion de données, veuillez générer un ROLLBACK
*   pour réinitialiser la table sinon, le COMMIT a lieu.
*   Montrez que ce Rollback est fonctionnel en s’appuyant sur des exemples pertinents ainsi que le ainsi que le COMMIT.
***********************************************************************************************************************************************************/

USE AdventureWorks2017
GO

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE usp_GetErrorInfo;  
GO  
-- Create procedure to retrieve error information.
CREATE PROCEDURE usp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO  

--IF OBJECT_ID('tempdb.#temp1') is not NULL -- ne marche pas avec Azure car #temp1 n'est pas dans tempdb (jamais trouvé où)
DROP table #temp1

SELECT *
INTO #temp1 
FROM [HumanResources].[Department]

BEGIN TRANSACTION
    BEGIN TRY  

        --SELECT 1/0 test;             -- retirer le commentaire pour avoir l'erreur
        INSERT INTO  #temp1 (Name, GroupName, ModifiedDate) VALUES ('Koality', 'Koality wellbeing', '2000-01-01 00:00:00.000')

    END TRY  
    BEGIN CATCH 
    ROLLBACK TRANSACTION
    -- Execute error retrieval routine.
    EXECUTE usp_GetErrorInfo;
    END CATCH;
COMMIT TRANSACTION
GO
SELECT * FROM #temp1

--------------Autre solution avec une création de BDD-----------------------

CREATE DATABASE HomeWork04_02
GO

CREATE table tblProduct
( 
Name varchar(50),
UnitPrice int,
QtyAvailable int)

-- SELECT * FROM tblProduct

Create Table tblGender
(
Gender varchar(50))

 -- Début requete

BEGIN TRY  
BEGIN TRANSACTION

-- SELECT 1/0 test;   -- retirer le commentaire pour avoir l'erreur
INSERT INTO  tblProduct (Name, UnitPrice, QtyAvailable) VALUES ('HomeWork', 100, 1)

Commit Transaction
END TRY  
    BEGIN CATCH  
    Rollback Transaction
        SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage
    END CATCH
GO 
SELECT * FROM tblProduct
