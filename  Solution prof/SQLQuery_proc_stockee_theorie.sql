
/* Procédure stockée 
Différence entre une procédure stockée et une fonction

La principale différence entre une procédure et une fonction stockée est dans l'utilisation qu'on en fait. 
Une procédure stockée sera utilisée seule alors qu'une fonction stockée sera utilisée à l'intérieur d'une requête SQL.
Une autre différence se fait sentir au niveau de la valeur de retour : seule la fonction stockée en a une. 
*/

Use AdventureWorks2017
GO
Select * from [Person].[Person]
Select * from [HumanResources].[Employee]

drop table #temp1
Select BusinessEntityID, Firstname,Lastname, Title 
 into #temp1 from [Person].[Person]
 Select * from #temp1

 -- Je vais faire une jointure LEFT
 Drop table #temp2
 Select p.BusinessEntityID, p.Firstname, p.Lastname, p.Title, 
     H.Birthdate, H.Gender  into #temp2
	 from #temp1 p LEFT JOIN [HumanResources].[Employee] H on p.BusinessEntityID = H.BusinessEntityID
where H.Birthdate <> ''

Select * from #temp2  -- table résultante qui résulte d'une jointure entre les tables Person et Employee


/************************************
  CREATION d'une procédure stockée.
************************************/

-- Les procédures stockée se retrouvent au niveau de la valise Programmability Stored Procedures
USE AdventureWorks2017
GO
-- Je teste l'exitance de cette procédure, ici que je nomme 
IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.spGetEmployeesMB2021' AND type = 'P')
  DROP PROCEDURE dbo.spGetEmployeesMB2021
GO
-- En exécutant ce petit bout de code, j'ai créé une procédure stockée
SELECT name FROM sysobjects where type ='P' -- L'ensemble de toutes les procédures stockées que j'ai créé
GO

-- Je créé réellement ma procédure stockée.
-- CREATE PROCEDURE dbo.spGetEmployeesMB2021  -- le nom de ma procédure dbo.spGetEmployeesMB2021
ALTER PROCEDURE dbo.spGetEmployeesMB2021 
AS BEGIN
 --  Select * from [Person].[Person]
 --  Select * from [HumanResources].[Employee]
	
	drop table #temp3
	Select BusinessEntityID, Firstname,Lastname, Title 
	 into #temp3 from [Person].[Person]
	 Select * from #temp3

	 -- Je vais faire une jointure LEFT JOIN
	 Drop table #temp4
	 Select p.BusinessEntityID, p.Firstname, p.Lastname, p.Title, 
		 H.Birthdate, H.Gender  into #temp4
		 from #temp3 p LEFT JOIN [HumanResources].[Employee] H on p.BusinessEntityID = H.BusinessEntityID
	where H.Birthdate <> ''
	
	Drop table #temp_employee
	Select * into #temp_employee from #temp4
	Print 'Hello the World'
	Print 'Bonjour les étudiants de BAC info 1er'
END
-- En exécutant le code ci-dessus, je crée une prcédure stockée que je peux appler à tout moment.

-- Pour appeler une procédure stockée.
-- Il y a plusieurs façon d'appeler une procédure

-- 1er façon d'appeler une procédure stockée
dbo.spGetEmployeesMB2021

-- 2ème façon d'appeler ma procédure stockée
EXEC dbo.spGetEmployeesMB2021

-- 3ème façon d'appeler ma procédure stockée
EXECUTE dbo.spGetEmployeesMB2021


-- Question :
-- Si je voulais maintenant modifier ma procédure stockée
-- y réajouter du code SQL




