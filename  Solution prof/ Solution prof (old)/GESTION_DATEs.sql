
/*************************************************************************************************************
* Programme à réaliser : rechercher de la date la plus récente dans la table [HumanResources].[Employee]
*   de la base de données AdventureWorks2017
*   On souhaite avoir comme résultat la date de naissance la plus récente et de la plus éloignée
*   Ce résultat devra reprendre les champs suivants : NationalIDNumber, date_naissance (anciennement BirthDay)
*   La recherche de ces 2 dates doivent se retrouver dans une et une seule table finale
*   Nous travaillerons avec les tables temporaires
*
* (c) MB - Ifosupwavre
**************************************************************************************************************/

USE AdventureWorks2017
declare @dt_sel date
SELECT * FROM  [HumanResources].[Employee]

-- Copie de la table vers une table temporaire.
-- (1) Cfr.documentation technique MSQL : https://docs.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database?view=sql-server-2017 
-- (2) Cfr. https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017


IF object_id('tempdb.dbo.#temp1') is not null drop table #temp1
--drop table #temp1
select * into #temp1 FROM [HumanResources].[Employee]
select * from #temp1 -- 290 lignes

declare @date_max datetime
select NationalIDNumber, Birthdate from #temp1
select NationalIDNumber, cast (convert(varchar(20),birthdate,112) as INT) date_naissance from #temp1
select * from #temp1

-- A placer dans la nouvelle table
IF object_id('tempdb.dbo.#temp2') is not null drop table #temp2
--drop table #temp2
select NationalIDNumber, cast (convert(varchar(20),birthdate,112) as INT) date_naissance into #temp2 from #temp1
select * from #temp2  -- j'ai mes dates converties mais en AAAAMMDD

IF object_id('tempdb.dbo.#temp3') is not null drop table #temp3
--drop table #temp3      -- date la plus récente
declare @dt_recente integer 
select NationalIDNumber, date_naissance into #temp3 from #temp2
where date_naissance in (select max(date_naissance) from #temp2);
select * from #temp3  -- j'ai mes dates converties mais en AAAAMMDD

-- Vérification :
select * from #temp2  where NationalIDNumber = 563680513

IF object_id('tempdb.dbo.#temp4') is not null drop table #temp4
--drop table #temp4  --  date la plus petite
select NationalIDNumber, date_naissance into #temp4 from #temp2
where date_naissance in (select min(date_naissance) from #temp2);
select * from #temp4

--
select * from #temp3  -- date MAX
select * from #temp4  -- date Min

-- UNION ALL
IF object_id('tempdb.dbo.#temp_finalMB') is not null drop table #temp_finalMB
--drop table #temp_final
select *
into #temp_finalMB
from #temp4
UNION
select *
from #temp3

select * FROM #temp_finalMB

/* Convertir AAAAMMDD en JJ-MM-AAAA
Source : https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
ou 
-- https://database.guide/datetime-vs-smalldatetime-in-sql-server-whats-the-difference/
*/

--DROP table #temp_finalMB1
-----select NationalIDNumber, convert(nvarchar, getdate(), 105) Date_naissance into #temp_finalMB1 from #temp_finalMB

--select NationalIDNumber, convert(nvarchar(30), Date_naissance, 102) AS Date_naissance1 into #temp_finalMB1 from #temp_finalMB
--select * from #temp_finalMB1


/* Conversion de date */
-- Impossible de caster de INT en DATE date -> il faut passer par un VAR ! 
-- Ce fera en plusieur temps !!
-- Cfr. https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15 
-- Explicit conversion INT
DROP table #temp_finalMB2  -- 1
Select NationalIDNumber, cast([Date_naissance] as varchar(20)) as new_date into #temp_finalMB2 FROM #temp_finalMB
Select * from #temp_finalMB2


DROP table #temp_finalMB3  -- 2
Select NationalIDNumber, cast([New_date] as DATE) as new_date1 into #temp_finalMB3 FROM #temp_finalMB2
Select * from #temp_finalMB3

DROP table #temp_finalMB4  --3  -- https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

select NationalIDNumber, convert(nvarchar, new_date1, 103) AS new_date2 into #temp_finalMB4 from #temp_finalMB3
select * from #temp_finalMB4

---  FIN DU CODE --- 
