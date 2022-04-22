USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

USE Examen_blanc20200523_prenom_nom
GO
--DROP et crée une BDD----------------------------------------------------------------------------

IF object_id ('tempdb.dbo.#temp1') IS NOT NULL 
DROP TABLE #temp1
GO

--DROP une table temp----------------------------------------------------------------------------

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'tbl_micke_bern')
DROP TABLE tbl_micke_bern
GO

-- DROP table normale -----------------------------------------------------------------------------------

CREATE TABLE Employee  
(
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id incémentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la première valeur de mon enregistrement commence à 100
									 -- En pratique, c'est toujours (1,1)
Nom VARCHAR (100) NOT NULL,
Salaire INT NULL,    
)
GO

--crée une table normale-------------------------------------------------------------------------

/**************************************************************
  ETAPE n°4 
*************************************************************/

 --Pour séparer le code en étapes-------------------------------------------------------------------------

--SET IDENTITY_INSERT tbl_micke_bern ON (Si on veut pouvoir changer l'ID soit même)

 INSERT INTO Employee_TEST (Id, Nom, Salaire) VALUES (1, 'Wail', 400);

 --Insertion de données----------------------------------------------------------------------------------

Declare @sexeMF nvarchar(1)
SET @sexeMF = 'M' -- Je suis un Homme

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

 --IF/Else----------------------------------------------------------------------------------------------

ALTER TABLE tbl_Bernair_Michel ADD Date_et_Heure Datetime
-------------------------
ALTER TABLE #temp3
ALTER COLUMN LoginID NVARCHAR(30) NULL -- pour autoriser null

UPDATE #temp3
SET LoginID = NULL

--ALTER Table pour ajouter un champ-----------------------------------------------------------------------


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

/***********************************************************************/

DECLARE @age INT
DECLARE @i INT =1
DECLARE @nbligne INT
SET @nbLigne = (SELECT COUNT(age) FROM Tbl_Vaccin)

WHILE (@i <= @nbligne)
    BEGIN
        SET @age = (SELECT age FROM Tbl_Vaccin WHERE @i = age)
        IF @age >= 70
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Opel AstraZENECA' WHERE @i = age 
            END
        ELSE IF @age BETWEEN 52 AND 69
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Moderna' WHERE @i = age 
            END
        ELSE IF @age <= 51
            BEGIN
                UPDATE Tbl_Vaccin
                SET TypeDeVaccin = 'Pfizer' WHERE @i = age 
            END
        ELSE
            BEGIN
                PRINT 'ERROR'
            END
        SET @i = @i + 1
    END

------- -------------------  -------------------------- --------------------------

DECLARE @id INT
DECLARE @i INT
SET @i = 1
DECLARE @nbligne INT
SET @nbLigne = (SELECT COUNT(BusinessEntityID) FROM Tbl_IdVaccin)

WHILE @i <= @nbligne
    BEGIN 
        SET @id = (SELECT BusinessEntityID FROM tbl_IdVaccin)
        IF @id % 2 = 1
            BEGIN
                UPDATE tbl_IdVaccin
                SET Vaccin = 'x'
                WHERE @i = BusinessEntityID
            END
            SET @i = @i + 1;
    END

Select * from tbl_IdVaccin

--Boucle While + UPDATE-----------------------------------------------------------------------------------

DECLARE @maxWeight FLOAT, @productKey INTEGER  
SET @maxWeight = 100.00  
SET @productKey = 424  
IF @maxWeight <= (SELECT Weight from DimProduct WHERE ProductKey = @productKey)   
    SELECT @productKey AS ProductKey, EnglishDescription, Weight, 'This product is too heavy to ship and is only available for pickup.' 
        AS ShippingStatus
    FROM DimProduct WHERE ProductKey = @productKey
ELSE  
    SELECT @productKey AS ProductKey, EnglishDescription, Weight, 'This product is available for shipping or pickup.' 
        AS ShippingStatus
    FROM DimProduct WHERE ProductKey = @productKey

-- IF ELSE ---------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT* FROM IFOSUP_Trans.sys.tables WHERE name = 'tbl_audit_hr')
DROP Table tbl_audit_hr
CREATE TABLE tbl_audit_hr
(
id nvarchar(10),
auditData nvarchar(255)
)
GO

