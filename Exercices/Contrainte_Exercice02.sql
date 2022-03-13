/*************************************************************************************************************************************************************
--Ecrire le code transactionnel qui répond au cahier de charge suivant.
--Veuillez créer une base de données nommée : « MyIfosup_Bank » (avec test de son existence) où
--nous retrouverons les tables suivantes :
--• L’une prend en compte mon épargne où j’ai un montant de 1000 € (numéro de compteID,
--montant)
--• L’autre est associée au compte courant où nous avons un montant de 1000€ (numéro de
--compteID, montant).
--Pour le compte courant, celui-ci est assorti d’une contrainte que nous appellerons < Diff > .
--Cette contrainte stipule que lors d’un achat (compte débité) , cette différence entre le montant de
--notre compte et celui d’un achat, ne peut dépasser un seuil de 100€.
--Tester que la règle fonctionne en essayant de faire des opérations qui violent la règle.
--Les opérations bancaires sont les suivantes :
--Si je crédite le compte d’épargne, cela ne pose aucun problème.
--Par contre, si je débitais le compte courant d’un certain montant où la différence était supérieure à
--100 €, il y aurait erreur puisqu’elle est engendrée par la contrainte de départ au sein de la table
--compte courant.
--Dans ce cas, il conviendra d’effectuer un ROLLBACK (dans une gestion d‘erreur) des montants
--engagés tant pour le débit que le crédit.
--Sources utiles :
--Gestion des erreurs :
--•
--•
--Raiserror (Transct-SQL) : https://docs.microsoft.com/en-us/sql/t-sql/language-
--elements/raiserror-transact-sql?view=sql-server-2017
--Try...Catch (Transact-SQL) : https://docs.microsoft.com/en-us/sql/t-sql/language-
--elements/try-catch-transact-sql?view=sql-server-2017
--Contraintes :
--• Unique Constraints ans Check Constraints : https://docs.microsoft.com/en-us/sql/relational-
--databases/tables/unique-constraints-and-check-constraints?view=sql-server-2017
--•
--SET :
--•
--Alter Table (Transact-SQL) : https://docs.microsoft.com/en-us/sql/relational-
--databases/tables/unique-constraints-and-check-constraints?view=sql-server-2017
--SET (Transac-SQL) : https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-local-
--variable-transact-sql?view=sql-server-2017
***********************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'MyIfosup_Bank')
DROP DATABASE MyIfosup_Bank 
GO
CREATE DATABASE MyIfosup_Bank
GO

CREATE TABLE #savings
(compteID int Identity(1,1) Primary Key, montant int)

CREATE TABLE #checking
(compteID int Identity(1,1) Primary Key, montant int)

INSERT INTO  #savings 
(montant) VALUES (1000)

INSERT INTO  #checking 
(montant) VALUES (1000)

--SELECT * FROM #savings
--SELECT * FROM #checking

ALTER TABLE #savings
ADD CONSTRAINT CK_Diff CHECK (montant < 100)

BEGIN TRANSACTION
    BEGIN TRY  

    UPDATE #checking
    SET montant = 50
    FROM #checking
Commit Transaction
    END TRY  
        BEGIN CATCH  
Rollback Transaction
        SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage
    END CATCH
GO 

