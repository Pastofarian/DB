

-- SQLQuery_curseur_exemple2 --

/******************************************
* Comprendre les curseurs et son utilit�  *
*******************************************/
-- 

Use AdventureWorks2017

-- Nous allons travailler avec 2 tables
-- [Production].[Product]
-- [Production].[ProductInventory]

Select * from [Production].[Product] -- ProductID | Name | ProductNumber | ListPrice
Select * from [Production].[ProductInventory] -- ProductID | LocationId | Quantity

-- Mise en forme de ces tables.. je travaille avec des tables temporaires.

IF object_id ('tempdb.dbo.#temp1') is not null 
Drop table #temp1
Select ProductID, Name, ProductNumber, Color, ListPrice into #temp1 From [Production].[Product] Where ProductId like '7%' -- 94 lignes
Select * from #temp1 -- 10 lignes

Select * from [Production].[ProductInventory]


IF object_id ('tempdb.dbo.#temp2') is not null 
Drop table #temp2
Select ProductID, LocationId, Quantity into #temp2 from [Production].[ProductInventory] where ProductID like '7%'
Select * from #temp2

Select * from #temp1
Select * from #temp2

/* Voici mes 2 tables en dur :
tblProducts
tblProductSales

*/
Drop table tbl_Products
Select top (10) * into tbl_Products From #temp1  -- Prendre que les 10 premiers enregistrements

Drop table tbl_ProductSales
Select top (10) * into tbl_ProductSales From #temp2  --

Select  * from tbl_Products
Select  * from tbl_ProductSales


/*
-- Jointure entre les 2 tables
-- Je souhaite ici avoir le nom du produit associ� � sa quantit� de production -> table #temp3
*/

-- ProductId | Name | ProductNumber | ListPrice | Quantity
IF object_id ('tempdb.dbo.#temp3') is not null 
Drop table #temp3
Select P.ProductId, P.Name, P.ProductNumber,  P.ListPrice, S.Quantity
INTO #temp3 FROM tbl_Products P
JOIN tbl_ProductSales S on P.ProductID = S.ProductID
Where (P.Name = 'HL Road Frame - Red, 58' OR               -- ProductNumber
P.Name = 'Sport-100 Helmet, Red' OR P.Name = 'Sport-100 Helmet, Black')

Select * from #temp3 -- R�sultat de la jointure
-- Si on voulait modifier la quantit� de tel ou tel produit en fonction du ProductId, on le ferait via une jointure
-- Mais on peut aussi travailler avec un Curseur qui va lire les enregistrements d'une premi�re table (tbl_Products)
-- et modifier la seconde (tbl_ProductSales) en tenant compte des crit�res



/*****************************************
  1er Cr�ation d'un curseur
  Lecture des enregistrements de la table
********************************************/
Declare @ProductID int
Declare @Name nvarchar(30)

Declare ProductCursor Cursor FOR
Select ProductID, Name from tbl_Products ---Where ProductID like '7%'
Open ProductCursor
WHILE (@@FETCH_STATUS = 0)  -- Tant que je ne suis pas � la fin > on boucle
		BEGIN
		Print 'Id ' + cast(@ProductID as nvarchar(30)) + ' Nom : ' + @Name
		Fetch Next from ProductCursor into @ProductID, @Name
				END
CLOSE ProductCursor
DEALLOCATE ProductCursor
-- En fait, le code de ci-dessus ne fait que lister les donn�es de la table 

Select * from #temp3  -- Name  |   ProductNumber   |   ListPrice   |  Quantity  


/******************************************************************************************************
* Cr�ation du second curseur
  L'id�e, c'est de remplacer la jointure : 
  Je vais lire chaque enregistrement de la premi�re table et modifier la seconde suivant certains crit�res
  en m�me temps, c'est l'atout m�me de l'utilit� d'un curseur

-- Admettons maintenant que je souhaite mettre � jour aussi la table ProductSales en  
-- en modifiant la valeur de la quantit� 
-- Si j'ai affaire � un ProductId 707 (ou � son ProductNumber) => j'ajoute la valeur de 10 au champ quantit�
-- 708 -> "quantity" est augment� de 20 unit�s
-- 709 -> "quantity" est augment� de 10 unit�s, etc.
   Ces op�rations de mise � jour auraient pu �tre faites via une jointure et des tables temporaires.
   �a prend du temps en termes de code SQL !
   Alors qu'ici, les op�rations se font au fur et � mesure de la lecture des donn�es !
*/

GO
DROP Table tbl_Products1
Select * into  tbl_Products1 From  tbl_Products
Select * from  tbl_Products1
Select * from tbl_ProductSales 

Declare @ProductID1 int,
        @Name1 nvarchar(30),
        @ProductNombre1 nvarchar(25),
		@Quantity1 smallint;
Declare testcurseur Cursor FOR
  ( Select ProductID,ProductNumber from tbl_Products1 )  
Open testcurseur
PRINT 'Mise � jour de la table tlb_ProductSales en parcourant ligne par ligne la table tbl_Product'
PRINT '-------------------------------------------------------------------------------------------'
FETCH Next From testcurseur INTO @ProductID1, @ProductNombre1  -- On se positionne ligne par ligne, la premi�re ici !
PRINT 'Numero de depart: ' + cast (@ProductID1 as nvarchar(10))
WHILE (@@FETCH_STATUS = 0)  -- Tant que je ne suis pas � la fin > on boucle
		BEGIN  -- Begin 1
		--Print 'Id ' + cast(@ProductID as nvarchar(30)) + ' Nom : ' + @Name
		Print 'je suis dans le curseur'
		PRINT 'Numero dans le curseur : ' + cast (@ProductID1 as nvarchar(10))
		Print ' '
		IF ( @ProductNombre1 = 'FR-R92R-58' )   --- 
         BEGIN
		 Select ProductID, Quantity from tbl_ProductSales WHERE ProductID = @ProductID1 
         UPDATE tbl_ProductSales SET Quantity = 298 WHERE ProductID = @ProductID1  -- Mise  jour de la table tbl_ProductSales
         END
        ELSE IF ( @ProductNombre1 = 'SO-B909-M' )   --- 709
         BEGIN
		 Select ProductID, Quantity from tbl_ProductSales WHERE ProductID = @ProductID1 
         UPDATE tbl_ProductSales SET Quantity = 190 WHERE ProductID = @ProductID1  -- Mise  jour de la table tbl_ProductSales
         
		END

Fetch Next from testcurseur into @ProductID1, @ProductNombre1
	END   -- Fin du Begin 1
CLOSE testcurseur
DEALLOCATE testcurseur


-- Et voil� la mise � jour de la table tbl_ProductSales
-- Ici, seul le << ProductId = 790 >> a �t� mis � jour.
-- Sa quantit� est pass�e de la valeur de 180 � 190.
Select * from tbl_ProductSales   