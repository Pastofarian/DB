
/*************************************************************************************************************************************************************
* Programme �  réaliser : Mise en pratique de la notion de table temporaire et pratique du SQL Microsoft

   On travaillera avec les tables :
    * [Production].[Product]  de la base de données AdventureWorks2017
    * [Production].[ProductInventory]
   Les jointures entre ces 2 tables se retrouvent sur : http://axway.cluster013.ovh.net/ifosup_5IBD2B/db/download/AdventureWorks2008.gif
A vous de trouver les clefs qui les lient.

On souhaite avoir comme résultat final le nombre de produit total qui existe dans cet inventaire 
(produitID)
Ce résultat sera sauvée dans un vrai nouvelle table en dur [dbo].[Inventory]
Cette table finale en dur devra ressembler �  ceci :
A savoir:

 ProductID  | Nom_du_produit | ProductNumber  |  quantite_totale

On vérifiera qu'il n'y a pas de doublon dans la table.
Veuillez utiliser une série de tables temporaires �  chacune de vos étapes.


(1) Pour vérifier la présence d'un doublon :
https://support.microsoft.com/fr-be/help/139444/how-to-remove-duplicate-rows-from-a-table-in-sql-server

(2) A la lecture de la table, on remarquera qu'il conviendra de les regrouper
Utilisation d'un GROUP BY.

(3) SUM (Transact-SQL) : https://docs.microsoft.com/en-us/sql/t-sql/functions/sum-transact-sql?view=sql-server-ver15

(c) MB - Ifosupwavre - Bon travail

***********************************************************************************************************************************************************/


USE AdventureWorks2017
select * from [Production].[Product]
select * from [Production].[ProductInventory]

/* -- jointure : 
Production.Product : 
ProductID, Name, ProductNumber, SafetyStockLevel, ReorderPoint
[Production].[ProductInventory] -> ProductID, Quantity
*/

IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

select P.ProductID, P.Name [Nom], P.ProductNumber, P.SafetyStockLevel, P.ReorderPoint,
I.Quantity, I.ModifiedDate
into #temp1 from [Production].[Product] as P join 
[Production].[ProductInventory] as I on P.ProductID = I.productID
 select * from #temp1  -- 1070 lignes


IF Object_Id('tempdb.#temp2') is not null
DROP table #temp2
 select ProductID, Nom [Nom_du_produit], ProductNumber, 
Quantity into #temp2 from #temp1 

select * from #temp2

-- On va regrouper les produits -> Group By ?
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/sum-transact-sql?view=sql-server-ver15
---drop table #temp3

IF Object_Id('tempdb.#temp3') is not null
DROP table #temp3
select ProductID, [Nom_du_produit], ProductNumber, 
--count (Quantity) [quantite_totale] 
SUM (Quantity) [quantite_totale] into #temp3 from #temp2
group by ProductID, [Nom_du_produit], ProductNumber

select * from #temp2
select * from #temp3 -- OK 432 lignes
/*
Nous avons donc la table suivante :
ProductID | Nom_du_produit | ProductNumber | quantite_totale
*/
-- Je vais cr�er une table en dur pour y placer les donn�es de la table temporaire


/*****************************************************
-- Y-a-t-il encore des doublons ? -rev�rification
******************************************************/
---Url : https://support.microsoft.com/fr-be/help/139444/how-to-remove-duplicate-rows-from-a-table-in-sql-server
-- Je v�rifie que s'il y a des doublons dans la table temp3


IF Object_Id('tempdb.#temp_reverif_doublon') is not null
DROP table #temp_reverif_doublon

SELECT COUNT(productNumber) AS nbr_doublon, ProductNumber    -- Recherche des doublons
into #temp_reverif_doublon FROM #temp3
GROUP BY productNumber
HAVING   COUNT(productNumber) > 1  
select * from #temp_reverif_doublon  -- ok pas de donn�es dans la table et donc pas de doublon
                                     -- dans celle-ci OK
-- Je vais tester en y ajoutant un produit et v�rifier que les doublons fonctionnent correctement

IF Object_Id('tempdb.#temp4') is not null
DROP table #temp4
select * into #temp4 from #temp3 
select * from #temp4 -- 432 lignes

-- Ajout d'une donn�e dans une table temporaire oui...on peut !
-- Exemple...je prends le premier ProductID
INSERT #temp4 (ProductID, [Nom_du_produit], ProductNumber, [quantite_totale])
    VALUES ('1000','Adjustable Race', 'AR-5381', '1000') -- 1 row affected

IF Object_Id('tempdb.#temp5') is not null
DROP table #temp5
select * into #temp5 from #temp4
select * from #temp5


-- Rev�rification du doublon
--DROP TABLE #temp_reverif_doublon1
IF Object_Id('tempdb.#temp_reverif_doublon') is not null
DROP table #temp_reverif_doublon
SELECT COUNT(productNumber) AS nbr_doublon, ProductNumber    -- Recherche des doublons
into #temp_reverif_doublon1 FROM #temp5
GROUP BY productNumber
HAVING   COUNT(productNumber) > 1  
select * from #temp_reverif_doublon1   --  2 pour AR-5381


-- Je repars de la table  #temp3 -> A placer comme table #temp_final

IF Object_Id('tempdb.#temp_final') is not null
DROP table #temp_final
select * into #temp_final from #temp3
select * from #temp_final  --- 432 lignes sans doublon


-- Test existence d'une table

IF EXISTS (SELECT * FROM [AdventureWorks2017].sys.tables WHERE name = 'Inventory')
DROP TABLE dbo.[Inventory]
GO
CREATE TABLE [dbo].[Inventory](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Nom_du_produit] [nvarchar](25) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[quantite_totale] [int] NOT NULL
) ON [PRIMARY]
GO


SELECT * FROM #temp_final
SELECT * FROM [dbo].Inventory

-- Avant de faire un < SELECT into >, il convient de refaire � nouveau un DROP TABLE dbo.Inventory
-- Sinon sans le DROP TABLE, cela recr�e la m�me structure => d'o� l'erreur !!!!
--
DROP TABLE dbo.Inventory
SELECT * into dbo.Inventory from #temp_final
SELECT * from dbo.Inventory -- 432 lignes

