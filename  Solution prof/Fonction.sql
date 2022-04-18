
/*******************************/
/* Etude de la fonction en SQL */
/******************************/

USE AdventureWorks2017

/*
Test de l'existence d’une fonction SQL Server avant de la supprimer?
Pour éviter cette erreur, il suffit d’ajouter une commande pour tester 
 l’existence de la fonction au préalable.
*/
GO
   IF OBJECT_ID (N'dbo.IFOSUP_EcartJour', N'FN') IS NOT NULL  
   DROP FUNCTION dbo.IFOSUP_EcartJour;  
GO


-- Création de la fonction
CREATE FUNCTION dbo.IFOSUP_EcartJour  -- Nom de la fonction
(@date1 datetime, @date2 datetime) -- paramètres
returns int
AS begin
return abs(datediff(day,@date1,@date2))  -- la différence entre 2 dates, je souhaite que la valeur absolue car datetime !
end

SELECT dbo.IFOSUP_EcartJour ('2019-6-4',getdate()) as difference



/*************************************************************

Fonctions sous MSQL
+++++++++++++++++++

Ecrire une fonction pour la DB [AdventureWorks2017] :
 -> que l'on déclarera (nom de celle-ci)

En se basant sur l'exercice théorique vu au cours : 
http://axway.cluster013.ovh.net/ifosup/db/download/Les%20fonctions_SQL_MB.pdf
La fonction permet de calculer la différence (en nombre de jour) entre la date système (getdate) et celle d'une date.
Pour ce laboratoire, cette différence sera celle de la date système et celle de la date de naissance de la table [HumanResources].[Employee].

Nous travaillerons avec des tables temporaires.

La table temporaire finale doit reprendre les champs suivants :
 ------------------------------------------------------------------------------------------------------
| BusinessEntityID | NationalIDNumber | JobTitle | BirthDate  |  difference  | MaritalStatus | Gender  |
 ----------------------------------------------------------------------------------------------------  |
 
***************************************************/


USE AdventureWorks2017
--SELECT * FROM [HumanResources].[Employee]  --
drop table #temp1
SELECT BusinessEntityID, NationalIDNumber,JobTitle,BirthDate,[MaritalStatus],
      	[Gender] into #temp1 FROM [HumanResources].[Employee]
SELECT * FROM #temp1

--en ajoutant une colonnne à la table temporaire 'Difference'
drop table #temp2
SELECT BusinessEntityID, NationalIDNumber,JobTitle,BirthDate,
       [dbo].[IFOSUP_EcartJour] ([BirthDate], getdate()) as difference,
       [MaritalStatus],
       [Gender] into #temp2 FROM #temp1
		
SELECT * FROM #temp2
