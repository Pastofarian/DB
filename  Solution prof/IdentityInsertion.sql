
/*
EXERCICE pour expliquer la notion d'insertion de données dans une base de données
==> On pouvait avoir un message d'erreur de type :

--> Msg 8101, Level 16, State 1, Line 23
--> An explicit value for the identity column in table 'Nom_de_table' can only be specified when a column list is used 
-->       and IDENTITY_INSERT is ON.

Lorsqu'on faisait l'insetion de données dans une table où nous avions un champs Id considéré considéré comme une clé primaire et
incrémentale => 
insertion d'une première donnée => Id =1
                                      =2
									  Etc.

*/

-- CREATION DE LA BASE DE DONNEE
USE MASTER
-- Vérification si elle existe
IF EXISTS (select * from master.dbo.sysdatabases where name = 'TEST_INSERT')
DROP DATABASE TEST_INSERT
GO
CREATE DATABASE TEST_INSERT
GO

-- select * from master.dbo.sysdatabases
-- Création de la table qui compose la DB en question 'TEST_INSERT'
-- Vérification que cette table n'existe déjà pas dans la DB 'TEST_INSERT'
USE TEST_INSERT   -- il y a une changement de la DB (MASTER --> TEST_INSERT)

IF EXISTS (select * from TEST_INSERT.sys.tables where name = 'Employee')
DROP TABLE Employee
GO
CREATE TABLE Employee  -- 3 champs !!
(
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id incémentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la première valeur de mon enregistrement commence à 100
									 -- En pratique, c'est toujours (1,1)
Nom VARCHAR (100) NOT NULL,
Salaire INT NULL,    --- Money
)

-- select * from TEST_INSERT.sys.tables

select * from Employee

-- Je vais vous montrer que les paramètres de la première colonne, clé primaire; incémentale

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
-- Pourquoi : parce que je souhaite réaffecter l'ID 3 à une autre personne alors que cet Id =3 a été affecté auparavant.
-- Réattribution des ID incrémentale => Erreur

SET IDENTITY_INSERT Employee ON  -- je souhaite forcer l'Id déjà réaffacté à une autre personne.
INSERT INTO Employee (Id, Nom, Salaire) VALUES (3, 'Anthony', 400);
select * from Employee
SET IDENTITY_INSERT Employee OFF -- je termine cette réaffecation des ID
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
Id INT IDENTITY (1,1) PRIMARY KEY, --- Id incémentale -> (1,...) 1, 2, 3, 4 |  (..,1) => je souhaite commencer au nombre 1
                                     -- (1,100) ==> pas de 1 , la première valeur de mon enregistrement commence à 100
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







