
-- Procédure stockée qui se base sur une entrée comme paramètre
-- Savoir quelles sont les personnes M ou F d'un département
-- Normalement, j'aurai dû fair eune jointure...du code SQL entre
--- HumanResources.Employees et EmployeeDepartmentHistory

-- ETAPE n°1 :
--------------
USE [AdventureWorks2017]
IF object_id ('tempdb.dbo.#temp_EmployeeBIS') is not null 
DROP TABLE #temp_EmployeeBIS
select p.BusinessEntityId, p.Firstname, p.LastName, p.Title, H.BirthDate, H.Gender into  #temp_EmployeeBIS
FROM [Person].[Person] p LEFT JOIN  [HumanResources].[Employee] H ON p.BusinessEntityID = H.BusinessEntityID 
WHERE H.BirthDate <> ''
SELECT * FROM #temp_EmployeeBIS

-- ETAPE n°2 :
--------------

--DROP TABLE tbl_employee
SELECT * INTO tbl_employee FROM #temp_EmployeeBIS 
SELECT * FROM tbl_employee  -- si ## global pour permet d'envoyer des tables temporaires dans des sessions différentes

-- Jointure pour aller chercher A quel département appartient la personne : [HumanResources].[EmployeeDepartmentHistory]

SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]  -- BusinessEntityId, DepartmentId
IF object_id ('tempdb.dbo.#temp_employeedepartment') is not null 
DROP TABLE #temp_employeedepartment
Select E.BusinessEntityID, E.FirstName, E.LastName, E.Title, E.BirthDate, E.Gender, D.DepartmentId
INTO #temp_employeedepartment FROM tbl_employee E JOIN [HumanResources].[EmployeeDepartmentHistory] D 
ON E.BusinessEntityID = D.BusinessEntityID
Select * from #temp_employeedepartment  -- 296 lignes

DROP TABLE tbl_Employee_Gender_Department
SELECT * INTO  tbl_Employee_Gender_Department FROM #temp_employeedepartment


-- Cette table tbl_Employee_Gender_Department
Select * from tbl_Employee_Gender_Department  -- j'ai ma table en dur -- 296 lignes

-- L'idée, c'est de créer une procédure stockée lorsque je passe en paramètre M ou F, il me donne le
-- si je donne en paramètre le DepartmentID et le sexe M
-- Cette procédure doit me renvoyer les personnes de ce département

-- CREATION DE LA PROCEDURE STOCKEE
-- On aura testé auparavant l'existence de la procédure stockée
USE AdventureWorks2017
GO
CREATE PROCEDURE spGetEmployeesByGenderAndDepartmentMB2021 -- nom de cette procédure
--je vais crée les 2 paramètres qui vont accueillir les 2: sexe, ID du département

@Gender nvarchar(1),
@departmentID int
AS
BEGIN
 Select * from tbl_Employee_Gender_Department WHERE GENDER = @GENDER and DepartmentID = @departmentID
 
END

--Exécution de ma procédure stockée avec passage en paramètre
spGetEmployeesByGenderAndDepartmentMB2021 @Gender = 'F', @departmentId = 16

-- Autre exemple :
-- Exécution de ma procédure stockée avec passage en paramètre
spGetEmployeesByGenderAndDepartmentMB2021 @Gender = 'F', @departmentId = 1


