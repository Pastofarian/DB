

-- Transaction -- 
-- Source : https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-2017
-- Source : Money et smallmoney : https://docs.microsoft.com/en-us/sql/t-sql/data-types/money-and-smallmoney-transact-sql?view=sql-server-2017


/*****************************************************************************
 1) test de l'existence de la présence ou non de la base de données tests
  -- MyIfosup_Bank -- 
*****************************************************************************/
USE Master
GO
--si DB existe -> je la vide et je la recrée
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'MyIfosup_Bank')
DROP DATABASE MyIfosup_Bank  -- Quelque soit la situation de la table, je la vide ! 
GO
CREATE DATABASE MyIfosup_Bank  -- Je la recrée à nouveau une nouvelle table
GO


/*************************************************************
 2) test de l'existence de la présence de la table T_TRANS
**************************************************************/
USE MyIfosup_Bank    -- (dans la DB )
GO
IF EXISTS (SELECT * FROM MyIfosup_Bank.sys.tables WHERE name = 'Compte_epargne')
DROP TABLE Compte_epargne
GO
CREATE TABLE Compte_epargne
(
AccountNum INT PRIMARY KEY,   
Amount Money NOT NULL -- on aurait aussi travailler avec INT mais avec Money, on peut préciser la devise !
)
SELECT * FROM Compte_epargne
GO

IF EXISTS (SELECT * FROM MyIfosup_Bank.sys.tables WHERE name = 'Compte_courant ')
DROP TABLE Compte_courant 
GO
CREATE TABLE Compte_courant  
(
AccountNum INT PRIMARY KEY,
Amount Money NOT NULL
)
GO
Select * from Compte_courant

ALTER TABLE Compte_courant   -- la balance : le montant ne peut être plus grand que 100
 ADD CONSTRAINT DIFF CHECK (Amount > $100) 
GO


/*********************************************************************************************
     Insertion des données dans les 2 tables -> il faut que mes comptes soient alimentés
*********************************************************************************************/
truncate table Compte_epargne -- vide les tables
truncate table Compte_courant 

INSERT Compte_courant
VALUES (12345, €1000)

INSERT Compte_epargne  
VALUES (12345, €1000)

select * from Compte_courant
select * from Compte_epargne

-- Début de la transaction ************ Que je fasse juste Begin Transaction ou le Begin Try ou le Rollback j'ai le même résultat
-- 
BEGIN TRANSACTION 

---- compte courant doit avoir au moins 100 euros
-- cas test 1 : 899 OK car 1000 -899 = 101 > 100 ==> OK
--     test 2 : 900 NonOK car 1000-900 =100 > 100 ==> Non
--     test 3 : 990 NonOK car 1000 -990 = 10 > 100 ==> Non
   UPDATE Compte_courant SET Amount = Amount - €990  -- compte courant doit avoir au moins 100 euros
     WHERE AccountNum = 12345
   --UPDATE Compte_epargne SET Amount = Amount + €990
   --  WHERE AccountNum = 12345 
COMMIT TRANSACTION

-- Résultat de l'éexécution de la transaction ==> Erreur 
--  Msg 547, Level 16, State 0, Line 77
--  The UPDATE statement conflicted with the CHECK constraint "DIFF". The conflict occurred in database "MyIfosup_Bank",
--   table "dbo.Compte_courant", column 'Amount'.
--   The statement has been terminated.
--  Par contre, si je débitais le compte courant d’un certain montant où la différence était supérieure à 100 €,
--  il y aurait erreur puisqu’elle est engendrée par la contrainte de départ au sein de la table compte courant.


select * from Compte_courant WHERE AccountNum = 12345
select * from Compte_epargne WHERE AccountNum = 12345



--drop table [dbo].[Compte_courant]
--drop table [dbo].[Compte_epargne]

/*****************************************************
 G1 : Gestion de la transaction et de son erreur
******************************************************/
BEGIN TRANSACTION
    BEGIN TRY
        UPDATE Compte_courant SET Amount = Amount - €990.00
        WHERE AccountNum = 12345
        UPDATE Compte_epargne SET Amount = Amount + €990.00
        WHERE AccountNum = 12345
COMMIT TRANSACTION
    END TRY  -- END TRY du BEGIN TRY
    BEGIN CATCH
        RAISERROR('G1: Transaction Avortée', 16, 1)
        ROLLBACK TRANSACTION
    END CATCH

select * from Compte_courant WHERE AccountNum = 12345
select * from Compte_epargne WHERE AccountNum = 12345


/**************************************************************
  G2 : Autre façon de gérer les transactions et leurs erreurs 
****************************************************************/

BEGIN TRANSACTION  -- début de la transaction
 BEGIN TRY      
        UPDATE Compte_courant SET Amount = Amount - €990.00
          WHERE AccountNum = 12345
        UPDATE Compte_epargne SET Amount = Amount + €990.00
          WHERE AccountNum = 12345
END TRY
BEGIN CATCH  
    SELECT    -- une série de varaibles "systèmes" qui donne renseigne sur la nature de l'erreur en question
        ERROR_NUMBER() AS ErrorNumber         -- returns the number of the error.
        ,ERROR_SEVERITY() AS ErrorSeverity    -- returns the severity.
        ,ERROR_STATE() AS ErrorState          -- returns the error state number.
        ,ERROR_PROCEDURE() AS ErrorProcedure  -- returns the name of the stored procedure or trigger where the error occurred.
        ,ERROR_LINE() AS ErrorLine            -- returns the line number inside the routine that caused the error.
        ,ERROR_MESSAGE() AS ErrorMessage;  
 -- ERROR_MESSAGE() : cet variable veut dire : returns the complete text of the error message. The text includes the values supplied for any substitutable parameters, such as lengths,
 --  object names, or times. 
  
    IF @@TRANCOUNT > 0  -- Returns the number of BEGIN TRANSACTION statements that have occurred on the current connection.
        ROLLBACK TRANSACTION; 
        PRINT ('G2: Je fais un Rollback')
     SELECT Amount AS Compte_courant FROM Compte_courant WHERE AccountNum = 12345
     SELECT Amount AS Compte_epargne FROM Compte_epargne WHERE AccountNum = 12345

END CATCH;  



/**************************************************************
  G3 : Autre façon de gérer les transactions et leurs erreurs 
        La fonction GOTO
****************************************************************/

USE MyIfosup_Bank  
GO
select * from Compte_epargne WHERE AccountNum = 12345
select * from Compte_courant WHERE AccountNum = 12345
GO
DECLARE @Error int
SET @Error = @@ERROR
BEGIN TRANSACTION
IF (@Error<> 0) GOTO Error_Handler  
        UPDATE Compte_courant SET Amount = Amount - €990.00
          WHERE AccountNum = 12345
        UPDATE Compte_epargne SET Amount = Amount + €990.00
          WHERE AccountNum = 12345
     SET @Error = @@ERROR
IF (@Error <> 0) GOTO Error_Handler
 COMMIT TRAN 
 
 Error_Handler:
 IF @Error <> 0
  BEGIN
   ROLLBACK TRANSACTION
   PRINT ('G3: Je fais un Rollback')
  END

  
-- Les montants de mes comptes n'ont pas été débités.
-- Les montants sont restés les mêmes.
SELECT Amount AS Compte_courant FROM Compte_courant WHERE AccountNum = 12345
SELECT Amount AS Compte_epargne FROM Compte_epargne WHERE AccountNum = 12345
