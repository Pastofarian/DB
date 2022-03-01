

-- Création du Trigger --
-- Source utile : https://docs.microsoft.com/en-us/sql/t-sql/language-elements/else-if-else-transact-sql?view=sql-server-2017

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER tgr_createCategory
   ON  Tbl_Cat 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @cat_name nvarchar(50)
	SET @cat_name = (SELECT CategoryName FROM INSERTED)
    -- Insertion du Trigger
	IF (SELECT count(*) FROM Tbl_Cat WHERE CategoryName = @cat_name) > 1
	 BEGIN
	   ROLLBACK TRANSACTION
	 RAISERROR ('La catégorie %s existe déjà !',1,1,@cat_name)
	 END
END
GO


--

-- Puisque le trigger a été créé
-- Nous pouvons faire des INSERT, à chaque Insert, le déclencheur joue son rôle

INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('1','SMARTPHONE')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]

-- insertion d'une autre donnée
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')

-- Je souhaite que lorsque j'insère une nouvelle donnée qui existe déjà dans le système
-- la gestion se fasse via un trigger qui lui opère un rollback transactionnel et puis affiche
--  que le produit existe déjà.

INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]


--
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('3','GPS')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]