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

SELECT CONVERT(NVARCHAR, DateDeNaissance_min, 103 ) AS Date, NationalIDNumber As NumeroNational FROM #temp2 
UNION
SELECT CONVERT(NVARCHAR, DateDeNaissance_max, 103 ) AS Date, NationalIDNumber As NumeroNational  FROM #temp3




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



/****************************************************************************************************************************************************
* 1. Ecrire un petit programme qui liste l'ensemble des personnes ayant un mail de la DB AdventureWorks2017.
*    Nous souhaiterons avoir les données suivantes (champs à renommer): 
*     Nom (FirstName), Prénom (LastName), BusinessEntityID et (Adresse mail) EmailAddress.
*    ...et ce dans une table temporaire #temp2
*    On utilisera aussi une table temporaire @temp1 
* 
* 2. Déclarer 3 variables type firstname, lastname, Email
*    Ces 3 variables doivent reprendre comme contenu les données Prénom, Nom, Adresse mail où BusinessEntityID est égale à 295 de la table #temp2
*    Afficher le contenu de ces variables via un SELECT
* 
*****************************************************************************************************************************************************/

USE
AdventureWorks2017
GO
--IF OBJECT_ID('tempdb.#temp2') is not NULL
DROP table #temp2
--IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1
GO

SELECT Person.BusinessEntityID, Person.LastName AS Nom, Person.FirstName AS Prenom, Person.EmailAddress.EmailAddress AS [Adresse mail]
INTO #temp2 
FROM Person.Person
INNER JOIN person.EmailAddress
ON Person.Person.BusinessEntityID = Person.EmailAddress.EmailAddressID
GO
CREATE TABLE #temp1
(ID int Identity(1,1) Primary Key)
GO
SELECT * FROM #temp2

DECLARE @FirstName AS VARCHAR(50);
DECLARE @LastName AS VARCHAR(50);
DECLARE @Email AS VARCHAR(50);

SET @FirstName = (SELECT Prenom FROM #temp2 WHERE BusinessEntityID = 295);
SET @LastName = (SELECT Nom FROM #temp2 WHERE BusinessEntityID = 295);
SET @Email = (SELECT [Adresse mail] FROM #temp2 WHERE BusinessEntityID = 295);

SELECT @FirstName AS "Prenom";
SELECT @LastName AS "Nom";
SELECT @Email AS "Mail";
GO



