/*************************************************************************************************************************************************************
*   On souhaite travailler avec la base de données « AdventureWorks2017 ».
*   Nous travaillerons avec la table « HumanResources.Departement » :
*
*   Ecrire le code SQL qui nous montre une transaction avec quelques données insérées dans celle-ci (cfr.
*   Schéma de la table pour connaître les champs en question).
*   S’il devait y avoir une erreur au cours de l’insertion de données, veuillez générer un ROLLBACK
*   pour réinitialiser la table sinon, le COMMIT a lieu.
*   Montrez que ce Rollback est fonctionnel en s’appuyant sur des exemples pertinents ainsi que le
***********************************************************************************************************************************************************/
USE AdventureWorks2017
GO

IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1

SELECT *
INTO #temp1 
FROM [HumanResources].[Department]

BEGIN TRY  
BEGIN TRANSACTION

-- SELECT 1/0 test;             -- retirer le commentaire pour avoir l'erreur
INSERT INTO  #temp1 (Name, GroupName, ModifiedDate) VALUES ('Koality', 'Koality wellbeing', '2000-01-01 00:00:00.000')

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



/*************************************************************************************************************************************************************
* Programme à réaliser : Mise en pratique de la notion de table temporaire
*
*   Rechercher la date la plus récente dans la table [HumanResources].[Employee]                                                     *
*   de la base de données AdventureWorks2017
*   On souhaite avoir comme résultat la date de naissance la plus récente et la plus éloignée
*   Ce résultat devra reprendre les champs suivants : NationalIDNumber, date_naissance (anciennement BirthDay)
*   La recherche de ces 2 dates doivent se retrouver dans une et une seule table finale temporaire.
*   Nous travaillerons avec les tables temporaires
*
* Cfr. : (1) Cfr.documentation technique MSQL : https://docs.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database?view=sql-server-2017 
*        (2) Cfr. https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017
*
* (c) MB - Ifosupwavre
***********************************************************************************************************************************************************/

USE AdventureWorks2017
GO

-- SELECT * FROM [HumanResources].[Employee]

IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1
IF OBJECT_ID('tempdb.#temp2') is not NULL
DROP table #temp2
IF OBJECT_ID('tempdb.#temp3') is not NULL
DROP table #temp3

SELECT NationalIDNumber, BirthDate
INTO #temp1 
FROM [HumanResources].[Employee] 

SELECT TOP 1 (BirthDate) AS DateDeNaissance_min, NationalIDNumber
INTO #temp2
FROM #temp1
GROUP BY BirthDate, NationalIDNumber
ORDER BY Birthdate ASC

SELECT TOP 1 (BirthDate) AS DateDeNaissance_max, NationalIDNumber
INTO #temp3
FROM #temp1
GROUP BY BirthDate, NationalIDNumber
ORDER BY Birthdate DESC

SELECT CONVERT(NVARCHAR, DateDeNaissance_min, 101 ) AS Date, NationalIDNumber As NumeroNational FROM #temp2 
UNION
SELECT CONVERT(NVARCHAR, DateDeNaissance_max, 101 ) AS Date, NationalIDNumber As NumeroNational  FROM #temp3




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

BEGIN TRY  
    BEGIN TRANSACTION
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


--https://stackoverflow.com/questions/43842183/banking-transaction-in-sql

--https://social.msdn.microsoft.com/Forums/sqlserver/en-US/18f301cf-205a-4403-a03b-f7c0af692f56/create-bank-statement-in-ms-sql


