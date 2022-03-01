
/*
DECLARATION DES VARIABLES
--------------------------------------------
Les variables sont limitées au lot d'exécution de la session en cours uniquement.
Cela concerne uniquement la session en cours.
*/

USE AdventureWorks2017
select * from [person].[Person] 
select * from [HumanResources].[Employee]
-- 1er façon de décrire des variables

DROP table #temp1
select COUNT (BusinessEntityID) Nbr_ligne into #temp1 from [person].[Person]
select * from #temp1 -- 19.972 lignes


-- Plusieurs façon de déclarer une variable
-- 1)
DECLARE @var1 INT;      -- Déclaration littérale 
SET @var1 = 6           -- n°1 Assignation de la variable à une valeur 6 : SET
SET @var1 = @var1 + 1   -- On n'hésitera pas faire
PRINT @var1
SELECT @var1
SELECT @var1 AS variable

-- n°2 Assignation : On peux aussi étoffer l'assignation comme suit :
-- SET se fait à partir d'un SELECT 

USE AdventureWorks2017
SELECT * FROM [person].[Person]
DECLARE @var2 INT
SET @var2 = ( select COUNT (BusinessEntityID) Nbr_ligne from [person].[Person] )
Print @var2
select @var2 AS variable


-- autre exemple :
select * from [HumanResources].[Employee]
DECLARE @var_date DATE
SELECT @var_date = MAX (c.BirthDate) FROM [HumanResources].[Employee] c
SELECT @var_date

-- SET se fait à partir d'une fonction 
SELECT * FROM [HumanResources].[Employee]
DECLARE @var_datetime DATETIME
SET  @var_datetime = GETDATE()  -- Fonction
SELECT BusinessEntityID, NationalIDNumber, BirthDate, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]


-- Déclaration de la variable - ATTENTION AU GO...cloisonne la déclaration des variables
/*
J'aurai automatiquement une erreur SQL de type :
Msg 137, Level 15, State 1, Line 33
Must declare the scalar variable "@var3".
*/
USE AdventureWorks2017
DECLARE @var3 INT
GO
SELECT * FROM [person].[Person]
SET @var3 = ( select COUNT (BusinessEntityID) Nbr_ligne from [person].[Person] )  
-- Dés que je fais quelques choses dans un SELECT, je dois lui affecter le résultat dans une nouvelle variable
Print @var3
select @var3 AS variable

-- 2) Deuxième façon
USE AdventureWorks2017
GO
SELECT * FROM [person].[Person]  where BusinessEntityID = 3;
DECLARE @firstname AS NVARCHAR(50)
DECLARE @lastname AS NVARCHAR(50)
SET @firstname = (select FirstName from [person].[Person]  where BusinessEntityID = 3);




--3) Troisième façon de faire

DECLARE @firstname as nvarchar(10),
        @lastname as nvarchar(20);
SELECT @firstname = firstname, @lastname = lastname 
 FROM [person].[Person] where businessEntityID = 3;
 SELECT @firstname AS Prenom, @Lastname AS Nom


--------
