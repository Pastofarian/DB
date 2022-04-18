

/*********************************************

Programmer la requête suivante en utilisant les expressions syntaxiques suivantes : 
 CASE WHEN
  END
A partir des tables [Person].[Address] et [Person].[StateProvince] de la base de données AdventureWorks2017
On souhaite lister :
1) Les adresses qui ne sont pas dans la région de la cote Ouest des Etats-Unis, seront notés "Elsewhere".
   Les autres sont notés "West Coast"  c'est-à-dire où le champ de StateProvindeCode prend les valeurs suivantes : 
    * Etat de Washinghton 'WA' 
	* Etat d'Oregon 'OR'
	* Etat de Calfornie 'CA'
    Pour votre information, le lien (jointure) entre les 2 tables précédemment citées se retrouve au niveau des champs suivants : 
	StateProvinceID <-------> StateProvinceID.
	
	Je souhaiterais que cette liste soit placée dans la table temporaire nommée #temp1 .

2) Quel le nombre d'adresse qui appartienne à telle ou telle région ?
   Autrement dit :  Lecture du nombre d'adresse ayant le même code de région
     Exemple : les adresses se trouvant dans l'état de Washinghton sont au nombre de 2.636, 16 pour l'état de New-York.

3) Quel le nombre total des adresses du côté West Coast ? (et donc des autres adresses qui sont du côté "Elsewhere")

***********************************************/

USE AdventureWorks2017
SELECT * FROM [Person].[Address]  -- AddressID
SELECT * FROM [Person].[StateProvince] a

SELECT StateProvinceCode,
 CASE StateProvinceCode                       -- West coast considéré sont : Californie, Washington, Oregon
  WHEN 'CA' THEN 'West Coast'
  WHEN 'WA' THEN 'West Coast'
  WHEN 'OR' THEN 'West Coast'
ELSE 'Elsewhere'
END
FROM [Person].[StateProvince]  a  --Sales.CustomerAddress a
INNER JOIN Person.Address p
ON a.StateProvinceID= p.StateProvinceID


-- Si je travaille avec une table temporaire --
-- Listing des régions de la côte ouest des Etats-Unis
--DROP table #temp1
-- Pour éviter les erreurs type warning 
IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1
SELECT 
 CASE a.StateProvinceCode                       -- West coast considéré sont : Californie, Washington, Oregon
  WHEN 'CA' THEN 'West Coast'
  WHEN 'WA' THEN 'West Coast'
  WHEN 'OR' THEN 'West Coast'
ELSE 'Elsewhere'
END
[StateProvinceCode], a.[StateProvinceCode] as code_region, p.AddressID, P.AddressLine1
into #temp1
FROM [Person].[StateProvince]  a  ----Sales.CustomerAddress a
INNER JOIN Person.Address p
ON a.StateProvinceID= p.StateProvinceID
select * from #temp1 where StateProvinceCode <> 'Elsewhere'  -- 8.305 lignes
select * from #temp1 where code_region = 'WA'  -- 2.636 lignes

-- Remarque : en faisant que P.addressLine1, il n'affichera que la première adresse appartenant à telle ou telle région !

-- Quel le nombre d'adresse qui appartienne à telle ou telle région ?
-- Autrement dit :  Lecture du nombre d'adresse ayant le même code de région
-- Exemple : les adresses se trouvant dans l'état de Washinghton sont au nombre de 2.636
SELECT COUNT(StateProvinceCode) AS NumOfCustomers, code_region
FROM #temp1
GROUP BY StateProvinceCode, code_region;

-- Quel le nombre total des adresses du côté West Coast ? (et donc des autres adresses qui ne sont pas du côté "Elsewhere")
SELECT COUNT(StateProvinceCode) AS NumOfCustomers, StateProvinceCode
FROM #temp1
GROUP BY StateProvinceCode, StateProvinceCode

-----------Fin code -------------------------------------------------------

USE AdventureWorks2017

         SELECT * FROM [Person].[Address]   --where StateProvinceID = 2 -- AddressID
         SELECT * FROM [Person].[StateProvince] a

         SELECT * FROM [Person].[StateProvince] where StateProvinceCode = 'AK'

         -- Si je travaille avec une table temporaire --
         -- Listing des régions de la côte ouest des Etats-Unis
         --DROP table #temp1
         -- Pour éviter les erreurs type warning 
         IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2
         SELECT 
          CASE                      -- West coast considéré sont : Californie, Washington, Oregon
           WHEN a.StateProvinceCode IN ('CA','WA','OR') THEN 'West Coast'
           WHEN a.StateProvinceCode IN ('HI','AK') THEN 'Pacific'
           WHEN a.StateProvinceCode IN ('CT', 'MA', 'ME', 'NH', 'RI', 'VT') THEN 'New England'
           ELSE 'Elsewhere'
         END
         [StateProvinceCode], a.[StateProvinceCode] as code_region --, p.AddressID, P.AddressLine1
         into #temp2
         FROM [Person].[StateProvince]  a  ----Sales.CustomerAddress a
         INNER JOIN Person.Address p
         ON a.StateProvinceID= p.StateProvinceID
         SELECT * FROM #temp2

         SELECT * FROM #temp2 where StateProvinceCode  = 'Pacific'

         select * from #temp2 where StateProvinceCode <> 'Elsewhere'  -- 8.305 lignes
         select * from #temp2 where code_region = 'WA'  -- 2.636 lignes


         SELECT COUNT(StateProvinceCode) AS NumOfCustomers, code_region
         FROM #temp2
         GROUP BY StateProvinceCode, code_region;

         -- Quel le nombre total des adresses du côté West Coast ? (et donc des autres adresses qui ne sont pas du côté "Elsewhere")
         SELECT COUNT(StateProvinceCode) AS NumOfCustomers, StateProvinceCode
         FROM #temp2
         GROUP BY StateProvinceCode, StateProvinceCode

-------------Fin code -------------------------------------------------------------

/*
     --  CASE EXPRESSION  -- 
*/

USE AdventureWorks2017;  
GO 
-- A. Using a SELECT statement with a simple CASE expression ====> CASE WHEN
IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1

SELECT * INTO #temp1 FROM Production.Product 
SELECT * FROM #temp1 where ProductLine is NULL  -- 226 lignes

IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2
SELECT   ProductNumber, Category =  
      CASE ProductLine  
         WHEN 'R' THEN 'Road'  
         WHEN 'M' THEN 'Mountain'  
         WHEN 'T' THEN 'Touring'  
         WHEN 'S' THEN 'Other sale items'  
       ELSE 'Not for sale'          -- NULL => ça se joue au niveau du ELSE
      END,  
   Name  
INTO #temp2 FROM #temp1 --Production.Product  
ORDER BY ProductNumber;  
GO  
Select * from #temp2



-- B. Using a SELECT statement with a searched CASE expression  ===> CASE WHEN THEN
USE AdventureWorks2017;  
GO  
SELECT * FROM Production.Product  
IF object_id('tempdb.dbo.#temp3') is not null 
DROP TABLE #temp3
SELECT * INTO #temp3 FROM Production.Product  
SELECT ProductNumber,Name,ListPrice FROM #temp3

IF object_id('tempdb.dbo.#temp4') is not null 
DROP TABLE #temp4
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
INTO #temp4 FROM Production.Product  
ORDER BY ProductNumber ;  
GO  
SELECT * FROM #temp4

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

USE AdventureWorks2017;  
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








