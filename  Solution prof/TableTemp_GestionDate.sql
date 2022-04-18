
/*************************************************************************************************************
* Programme à réaliser : rechercher de la date la plus récente dans la table [HumanResources].[Employee]
*   de la base de données AdventureWorks2017
*   On souhaite avoir comme résultat la date de naissance la plus récente et de la plus éloignée
*   Ce résultat devra reprendre les champs suivants : NationalIDNumber, date_naissance (anciennement BirthDay)
*   La recherche de ces 2 dates doivent se retrouver dans une et une seule table finale
*   Nous travaillerons avec les tables temporaires
*
* (c) MB - Ifosupwavre
**************************************************************************************************************/

USE AdventureWorks2017
declare @dt_sel date
SELECT * FROM  [HumanResources].[Employee]

-- Copie de la table vers une table temporaire.
-- (1) Cfr.documentation technique MSQL : https://docs.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database?view=sql-server-2017 
-- (2) Cfr. https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017


IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1
--drop table #temp1
select * into #temp1 FROM [HumanResources].[Employee]
select * from #temp1 -- 290 lignes

declare @date_max datetime
select NationalIDNumber, Birthdate from #temp1
select NationalIDNumber, cast (convert(varchar(20),birthdate,112) as INT) date_naissance from #temp1
select * from #temp1

-- A placer dans la nouvelle table
IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2
--drop table #temp2
select NationalIDNumber, cast (convert(varchar(20),birthdate,112) as INT) date_naissance into #temp2 from #temp1
select * from #temp2  -- j'ai mes dates converties mais en AAAAMMDD

IF object_id('tempdb.dbo.#temp3') is not null drop table #temp3
--drop table #temp3      -- date la plus récente
declare @dt_recente integer 
select NationalIDNumber, date_naissance into #temp3 from #temp2
where date_naissance in (select max(date_naissance) from #temp2);
select * from #temp3  -- j'ai mes dates converties mais en AAAAMMDD

-- Vérification :
select * from #temp2  where NationalIDNumber = 563680513

IF object_id('tempdb.dbo.#temp4') is not null drop table #temp4
--drop table #temp4  --  date la plus petite
select NationalIDNumber, date_naissance into #temp4 from #temp2
where date_naissance in (select min(date_naissance) from #temp2);
select * from #temp4

--
select * from #temp3  -- date MAX
select * from #temp4  -- date Min

-- UNION ALL
IF object_id('tempdb.dbo.#temp-finalMB') is not null drop table #temp_finalMB
--drop table #temp_final
select *
into #temp_finalMB
from #temp4
UNION
select *
from #temp3

select * FROM #temp_finalMB

/* Convertir AAAAMMDD en JJ-MM-AAAA
Source : https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
ou 
-- https://database.guide/datetime-vs-smalldatetime-in-sql-server-whats-the-difference/
*/

--DROP table #temp_finalMB1
-----select NationalIDNumber, convert(nvarchar, getdate(), 105) Date_naissance into #temp_finalMB1 from #temp_finalMB

--select NationalIDNumber, convert(nvarchar(30), Date_naissance, 102) AS Date_naissance1 into #temp_finalMB1 from #temp_finalMB
--select * from #temp_finalMB1


/* Conversion de date */
-- Impossible de caster de INT en DATE date -> il faut passer par un VAR ! 
-- Ce fera en plusieur temps !!
-- Cfr. https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15 
-- Explicit conversion INT
DROP table #temp_finalMB2  -- 1
Select NationalIDNumber, cast([Date_naissance] as varchar(20)) as new_date into #temp_finalMB2 FROM #temp_finalMB
Select * from #temp_finalMB2


DROP table #temp_finalMB3  -- 2
Select NationalIDNumber, cast([New_date] as DATE) as new_date1 into #temp_finalMB3 FROM #temp_finalMB2
Select * from #temp_finalMB3

DROP table #temp_finalMB4  --3  -- https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

select NationalIDNumber, convert(nvarchar, new_date1, 103) AS new_date2 into #temp_finalMB4 from #temp_finalMB3
select * from #temp_finalMB4

---  FIN DU CODE --- 





/*************************************************************************************************************************************************************
* Programme Ã  rÃ©aliser : Mise en pratique de la notion de table temporaire et pratique du SQL Microsoft

   On travaillera avec les tables :
    * [Production].[Product]  de la base de donnÃ©es AdventureWorks2017
    * [Production].[ProductInventory]
   Les jointures entre ces 2 tables se retrouvent sur : http://axway.cluster013.ovh.net/ifosup_5IBD2B/db/download/AdventureWorks2008.gif
A vous de trouver les clefs qui les lient.

On souhaite avoir comme rÃ©sultat final le nombre de produit total qui existe dans cet inventaire 
(produitID)
Ce rÃ©sultat sera sauvÃ©e dans un vrai nouvelle table en dur [dbo].[Inventory]
Cette table finale en dur devra ressembler Ã  ceci :
A savoir:

 ProductID  | Nom_du_produit | ProductNumber  |  quantite_totale

On vÃ©rifiera qu'il n'y a pas de doublon dans la table.
Veuillez utiliser une sÃ©rie de tables temporaires Ã  chacune de vos Ã©tapes.


(1) Pour vÃ©rifier la prÃ©sence d'un doublon :
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
-- Je vais créer une table en dur pour y placer les données de la table temporaire


/*****************************************************
-- Y-a-t-il encore des doublons ? -revérification
******************************************************/
---Url : https://support.microsoft.com/fr-be/help/139444/how-to-remove-duplicate-rows-from-a-table-in-sql-server
-- Je vérifie que s'il y a des doublons dans la table temp3


IF Object_Id('tempdb.#temp_reverif_doublon') is not null
DROP table #temp_reverif_doublon

SELECT COUNT(productNumber) AS nbr_doublon, ProductNumber    -- Recherche des doublons
into #temp_reverif_doublon FROM #temp3
GROUP BY productNumber
HAVING   COUNT(productNumber) > 1  
select * from #temp_reverif_doublon  -- ok pas de données dans la table et donc pas de doublon
                                     -- dans celle-ci OK
-- Je vais tester en y ajoutant un produit et vérifier que les doublons fonctionnent correctement

IF Object_Id('tempdb.#temp4') is not null
DROP table #temp4
select * into #temp4 from #temp3 
select * from #temp4 -- 432 lignes

-- Ajout d'une donnée dans une table temporaire oui...on peut !
-- Exemple...je prends le premier ProductID
INSERT #temp4 (ProductID, [Nom_du_produit], ProductNumber, [quantite_totale])
    VALUES ('1000','Adjustable Race', 'AR-5381', '1000') -- 1 row affected

IF Object_Id('tempdb.#temp5') is not null
DROP table #temp5
select * into #temp5 from #temp4
select * from #temp5


-- Revérification du doublon
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

-- Avant de faire un < SELECT into >, il convient de refaire à nouveau un DROP TABLE dbo.Inventory
-- Sinon sans le DROP TABLE, cela recrée la même structure => d'où l'erreur !!!!
--
DROP TABLE dbo.Inventory
SELECT * into dbo.Inventory from #temp_final
SELECT * from dbo.Inventory -- 432 lignes

