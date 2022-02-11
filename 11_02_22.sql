
--new query
DECLARE @chaine varchar(50);   -- correspond à un let en JS
SET @chaine = '哈罗';
SELECT @chaine, LEN(@chaine) as [LEN],  -- LEN = nombre de caratère
DATALENGTH(@chaine) as [datalenght]; --datalength = nombre d'octet

-------------------------------------------------------------------------

--pour que t-sql reconnaisse les caractères spéciaux

DECLARE @chaine nvarchar(50);
SET @chaine = N'哈罗';
SELECT @chaine, LEN(@chaine) as [LEN], -- LEN = nombre de caratère
DATALENGTH(@chaine) as [datalenght]; --datalength = nombre d'octet

----------------------------------------------------------------------------

USE
AdventureWorks2017
DECLARE @empname AS NVARCHAR(31);
SET @empname = (SELECT firstname + N' ' + lastname FROM [person].[person] WHERE BusinessEntityID = 3);
SELECT @empname AS empname;
SELECT * FROM [Person].[Person]
PRINT @empname --pour l'affichage au niveau des messages
Go

------------------------------------------------------------------------------

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

