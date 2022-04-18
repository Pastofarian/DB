/*
     --  CASE EXPRESSION  -- 
*/

USE AdventureWorks2017;  
GO 
-- A. Using a SELECT statement with a simple CASE expression ====> CASE WHEN
Drop table #temp100

SELECT * INTO #temp100 FROM Production.Product 
SELECT * FROM #temp100 where ProductLine is NULL  -- 226 lignes

DROP TABLE #temp200  
SELECT   ProductNumber, Category =  
      CASE ProductLine  
         WHEN 'R' THEN 'Road'  
         WHEN 'M' THEN 'Mountain'  
         WHEN 'T' THEN 'Touring'  
         WHEN 'S' THEN 'Other sale items'  
		 ELSE 'Not for sale'          -- NULL => ça se joue au niveau du ELSE
      END,  
   Name  
INTO #temp200 FROM #temp100 --Production.Product  
ORDER BY ProductNumber;  
GO  



-- B. Using a SELECT statement with a searched CASE expression  ===> CASE WHEN THEN
USE AdventureWorks2017;  
GO  
SELECT * FROM Production.Product  
IF object_id('tempdb.dbo.#temp2') is not null 
DROP TABLE #temp2
SELECT * INTO #temp2 FROM Production.Product  
SELECT ProductNumber,Name,ListPrice FROM #temp2

IF object_id('tempdb.dbo.#temp3') is not null 
DROP TABLE #temp3
SELECT   ProductNumber, Name,  "Slot des prix" =   
      --CASE   
        CASE ListPrice
		 --WHEN ListPrice =  0 THEN 'Interdit à la revente'  
		 WHEN  0 THEN 'Interdit à la revente'  
         --WHEN ListPrice < 50 THEN 'En dessous des 50 €'  
         --WHEN ListPrice >= 50 and ListPrice < 250 THEN 'En dessous des 250 €'  
         --WHEN ListPrice >= 250 and ListPrice < 1000 THEN 'En dessous des 1000 €'  
         ELSE 'Au dessus des 1000 €'  
      END  
INTO #temp3 FROM Production.Product  
ORDER BY ProductNumber ;  
GO  
SELECT * FROM #temp3

-- C. Using CASE in an ORDER BY clause
/*
SELECT * FROM HumanResources.Employee where SalariedFlag = 0 ;
SELECT BusinessEntityID, SalariedFlag  
FROM HumanResources.Employee  
ORDER BY 
      CASE SalariedFlag WHEN 1 THEN BusinessEntityID END DESC,  
      CASE WHEN SalariedFlag = 0 THEN BusinessEntityID END;  
GO
*/

SELECT * FROM Sales.vSalesPerson  
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName  
FROM Sales.vSalesPerson  
WHERE TerritoryName IS NOT NULL  
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END;

-- D. Using CASE in an UPDATE statement
USE AdventureWorks2017;  
GO  
UPDATE HumanResources.Employee  
SET VacationHours =   
    ( CASE  
         WHEN ((VacationHours - 10.00) < 0) THEN VacationHours + 40  
         ELSE (VacationHours + 20.00)  
       END  
    )  
OUTPUT Deleted.BusinessEntityID, Deleted.VacationHours AS BeforeValue,   
       Inserted.VacationHours AS AfterValue  
WHERE SalariedFlag = 0;



-- E. Using CASE in a SET statement

USE AdventureWorks2012;  
GO  
CREATE FUNCTION dbo.GetContactInformation(@BusinessEntityID int)  
    RETURNS @retContactInformation TABLE   
(  
BusinessEntityID int NOT NULL,  
FirstName nvarchar(50) NULL,  
LastName nvarchar(50) NULL,  
ContactType nvarchar(50) NULL,  
    PRIMARY KEY CLUSTERED (BusinessEntityID ASC)  
)   
AS   
-- Returns the first name, last name and contact type for the specified contact.  
BEGIN  
    DECLARE   
        @FirstName nvarchar(50),   
        @LastName nvarchar(50),   
        @ContactType nvarchar(50);  
  
    -- Get common contact information  
    SELECT   
        @BusinessEntityID = BusinessEntityID,   
@FirstName = FirstName,   
        @LastName = LastName  
    FROM Person.Person   
    WHERE BusinessEntityID = @BusinessEntityID;  
  
    SET @ContactType =   
        CASE   
            -- Check for employee  
            WHEN EXISTS(SELECT * FROM HumanResources.Employee AS e   
                WHERE e.BusinessEntityID = @BusinessEntityID)   
                THEN 'Employee'  
  
            -- Check for vendor  
            WHEN EXISTS(SELECT * FROM Person.BusinessEntityContact AS bec  
                WHERE bec.BusinessEntityID = @BusinessEntityID)   
                THEN 'Vendor'  
  
            -- Check for store  
            WHEN EXISTS(SELECT * FROM Purchasing.Vendor AS v            
                WHERE v.BusinessEntityID = @BusinessEntityID)   
                THEN 'Store Contact'  
  
            -- Check for individual consumer  
            WHEN EXISTS(SELECT * FROM Sales.Customer AS c   
                WHERE c.PersonID = @BusinessEntityID)   
                THEN 'Consumer'  
        END;  
  
    -- Return the information to the caller  
    IF @BusinessEntityID IS NOT NULL   
    BEGIN  
        INSERT @retContactInformation  
        SELECT @BusinessEntityID, @FirstName, @LastName, @ContactType;  
    END;  
  
    RETURN;  
END;  
GO  
  
SELECT BusinessEntityID, FirstName, LastName, ContactType  
FROM dbo.GetContactInformation(2200);  
GO  
SELECT BusinessEntityID, FirstName, LastName, ContactType  
FROM dbo.GetContactInformation(5);

-- F. Using CASE in a HAVING clause

USE AdventureWorks2017;  
GO  
SELECT JobTitle, MAX(ph1.Rate)AS MaximumRate  
FROM HumanResources.Employee AS e  
JOIN HumanResources.EmployeePayHistory AS ph1 ON e.BusinessEntityID = ph1.BusinessEntityID  
GROUP BY JobTitle  
HAVING (MAX(CASE WHEN Gender = 'M'   
        THEN ph1.Rate   
        ELSE NULL END) > 40.00  
     OR MAX(CASE WHEN Gender  = 'F'   
        THEN ph1.Rate    
        ELSE NULL END) > 42.00)  
ORDER BY MaximumRate DESC;








