

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






