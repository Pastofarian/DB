
-- Proc�dure stock�e qui se base sur une entr�e comme param�tre
-- Savoir quelles sont les personnes M ou F d'un d�partement
-- Normalement, j'aurai d� fair eune jointure...du code SQL entre
--- HumanResources.Employees et EmployeeDepartmentHistory

-- ETAPE n�1 :
--------------
USE [AdventureWorks2017]
IF object_id ('tempdb.dbo.#temp_EmployeeBIS') is not null 
DROP TABLE #temp_EmployeeBIS
select p.BusinessEntityId, p.Firstname, p.LastName, p.Title, H.BirthDate, H.Gender into  #temp_EmployeeBIS
FROM [Person].[Person] p LEFT JOIN  [HumanResources].[Employee] H ON p.BusinessEntityID = H.BusinessEntityID 
WHERE H.BirthDate <> ''
SELECT * FROM #temp_EmployeeBIS

-- ETAPE n�2 :
--------------

--DROP TABLE tbl_employee
SELECT * INTO tbl_employee FROM #temp_EmployeeBIS 
SELECT * FROM tbl_employee  -- si ## global pour permet d'envoyer des tables temporaires dans des sessions diff�rentes

-- Jointure pour aller chercher A quel d�partement appartient la personne : [HumanResources].[EmployeeDepartmentHistory]

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

-- L'id�e, c'est de cr�er une proc�dure stock�e lorsque je passe en param�tre M ou F, il me donne le
-- si je donne en param�tre le DepartmentID et le sexe M
-- Cette proc�dure doit me renvoyer les personnes de ce d�partement

-- CREATION DE LA PROCEDURE STOCKEE
-- On aura test� auparavant l'existence de la proc�dure stock�e
USE AdventureWorks2017
GO
CREATE PROCEDURE spGetEmployeesByGenderAndDepartmentMB2021 -- nom de cette proc�dure
--je vais cr�e les 2 param�tres qui vont accueillir les 2: sexe, ID du d�partement

@Gender nvarchar(1),
@departmentID int
AS
BEGIN
 Select * from tbl_Employee_Gender_Department WHERE GENDER = @GENDER and DepartmentID = @departmentID
 
END

--Ex�cution de ma proc�dure stock�e avec passage en param�tre
spGetEmployeesByGenderAndDepartmentMB2021 @Gender = 'F', @departmentId = 16

-- Autre exemple :
-- Ex�cution de ma proc�dure stock�e avec passage en param�tre
spGetEmployeesByGenderAndDepartmentMB2021 @Gender = 'F', @departmentId = 1


