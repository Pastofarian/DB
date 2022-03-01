--04-02-2022 

USE AdventureWorks2017
SELECT * FROM [Production].[Product]
SELECT * FROM [Production].[ProductInventory]

/* jointure:
production.Product :
[Produ]
*/
IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1

SELECT P.ProductID, P.Name [Nom], P.ProductNumber, P.SafetyStockLevel, P.ReorderPoint, -- [] ou as pour renommer
I.Quantity, I.ModifiedDate
INTO #temp1 
FROM [Production].[Product] AS P 
JOIN [Production].[ProductInventory] AS I 
ON P.productID = I.ProductID

SELECT * FROM #temp1 -- 1070 lignes

--------------------------------------------------


IF OBJECT_ID('tempdb.#temp2') is not NULL
DROP table #temp2
select ProductID, Nom [Nom_du_produit], ProductNumber,
Quantity into #temp2 from #temp1

select * from #temp2

-- On va regrouper les produits -> Group By ?
-- https microsoft sum-transact-sql
-- drop table #temp3

-----------------------------------------------------------

IF OBJECT_ID('tempdb.#temp3') is not NULL
DROP TABLE #temp3
SELECT ProductID, [Nom_du_produit], ProductNumber,
-- count (Quantity) [quantite_totale]
SUM (Quantity) [quantite_totale] INTO #temp3 FROM #temp2
GROUP BY ProductID, [Nom_du_produit], ProductNumber

SELECT * FROM #temp2
SELECT * FROM #temp3

----------------------------------------------------------

USE AdventureWorks2017
GO

-- SELECT * FROM [HumanResources].[Employee]

IF OBJECT_ID('tempdb.#temp1') is not NULL
DROP table #temp1

IF OBJECT_ID('tempdb.#temp2') is not NULL
DROP table #temp2

IF OBJECT_ID('tempdb.#temp3') is not NULL
DROP table #temp3

SELECT NationalIDNumber, BirthDate
INTO #temp1 
FROM [HumanResources].[Employee] 

SELECT TOP 1 (BirthDate) AS DateDeNaissance_min, NationalIDNumber
INTO #temp2
FROM #temp1
GROUP BY BirthDate, NationalIDNumber
ORDER BY Birthdate ASC

Select * FROM #temp2

SELECT TOP 1 (BirthDate) AS DateDeNaissance_max, NationalIDNumber
INTO #temp3
FROM #temp1
GROUP BY BirthDate, NationalIDNumber
ORDER BY Birthdate DESC

SELECT * FROM #temp3


