
/********************************/
/* Etude des Triggers           */
/* SQLQuery_Trigger_theorie.sql */
/******************************/


USE AdventureWorks2017
GO
-- Track all Inserts, Updates, and Deletes
 SELECT * FROM [Production].[ProductInventory]

 -- Existence de la table 
IF EXISTS (SELECT * FROM AdventureWorks2017.sys.tables WHERE name like '%IFOSUPWAVRE')
DROP TABLE Production.ProductInventoryAudit_IFOSUPWAVRE
GO
 -- Création d'une table semblable à celle de Production.ProductionInventoryAudit_IFOSUPWAVRE
 -- Même nombre et type de champs
 CREATE TABLE Production.ProductInventoryAudit_IFOSUPWAVRE
	(
	ProductID int NOT NULL ,
	LocationID smallint NOT NULL ,
	Shelf nvarchar(10) NOT NULL ,
	Bin tinyint NOT NULL ,
	Quantity smallint NOT NULL ,
	rowguid uniqueidentifier NOT NULL ,
	ModifiedDate datetime NOT NULL ,
	InsOrUPD char(1) NOT NULL ) -- Insert/Delete -> InsOrUPD =>Champ montrant si la donnée a été insérée ou supprimée
 GO

 /* Existence d'un Trigger */
 
 ----SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'.[Production_trigger_ProductInventoryAudit_IFOSUPWAVRE]')
USE AdventureWorks2017
GO 
SELECT * FROM sys.objects WHERE type = 'TR' 
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' 
           AND NAME = 'Production_trigger_ProductInventoryAudit_IFOSUPWAVRE' ) 
		BEGIN 
			  PRINT 'Trigger Exists'
	    --DROP TRIGGER [Production].[Production_trigger_ProductInventoryAudit_IFOSUPWAVRE]
		END
		ELSE
		BEGIN
		 PRINT 'Pas de Trigger pour ce nom, donc je le crée'
        END
GO

-- Create trigger to populate Production.ProductInventoryAudit table
CREATE TRIGGER Production_trigger_ProductInventoryAudit_IFOSUPWAVRE
ON Production.ProductInventory
AFTER INSERT, DELETE  -- après une insertion/suppression rajouter les données dans les champs
AS
SET NOCOUNT ON  
-- Insertion de lignes
 INSERT Production.ProductInventoryAudit_IFOSUPWAVRE  -- dans la table
 (ProductID, LocationID, Shelf, Bin, Quantity,
 rowguid, ModifiedDate, InsOrUPD) 
 SELECT DISTINCT i.ProductID, i.LocationID, i.Shelf, i.Bin, i.Quantity,
 i.rowguid, GETDATE(), 'I'
 FROM inserted i
 -- Suppression de lignes
 INSERT Production.ProductInventoryAudit_IFOSUPWAVRE
 (ProductID, LocationID, Shelf, Bin, Quantity,
 rowguid, ModifiedDate, InsOrUPD)
 SELECT d.ProductID, d.LocationID, d.Shelf, d.Bin, d.Quantity,
        d.rowguid, GETDATE(), 'D'
FROM deleted d

GO
-- Insert d'une nouvelle ligne dans la table originale Production.ProductInventory
--  entraînera l'inserton dû au trigger
-- 
INSERT Production.ProductInventory
(ProductID, LocationID, Shelf, Bin, Quantity)
VALUES (318, 6, 'A', 4, 22)


-- Suppression d'une ligne
DELETE Production.ProductInventory
WHERE ProductID = 318 AND LocationID = 6

-- Vérification des données de la table
SELECT ProductID, LocationID, InsOrUpd
FROM Production.ProductInventoryAudit_IFOSUPWAVRE

SELECT * FROM production.ProductInventory where productID = 318
SELECT * FROM Production.ProductInventoryAudit_IFOSUPWAVRE



-- REMARQUES :
/* SET NOCOUNT ON ou OFF ?
Source 1 : https://www.developpez.net/forums/d720351/bases-donnees/ms-sql-server/developpement/debutante-trigger-set-nocount-on-off/
Source 2 : https://docs.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver15)
SET NOCOUNT sert à spécifier si SQL Server doit retourner à l'appelant le nombre de lignes
affectées par une requête; or dans un trigger cela n'a aucun intérêt à mon sens parce
que l'application n'a pas à se préoccuper de ce que fait le trigger.

Pour réduire le traffic réseau, il est préférable d'écrire SET NOCOUNT ON dans tout module SQL,
mais certaines plateformes de développement exigent que le nombre de lignes affectées 
soit retourné ...
*/