--Table Audit---------------------------------------------------------------------------------------------

IF OBJECT_ID(N'dbo.IFOSUP_NewFormatDate', N'FN')IS NOT NULL
DROP FUNCTION dbo.IFOSUP_NewFormatDate;
GO


CREATE FUNCTION dbo.EcartJour (@date1 DATETIME, @date2 DATETIME)
--ALTER FUNCTION dbo.EcartJour (@date1 DATETIME, @date2 DATETIME)
RETURNS INT
AS BEGIN
    RETURN ABS(DATEDIFF(day, @date1, @date2))
END
GO

IF object_id ('tempdb.dbo.#temp2') IS NOT NULL 
DROP TABLE #temp2
GO

SELECT BusinessEntityID, NationalIDNumber, JobTitle,
BirthDate, MaritalStatus, Gender, dbo.EcartJour (BirthDate, GETDATE()) AS Difference
INTO #temp2
FROM #temp1

-- Function ---------------------------------------------------------------------------------------------

DECLARE @Nom AS VARCHAR(255)
DECLARE @Prenom AS VARCHAR(255)
DECLARE @Etat AS VARCHAR(255)

 DECLARE cur1 CURSOR FOR (SELECT Nom, Prenom, Etat FROM T_STUDENT_STATE WHERE Etat = 'Admis')
 
 OPEN cur1

FETCH cur1 INTO @nom, @Prenom, @Etat

WHILE @@FETCH_STATUS = 0

BEGIN
    FETCH cur1 INTO @nom, @Prenom, @Etat
    SELECT @nom, @Prenom, @Etat
    PRINT @nom
    PRINT @Prenom
    PRINT @Etat

END
CLOSE cur1
DEALLOCATE cur1

----   ---------------------------------           -----------------------------

DECLARE @email VARCHAR(30)
DECLARE @sexe INT
DECLARE @nom VARCHAR(30)
DECLARE @prenom VARCHAR(30)
DECLARE @id INT
DECLARE @remarque VARCHAR(30);


DECLARE cur1 CURSOR FOR (SELECT Id, Nom, Prenom, Sexe, Email, Remarque FROM tbl_Bernair_Michel_BIS WHERE Email LIKE '%ifosupwavre.be')
 
OPEN cur1

FETCH NEXT From cur1 INTO @id, @nom, @prenom, @sexe, @email, @remarque

WHILE (@@FETCH_STATUS = 0)
BEGIN
   IF (@sexe = 1)
      BEGIN
                UPDATE tbl_Bernair_Michel_BIS
                SET Email = @nom + '.' + @prenom + '.' + 'M@ifosupwavre.be' 
                WHERE id = @id 
      END
   ELSE IF (@sexe = 2)
      BEGIN
                UPDATE tbl_Bernair_Michel_BIS
                SET Email = @nom + '.' + @prenom + '.' + 'F@ifosupwavre.be'
                WHERE id = @id  
      END
FETCH NEXT From cur1 INTO @id, @nom, @prenom, @sexe, @email, @remarque
END

CLOSE cur1
DEALLOCATE cur1

--CURSOR ---------------------------------------------------------------------------------------------

IF EXISTS (SELECT name FROM sysobjects  WHERE name = 'dbo.GetEmployeeIFOSUP' AND type = 'P')
  DROP PROCEDURE dbo.GetEmployeeIFOSUP
GO

-- DROP PROCEDURE -----------------------------------------------------------------------------------

--CREATE PROCEDURE spGetEmail
 ALTER PROCEDURE spGetEmail

@id INT,
@FirstName VARCHAR(255) OUTPUT,
@LastName VARCHAR(255) OUTPUT

 AS
 BEGIN
    SELECT @FirstName = FirstName, @LastName = LastName
    FROM #temp1 
    WHERE BusinessEntityID = @id
END
GO

DECLARE @FirstName VARCHAR(255),
        @LastName VARCHAR(255),
        @Result INT;

