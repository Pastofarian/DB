

/* Différence entre Return Values
    et 
  Output Parameters
*/


USE AdventureWorks2017
Select * from tbl_Employee_Gender_Department 

		CREATE PROC spGetTotalCountofEmployee 
		 -- ALTER PROC spGetTotalCountofEmployee  
		@TotalCount INt OUTPUT  -- Combien d'employé y-a-t-il ?
		AS
		BEGIN
		 Select @TotalCount = COUNT(BusinessEntityId) FROM tbl_Employee_Gender_Department  -- Count Function
		END

-- Je déclare ce que j'ai mis en OUTPUT
Declare  @nombre_total_employee INT  -- cette variable recevra la valeur retournée par la procédure
Declare @return_value INT
EXEC  @return_value = [dbo].[spGetTotalCountofEmployee] @nombre_total_employee OUTPUT
----EXEC [spGetTotalCountofEmployee] @nombre_total_employee OUTPUT
Select 'Return Value' = @Return_value -- Prend la valeur NULL et non 0 ==> Erreur
PRINT @nombre_total_employee
Select @nombre_total_employee N'@nombre_de_valeur'


---
/* RETURN VALUES
*/

USE AdventureWorks2017
Select * from tbl_Employee_Gender_Department 

		CREATE PROC spGetTotalCountofEmployee2 
		 -- ALTER PROC spGetTotalCountofEmployee2  
		AS
		BEGIN   -- On ajout le mot clé "return"
		 return (Select COUNT(BusinessEntityId) FROM tbl_Employee_Gender_Department)  -- Count Function
		END 


-- Exécution de la procédure avec passage par paramètre
Declare  @nombre_total_employee INT  -- cette variable recevra la valeur retournée par la procédure
Declare @return_value INT
EXECUTE  @nombre_total_employee = spGetTotalCountofEmployee2
PRINT  @nombre_total_employee
SELECT  @nombre_total_employee N'@nombre_de_valeur'

/* Quand utiliser OUTPUT / Return Values ? */
---------------------------------------------

-- sp for Stored Procedured ==> OUTPUT
USE AdventureWorks2017
Select TotalCount = COUNT(BusinessEntityID) FROM tbl_Employee_Gender_Department 

CREATE PROC spGetTotalCountEmployee
 -- ALTER PROC spGetTotalCountEmployee
 @totalCount INT OUTPUT        -- Cas OUTPUT
AS
BEGIN
	Select @TotalCount = COUNT(BusinessEntityID) FROM tbl_Employee_Gender_Department 
END

Declare @nombre_employee INT
Declare @return_value INT
EXEC @return_value = spGetTotalCountEmployee @nombre_employee OUTPUT
Select @nombre_employee N'@Nombre_employee'
Select @return_value N'Flag de la reussite'


-- sp for Stored Procedured => Return Value ---

CREATE PROC spGetTotalCountEmployee1
 -- ALTER PROC spGetTotalCountEmployee1
           -- il n'y a plus de variables
AS
BEGIN
	Return ( Select COUNT(BusinessEntityID) FROM tbl_Employee_Gender_Department )
END


Declare @nombre_employee INT
Declare @return_value INT
EXEC @return_value = spGetTotalCountEmployee @nombre_employee OUTPUT
Select @nombre_employee N'@Nombre_employee'
Select @return_value N'Flag de la reussite'

-- Montrons maintenant qu'il convient de travailler tantôt avec OUTPUT ou Return Value

USE AdventureWorks2017
CREATE PROC spGetNameByID1
	@Id INT,
	@Name nvarchar(255) OUTPUT
AS
BEGIN
Select @Name = Lastname FROM tbl_Employee_Gender_Department WHERE BusinessEntityId = @Id
END

-- Exécution 
Declare @Nom_Employee nvarchar(255)
Declare @Idd INT
SET @Idd = 3
EXECUTE spGetNameByID1 @Idd, @Nom_Employee OUTPUT
Select @Nom_Employee
PRINT 'Nom de l''employee : ' + @Nom_Employee


-- Return Value en reprenant la même idée: afficher le nom de la personne
USE AdventureWorks2017
CREATE PROC spGetNameByID2
 -- ALTER PROC spGetNameByID2
	@Id INT
AS
BEGIN
  Return (Select Lastname FROM tbl_Employee_Gender_Department WHERE BusinessEntityId = @Id )

 Return (Select DepartmentID FROM tbl_Employee_Gender_Department WHERE BusinessEntityId = @Id )
END

Declare @Nom_Employee nvarchar(255)
Declare @test int
Declare @Idd INT
--EXEC @test = spGetNameByID2 3
--select @test
EXEC @Nom_Employee = spGetNameByID2 3
Select @Nom_Employee
PRINT 'Nom de l''employee : ' + @Nom_Employee

-- Msg 245, Level 16, State 1, Procedure spGetNameByID2, Line 5 [Batch Start Line 119]
-- Conversion failed when converting the nvarchar value 'Tamburello' to data type int.
-- Le return se fait une valeur de type nvarchar(255) alors qu'il s'attend à voir un INT !
-- 

Select * FROM tbl_Employee_Gender_Department 