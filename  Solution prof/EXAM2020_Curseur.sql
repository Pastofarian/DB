

/*************************************************************
  ETAPE n°1 : création de la base de données et de la table
**************************************************************/

-- Michel Bernair.

--Création de votre base de donnée Examen_blanc20192020_bernair_michel
-- Si la DB existe ou pas.


IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'Examen_reel06062020_bernair_michel')
DROP DATABASE Examen_reel06062020_bernair_michel -- Quelque soit la situation de la table, je la vide ! 
GO
	CREATE DATABASE Examen_blanc06062020_bernair_michel -- Je la recrée à nouveau une nouvelle table
GO

-- Création votre table où votre nom et prenom se retrouveront dans celle-ci
-- Faites un test de son existence
-- 
DROP Table tbl_Bernair_Michel 
USE Examen_blanc06062020_bernair_michel 
GO
		CREATE TABLE tbl_Bernair_Michel -- tbl_bernair_michel
		(
		Id INT IDENTITY (1,1) PRIMARY KEY,  -- incrémentale => à chaque enregistrement de l'id = 1, 2, 3,etc.
		Nom nvarchar(30) NOT NULL,
		Prenom nvarchar(30) NOT NULL,
		Sexe int,
		Email nvarchar(30) NOT NULL,
		Remarque nvarchar(30) NOT NULL       -- Présent à l''examen
		)

GO
Select * from tbl_Bernair_Michel  -- table vide.

SET IDENTITY_INSERT tbl_Bernair_Michel ON

   INSERT INTO tbl_Bernair_Michel (Id, Nom, Prenom, sexe, Email, Remarque) VALUES  	  
	('1','Bern', 'Mike', '1','mike.bern@ifosupwavre.be','Présent à l''examen'),  -- Insertion de mon nom/prenom en tant qu'Homme
	('2','Ride','Sally','2','sally.ride@gmail.com','Non présente à l''examen'), -- second enregistrement qui opposé au mien
    ('3','Marc', 'Jacquet', '1','marc.jacquet@ifosupwavre.be','Non présent à l''examen'),
	('4','Louise','Bravo','2','louise.bravo@ifosupwavre.be','Présente à l''examen')
SET IDENTITY_INSERT tbl_Bernair_Michel OFF
Select * from tbl_Bernair_Michel

/******************
*  Table finale   *
*******************/

DROP TABLE tbl_Bernair_Michel_BIS
Select * into   tbl_Bernair_Michel_BIS FROM  tbl_Bernair_Michel

Select * from  tbl_Bernair_Michel_BIS

-- Ne prendre la mise à jour que les adresses E-mail @ifosupavre !!
---------------------------
-- Curseur -> pour 'c'  --
---------------------------
Declare @ID_c int,
        @Nom_c nvarchar(30),
        @Prenom_c nvarchar(30),
		@Sexe_c int,
		@Email_c nvarchar(30),
		@remarque_c nvarchar(30);
Declare testcurseur Cursor FOR
  ( Select Id,Nom, Prenom, Sexe,Email,Remarque from tbl_BERNAIR_MICHEL_BIS WHERE Email like '%ifosupwavre.be' )  
Open testcurseur
PRINT 'Mise à jour de la table tlb_Michel_Bernair en parcourant ligne par ligne'
PRINT '------------------------------------------------------------------------'
FETCH Next From testcurseur INTO @Id_c, @nom_c, @Prenom_c, @Sexe_c, @Email_c, @Remarque_c  -- On se positionne ligne par ligne, la première ici !
---PRINT 'Numero de depart: ' + cast (@ProductID1 as nvarchar(10))
WHILE (@@FETCH_STATUS = 0)  -- Tant que je ne suis pas à la fin > on boucle
  BEGIN  -- Begin 1
		--Print 'Id ' + cast(@ProductID as nvarchar(30)) + ' Nom : ' + @Name
  		Print 'je suis dans le curseur'
		PRINT 'Numero dans le curseur : ' + cast (@Id_c as nvarchar(10))
		Print @nom_c + ' ' + @prenom_c
		IF ( @Sexe_c = 1 ) 
		    BEGIN
		 PRINT 'OK sexe 1'  
		 Select Id,Nom, Prenom, sexe, email, remarque from tbl_Bernair_Michel_BIS WHERE Id = @Id_c
		 PRINT @nom_c + ' ' + @Prenom_c + ' ' + @Email_c		 
         UPDATE tbl_BERNAIR_MICHEL_BIS SET Email = @nom_c + '.'  + @Prenom_c + '.' + 'M'+ '@Ifosupwavre.be' 
		   WHERE Id = @Id_c -- Mise  jour de la table tbl_BERNAIR_MICHEL_BIS
         PRINT '... son Email devient : ' + @Email_c
		 END
        ELSE IF ( @Sexe_c = 2 )   
           BEGIN
		   PRINT 'OK sexe 2'  
		 --Print @nom_c + ' ' + @prenom_c
		  Select Id, Nom, Prenom, sexe, email,remarque from tbl_Bernair_Michel_BIS WHERE Id = @Id_c 
		  UPDATE tbl_BERNAIR_MICHEL_BIS SET Email = @nom_c + '.' + @Prenom_c + '.' + 'F' + '@Ifosupwavre.be' 
		  WHERE Id = @Id_c           -- Mise  jour de la table tbl_BERNAIR_MICHEL_BIS
          PRINT @nom_c + ' ' + @Prenom_c + ' ' + @Email_c
	  END

Fetch Next from testcurseur into @Id_c, @nom_c, @Prenom_c, @Sexe_c, @Email_c, @Remarque_c
PRINT ' Le prochain enregistrement est'
PRINT '-------------------------------'
PRINT @nom_c + ' ' + @Prenom_c
	END   -- Fin du Begin 1
CLOSE testcurseur
DEALLOCATE testcurseur

Select * from  tbl_Bernair_Michel_BIS


use AdventureWorks2017
select * from [Sales].[Customer]
select * from [Purchasing].[Vendor]
select * from [Person].[StateProvince]