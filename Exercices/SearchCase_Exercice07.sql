

/*********************************************

Programmer la requête suivante en utilisant les expressions syntaxiques suivantes : 
 En se basant sur la directive Searched Case Expression
  CASE WHEN
   END
Source : https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-2017
A partir des tables [Person].[Address] et [Person].[StateProvince] de la base de données AdventureWorks2017

On souhaite lister à nouveau :

1) - Les adresses qui sont dans la région de la cote Ouest "West Coast" des Etats-Unis.
     La région dite de "West Coast" est celle où le champ de StateProvindeCode prend les valeurs suivantes : 
        * Etat de Washinghton 'WA' 
   * Etat d'Oregon 'OR'
   * Etat de Calfornie 'CA'
     Pour votre information, le lien (jointure) entre les 2 tables précédemment citées se retrouve au niveau des champs suivants :          StateProvinceID <-------> StateProvinceID.

   On tiendra compte aussi des autres régions cette fois-ci.
   - Pour les Etats du Pacific, leurs codes sont : 'Hi' pour Hawaï, 'AK' pour Alaska.
   - Pour les Etats de la Nouvelle Angleterre dite "New England", leurs codes sont : 'CT', 'MA', 'ME', 'NH', 'RI', 'VT'.
   - Les autres états seront notés 'Elsewhere'.


   Je souhaiterai que cette liste soit placée dans la table temporaire nommée #temp1 .

2) Quel le nombre d'adresse qui appartienne à telle ou telle région ?
   Autrement dit :  Lecture du nombre d'adresse ayant le même code de région
   Exemple : les adresses se trouvant dans l'état de Washinghton sont au nombre de 2.636, 16 pour l'état de New-York.

3) Quel le nombre total des adresses sur les différentes régions (West Coast, Pacific, New England et Elsewhere) ? 

4) Comment se fait-il que l'on ne voie pas une des régions ci-mentionnés ci-dessus dans le résultat final ?

(c) MB - Ifosupwavre

**********************************/ Ok sauf point 4)

/*SEARCH CASE*/

USE AdventureWorks2017
GO

--IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

SELECT AddressID, AddressLine1, City, Name,
CASE 
    WHEN StateProvinceCode = 'WA' THEN 'West Coast'
    WHEN StateProvinceCode = 'OR' THEN 'West Coast'
    WHEN StateProvinceCode = 'CA' THEN 'West Coast'
    WHEN StateProvinceCode = 'AK' OR StateProvinceCode = 'HI' THEN 'Pacific'
    WHEN StateProvinceCode = 'CT' OR StateProvinceCode = 'MA' OR StateProvinceCode = 'ME' OR StateProvinceCode = 'NH' OR StateProvinceCode = 'RI' OR StateProvinceCode = 'VT' THEN 'New England'
    ELSE 'Elsewhere'
END AS Region   
INTO #temp1
FROM Person.StateProvince
INNER JOIN Person.Address
ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
WHERE CountryRegionCode = 'US'
ORDER BY Region
GO

SELECT * FROM #temp1
ORDER BY Region DESC
GO

--SELECT * FROM [Person].[Address]
--SELECT * FROM [Person].[StateProvince]

SELECT COUNT(AddressID) AS NbrTotalAdresses, Name, Region
FROM #temp1
GROUP BY Name, Region
ORDER BY Region DESC
GO

SELECT COALESCE(Name, 'Total'), COUNT(AddressID) AS NbrTotalAdresses, Name, Region
FROM #temp1

GROUP BY ROLLUP(Region, Name)

-- 4) Comment se fait-il que l'on ne voie pas une des régions ci-mentionnés ci-dessus dans le résultat final ?
/* Aucune idée !!!!*/

/*********************************************