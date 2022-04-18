   ----------------------------
-- SQL_declaration_variable.sql --
   ----------------------------

/********************************** 
 -- DECLARATION DES VARIABLES -- 
    Et de leurs utilisations
	 au sein d'une requ�te SQL	
***********************************/
-- Premi�re fa�on de faire
GO 
USE AdventureWorks2017; 

DECLARE @empname AS NVARCHAR(31); 
SET @empname = (SELECT firstname + N' ' + lastname FROM [Person].[Person] WHERE BusinessEntityID = 3); 
SELECT @empname AS empname;
SELECT * FROM [Person].[Person] 
PRINT @empname  -- pour l'affichage au niveau des Messages
GO
-- Deuxi�me fa�on de d�clarer et de travailler avec ces variables
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
-- Troisi�me fa�on de les d�clarer
GO
DECLARE @firstname AS NVARCHAR(10), 
         @lastname AS NVARCHAR(20);
SELECT  @firstname = firstname,   @lastname  = lastname FROM [Person].[Person] WHERE BusinessEntityID = 3;
SELECT @firstname AS firstname, @lastname AS lastname;
GO

/****************************************************************************************************************************************************
* 1. Ecrire un petit programme qui liste l'ensemble des personnes ayant un mail de la DB AdventureWorks2017.
*    Nous souhaiterons avoir les donn�es suivantes (champs � renommer): 
*     Nom (FirstName), Pr�nom (LastName), BusinessEntityID et (Adresse mail) EmailAddress.
*    ...et ce dans une table temporaire #temp2
*    On utilisera aussi une table temporaire @temp1 
* 
* 2. D�clarer 3 variables type firstname, lastname, Email
*    Ces 3 variables doivent reprendre comme contenu les donn�es Pr�nom, Nom, Adresse mail o� BusinessEntityID est �gale � 295 de la table #temp2
*    Afficher le contenu de ces variables via un SELECT
* 
*****************************************************************************************************************************************************/
-- Jointure en utilisant les variables comme donn�es finales
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
SELECT firstname Pr�nom, lastname Nom, [BusinessEntityID], EmailAddress [Adresse mail]
 INTO #temp2 FROM #temp1 
 SELECT * FROM #temp2
SELECT * FROM #temp2 where Pr�nom in ('Kim')
GO
GO
DECLARE  @firstname AS NVARCHAR(10), 
         @lastname AS NVARCHAR(20),
		 @Email AS NVARCHAR(255);
SELECT  @firstname = Pr�nom,   @lastname  = Nom,  
        @Email = [Adresse mail] FROM #temp2 WHERE BusinessEntityID = 295;
SELECT @firstname AS Pr�nom, @lastname AS Nom, @Email AS [Adresse mail];


-- Fin Code ----------------------------------------------------


/*
DECLARATION DES VARIABLES
--------------------------------------------
Les variables sont limit�es au lot d'ex�cution de la session en cours uniquement.
Cela concerne uniquement la session en cours.
*/

USE AdventureWorks2017
select * from [person].[Person] 
select * from [HumanResources].[Employee]
-- 1er fa�on de d�crire des variables

DROP table #temp1
select COUNT (BusinessEntityID) Nbr_ligne into #temp1 from [person].[Person]
select * from #temp1 -- 19.972 lignes


-- Plusieurs fa�on de d�clarer une variable
-- 1)
DECLARE @var1 INT;      -- D�claration litt�rale 
SET @var1 = 6           -- n�1 Assignation de la variable � une valeur 6 : SET
SET @var1 = @var1 + 1   -- On n'h�sitera pas faire
PRINT @var1
SELECT @var1
SELECT @var1 AS variable

-- n�2 Assignation : On peux aussi �toffer l'assignation comme suit :
-- SET se fait � partir d'un SELECT 

USE AdventureWorks2017
SELECT * FROM [person].[Person]
DECLARE @var2 INT
SET @var2 = ( select COUNT (BusinessEntityID) Nbr_ligne from [person].[Person] )
Print @var2
select @var2 AS variable


-- autre exemple :
select * from [HumanResources].[Employee]
DECLARE @var_date DATE
SELECT @var_date = MAX (c.BirthDate) FROM [HumanResources].[Employee] c
SELECT @var_date

