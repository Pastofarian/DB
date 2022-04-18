
/******************************************************************************
     Ecrire une transaction qui porte sur la table finale qui reprendra les
	 10 premiers enregistrements dont les champs sont 
	 les suivants : 
     BusinessEntityId | NationalIDNumber | BirthDate | MaritalStatus | Gender
     Title | FirstName | LastName | PhoneNumber | [Type_telephone]
     
	 ETAPE n°1 :
	 Pour arriver à une telle table, il faudra effectuer 3 jointures successives
	 entre les tables suivantes :
	  -- 4 jointures :
	 (1)  [HumanResources].[Employee] 
     (2)  [Person].[Person]
     (3)  [Person].[PersonPhone]
     (4)  [Person].[PhoneNumberType]
	 Les jointures de type INNER JOIN se font :
	 (1) - (2) [HumanResources].[Employee] et [Person].[Person] via le champ BusinessEntityId 
	           => me donne une table temporaire #Temp1
	 (#Temp1) - (3) Jointure entre #temp1 et [Person].[PersonPhone] via le champ BusinessEntityId 
	           => me donneune table temporaire #temp2
	 (#temp2) - (4) Jointure entre #temp2 et [Person].[PhoneNumberType] via le champ PhoneNumberTypeID

	 ETAPE n°2 :
	 ---------
	 Prendre les 10 premiers enregistrements => TOP Transct-SQL
	 Source utile : https://docs.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql?view=sql-server-ver15

	 ETAPE n°3 :
	 ---------
	  - Sauver cette table où vous avez les 10 premiers enregistrement dans une table en dur nommée comme suit:
	 tbl_transact_nom_prenom
	 Exemple : Je m'appelle Mike Bern -> d'où tbl_transact_mike_bern
	  - Renommer le champ Birthdate en [Date_de_naissance]
	  Qu'il conviendra de CASTER en nvarchar(10)-> puisque ce champ est de type DATE 
	 Source utile : https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15
	 
	 ETAPE n°4 : 
	 ---------
	 Ecrire une transaction qui lorsque j'insère une valeur de date inférieure ou égale à 1900, 
	 j'effecture un Rollback, sinon, je valide cette insertion.
	 Ci-dessous le type d'insert :	  
	  INSERT #temp300 (BusinessEntityId, NationalIDNumber, [Date_de_Naissance], MaritalStatus,
	  Gender, Title, FirstName, LastName, PhoneNumber, [Type_telephone] ) 
      VALUES ('15','879342154',	'1900-12-31',	'M',	'M', 'Mr', 'Mike', 'Bern', '000-111-2222', 'Work')
	 
	  INSERT #temp300 (BusinessEntityId, NationalIDNumber, [Date_de_Naissance], MaritalStatus,
	  Gender, Title, FirstName, LastName, PhoneNumber, [Type_telephone] ) 
      VALUES ('15','879342154',	'2001-11-09',	'M',	'M', 'Mr', 'Mike', 'Bern', '000-111-2222', 'Work')

	  Bon travail.


***************************************************************************	 */

Use AdventureWorks2017
Select * from [HumanResources].[Employee]
Select * from [Person].[Person]
Select * from [Person].[PersonPhone]
Select * from [Person].[PhoneNumberType]


-- Jointure entre [HumanResources].[Employee] et [Person].[Person]
 IF object_id ('tempdb.dbo.#temp1') is not null drop table #temp1
 SELECT E.BusinessEntityId, E.NationalIDNumber, E.BirthDate, E.MaritalStatus, E.Gender,
 P.Title, P.FirstName, P.LastName
 into #temp1 From [HumanResources].[Employee] E 
 inner join [Person].[Person] P on E.BusinessEntityId = P.BusinessEntityId
 Select * from #temp1

 -- Jointure avec le téléphone
 -- [Person].[PersonPhone]
 -- #temp1
 IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
  SELECT E.BusinessEntityId, E.NationalIDNumber, E.BirthDate, E.MaritalStatus, E.Gender,
 E.Title, E.FirstName, E.LastName, P.PhoneNumber, P.PhoneNumberTypeID
 into #temp2 FROM #temp1 E inner join [Person].[PersonPhone] P
 on E.BusinessEntityId = P.BusinessEntityId

 Select * from #temp2  -- 290 lignes
---- [Person].[PhoneNumberType]
 
 -- Dernière jointure
 IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
  SELECT E.BusinessEntityId, E.NationalIDNumber, E.BirthDate, E.MaritalStatus, E.Gender,
 E.Title, E.FirstName, E.LastName, E.PhoneNumber, T.[Name] [Type_telephone]
 into #temp3 FROM #temp2 E inner join [Person].[PhoneNumberType] T
 on E.PhoneNumberTypeID = T.PhoneNumberTypeID
 Select * from #temp3
 
 /* ETAPE n°2 */
  
  -- Prendre que les 10 premières valeurs de cette table
