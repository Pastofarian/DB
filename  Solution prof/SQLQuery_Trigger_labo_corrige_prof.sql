

-- Cr�ation du Trigger --
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
	 RAISERROR ('La cat�gorie %s existe d�j� !',1,1,@cat_name)
	 END
END
GO


--

-- Puisque le trigger a �t� cr��
-- Nous pouvons faire des INSERT, � chaque Insert, le d�clencheur joue son r�le

INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('1','SMARTPHONE')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]

-- insertion d'une autre donn�e
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')

-- Je souhaite que lorsque j'ins�re une nouvelle donn�e qui existe d�j� dans le syst�me
-- la gestion se fasse via un trigger qui lui op�re un rollback transactionnel et puis affiche
--  que le produit existe d�j�.

INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]


--
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('2','APPLE WATCH')
INSERT INTO TBL_Cat ([CategoryID],CategoryName) VALUES ('3','GPS')
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]