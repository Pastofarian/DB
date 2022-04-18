/**************************************************************
  ETAPE n°1 
 *************************************************************/
USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'EXAMEN_REEL_030420201_EX2_Mike_Bern')
DROP DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern 
GO
CREATE DATABASE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

USE EXAMEN_REEL_030420201_EX2_Mike_Bern
GO

/**************************************************************
  ETAPE n°2 
 *************************************************************/

DROP TABLE IF EXISTS tbl_bern_mike;
GO

CREATE TABLE tbl_bern_mike  
(
Id INT IDENTITY (1,1) PRIMARY KEY, 
Nom VARCHAR (30) NOT NULL,
Prenom VARCHAR (30) NOT NULL,
Sexe INT,
Email VARCHAR (30) NOT NULL, 
Remarque VARCHAR (30) NOT NULL   
)
GO

SELECT * FROM tbl_bern_mike
GO

/**************************************************************
  ETAPE n°3 
 *************************************************************/

SET IDENTITY_INSERT tbl_bern_mike ON

 INSERT INTO tbl_bern_mike (Id, Nom, Prenom, Sexe, Email, Remarque) VALUES      
('1','Bern', 'Mike', '1','mike.bern@ifosupwavre.be','Présent à l''examen'),
('2','Ride','Sally','2','sally.ride@gmail.com','Non présente à l''examen'),
('3','Marc', 'Jacquet', '1','marc.jacquet@ifosupwavre.be','Non présent à l''examen'),
('4','Louise','Bravo','2','louise.bravo@ifosupwavre.be','Présente à l''examen')

 SET IDENTITY_INSERT tbl_bern_mike  OFF

SELECT * FROM tbl_bern_mike
GO

 /**************************************************************
  ETAPE n°4 
 *************************************************************/

DROP TABLE IF EXISTS tbl_Bernair_Michel_BIS;
GO

SELECT * 
INTO tbl_Bernair_Michel_BIS
FROM tbl_bern_mike

SELECT * FROM tbl_Bernair_Michel_BIS
GO

 /**************************************************************
  ETAPE n°5 
 *************************************************************/

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

SELECT * FROM tbl_Bernair_Michel_BIS

