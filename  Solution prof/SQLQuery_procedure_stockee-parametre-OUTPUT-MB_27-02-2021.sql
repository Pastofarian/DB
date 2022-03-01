

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






