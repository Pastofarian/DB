
/*
-- Proc�dure stock�e --
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
 Cr�ation de la proc�dure stock�e -> Type 'P'
 Test si la proc�dure existe ou pas.
 */
-- test de l'existance de la proc�dure stock�e dbo.GetEmployeeIFOSUP de type 'P'
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
-- Retourne le code 1 si pas d'email, sinon 0 en cas de succ�s de trouver un mail
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

-- Appel de la proc�dure dbo.GetEmployeeIFOSUP avec passage en param�tre le BusinessEntityID = 123
EXECUTE @Result = dbo.GetEmployeeIFOSUP 123,  --1
        @Email OUTPUT,
        @Name OUTPUT;

-- Affichage du r�sultat
SELECT @Result AS Result,
@Email AS Email,
@Name AS [Name];


--------------------Fin code ---------------------------------------------------------------
OUTPUT



/*
1 er cas de la proc�dure stock�e ==> on faisait passer un param�tre d'entr�e � la proc�dure stock�e
2 �me cas de la proc�dure stock�e ==> la proc�dure stock�e fait quelque chose (traitement) et qu'elle
-- retourne une valeur en sortie ==> je dois marquer dans le code SQL que j'ai affaire � une valeur en sortie 
Ce marquage se fait par le code petit SQL au niveau de la variable de sortie qui est concern�e 
c'est-�-dire OUT
*/

-- EXEMPLE n�1

USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de r�f�rence
GO
-- Cr�er une proc�dure stock�e, je souhaite savoir combien (c'est un nombre) de femme / homme dans cette table
CREATE PROC spGetEmployesByGenderAndDepartmentMB27022021
        @gender nvarchar(1),
        @employeeCount INT OUT -- ce param�tre est un param�tre de sortie -> Ma proc�dure stock�e me renvoit quelque chose
                                                   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
AS
 BEGIN
  Select @employeeCount = COUNT(BusinessEntityID) from tbl_Employee_Gender_Department 
    where Gender = @gender  -- je compte le nombre de donn�e que j'ai dans la table tbl_Employ....
    --lorsque je fais passer en param�tre d'entr�e GENDER
         -- Le tout est plac� dans une variable d�clar�e au pr�alable dans ma proc�dure stock�e : @employeeCount
END

-- Select COUNT(*) from tbl_Employee_Gender_Department -- 296 valeurs (M/F)

-- Je vais appeler cette proc�dure stock�e.
-- Elle doit me retourner une valeur (INT) qui sera r�cup�r� par une autre valeur qui est en dehors de 
-- ma proc�dure stock�e.


DECLARE @EmployeeTotal_meme_sexe INT -- cette valeur que je d�clare doit �tre type que celle que retourne la proc�dure stock�e.
EXECUTE spGetEmployesByGenderAndDepartmentMB27022021 'F', @EmployeeTotal_meme_sexe OUTPUT
Select @EmployeeTotal_meme_sexe Nbr_total_employee
Print @EmployeeTotal_meme_sexe

------

-- EXEMPLE n�2 
/* 
Je vais enrichier ce m�me code en faisant passer une deuxi�e param�tre en sortie
Je souhaite qu'il affiche un petit texte du style : 
 ' Nombre de personne ayant le m�me sexe'
*/


USE AdventureWorks2017
GO
Select * from tbl_Employee_Gender_Department  --  table de r�f�rence
GO
-- Cr�er une proc�dure stock�e, je souhaite savoir combien (c'est un nombre) de femme / homme dans cette table
-- CREATE PROC spGetEmployesByGenderAndDepartmentMB27022021
ALTER PROC  spGetEmployesByGenderAndDepartmentMB27022021
        @gender nvarchar(1),
        @employeeCount INT OUT, -- ce param�tre est un param�tre de sortie -> Ma proc�dure stock�e me renvoit quelque chose
                                                   -- Elle me renvoit ici dans ce cas un ENTIER (INT)
    @texte nvarchar(255) OUT
AS
 BEGIN
  Set @texte = 'Nombre de personne ayant le m�me sexe'
  Select @employeeCount = COUNT(BusinessEntityID) from tbl_Employee_Gender_Department 
    where Gender = @gender  -- je compte le nombre de donn�e que j'ai dans la table tbl_Employ....
    --lorsque je fais passer en param�tre d'entr�e GENDER
         -- Le tout est plac� dans une variable d�clar�e au pr�alable dans ma proc�dure stock�e : @employeeCount
END

-- Select COUNT(*) from tbl_Employee_Gender_Department -- 296 valeurs (M/F)

-- Je vais appeler cette proc�dure stock�e.
-- Elle doit me retourner une valeur (INT) qui sera r�cup�r� par une autre valeur qui est en dehors de 
-- ma proc�dure stock�e.


DECLARE @EmployeeTotal_meme_sexe INT, -- cette valeur que je d�clare doit �tre type que celle que retourne la proc�dure stock�e.
        --@PrintText INT -- Je mets volontairement un autre TYPE pour cette variable qui est cens� r�cup�r� 
                               -- un contenu du type texte
                                           --- J'aurai d�s lors ce type de message d'erreur :
                      --  Msg 8114, Level 16, State 2, Procedure spGetEmployesByGenderAndDepartmentMB27022021, 
                                          --  Line 0 [Batch Start Line 77]
                      --   Error converting data type nvarchar to int.

        -- SOLUTION � ce message d'erreur puisqu'ils ne sont pas de m�me type, c'est rendre ma variable qui se trouve en dehors
         -- de ma proc�dure stock�e, qu'elle soit du m�me type
         @PrintText nvarchar(255)

EXECUTE spGetEmployesByGenderAndDepartmentMB27022021 'F', @EmployeeTotal_meme_sexe OUTPUT,
                                                          @PrintText OUTPUT
Select @EmployeeTotal_meme_sexe Nbr_total_employee

Print @EmployeeTotal_meme_sexe
--Print @PrintText

-- Mais je souhaiterai placer sur la m�me ligne mes 2 variables  @EmployeeTotal_meme_sexe (INT) et
--   @PrintText (nvarchar(255))  au sein d'un PRINT
-- On sait TOUS que le PRINT n'affirche que des donn�es de type TEXTE cad varchar, nvarchar.

-- Alors on doit ABSOLUMENT CASTER !!!! Il y a une conversion de l'INT en NVARCHAR (ou VARCHAR)
Print @PrintText + ': ' + CAST (@EmployeeTotal_meme_sexe as nvarchar(255))


-------------------Fin code------------------------------------------------------------------
RETURN





/*
3 �me cas : utilisation du RETURN au sein de la proc�dure stock�e.
~ �a me fait penser au deuxi�me cas :
 J'ai une proc�dure stcok�e --> elle retournait une valeur qui �tait r�cup�r� par une autre variable situ�e 
 en dehors de cette proc�dure
Le MOT Return fera exactement la m�me chose MAIS....
Vous allez directement comprendre la diff�rence entre l'utilisation de l'OUTPUT ou du RETURN

*/

-- EXEMPLE n�3 : 
USE AdventureWorks2017
GO
Select * FROM tbl_Employee_Gender_Department  -- 296 records

-- Cr�ation de ma proc�dure stock�e qui retourne une valeur
GO
CREATE PROC spGetTotal_Gender_Department27022021
AS
 BEGIN
  return (Select COUNT(BusinessEntityID) From tbl_Employee_Gender_Department ) -- Return poertera toujours sur les INT !!!

 END


 -- Ex�cution de la proc�dure stock�e
 -- Puisque je retourne quelque chose de ma proc�dure stock�e du fait, j'ai le mot RETURN
 -- Je dois pouvoir r�cup�rer cette valeur ~ �a me fait penser � OUTPUT
 -- Je dois donc d�clarer une nouvelle variable qui joue ce r�le.
 Declare @nombre_total_employee INT
 EXECUTE  @nombre_total_employee = spGetTotal_Gender_Department27022021
 Select  @nombre_total_employee Nombre_total_employee
 
 -- Diff�rence majeure entre OUTPUT et le Return qui sont tous les deux des param�tres de sortie.


 /* TEST de savoir : 
 -- Si je voulais savoir si la proc�dure stock�e s'est bien pass�e,
 -- Il y a une variable qui nous donne si la proc�dure stock� s'est bien d�roul�e ou pas
 -- return_value INT
 */
 GO

 Declare @nombre_total_employee INT,
         @return_value INT   -- c'est le nom de la variable
 EXECUTE  @nombre_total_employee = spGetTotal_Gender_Department27022021
 Select  @nombre_total_employee Nombre_total_employee
 Select @return_value   -- NULL ==> La proc�dure stock�e s'est bien pass�e


-----------------------Fin code -------------------------------------------------------------
Theorie



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


--------------------------------Fin code ----------------------------------------------------
Entr�e


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



----------------Fin code---------------------------------------------------------------------




/* Diff�rence entre Return Values
    et 
  Output Parameters
*/


USE AdventureWorks2017
Select * from tbl_Employee_Gender_Department 

        CREATE PROC spGetTotalCountofEmployee 
         -- ALTER PROC spGetTotalCountofEmployee  
        @TotalCount INt OUTPUT  -- Combien d'employ� y-a-t-il ?
        AS
        BEGIN
         Select @TotalCount = COUNT(BusinessEntityId) FROM tbl_Employee_Gender_Department  -- Count Function
        END

-- Je d�clare ce que j'ai mis en OUTPUT
Declare  @nombre_total_employee INT  -- cette variable recevra la valeur retourn�e par la proc�dure
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
        BEGIN   -- On ajout le mot cl� "return"
         return (Select COUNT(BusinessEntityId) FROM tbl_Employee_Gender_Department)  -- Count Function
        END 


-- Ex�cution de la proc�dure avec passage par param�tre
Declare  @nombre_total_employee INT  -- cette variable recevra la valeur retourn�e par la proc�dure
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

-- Montrons maintenant qu'il convient de travailler tant�t avec OUTPUT ou Return Value

USE AdventureWorks2017
CREATE PROC spGetNameByID1
    @Id INT,
    @Name nvarchar(255) OUTPUT
AS
BEGIN
Select @Name = Lastname FROM tbl_Employee_Gender_Department WHERE BusinessEntityId = @Id
END

-- Ex�cution 
Declare @Nom_Employee nvarchar(255)
Declare @Idd INT
SET @Idd = 3
EXECUTE spGetNameByID1 @Idd, @Nom_Employee OUTPUT
Select @Nom_Employee
PRINT 'Nom de l''employee : ' + @Nom_Employee


-- Return Value en reprenant la m�me id�e: afficher le nom de la personne
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
-- Le return se fait une valeur de type nvarchar(255) alors qu'il s'attend � voir un INT !
-- 

Select * FROM tbl_Employee_Gender_Department 


