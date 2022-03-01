/*********************************************

Ecrire un trigger sur une table tbl_cat d'une base de donnée DB_IFOSUP_EXERCICE_TRIG qui reprend les champs suivants :
 CategoryID   -> int (entier) Ne pouvant être nul 
 CategoryName -> chaîne de caractère pouvant être nulle 
 CategoryDescription -> chaîne de caractère pouvant être nulle 

A l'insertion d'une donnée, on souhaite que ce trigger fasse un Rollback si la donnée rentrée existe déjà dans la table.

Source :  https://docs.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-2017
          https://docs.microsoft.com/en-us/sql/t-sql/language-elements/else-if-else-transact-sql?view=sql-server-2017
           --> cfr.section : B. Using a query as part of a Boolean expression

(c) MB - Ifosupwavre

******************************************************/
USE master
GO

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'DB_IFOSUP_EXERCICE_TRIG')
DROP DATABASE DB_IFOSUP_EXERCICE_TRIG 
GO
CREATE DATABASE DB_IFOSUP_EXERCICE_TRIG
GO

USE DB_IFOSUP_EXERCICE_TRIG
IF EXISTS (SELECT * FROM DB_IFOSUP_EXERCICE_TRIG.sys.tables WHERE name = 'tbl_cat')
DROP TABLE tbl_cat 
GO
CREATE TABLE tbl_cat
(CategoryID int Identity(1,1) Primary Key NOT NULL, CategoryName VARCHAR(255), CategoryDescription VARCHAR(255))
GO

--SELECT * FROM tbl_cat

INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('Ibanez', 'Electrique')
INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('PRS', 'Electrique')
INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('Gibson', 'Electro-Acoustique')
INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('Fender', 'Acoustique')
INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('Cort', 'Electrique')
INSERT INTO tbl_cat (CategoryName, CategoryDescription)
VALUES ('Jackson', 'Electrique')

SELECT * FROM sys.objects WHERE type = 'TR' 
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' 
           AND NAME = 'tbl_cat_trigger' ) 
        BEGIN 
              PRINT 'Trigger Exists'
        --DROP TRIGGER [tbl_cat].[tbl_cat_trigger]
        END
        ELSE
        BEGIN
         PRINT 'Pas de Trigger pour ce nom'
        END
GO

--CREATE TRIGGER tbl_cat_trigger
ALTER TRIGGER tbl_cat_trigger
    ON tbl_cat
    AFTER INSERT, UPDATE  
AS 
BEGIN
SET NOCOUNT ON  
DECLARE @twin NVARCHAR(255)
SET @twin = (SELECT CategoryName FROM INSERTED)
IF (SELECT COUNT(*) FROM tbl_cat WHERE CategoryName = @twin) > 1
    BEGIN
        ROLLBACK TRANSACTION
    RAISERROR('Item already in use !', 1, 1, @twin)
    END
END
GO

