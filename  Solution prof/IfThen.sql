
-- SQL_CASE_EXPRESSIONS_avec_IF_THEN.sql --

/*********************************************

D�claration d'une variable
SET d'une variable
IF 
 BEGIN
 END
 ELSE
 END


Programmer la requ�te suivante en utilisant les expressions syntaxiques suivantes : 
 CASE WHEN
  END
A partir des tables [Person].[Address] et [Person].[StateProvince] de la base de donn�es AdventureWorks2017
On souhaite lister :
1) Les adresses qui ne sont pas dans la r�gion de la cote Ouest des Etats-Unis, seront not�s "Elsewhere".
   Les autres sont not�s "West Coast"  c'est-�-dire o� le champ de StateProvindeCode prend les valeurs suivantes : 
    * Etat de Washinghton 'WA' 
	* Etat d'Oregon 'OR'
	* Etat de Calfornie 'CA'
    Pour votre information, le lien (jointure) entre les 2 tables pr�c�demment cit�es se retrouve au niveau des champs suivants : 
	StateProvinceID <-------> StateProvinceID.
	
	Je souhaiterais que cette liste soit plac�e dans la table temporaire nomm�e #temp1 .

2) Quel le nombre d'adresse qui appartienne � telle ou telle r�gion ?
   Autrement dit :  Lecture du nombre d'adresse ayant le m�me code de r�gion
     Exemple : les adresses se trouvant dans l'�tat de Washinghton sont au nombre de 2.636, 16 pour l'�tat de New-York.

3) Quel le nombre total des adresses du c�t� West Coast ? (et donc des autres adresses qui sont du c�t� "Elsewhere")


***********************************************/

USE AdventureWorks2017

-- IF THEN

DECLARE @flag int         -- d�claration de variables type Integer
SET @flag = 1             -- J'assigne la valeur � cette variable @flag � 3
IF @flag = 1
BEGIN
                PRINT @flag;
				SELECT * FROM [Person].[Address]  -- AddressID
				SELECT * FROM [Person].[StateProvince] a

				SELECT StateProvinceCode,
				 CASE StateProvinceCode                       -- West coast consid�r� sont : Californie, Washington, Oregon
				  WHEN 'CA' THEN 'West Coast'
				  WHEN 'WA' THEN 'West Coast'
				  WHEN 'OR' THEN 'West Coast'
				ELSE 'Elsewhere'
				END
				FROM [Person].[StateProvince]  a  --Sales.CustomerAddress a
				INNER JOIN Person.Address p
				ON a.StateProvinceID= p.StateProvinceID


				-- Si je travaille avec une table temporaire --
				-- Listing des r�gions de la c�te ouest des Etats-Unis
				--DROP table #temp1
				-- Pour �viter les erreurs type warning 
				IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1
				SELECT 
				 CASE a.StateProvinceCode                       -- West coast consid�r� sont : Californie, Washington, Oregon
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

				-- Remarque : en faisant que P.addressLine1, il n'affichera que la premi�re adresse appartenant � telle ou telle r�gion !

				-- Quel le nombre d'adresse qui appartienne � telle ou telle r�gion ?
				-- Autrement dit :  Lecture du nombre d'adresse ayant le m�me code de r�gion
				-- Exemple : les adresses se trouvant dans l'�tat de Washinghton sont au nombre de 2.636
				SELECT COUNT(StateProvinceCode) AS NumOfCustomers, code_region
				FROM #temp1
				GROUP BY StateProvinceCode, code_region;

				-- Quel le nombre total des adresses du c�t� West Coast ? (et donc des autres adresses qui ne sont pas du c�t� "Elsewhere")
				SELECT COUNT(StateProvinceCode) AS NumOfCustomers, StateProvinceCode
				FROM #temp1
				GROUP BY StateProvinceCode, StateProvinceCode

END

ELSE
BEGIN

            PRINT @flag;
			SELECT * FROM [Person].[Address]   --where StateProvinceID = 2 -- AddressID
			SELECT * FROM [Person].[StateProvince] a

			SELECT * FROM [Person].[StateProvince] where StateProvinceCode = 'AK'

			-- Si je travaille avec une table temporaire --
			-- Listing des r�gions de la c�te ouest des Etats-Unis
			--DROP table #temp1
			-- Pour �viter les erreurs type warning 
			IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2
			SELECT 
			 CASE                      -- West coast consid�r� sont : Californie, Washington, Oregon
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

			-- Quel le nombre total des adresses du c�t� West Coast ? (et donc des autres adresses qui ne sont pas du c�t� "Elsewhere")
			SELECT COUNT(StateProvinceCode) AS NumOfCustomers, StateProvinceCode
			FROM #temp2
			GROUP BY StateProvinceCode, StateProvinceCode




END