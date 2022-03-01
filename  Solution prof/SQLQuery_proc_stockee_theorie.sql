
/* Proc�dure stock�e 
Diff�rence entre une proc�dure stock�e et une fonction

La principale diff�rence entre une proc�dure et une fonction stock�e est dans l'utilisation qu'on en fait. 
Une proc�dure stock�e sera utilis�e seule alors qu'une fonction stock�e sera utilis�e � l'int�rieur d'une requ�te SQL.
Une autre diff�rence se fait sentir au niveau de la valeur de retour : seule la fonction stock�e en a une. 
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

Select * from #temp2  -- table r�sultante qui r�sulte d'une jointure entre les tables Person et Employee


/************************************
  CREATION d'une proc�dure stock�e.
************************************/

-- Les proc�dures stock�e se retrouvent au niveau de la valise Programmability Stored Procedures
USE AdventureWorks2017
GO
-- Je teste l'exitance de cette proc�dure, ici que je nomme 
IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.spGetEmployeesMB2021' AND type = 'P')
  DROP PROCEDURE dbo.spGetEmployeesMB2021
GO
-- En ex�cutant ce petit bout de code, j'ai cr�� une proc�dure stock�e
SELECT name FROM sysobjects where type ='P' -- L'ensemble de toutes les proc�dures stock�es que j'ai cr��
GO

-- Je cr�� r�ellement ma proc�dure stock�e.
-- CREATE PROCEDURE dbo.spGetEmployeesMB2021  -- le nom de ma proc�dure dbo.spGetEmployeesMB2021
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
	Print 'Bonjour les �tudiants de BAC info 1er'
END
-- En ex�cutant le code ci-dessus, je cr�e une prc�dure stock�e que je peux appler � tout moment.

-- Pour appeler une proc�dure stock�e.
-- Il y a plusieurs fa�on d'appeler une proc�dure

-- 1er fa�on d'appeler une proc�dure stock�e
dbo.spGetEmployeesMB2021

-- 2�me fa�on d'appeler ma proc�dure stock�e
EXEC dbo.spGetEmployeesMB2021

-- 3�me fa�on d'appeler ma proc�dure stock�e
EXECUTE dbo.spGetEmployeesMB2021


-- Question :
-- Si je voulais maintenant modifier ma proc�dure stock�e
-- y r�ajouter du code SQL




