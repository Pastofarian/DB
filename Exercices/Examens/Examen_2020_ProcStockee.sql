/**************************************************************
  ETAPE n°1 
 *************************************************************/

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_blanc20200523_prenom_nom')
DROP DATABASE Examen_blanc20200523_prenom_nom 
GO
CREATE DATABASE Examen_blanc20200523_prenom_nom
GO

USE Examen_blanc20200523_prenom_nom
GO

---------------------------------------------------------------

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'tbl_micke_bern')
DROP TABLE tbl_micke_bern
GO

CREATE TABLE tbl_micke_bern  
(
Id INT IDENTITY (1,1) PRIMARY KEY, 
                                     
Nom VARCHAR (30) NOT NULL,
Prenom VARCHAR (30) NOT NULL,
Sexe INT,
Remarque VARCHAR (30) NOT NULL    
)
GO


/**************************************************************
  ETAPE n°2 
 *************************************************************/

DECLARE @sexe VARCHAR(1)
SET @sexe = 'M'
    SET IDENTITY_INSERT tbl_micke_bern ON
IF @sexe = 'M'
BEGIN
    INSERT INTO tbl_micke_bern (Id, Nom, Prenom, Sexe, Remarque) 
    VALUES
    ('1','Bern', 'Mike', '1','Présent à l''examen'), 
    ('2','Ride','Sally','2','Non présente à l''examen')
END
ELSE 
BEGIN
    INSERT INTO tbl_micke_bern (Id, Nom, Prenom, Sexe, Remarque) 
    VALUES
    ('1','Jacquet', 'Marc', '1','Présent à l''examen'), 
    ('2','Ride','Sally','2','Non présente à l''examen')
END
 SET IDENTITY_INSERT tbl_micke_bern OFF


SELECT * FROM tbl_micke_bern

/**************************************************************
  ETAPE n°3 
 *************************************************************/

ALTER TABLE tbl_micke_bern
ADD Date_et_Heure DATETIME
GO 

SELECT * FROM tbl_micke_bern

/**************************************************************
  ETAPE n°4 
 *************************************************************/

IF EXISTS (SELECT * FROM Examen_blanc20200523_prenom_nom.sys.tables WHERE name = 'tbl_micke_bern_BIS')
DROP TABLE tbl_micke_bern_BIS
GO

SELECT * 
INTO tbl_micke_bern_BIS 
FROM tbl_micke_bern

SELECT * FROM tbl_micke_bern_BIS 

/**************************************************************
  ETAPE n°5 
 *************************************************************/

UPDATE tbl_micke_bern_BIS 
SET [Date_et_Heure] = GETDATE()
GO

/************ ou *****************************/ 

DECLARE @i INT = 1;
DECLARE @nbligne INT
SET @nbLigne = (SELECT COUNT(id) FROM tbl_micke_bern_BIS)
WHILE @i <= @nbligne
    BEGIN
        UPDATE tbl_micke_bern_BIS
        SET [Date_et_Heure] = GETDATE()
        WHERE [id] = 1 OR ID = 2
        SET @i = @i + 1;
    END
GO

SELECT * FROM tbl_micke_bern_BIS

/**************************************************************
  ETAPE n°6 et 7 
 *************************************************************/
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'splist' AND type = 'P')
  DROP PROCEDURE splist
GO

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
        --@result INT

EXECUTE splist 1, @prenom OUTPUT, @nom OUTPUT, @date OUTPUT

PRINT ' Affichage de votre Nom et Prenom'
PRINT '---------------------------------'
PRINT @nom + '  ' + @prenom + ' ' + cast(@date as nvarchar(30))

SELECT 
    @prenom AS Prenom,
    @nom AS Nom, 
    @date AS Date