-- SET se fait � partir d'une fonction 
SELECT * FROM [HumanResources].[Employee]
DECLARE @var_datetime DATETIME
SET  @var_datetime = GETDATE()  -- Fonction
SELECT BusinessEntityID, NationalIDNumber, BirthDate, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]


-- D�claration de la variable - ATTENTION AU GO...cloisonne la d�claration des variables
/*
J'aurai automatiquement une erreur SQL de type :
Msg 137, Level 15, State 1, Line 33
Must declare the scalar variable "@var3".
*/
USE AdventureWorks2017
DECLARE @var3 INT
GO
SELECT * FROM [person].[Person]
SET @var3 = ( select COUNT (BusinessEntityID) Nbr_ligne from [person].[Person] )  
-- D�s que je fais quelques choses dans un SELECT, je dois lui affecter le r�sultat dans une nouvelle variable
Print @var3
select @var3 AS variable

-- 2) Deuxi�me fa�on
USE AdventureWorks2017
GO
SELECT * FROM [person].[Person]  where BusinessEntityID = 3;
DECLARE @firstname AS NVARCHAR(50)
DECLARE @lastname AS NVARCHAR(50)
SET @firstname = (select FirstName from [person].[Person]  where BusinessEntityID = 3);




--3) Troisi�me fa�on de faire

DECLARE @firstname as nvarchar(10),
        @lastname as nvarchar(20);
SELECT @firstname = firstname, @lastname = lastname 
 FROM [person].[Person] where businessEntityID = 3;
 SELECT @firstname AS Prenom, @Lastname AS Nom


-------- Fin code------------------------------------------------------------


-- D�claration des variables dans SQL

-- D�claration litt�rale

DECLARE @var1 INT --= 6 + 6;
---SET @var = 6      --- -Assignation de la variable var1 �gale � 6
SET @var1 = 6 + 6
DECLARE @var2 INT = 12
SELECT (@var1 + @var2) Mike -- , @var1 John, @var1 Mike -- NULL  => 0 ou est-ce que c'est manquant !
PRINT 'TOTAL' + ' = ' + CAST (@var1 AS VARCHAR(10))
-- 
USE AdventureWorks2017
DECLARE @nbr_ligne INT
SET @nbr_ligne = ( SELECT COUNT (BusinessEntityID) Nbr_ligne FROM [person].[Person] ) -- Affectation d'une variable  */* � un SELECT
PRINT @nbr_ligne --- Rapport ==> au niveau de l'onglet (de la fen�tre) Messages

--
-- Affectation d'une variable  */* � une fonction SQL (GETDATE() )
DECLARE @var_datetime DATETIME
SET @var_datetime = getdate()
---SELECT * FROM [HumanResources].[Employee]
SELECT BusinessEntityID, NationalIDNumber, BirthDate AS Date_de_naissance, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]

-- GO !!!!
USE AdventureWorks2017

GO  -- fragmente le code (factorisation du code SQL)
DECLARE @var_datetime DATETIME
SET @var_datetime = getdate()
---SELECT * FROM [HumanResources].[Employee]
SELECT BusinessEntityID, NationalIDNumber, BirthDate AS Date_de_naissance, @var_datetime AS DATE_HEURE from [HumanResources].[Employee]
GO

--
-- Deuxi�me fa�on de d�clarer mais aussi de travailler avec ces variables dans des SELECT
USE AdventureWorks2017
GO
SELECT * FROM [person].[Person]  where BusinessEntityID = 3;
   DECLARE @firstname AS NVARCHAR(50)
   DECLARE @lastname AS NVARCHAR(50)

SET @firstname  = (select FirstName  from [person].[Person]  where BusinessEntityID = 3);
   PRINT @firstname

SET @lastname = (select Lastname from [person].[Person] where businessEntityID = 3);
   Print @firstname;
   Print @lastname;
-- en fin 
SELECT @firstname as Prenom, @lastname Nom

--
-- Autre fa�on de d�clarer les variables et de jouer avec elles.

DECLARE @firstname as nvarchar(10),
        @lastname as nvarchar(20);

SELECT @firstname = firstname, @lastname = lastname 
 FROM [person].[Person] where businessEntityID = 1;
 SELECT @firstname AS Prenom, @Lastname AS Nom
 PRINT @firstname + ' ' +  @Lastname














