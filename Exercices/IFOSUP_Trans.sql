USE Master
GO
--si DB existe --> je la videe et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'IFOSUP_Trans')
DROP DATABASE IFOSUP_Trans 
GO
CREATE DATABASE IFOSUP_Trans --Je la recrée à nouvveau
GO

----------------------------------------
GO
USE IFOSUP_Trans -- utilisation de la DB
IF EXISTS (SELECT * FROM IFOSUP_Trans.sys.tables WHERE name = 'T_Trans')
DROP TABLE T_TRANS 
GO
CREATE TABLE T_TRANS (colum_name varchar(255))
SELECT * FROM T_Trans
GO
-----------------------------------------

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction')
COMMIT TRANSACTION
SELECT colum_name FROM T_TRANS

------------------------------------------

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction')
-- COMMIT TRANSACTION
ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

--------------------------------------------
DROP TABLE T_TRANS
-------------------------------------------
-- recréer la table avec précédent code

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
COMMIT TRANSACTION

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

--------------------------------------------

TRUNCATE TABLE T_TRANS  --Vide la table de ses valeurs, supprime le contenu de la table

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
--COMMIT TRANSACTION
ROLLBACK TRANSACTION

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION
SELECT colum_name FROM T_TRANS

-------------------------------------------

-- 28/01/22

TRUNCATE TABLE T_TRANS

INSERT INTO T_Trans (colum_name) VALUES ('Pas de transaction')
BEGIN TRANSACTION
INSERT INTO T_TRANS (colum_name) VALUES ('Première transaction, ligne 1')
	SAVE TRANSACTION S1;

BEGIN TRANSACTION
	INSERT INTO T_TRANS (colum_name) VALUES ('Deuxième transaction')
--COMMIT TRANSACTION
ROLLBACK TRANSACTION S1

INSERT INTO T_TRANS (colum_name) VALUES ('première transaction, ligne 2')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION S1
SELECT colum_name FROM T_TRANS

-----------------------------------------------------


INTO #temp1 FROM [Production].[Product] AS P JOIN --crée la table avec INTO
[Production].[ProductInventory] AS I ON P.ProductID = I.ProductID
SELECT * FROM #temp1 -- 1070 lignes