EXECUTE @Result = spGetEmail 12,
@FirstName OUTPUT,
@LastName OUTPUT;


SELECT @Result AS Resultat,
@FirstName AS Prenom,
@LastName AS Nom

/***********Autre exemple***************/

GO
--CREATE PROCEDURE splist
ALTER PROCEDURE splist

@sexe INT, 
@prenom VARCHAR(30) OUTPUT,
@nom VARCHAR(30) OUTPUT,
@date DATETIME OUTPUT

AS
BEGIN
    SELECT @prenom = Prenom, @nom = Nom, @date = [Date_et_Heure]
    FROM tbl_micke_bern_BIS
    WHERE @sexe = Sexe
END
GO

DECLARE @prenom VARCHAR(30),
        @nom VARCHAR(30),
        @date DATETIME,
        @result INT

EXECUTE splist 1, @prenom OUTPUT, @nom OUTPUT, @date OUTPUT

PRINT ' Affichage de votre Nom et Prenom'
PRINT '---------------------------------'
PRINT @nom + '  ' + @prenom + ' ' + cast(@date as nvarchar(30))

SELECT 
    @prenom AS Prenom,
    @nom AS Nom, 
    @date AS Date

/***********Autre exemple***************/ 

--CREATE PROCEDURE spGetNom
ALTER PROCEDURE spGetNom

@id INT

AS 
BEGIN
    DECLARE @prenom VARCHAR(30) 
    DECLARE @nom VARCHAR(30)

    SET @nom = (SELECT nom FROM Tbl_Mike_Bern
    WHERE id = @id)
    SET @prenom = (SELECT prenom FROM Tbl_Mike_Bern
    WHERE id = @id)

    UPDATE Tbl_Mike_Bern 
    SET LoginID = @prenom + '.' + @nom + '.' + LEFT(@prenom, 1) + RIGHT(@nom, 2) + '@ifosupwavre.be'
    WHERE id = @id

END 
GO

EXECUTE spGetNom 10 

SELECT * FROM Tbl_Mike_Bern

PRINT ' Affichage de votre Nom et Prenom'
PRINT '---------------------------------'
PRINT @nom + '  ' + @prenom + ' ' + @email

-- Procedure stockee------------------------------------------------------------------------------------

SELECT id, titre =
    CASE 
        WHEN Gender = 'M' THEN 'Mr.'
        ELSE 'Ms.'
        END, prenom, nom, numero_national, type_telephone = 
    CASE   
         WHEN PhoneNumberTypeID = 1 THEN 'GSM' 
         WHEN PhoneNumberTypeID = 2 THEN 'Tel.maison'
         WHEN PhoneNumberTypeID = 3 THEN 'Tel.travail' 
    END, LoginID, titre_job, date_naissance, status_marital, genre, date_embauche   
INTO #temp2
FROM #temp1 
GO  

--CASE - WHEN-------------------------------------

IF EXISTS (SELECT 1 FROM sys.triggers 
           WHERE Name = 'tgr_test')
DROP TRIGGER tgr_test
GO

CREATE TRIGGER tgr_test
ON TBL_NOM_PRENOM
AFTER INSERT
  AS 
      SET NOCOUNT ON;

      DECLARE @id INT
      DECLARE @nom VARCHAR(30)
      DECLARE @prenom VARCHAR(30)

      SET @id = (SELECT BusinessEntityID FROM inserted)
      SET @nom = (SELECT nom FROM inserted)
      SET @prenom = (SELECT prenom FROM inserted)

      UPDATE TBL_NOM_PRENOM
      SET LoginID = 'adventure-works' + @prenom + '.' + @nom + '@ifosup.wavre.be' 
      INSERT into TBL_Audit VALUES(cast(@id as varchar (10)), 'Nouvel employé Ajouté : '+cast (getdate() as varchar(20)) )
      
GO
  
INSERT INTO TBL_NOM_PRENOM
VALUES ('1001','', '','','','','','','Mike','Bern','BE','x')
GO

--Trigger-------------------------------------------------------------------------------------------
