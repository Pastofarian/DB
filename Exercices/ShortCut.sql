USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

USE Examen_blanc20200523_prenom_nom
GO
--DROP et crée une BDD------------------------------------------------------------------------------------------------------

IF object_id ('tempdb.dbo.#temp11') IS NOT NULL 
DROP TABLE #temp11
GO

--DROP et crée une tabe temp---------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'Employee')
DROP TABLE Employee
GO


CREATE TABLE Employee  
(
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id incémentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la première valeur de mon enregistrement commence à 100
									 -- En pratique, c'est toujours (1,1)
Nom VARCHAR (100) NOT NULL,
Salaire INT NULL,    
)
GO

--DROP et crée une table normale---------------------------------------------------------------------------------------------

/**************************************************************
  ETAPE n°4 
 *************************************************************/

 --Pour séparer le code en étapes----------------------------------------------------------------------------------------

--SET IDENTITY_INSERT tbl_micke_bern ON (Si on veut pouvoir changer l'ID soit même)

 INSERT INTO Employee_TEST (Id, Nom, Salaire) VALUES (1, 'Wail', 400);

 --Insertion de données----------------------------------------------------------------------------------

Declare @sexeMF nvarchar(1)
SET @sexeMF = 'M' -- Je suis un Homme

 -- J'insère mon indentité et l"identité opposée cad la ligne suivante
 --    "Sally Ride"
SET IDENTITY_INSERT tbl_Bernair_Michel ON
IF @sexeMF = 'M'
  BEGIN
 INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES      
  ('1','Bern', 'Mike', '1','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
  ('2','Ride','Sally','2','Non présente à l''examen')
  END
ELSE  --  je suis une fille
 BEGIN
   INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Remarque) VALUES
   ('1','Ride','Sally','2','Présente à l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
   ('2','Marc', 'Jacquet', '1','Non présent à l''examen') 
 END

 SET IDENTITY_INSERT tbl_Bernair_Michel  OFF

 --IF/Else-----------------------------------------------------------------------------------------------------------

ALTER TABLE tbl_Bernair_Michel ADD Date_et_Heure Datetime

--ALTER Table pour ajouter un champ--------------------------------------------------------------------------------------------------------------


DECLARE @num INT = 1;
WHILE @num < 3
BEGIN  
   UPDATE  tbl_Bernair_Michel_BIS  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [Date_et_Heure] = getdate()
   WHERE [id] = 1 OR ID = 2
   PRINT 'Insertion de la donnée DATE/Heure' + ' ' + 'pour le codeclient cli_code n° : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des données Date/Heure dans la table ';
GO
Select * FROM tbl_Bernair_Michel_BIS

--Boucle While + UPDATE--------------------------------------------------------------------------------------------------------------------------------------

GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'dbo.GetEmployeeIFOSUP' AND type = 'P')
  DROP PROCEDURE dbo.GetEmployeeIFOSUP
GO

--DROP Procédure