/*
Procédure Stockée
++++++++++++++++++

Ecrire une procédure stockée pour la DB [AdventureWorks2017] :
 -> que l'on déclarera (nom de celle-ci)

La procédure stockée doit nous permettre de retourner E-mail et le prénom/Nom de la personne
pour un 'BusinessEntity' égale à 123.

Les valeurs retournées de la procédure sont : 
 @BusinessEntityID
 @Email_Address
 @Full_Name

BONUS : Vous pouvez inclure une condition pour laquelle nous aurions une valeur 0 si
l'email existe, sinon 1 -> Utiliser CASE WHEN... THEN... ELSE... dans le code de la procédure stockée.
Valeur que l'on souhaiterait voir afficher dans le retour d'Email et du Prénom/Nom de la personne
Comme ceci :
 ----------------------------- 
| Result | Email | Nom_prénom |
 -----------------------------
  0     mike.bern@test.be  mike bern

Sources utiles :
- Création d'une procédure stockée : 
   https://docs.microsoft.com/en-us/sql/relational-databases/stored-procedures/create-a-stored-procedure?view=sql-server-2017

- Valeurs retournées dans la procédure stockée : [Partie Returning data Using a Return Code]
   https://docs.microsoft.com/en-us/sql/relational-databases/stored-procedures/return-data-from-a-stored-procedure?view=sql-server-2017

(c) MB - Ifosupwavre
***********************************/  ok sans bonus

USE AdventureWorks2017;  
GO  
CREATE PROCEDURE HumanResources.uspGetID   
    @ID INT     
AS   

    SET NOCOUNT ON;  
    SELECT Person.EmailAddress.EmailAddress AS [Email], Person.LastName + ' ' + Person.FirstName AS Nom_Prenom 
    INTO #temp1 
    FROM Person.Person
    INNER JOIN person.EmailAddress
    ON Person.Person.BusinessEntityID = Person.EmailAddress.EmailAddressID
    WHERE Person.BusinessEntityID = @ID;  
    SELECT * FROM #temp1
GO  
EXECUTE HumanResources.uspGetID @ID = 123
GO
DROP PROCEDURE HumanResources.uspGetID

/* ----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------*/

Bonus OK

USE AdventureWorks2017;  
GO  
CREATE PROCEDURE HumanResources.uspGetID   
    @ID INT     
AS    
    SELECT Person.EmailAddress.EmailAddress AS [Email], Person.LastName + ' ' + Person.FirstName AS Nom_Prenom,
        CASE 
        WHEN Person.EmailAddress.EmailAddress = NULL OR Person.EmailAddress.EmailAddress = '' THEN 1
        ELSE 0
        END AS Result 
    INTO #temp1 
    FROM Person.Person
    INNER JOIN person.EmailAddress
    ON Person.Person.BusinessEntityID = Person.EmailAddress.EmailAddressID
    WHERE Person.BusinessEntityID = @ID;  
SELECT Result, Email, Nom_prenom
FROM #temp1
GO

EXECUTE HumanResources.uspGetID @ID = 123
GO
DROP PROCEDURE HumanResources.uspGetID