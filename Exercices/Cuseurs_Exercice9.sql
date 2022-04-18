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

USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_CURSOR')
DROP DATABASE IFOSUP_CURSOR 
GO
CREATE DATABASE IFOSUP_CURSOR
GO

USE IFOSUP_CURSOR
GO

/**************************************************************
  ETAPE n°1
 *************************************************************/

DROP TABLE IF EXISTS T_STUDENT_STATE;
GO 

CREATE TABLE T_STUDENT_STATE  
(
StudentID INT IDENTITY (1,1) PRIMARY KEY, --- Id incémentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la première valeur de mon enregistrement commence à 100
                                     -- En pratique, c'est toujours (1,1)
Nom VARCHAR (250) NOT NULL,
Prenom VARCHAR (255) NOT NULL,
Note VARCHAR (255), 
Etat VARCHAR (255),    
Remarque VARCHAR (255)   
)
GO

SELECT * FROM T_STUDENT_STATE

/**************************************************************
  ETAPE n°2
 *************************************************************/

INSERT INTO T_STUDENT_STATE(prenom,nom,note, etat, remarque) VALUES ('AYOTTE', 'Victor H. O.','100','Admis','')     
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES ('CALO','Fabrizio','','Abandon','')    
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES ('CLARAT','Arnaud D, J.','','Ajourné','Laboratoire: initiation aux bases de données')
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES ('COUTELLE','Julien P','','Abandon','')    
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES ('CUGNON','Geoffrey G','79','Admis','' )   
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES  ('DECUYPERE','Jules H, L.','82','Admis','' )  
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES  ('DEVRESSE', 'Cindy G, R.','64','Admise','' ) 
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES  ('DONGMO', 'Christian O','61','Admis','' )    
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES  ('FRANÇOIS','Shantou','57','Admis','' )   
INSERT INTO T_STUDENT_STATE (prenom,nom,note, etat, remarque) VALUES  ('GENICOT','Jerôme','100','Admis',''  )

SELECT * FROM T_STUDENT_STATE


/**************************************************************
  ETAPE n°3
 *************************************************************/

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
CLOSE cir1
DEALLOCATE cur1