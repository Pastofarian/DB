   ----------------------------
-- SQL_declaration_variable.sql --
   ----------------------------

/********************************** 
 -- DECLARATION DES VARIABLES -- 
    Et de leurs utilisations
	 au sein d'une requête SQL	
***********************************/
-- Première façon de faire
GO 
USE AdventureWorks2017; 

DECLARE @empname AS NVARCHAR(31); 
SET @empname = (SELECT firstname + N' ' + lastname FROM [Person].[Person] WHERE BusinessEntityID = 3); 
SELECT @empname AS empname;
SELECT * FROM [Person].[Person] 
PRINT @empname  -- pour l'affichage au niveau des Messages
GO
-- Deuxième façon de déclarer et de travailler avec ces variables
GO 
DECLARE @firstname AS NVARCHAR(10), @lastname AS NVARCHAR(20);
SET @firstname = (SELECT firstname 
                  FROM [Person].[Person]   
				  WHERE BusinessEntityID  = 3); 
SET @lastname = (SELECT lastname  
                 FROM [Person].[Person] 
			     WHERE BusinessEntityID  = 3);
SELECT @firstname AS firstname, @lastname AS lastname;

GO
-- Troisième façon de les déclarer
GO
DECLARE @firstname AS NVARCHAR(10), 
         @lastname AS NVARCHAR(20);
SELECT  @firstname = firstname,   @lastname  = lastname FROM [Person].[Person] WHERE BusinessEntityID = 3;
SELECT @firstname AS firstname, @lastname AS lastname;
GO

/****************************************************************************************************************************************************
* 1. Ecrire un petit programme qui liste l'ensemble des personnes ayant un mail de la DB AdventureWorks2017.
*    Nous souhaiterons avoir les données suivantes (champs à renommer): 
*     Nom (FirstName), Prénom (LastName), BusinessEntityID et (Adresse mail) EmailAddress.
*    ...et ce dans une table temporaire #temp2
*    On utilisera aussi une table temporaire @temp1 
* 
* 2. Déclarer 3 variables type firstname, lastname, Email
*    Ces 3 variables doivent reprendre comme contenu les données Prénom, Nom, Adresse mail où BusinessEntityID est égale à 295 de la table #temp2
*    Afficher le contenu de ces variables via un SELECT
* 
*****************************************************************************************************************************************************/
-- Jointure en utilisant les variables comme données finales
USE AdventureWorks2017
SELECT * FROM [Person].[Person]  -- 19.972 lignes -> Ils ont tous un email.
SELECT * FROM [Person].[EmailAddress]  -- 19.972 lignes

-- Rassembler les 2 tables via une jointure INNER
DROP TABLE #temp1
SELECT P1.FirstName, P1.LastName,P2.BusinessEntityID,P2.EmailAddress
into #temp1 FROM  [Person].[Person] P1 
inner join [Person].[EmailAddress]  P2 ON P1.[BusinessEntityID] = P2.BusinessEntityID
order by LastName

DROP TABLE #temp2
SELECT firstname Prénom, lastname Nom, [BusinessEntityID], EmailAddress [Adresse mail]
 INTO #temp2 FROM #temp1 
 SELECT * FROM #temp2
SELECT * FROM #temp2 where Prénom in ('Kim')
GO
GO
DECLARE  @firstname AS NVARCHAR(10), 
         @lastname AS NVARCHAR(20),
		 @Email AS NVARCHAR(255);
SELECT  @firstname = Prénom,   @lastname  = Nom,  
        @Email = [Adresse mail] FROM #temp2 WHERE BusinessEntityID = 295;
SELECT @firstname AS Prénom, @lastname AS Nom, @Email AS [Adresse mail];


