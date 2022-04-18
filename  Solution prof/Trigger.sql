
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
 -- Cr�ation d'une table semblable � celle de Production.ProductionInventoryAudit_IFOSUPWAVRE
 -- M�me nombre et type de champs
 CREATE TABLE Production.ProductInventoryAudit_IFOSUPWAVRE
	(
	ProductID int NOT NULL ,
	LocationID smallint NOT NULL ,
	Shelf nvarchar(10) NOT NULL ,
	Bin tinyint NOT NULL ,
	Quantity smallint NOT NULL ,
	rowguid uniqueidentifier NOT NULL ,
	ModifiedDate datetime NOT NULL ,
	InsOrUPD char(1) NOT NULL ) -- Insert/Delete -> InsOrUPD =>Champ montrant si la donn�e a �t� ins�r�e ou supprim�e
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
		 PRINT 'Pas de Trigger pour ce nom, donc je le cr�e'
        END
GO

-- Create trigger to populate Production.ProductInventoryAudit table
CREATE TRIGGER Production_trigger_ProductInventoryAudit_IFOSUPWAVRE
ON Production.ProductInventory
AFTER INSERT, DELETE  -- apr�s une insertion/suppression rajouter les donn�es dans les champs
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
--  entra�nera l'inserton d� au trigger
-- 
INSERT Production.ProductInventory
(ProductID, LocationID, Shelf, Bin, Quantity)
VALUES (318, 6, 'A', 4, 22)


-- Suppression d'une ligne
DELETE Production.ProductInventory
WHERE ProductID = 318 AND LocationID = 6

-- V�rification des donn�es de la table
SELECT ProductID, LocationID, InsOrUpd
FROM Production.ProductInventoryAudit_IFOSUPWAVRE

SELECT * FROM production.ProductInventory where productID = 318
SELECT * FROM Production.ProductInventoryAudit_IFOSUPWAVRE



-- REMARQUES :
/* SET NOCOUNT ON ou OFF ?
Source 1 : https://www.developpez.net/forums/d720351/bases-donnees/ms-sql-server/developpement/debutante-trigger-set-nocount-on-off/
Source 2 : https://docs.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver15)
SET NOCOUNT sert � sp�cifier si SQL Server doit retourner � l'appelant le nombre de lignes
affect�es par une requ�te; or dans un trigger cela n'a aucun int�r�t � mon sens parce
que l'application n'a pas � se pr�occuper de ce que fait le trigger.

Pour r�duire le traffic r�seau, il est pr�f�rable d'�crire SET NOCOUNT ON dans tout module SQL,
mais certaines plateformes de d�veloppement exigent que le nombre de lignes affect�es 
soit retourn� ...
*/



-----------------Fin code ----------------------------------------------------------------



/* TRIGGER */

Select  BusinessEntityID, Lastname, Firstname, Gender, DepartmentId  
    from tbl_Employee_Gender_Department  -- 296 enregistrements


---- Je ne prends que les 10 premiers enregistrements ==> TOP(10)
Select TOP(10) * 
    from tbl_Employee_Gender_Department 

       -- Ou ci-dessous - M�me r�sultat
Select TOP(10) BusinessEntityID, Lastname, Firstname, Gender, DepartmentId 
from tbl_Employee_Gender_Department 

-- tbl_Employee_Gender_Department 
-- Je vais ajouter un champ Salary 


-- Existence d'une table temporaire #temp1
IF object_id ('tempdb.dbo.#temp1') is not null 
drop table #temp1
select TOP (10) BusinessEntityID, Lastname, Firstname, Gender, DepartmentId into #temp1 from tbl_Employee_Gender_Department 
select * from #temp1 -- 10 

--  ajouter un champ Salary � la table #temp1
Alter table #temp1 ADD salary money  -- Type de Microsoft
Select * from #temp1  -- 10 lignes -- Salary NULL ! pas de valeur!

-- Je devrais modifier (UPDATE) l'ensemble des ces 10 enregistrements avec une donn�e dans le champ salaire
-- Boucle d'insertion de donn�es : Mise � jour des donn�es
-- J'affecte uniquement le champ salaire -> SET salary = ....

DECLARE @num INT = 0;
WHILE @num < 10
BEGIN  
   UPDATE #temp1  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [salary] = 1000
   WHERE [BusinessEntityID]  = @num   
   PRINT 'Insertion de donn�es de salaire ' + ' ' + 'Pour le BusinessEntityID n� : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des donn�es dans la table';
GO
Select * from #temp1   -- 

--je sauve @temp1 en dur : tbl_Employee_Gender_Department_Salary

