
-- Déclaration des variables dans SQL

-- Déclaration littérale

DECLARE @var1 INT --= 6 + 6;
---SET @var = 6      --- -Assignation de la variable var1 égale à 6
SET @var1 = 6 + 6
DECLARE @var2 INT = 12
SELECT (@var1 + @var2) Mike -- , @var1 John, @var1 Mike -- NULL  => 0 ou est-ce que c'est manquant !
PRINT 'TOTAL' + ' = ' + CAST (@var1 AS VARCHAR(10))
-- 
USE AdventureWorks2017
DECLARE @nbr_ligne INT
SET @nbr_ligne = ( SELECT COUNT (BusinessEntityID) Nbr_ligne FROM [person].[Person] ) -- Affectation d'une variable  */* à un SELECT
PRINT @nbr_ligne --- Rapport ==> au niveau de l'onglet (de la fenêtre) Messages

--
-- Affectation d'une variable  */* à une fonction SQL (GETDATE() )
DECLARE @var_datetime DATETIME
SET @var_datetime = getdate()
---SELECT * FROM [HumanResources].[Employee]
SELECT BusinessEntityID, NationalIDNumber, BirthDate AS Date_de_naissance, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]

-- GO !!!!
USE AdventureWorks2017

GO  -- fragmente le code (factorisation du code SQL)
DECLARE @var_datetime DATETIME
SET @var_datetime = getdate()
---SELECT * FROM [HumanResources].[Employee]
SELECT BusinessEntityID, NationalIDNumber, BirthDate AS Date_de_naissance, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]
GO

--
-- Deuxième façon de déclarer mais aussi de travailler avec ces variables dans des SELECT
USE AdventureWorks2017
GO
SELECT * FROM [person].[Person]  where BusinessEntityID = 3;
	DECLARE @firstname AS NVARCHAR(50)
	DECLARE @lastname AS NVARCHAR(50)

SET @firstname  = (select FirstName  from [person].[Person]  where BusinessEntityID = 3);
	PRINT @firstname

SET @lastname = (select Lastname from [person].[Person] where businessEntityID = 3);
	Print @firstname;
	Print @lastname;
-- en fin 
SELECT @firstname as Prenom, @lastname Nom

--
-- Autre façon de déclarer les variables et de jouer avec elles.

DECLARE @firstname as nvarchar(10),
        @lastname as nvarchar(20);

SELECT @firstname = firstname, @lastname = lastname 
 FROM [person].[Person] where businessEntityID = 1;
 SELECT @firstname AS Prenom, @Lastname AS Nom
 PRINT @firstname + ' ' +  @Lastname