Drop table tbl_transact_mike_bern
Select TOP(10) * into tbl_transact_mike_bern from #temp3
Select * from tbl_transact_mike_bern


/* ETAPE n°3  + CAST du champ BirthDate et renommage de ce champ en [Date_de_Naissance] */

Drop table #temp300
Select BusinessEntityId, NationalIDNumber, cast (BirthDate as nvarchar) Date_de_Naissance, MaritalStatus,
	 Gender, Title, FirstName, LastName, PhoneNumber, [Type_telephone]
into #temp300 from tbl_transact_mike_bern
Select * from #temp300  -- Date de naissance

-----------------   OK  --------------


 /*******************************************************************
 * Test si avec le IF THEN pour savoir si je suis en 1900 ou pas !  *
 *******************************************************************/

 Select * from #temp300
 
 --- Test 
 -- URL pour le test :
 -- IF THEN ELSE https://docs.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver15
 UPDATE #temp300
 SET Date_de_Naissance = '1900-01-01'
 Where BusinessEntityID = 5
 Select * from #temp300

Declare @Date_pivot nvarchar(4)
SET @Date_pivot = '1900'
 --IF @Date_pivot = (Select  substring ( [Date_de_naissance],1,4)   -- 1900 < 1971
 --                    FROM #temp300 Where BusinessEntityID = 2)
	IF @Date_pivot = (Select  substring ( cast (Date_de_Naissance as nvarchar(4)),1,4) as test
					FROM #temp300 where  BusinessEntityID = 5) 

  Select 'OK'             -- Je suis en 1900
ELSE
Select 'non OK'

--------------------- Fin OK ------------

 /*
 Pour tester la longueur d'un string
 -- https://docs.microsoft.com/en-us/sql/t-sql/functions/substring-transact-sql?view=sql-server-ver15
 Select * from tbl_transact_mike_bern
  DROP table #temp100
 SELECT BusinessEntityId, substring (cast (BirthDate as nvarchar),1,4)  as test 
   into #temp100 FROM tbl_transact_mike_bern  WHERE BusinessEntityId = 1
Select * from #temp100

*/

/************************************************************************
-- Permet de tester la fonction substring
drop table #temp200
Declare @test nvarchar
SELECT BusinessEntityId, substring (cast (BirthDate as nvarchar),1,4)  as test
into #temp200	     FROM tbl_transact_mike_bern 
select * from #temp200
**************************************************************************************/


/*
ETAPE n°4 :
 INSERT #temp300 (BusinessEntityId, NationalIDNumber, [Date_de_Naissance], MaritalStatus,
	 Gender, Title, FirstName, LastName, PhoneNumber, [Type_telephone] ) 
    VALUES ('15','879342154',	'2001-12-31',	'M',	'M', 'Mr', 'Mike', 'Bern', '000-111-2222', 'Work')
*/

select * from #temp300
--- Select * from  tbl_transact_mike_bern 
DECLARE @error int -- Déclaration de la variable Error du type Int -> parce qu'elle va retourner un nombre qui correspond en fait à une erreur classique
Declare @Date_pivotT nvarchar(4)
SET @Date_pivotT = '1900'
BEGIN TRANSACTION  -- Je commence une Transaction T1
   INSERT #temp300 (BusinessEntityId, NationalIDNumber, [Date_de_Naissance], MaritalStatus,
	 Gender, Title, FirstName, LastName, PhoneNumber, [Type_telephone] ) 
    VALUES ('15','879342154',	'1900-12-31',	'M',	'M', 'Mr', 'Mike', 'Bern', '000-111-2222', 'Work')
	
	IF @Date_pivotT = (Select  substring ( cast (Date_de_Naissance as nvarchar(4)),1,4) as test
					FROM #temp300 where  BusinessEntityID = 15) 
	 BEGIN
	   ROLLBACK TRANSACTION
	   RAISERROR ('Cette entrée n''est pas possible car la personne est née avant 1900',1,1)
	 END

-- Je gère les erreurs comme suit
Gestion_des_erreurs:
If @error <> 0
BEGIN
Rollback TRANSACTION
PRINT  @Error  -- Affiche le numéro de l'erreur, ici 2601
END
If @error =0
BEGIN
COMMIT TRANSACTION
END
select count (*) [Nombre_de_donnees_apres_InSERT] from #temp300  




