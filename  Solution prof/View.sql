use [AdventureWorks2017]
GO  
CREATE VIEW [dbo].[View_Product_Inventory_2]
AS  
SELECT e.[ProductID], [Name], [ProductNumber], [SafetyStockLevel], [ReorderPoint], [ListPrice], [StandardCost],
		[ProductModelID], [ProductSubcategoryID], [SizeUnitMeasureCode], [Size], [LocationID], 
		[Quantity]
FROM [Production].[Product] AS e JOIN [Production].[ProductInventory] AS  p  
ON e.[ProductID] = p.[ProductID] ;   
GO  
-- Query the view  
SELECT [ProductID], [Name], [ProductNumber], [SafetyStockLevel], [ReorderPoint], [ListPrice], [StandardCost],
		[ProductModelID], [ProductSubcategoryID], [SizeUnitMeasureCode], [Size], [LocationID], 
		[Quantity] 
FROM [dbo].[View_Product_Inventory_2]
ORDER BY [Name];