USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

USE Examen_blanc20200523_prenom_nom
GO

IF EXISTS ('tbl_mike_bern') IS NOT NULL
DROP table tbl_mike_bern

CREATE TABLE tbl_mike_bern  
(
Id INT IDENTITY (1,1) PRIMARY KEY, 
Nom VARCHAR (30) NOT NULL,
Prenom VARCHAR (30) NOT NULL,
Sexe INT,
Remarque VARCHAR(30) NOT NULL
)

/**************************************************************
  ETAPE n°2 
 *************************************************************/
--SET IDENTITY_INSERT tbl_micke_bern ON (Si on veut pouvoir changer l'ID soit même)

 Declare @sexeMF nvarchar(1)
SET @sexeMF = 'M' -- Je suis un Homme

 -- J'insère mon indentité et l"identité opposée cad la ligne suivante
 --    "Sally Ride"
SET IDENTITY_INSERT tbl_mike_bern ON
IF @sexeMF = 'M'
  BEGIN
 INSERT INTO tbl_mike_bern (Id, Nom, Prenom, sexe, Remarque) VALUES      
  ('1','Bern', 'Mike', '1','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
  ('2','Ride','Sally','2','Non présente à l''examen')
  END
ELSE  --  je suis une fille
 BEGIN
   INSERT INTO tbl_mike_bern (Id, Nom, Prenom, sexe, Remarque) VALUES
   ('1','Ride','Sally','2','Présente à l''examen'),  -- Insertion de mon nom/prenom en tant que Femme
   ('2','Marc', 'Jacquet', '1','Non présent à l''examen') 
 END

 /**************************************************************
  ETAPE n°3 
 *************************************************************/

ALTER TABLE tbl_mike_bern ADD Date_et_Heure Datetime
Select * from tbl_mike_bern     -- Date_et_Heure

 /**************************************************************
  ETAPE n°4 
 *************************************************************/

 Select * INTO tbl_mike_bern_BIS FROM tbl_mike_bern
Select * FROM tbl_mike_bern_BIS

 /**************************************************************
  ETAPE n°5 
 *************************************************************/

DECLARE @num INT = 1;
WHILE @num < 3
BEGIN  
   UPDATE  tbl_mike_bern  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [Date_et_Heure] = getdate()
   WHERE [id] = 1 OR ID = 2
   PRINT 'Insertion de la donnée DATE/Heure' + ' ' + 'pour le codeclient cli_code n° : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des données Date/Heure dans la table ';
GO


 /**************************************************************
  ETAPE n°6 
 *************************************************************/
Select * FROM tbl_mike_bern

 /**************************************************************
  ETAPE n°7 
 *************************************************************/

GO
IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.GetEmployeeIFOSUP' AND type = 'P')
  DROP PROCEDURE dbo.GetEmployeeIFOSUP
GO

CREATE PROCEDURE affichage_prenom_nomBIS               -- Procédure stockée
---  ALTER PROCEDURE affichage_prenom_nomBIS  

    @sexe_proc INT,  -- sexe 1 ou 0
        @nom_proc nvarchar(255) out,
        @prenom_proc nvarchar(255) out,
    @DateHeure_proc DateTime out
    AS
    BEGIN
    -- , DateMB, getdate() as datePROC 
  --Select sexe, (nom + ', ' + prenom) AS Mon_Nom_Prenom, Date_et_Heure FROM tbl_Bernair_Michel_BIS 
    
      SET @nom_proc = (Select nom FROM tbl_Bernair_Michel_BIS 
      WHERE sexe = @sexe_proc ) -- Lecture de la table
      SET @prenom_proc = (Select prenom FROM tbl_Bernair_Michel_BIS 
      WHERE sexe = @sexe_proc ) -- Lecture de la table
      SET @DateHeure_proc = (Select Date_et_Heure FROM tbl_Bernair_Michel_BIS 
      WHERE sexe = @sexe_proc )
    END

-- Je déclare ce que j'ai mis en OUTPUT
 -- cette variable recevra la valeur retournée par la procédure
---Declare @sexe1 INT
Declare @Mon_nom_prenom1 nvarchar(255) 
Declare @nom1 nvarchar(255) 
Declare @prenom1 nvarchar(255) 
Declare @Date_et_Heure1 DATETIME 
-- si vous êtes
EXEC [affichage_prenom_nomBIS] 1, @nom1 output, @prenom1 output, @Date_et_Heure1 output        ---, @nom1 out, @prenom1 out, @Date_et_Heure1 OUTPUT
Print ' Affichage de votre Nom et Prenom'
Print '---------------------------------'
Print @nom1 + '  ' + @prenom1 + ' ' + cast( @Date_et_Heure1 as nvarchar(30))
Select @nom1 as nom, @prenom1 as prenom, @date_et_heure1 as date_heure