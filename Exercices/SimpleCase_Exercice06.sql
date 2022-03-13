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
    Pour votre information, le lien (jointure) entre les 2 tables précédemment citées se retrouve au niveau des champs suivants : StateProvinceID <-------> StateProvinceID.
	
   Je souhaiterai que cette liste soit placée dans la table temporaire nommée #temp1 .

2) Quel le nombre d'adresse qui appartienne à telle ou telle région ?
   Autrement dit :  Lecture du nombre d'adresse ayant le même code de région
     Exemple : les adresses se trouvant dans l'état de Washinghton sont au nombre de 2.636, 16 pour l'état de New-York.

3) Quel le nombre total des adresses sur la cote ouest (West Coast) ? 

(c) MB - Ifosupwavre

**********************************/ OK

/*SIMPLE CASE*/

USE AdventureWorks2017
GO

--IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

SELECT AddressID, AddressLine1, City, Name, -- (ou on place Region ici à la place de le mettre à côté de END)
CASE StateProvinceCode
    WHEN 'WA'THEN 'West Coast'
    WHEN 'OR'THEN 'West Coast'
    WHEN 'CA'THEN 'West Coast'
    ELSE 'Elsewhere'
END AS Region   
INTO #temp1
FROM Person.StateProvince
INNER JOIN Person.Address
ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
WHERE CountryRegionCode = 'US'
ORDER BY Region

SELECT * FROM #temp1
GO

--SELECT * FROM [Person].[Address]
--SELECT * FROM [Person].[StateProvince]

SELECT COUNT(AddressID) AS NbrTotalAdresses, Name, Region
FROM #temp1
GROUP BY Name, Region
ORDER BY Region
GO

SELECT COALESCE(Region, 'Total'), COUNT(AddressID) AS NbrTotalAdresses, Name, Region
FROM #temp1
WHERE REGION = 'West Coast'
GROUP BY ROLLUP(Region, Name)
