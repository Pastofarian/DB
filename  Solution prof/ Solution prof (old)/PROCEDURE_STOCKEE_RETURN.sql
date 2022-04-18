
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