drop table tbl_Employee_Gender_Department_Salary   -- Table en dur
select * into tbl_Employee_Gender_Department_Salary from #temp1
select * from  tbl_Employee_Gender_Department_Salary -- Pourvue d�sormais du champ salaire pour les employ�s !


-- Id�e d'une traigger, d'un d�clencher
-- Lorsque je vais ins�rer une donn�e dans la table  tbl_Employee_Gender_Department_Salary 
-- Je souhaiterai que ce que je viens d'ins�rer se marque en tant log dans une table Audit, 
-- avec la date Syst�me au jour et � l'heure o� l'insertion s'est pass�

/*
-- 2 tables : tbl_Employee_Gender_Department_Salary 
              audit
                       */


-- Cr�ation de la table d'Audit pour r�cup�rer les donn�es ins�r�es ou supprim�es
USE AdventureWorks2017
DROP Table tbl_employee_salary_audit
CREATE TABLE tbl_employee_salary_audit
(
id nvarchar(10),
auditData nvarchar(255)
)
GO
-- TRIGGER qui va ne s'occuper que des insertions
-- INSERT INTO ..... ==> Il y a quelque chose qui doit se d�clencher
-- en, l'occurence une copie de cette insertion dans l atable d'Audit que je viens de cr�e auparvant.

CREATE TRIGGER tr_Employee_Gender_Department_Salary_For_INSERT
  --- ALTER TRIGGER tr_Employee_Gender_Department_Salary_For_INSERT
 ON tbl_Employee_Gender_Department_Salary
 FOR INSERT
 AS
 BEGIN                       -- Inserted est une table que le Trigger utilise uniquement dans son contexte
                             -- J'aurai pu avoir une table qui reprenne l'ensemble de mes insertions
                                                  -- que l'on nomme Audit (cfr.Etape n�2) -> tbl_employee_salary_audit
     --Select * From inserted  -- sur de ce qui a �t� ins�r�

        -- Je peux aller chercher l'ID de ce qui a �t� ins�r�
    Declare @id INT
        SELECT @Id = BusinessEntityID FROM Inserted
        -- Je veux une copie dans une autre table de ce qui a �t� ins�r�e > table tbl_employee_salary_audit
        INSERT into tbl_employee_salary_audit 
         VALUES ( cast(@id as nvarchar(10)) ,'Nouvel employ� Ajout� : '+ cast (getdate() as varchar(20)) )
         
END -- fin du BEGIN du Trigger

GO
Select * from tbl_Employee_Gender_Department_Salary -- 10
Select * from tbl_employee_salary_audit 

-- Nouvel enregistrement
INSERT INTO tbl_Employee_Gender_Department_Salary 
  VALUES ('12','Donald', 'Trump','M','16','200000000000000')

  -- Apr�s ce nouvel enregistrement, nous avons donc :

Select * from tbl_Employee_Gender_Department_Salary -- 10
Select * from tbl_employee_salary_audit 


/***************************************************
* Trigger pour la suppression d'un enregistrement
*****************************************************/
GO
CREATE TRIGGER tr_Employee_Gender_Department_Salary_For_DELETE
  --- ALTER TRIGGER tr_Employee_Gender_Department_Salary_For_DELETE
 ON tbl_Employee_Gender_Department_Salary
 FOR DELETE   -- �a concerne une supression d'un rengistrement
 AS
 BEGIN                       -- Deleted est une table que le Trigger utilise uniquement dans son contexte
                             
     ---Select * From deleted  -- sur de ce qui a �t� supprim�

        -- Je peux aller chercher l'ID de ce qui a �t� ins�r�
        Declare @idd INT
        SELECT @Idd = BusinessEntityID FROM deleted 
        -- Je veux une copie dans une autre table de ce qui a �t� supprim� > table tbl_employee_salary_audit
        INSERT into tbl_employee_salary_audit 
         VALUES ( cast(@idd as nvarchar(10)) ,'Employ� Supprim� ! '+ cast (getdate() as varchar(20)) )

 END
 
 -- TRUNCATE TABLE tbl_employee_salary_audit
 DELETE FROM tbl_Employee_Gender_Department_Salary WHERE BusinessEntityId = '13'



 Select * from tbl_Employee_Gender_Department_Salary  
 Select * from tbl_employee_salary_audit

---  Select * From deleted  -- en dehors du Trigger -> j'ai une erreur car objet inconnu mais connu uniquement 
                                                      -- dans son contexte du Trigger


 ----------------------------Fin Code --------------------------------------------------
 

 

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
SELECT [CategoryName] FROM [dbo].[Tbl_Cat]                                                     ------------