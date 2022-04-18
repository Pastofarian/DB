
/*
EXERCICE pour expliquer la notion d'insertion de donn�es dans une base de donn�es
==> On pouvait avoir un message d'erreur de type :

--> Msg 8101, Level 16, State 1, Line 23
--> An explicit value for the identity column in table 'Nom_de_table' can only be specified when a column list is used 
-->       and IDENTITY_INSERT is ON.

Lorsqu'on faisait l'insetion de donn�es dans une table o� nous avions un champs Id consid�r� consid�r� comme une cl� primaire et
incr�mentale => 
insertion d'une premi�re donn�e => Id =1
                                      =2
									  Etc.

*/

-- CREATION DE LA BASE DE DONNEE
USE MASTER
-- V�rification si elle existe
IF EXISTS (select * from master.dbo.sysdatabases where name = 'TEST_INSERT')
DROP DATABASE TEST_INSERT
GO
CREATE DATABASE TEST_INSERT
GO

-- select * from master.dbo.sysdatabases
-- Cr�ation de la table qui compose la DB en question 'TEST_INSERT'
-- V�rification que cette table n'existe d�j� pas dans la DB 'TEST_INSERT'
USE TEST_INSERT   -- il y a une changement de la DB (MASTER --> TEST_INSERT)

IF EXISTS (select * from TEST_INSERT.sys.tables where name = 'Employee')
DROP TABLE Employee
GO
CREATE TABLE Employee  -- 3 champs !!
(
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id inc�mentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la premi�re valeur de mon enregistrement commence � 100
									 -- En pratique, c'est toujours (1,1)
Nom VARCHAR (100) NOT NULL,
Salaire INT NULL,    --- Money
)

-- select * from TEST_INSERT.sys.tables

select * from Employee

-- Je vais vous montrer que les param�tres de la premi�re colonne, cl� primaire; inc�mentale

-- POPULATE - insertion de divers valeurs dans cette table Employee
GO
USE TEST_INSERT
INSERT INTO Employee VALUES
('Thibaut', 100),
('Romain', 150),
('Celine', 200),
('Jaime', 300);

select * from Employee
-- Si maintenant, j'efface un enregistrement
-- Celine
DELETE FROM Employee where Id = 3
select * from Employee  -- 1, 2, 4 ==> j'ai un trou au niveau des Id =>
INSERT INTO Employee VALUES (3, 'Anthony', 400);

-- Msg 8101, Level 16, State 1, Line 64
-- An explicit value for the identity column in table 'Employee' can only be specified 
-- when a column list is used and IDENTITY_INSERT is ON.
-- Pourquoi : parce que je souhaite r�affecter l'ID 3 � une autre personne alors que cet Id =3 a �t� affect� auparavant.
-- R�attribution des ID incr�mentale => Erreur

SET IDENTITY_INSERT Employee ON  -- je souhaite forcer l'Id d�j� r�affact� � une autre personne.
INSERT INTO Employee (Id, Nom, Salaire) VALUES (3, 'Anthony', 400);
select * from Employee
SET IDENTITY_INSERT Employee OFF -- je termine cette r�affecation des ID
INSERT INTO Employee VALUES ('Mike',1000);
select * from Employee


/* 
 Question Anthony : Pourquoi ne pas placer directement le code 
  => SET INSERT INTO <nom_de_table> ON
 */ 
--
IF EXISTS (select * from TEST_INSERT.sys.tables where name = 'Employee_TEST')
DROP TABLE Employee_TEST
GO
CREATE TABLE Employee_TEST  -- 3 champs !!
(
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id inc�mentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la premi�re valeur de mon enregistrement commence � 100
									 -- En pratique, c'est toujours (1,1)
Nom VARCHAR (100) NOT NULL,
Salaire INT NULL,    --- Money
)
Select * from Employee_TEST

-- Avant l'insertion
SET IDENTITY_INSERT Employee_TEST ON 
INSERT INTO Employee_TEST (Id, Nom, Salaire) VALUES (1, 'Wail', 400);
Select * from Employee_TEST

SET IDENTITY_INSERT Employee_TEST OFF







---







