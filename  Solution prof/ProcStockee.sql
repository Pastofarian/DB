
/*
-- Procédure stockée --
*/
 USE AdventureWorks2017
 GO
  SELECT * FROM [HumanResources].[Employee]         ---dbo.GetEmployee
 GO

GO
 SELECT * FROM HumanResources.Employee e where BusinessEntityID = 123
 SELECT * FROM Person.Person p  where BusinessEntityID = 123       -- BusinessEntityID
 SELECT * FROM Person.EmailAddress ea where BusinessEntityID = 123

 /*
 Création de la procédure stockée -> Type 'P'
 Test si la procédure existe ou pas.
 */
-- test de l'existance de la procédure stockée dbo.GetEmployeeIFOSUP de type 'P'
GO
IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.GetEmployeeIFOSUP' AND type = 'P')
  DROP PROCEDURE dbo.GetEmployeeIFOSUP
GO


CREATE PROCEDURE dbo.GetEmployeeIFOSUP (@BusinessEntityID int = 123,    --199
@Email_Address nvarchar(50) OUTPUT,
@Full_Name nvarchar(100) OUTPUT)
AS
BEGIN

SELECT @Email_Address = ea.EmailAddress,
       @Full_Name = p.FirstName + ' ' + COALESCE(p.MiddleName,'') + ' ' + p.LastName
 FROM HumanResources.Employee e
INNER JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
--INNER JOIN Person.EmailAddress ea
LEFT JOIN Person.EmailAddress ea
ON p.BusinessEntityID = ea.BusinessEntityID
WHERE e.BusinessEntityID = @BusinessEntityID;
-- Retourne le code 1 si pas d'email, sinon 0 en cas de succès de trouver un mail
RETURN (
CASE
 WHEN @Email_Address IS NULL THEN 1
ELSE 0
END
);
END;

GO

-- APPEL DE PROCEDURE

-- Declare variables to hold the result
DECLARE @Email nvarchar(50),
        @Name nvarchar(100),
        @Result int;

-- Appel de la procédure dbo.GetEmployeeIFOSUP avec passage en paramètre le BusinessEntityID = 123
EXECUTE @Result = dbo.GetEmployeeIFOSUP 123,  --1
        @Email OUTPUT,
        @Name OUTPUT;

-- Affichage du résultat
SELECT @Result AS Result,
@Email AS Email,
@Name AS [Name];


--------------------Fin code ---------------------------------------------------------------
OUTPUT



/*
1 er cas de la procédure stockée ==> on faisait passer un paramètre d'entrée à la procédure stockée
2 ème cas de la procédure stockée ==> la procédure stockée fait quelque chose (traitement) et qu'elle
-- retourne une valeur en sortie ==> je dois marquer dans le code SQL que j'ai affaire à une valeur en sortie 
Ce marquage se fait par le code petit SQL au niveau de la variable de sortie qui est concernée 
c'est-à-dire OUT
*/

-- EXEMPLE n°1

USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de référence
GO
-- Créer une procédure stockée, je souhaite savoir combien (c'est un nombre) de femme / homme dans cette table
CREATE PROC spGetEmployesByGenderAndDepartmentMB27022021
        @gender nvarchar(1),
        @employeeCount INT OUT -- ce paramètre est un paramètre de sortie -> Ma procédure stockée me renvoit quelque chose
                                                   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
AS
 BEGIN
  Select @employeeCount = COUNT(BusinessEntityID) from tbl_Employee_Gender_Department 
    where Gender = @gender  -- je compte le nombre de donnée que j'ai dans la table tbl_Employ....
    --lorsque je fais passer en paramètre d'entrée GENDER
         -- Le tout est placé dans une variable déclarée au préalable dans ma procédure stockée : @employeeCount
END

-- Select COUNT(*) from tbl_Employee_Gender_Department -- 296 valeurs (M/F)

-- Je vais appeler cette procédure stockée.
-- Elle doit me retourner une valeur (INT) qui sera récupéré par une autre valeur qui est en dehors de 
-- ma procédure stockée.


DECLARE @EmployeeTotal_meme_sexe INT -- cette valeur que je déclare doit être type que celle que retourne la procédure stockée.
EXECUTE spGetEmployesByGenderAndDepartmentMB27022021 'F', @EmployeeTotal_meme_sexe OUTPUT
Select @EmployeeTotal_meme_sexe Nbr_total_employee
Print @EmployeeTotal_meme_sexe

------

-- EXEMPLE n°2 
/* 
Je vais enrichier ce même code en faisant passer une deuxièe paramètre en sortie
Je souhaite qu'il affiche un petit texte du style : 
 ' Nombre de personne ayant le même sexe'
*/


USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de référence
GO
-- Créer une procédure stockée, je souhaite savoir combien (c'est un nombre) de femme / homme dans cette table
-- CREATE PROC spGetEmployesByGenderAndDepartmentMB27022021
ALTER PROC  spGetEmployesByGenderAndDepartmentMB27022021
        @gender nvarchar(1),
        @employeeCount INT OUT, -- ce paramètre est un paramètre de sortie -> Ma procédure stockée me renvoit quelque chose
                                                   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
    @texte nvarchar(255) OUT
AS
 BEGIN
  Set @texte = 'Nombre de personne ayant le même sexe'
  Select @employeeCount = COUNT(BusinessEntityID) from tbl_Employee_Gender_Department 
    where Gender = @gender  -- je compte le nombre de donnée que j'ai dans la table tbl_Employ....
    --lorsque je fais passer en paramètre d'entrée GENDER
         -- Le tout est placé dans une variable déclarée au préalable dans ma procédure stockée : @employeeCount
END

-- Select COUNT(*) from tbl_Employee_Gender_Department -- 296 valeurs (M/F)

-- Je vais appeler cette procédure stockée.
-- Elle doit me retourner une valeur (INT) qui sera récupéré par une autre valeur qui est en dehors de 
-- ma procédure stockée.


DECLARE @EmployeeTotal_meme_sexe INT, -- cette valeur que je déclare doit être type que celle que retourne la procédure stockée.
        --@PrintText INT -- Je mets volontairement un autre TYPE pour cette variable qui est censé récupéré 
                               -- un contenu du type texte
                                           --- J'aurai dés lors ce type de message d'erreur :
                      --  Msg 8114, Level 16, State 2, Procedure spGetEmployesByGenderAndDepartmentMB27022021, 
                                          --  Line 0 [Batch Start Line 77]
                      --   Error converting data type nvarchar to int.

        -- SOLUTION à ce message d'erreur puisqu'ils ne sont pas de même type, c'est rendre ma variable qui se trouve en dehors
         -- de ma procédure stockée, qu'elle soit du même type
         @PrintText nvarchar(255)

EXECUTE spGetEmployesByGenderAndDepartmentMB27022021 'F', @EmployeeTotal_meme_sexe OUTPUT,
                                                          @PrintText OUTPUT
Select @EmployeeTotal_meme_sexe Nbr_total_employee

Print @EmployeeTotal_meme_sexe
--Print @PrintText

-- Mais je souhaiterai placer sur la même ligne mes 2 variables  @EmployeeTotal_meme_sexe (INT) et
--   @PrintText (nvarchar(255))  au sein d'un PRINT
-- On sait TOUS que le PRINT n'affirche que des données de type TEXTE cad varchar, nvarchar.

-- Alors on doit ABSOLUMENT CASTER !!!! Il y a une conversion de l'INT en NVARCHAR (ou VARCHAR)
Print @PrintText + ': ' + CAST (@EmployeeTotal_meme_sexe as nvarchar(255))


-------------------Fin code------------------------------------------------------------------
RETURN





/*
3 ème cas : utilisation du RETURN au sein de la procédure stockée.
~ ça me fait penser au deuxième cas :
 J'ai une procédure stcokée --> elle retournait une valeur qui était récupéré par une autre variable située 
 en dehors de cette procédure
Le MOT Return fera exactement la même chose MAIS....
Vous allez directement comprendre la différence entre l'utilisation de l'OUTPUT ou du RETURN

*/

-- EXEMPLE n°3 : 
USE AdventureWorks2017
GO
Select * FROM tbl_Employee_Gender_Department  -- 296 records

-- Création de ma procédure stockée qui retourne une valeur
GO
CREATE PROC spGetTotal_Gender_Department27022021
AS
 BEGIN
  return (Select COUNT(BusinessEntityID) From tbl_Employee_Gender_Department ) -- Return poertera toujours sur les INT !!!

 END


 -- Exécution de la procédure stockée
 -- Puisque je retourne quelque chose de ma procédure stockée du fait, j'ai le mot RETURN
 -- Je dois pouvoir récupérer cette valeur ~ ça me fait penser à OUTPUT
 -- Je dois donc déclarer une nouvelle variable qui joue ce rôle.
 Declare @nombre_total_employee INT
 EXECUTE  @nombre_total_employee = spGetTotal_Gender_Department27022021
 Select  @nombre_total_employee Nombre_total_employee
 
 -- Différence majeure entre OUTPUT et le Return qui sont tous les deux des paramètres de sortie.


 /* TEST de savoir : 
 -- Si je voulais savoir si la procédure stockée s'est bien passée,
 -- Il y a une variable qui nous donne si la procédure stocké s'est bien déroulée ou pas
 -- return_value INT
 */
 GO

 Declare @nombre_total_employee INT,
         @return_value INT   -- c'est le nom de la variable
 EXECUTE  @nombre_total_employee = spGetTotal_Gender_Department27022021
 Select  @nombre_total_employee Nombre_total_employee
 Select @return_value   -- NULL ==> La procédure stockée s'est bien passée


-----------------------Fin code -------------------------------------------------------------
Theorie



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


--------------------------------Fin code ----------------------------------------------------
Entrée


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



----------------Fin code---------------------------------------------------------------------




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


