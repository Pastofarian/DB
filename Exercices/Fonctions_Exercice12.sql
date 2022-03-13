/*Fonctions sous MSQL
+++++++++++++++++++

Ecrire une fonction pour la DB [AdventureWorks2017] :
 -> que l'on déclarera (nom de celle-ci)

En se basant sur l'exercice théorique vu au cours : http://axway.cluster013.ovh.net/ifosup/db/download/Les%20fonctions_SQL_MB.pdf
La fonction permet de calculer la différence (en nombre de jour) entre la date système (getdate) et celle d'une date.
Pour ce laboratoire, cette différence sera celle de la date système et celle de la date de naissance de la table [HumanResources].[Employee].

Nous travaillerons avec des tables temporaires.

La table temporaire finale doit reprendre les champs suivants :
 ------------------------------------------------------------------------------------------------------
| BusinessEntityID | NationalIDNumber | JobTitle | BirthDate  |  difference  | MaritalStatus | Gender  |
 ----------------------------------------------------------------------------------------------------  |
 

Sources utiles :
 # https://docs.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-2017
 # https://docs.microsoft.com/fr-fr/sql/t-sql/statements/create-function-transact-sql?view=sql-server-2017
 # https://docs.microsoft.com/en-us/sql/t-sql/functions/getdate-transact-sql?view=sql-server-2017

(c) MB - Ifosupwavre*/

/***************************OK*/

USE AdventureWorks2017
GO

--SELECT * FROM [HumanResources].[Employee]

IF Object_Id('tempdb.#temp1') IS NOT NULL
DROP TABLE #temp1

DROP FUNCTION IF EXISTS EcartJour
GO

CREATE FUNCTION EcartJour()
RETURNS TABLE
AS
RETURN
(SELECT H.BusinessEntityID, H.NationalIDNumber, H.JobTitle, H.BirthDate, DATEDIFF ( DAY , BirthDate , GETDATE() ) AS Difference,
H.MaritalStatus, H.Gender
FROM [HumanResources].[Employee] as H);
GO

SELECT * INTO #temp1 FROM EcartJour();
SELECT * FROM #temp1
