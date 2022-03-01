/************** CURSEUR *****************

Programmer la requête suivante en utilisant la notion de CURSEUR

Source : https://docs.microsoft.com/fr-fr/sql/relational-databases/cursors?view=sql-server-2017

A partir de la base de données nommée < IFOSUP_CURSOR > dont sa table est < T_STUDENT_STATE > composé des champs suivants :
  --> StudentID est un entier, les autres < prenom >, < nom >, < note > (/100), < etat >, < remarque >
                             , seront de type 255 caractères.
  
1) "Populate" la table de 10 data (insérer 10 données dans celle-ci).
   Faite en sorte que les étudiants auront en fonction de leur propre note, le statut : admis(e), ajourné(e), abandon.

2) A partir d'un curseur, veuillez créer un rapport qui reprend uniquement les élèves Admis : utilisez la commande PRINT !


(c) MB - Ifosupwavre

**********************************/ ok

USE Master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR')
DROP DATABASE IFOSUP_CURSOR  
GO
  CREATE DATABASE IFOSUP_CURSOR  
GO

GO
USE IFOSUP_CURSOR  
IF EXISTS (SELECT * FROM IFOSUP_CURSOR.sys.tables WHERE name = 'T_STUDENT_STATE')
DROP TABLE T_STUDENT_STATE
GO
CREATE TABLE T_STUDENT_STATE (StudentID int, nom varchar(255), prenom varchar(255), note varchar(255), etat varchar(255), remarque varchar(255) )
GO

INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('1','AYOTTE', 'Victor H. O.','100','Admis','')   
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('2','CALO','Fabrizio','','Abandon','')  
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('3','CLARAT','Arnaud D, J.','','Ajourné','Laboratoire: initiation aux bases de données')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('4','COUTELLE','Julien P','','Abandon','')  
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('5','CUGNON','Geoffrey G','79','Admis','' ) 
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('6','DECUYPERE','Jules H, L.','82','Admis','' )  
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('7','DEVRESSE', 'Cindy G, R.','64','Admise','' ) 
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('8','DONGMO', 'Christian O','61','Admis','' )  
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('9','FRANÇOIS','Shantou','57','Admis','' ) 
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('10','GENICOT','Jerôme','100','Admis','' )
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('11','GOEFFOET','Guillaume A, R.','','Abandon','' ) 
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES   ('12','GORLIER','Laurent A, R.','93','Admis','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES   ('13','KOUAKOU','Victoria S, A.','','Abandon',''   )
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('14','LETAWE','Isabelle G, E.','57','Admise','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES   ('15','LEVIS','Maxime C, V.','100','Admis','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('16','MOHIMONT','Gauthier C','93','Admis','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('17','MOREIRA GUEDES','Carlos F','100','Admis','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES   ('18','OUAHIB','Anyssa N','99','Admise','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('19','PIERRE','Korenthin P, I.','75','Admis','')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('20','PRINCE','Maxime V, D.','','Ajourné','Laboratoire: initiation aux bases de données')
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('21','SANTOS CRISTOVAO',' Antonio J','57','Admis','' )
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES ('22','SIDIME','Fode B.','' ,'Abandon',''  )
INSERT INTO T_STUDENT_STATE (StudentID, nom, prenom, note, etat, remarque) VALUES  ('23','TORFS','Corentin E, N.','99','Admis','')
GO


DECLARE @firstname AS NVARCHAR(50)
DECLARE @lastname AS NVARCHAR(50)

DECLARE cur1 CURSOR FOR (SELECT Nom, prenom FROM T_STUDENT_STATE WHERE etat = 'Admis') 

OPEN cur1            

FETCH cur1 INTO @firstname, @lastname
      PRINT @firstname                           
      PRINT @lastname


WHILE @@fetch_Status = 0  

BEGIN

    FETCH cur1 INTO @firstname, @lastname 
    SELECT @firstname AS Prenom,@lastname AS Nom                    
    PRINT @lastname 
    PRINT @firstname                            
    
END
CLOSE cur1
DEALLOCATE cur1  