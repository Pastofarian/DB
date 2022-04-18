
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