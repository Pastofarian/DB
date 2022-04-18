
/**********************************************************************************************************
-- Deuxième exercice :
-- Ecrire un Trigger
-- Qui lorsque j'nséère le champ âge d'une personne égale à zéro, il modfie ce champ par un zéro.
-- On n'hésitera pas créer une table archive dans ce sens.
***********************************************************************************************************/

Use AdventureWorks2017
select * from [Person].[Person]
select * from [HumanResources].[Employee]
select * from [Person].[EmailAddress]
select * from [Person].[PersonPhone]
select * from [Person].[PhoneNumberType] 

-- Jointure 1
IF object_id ('tempdb.dbo.#temp1') is not null drop table #temp1
 Select P.BusinessEntityId, P.Title, P.Firstname, P.Lastname, 
 H.NationalIDNumber, H.BirthDate, H.MaritalStatus, H.Gender
 INTO #temp1 From [Person].[Person] P JOIN [HumanResources].[Employee] H ON  
  P.BusinessEntityId = H.BusinessEntityId -- 290


-- Jointure n°2
IF object_id ('tempdb.dbo.#temp2') is not null drop table #temp2
 Select T.BusinessEntityId, T.Title, T.Firstname, T.Lastname, 
 T.NationalIDNumber, T.BirthDate, T.MaritalStatus, T.Gender, E.EmailAddress
 INTO #temp2 From #temp1 T JOIN [Person].[EmailAddress] E ON T.BusinessEntityId = E.BusinessEntityId
select * from #temp2  -- 290 lignes

-- Jointure 3  -- [Person].[PhoneNumberType]
IF object_id ('tempdb.dbo.#temp3') is not null drop table #temp3
Select M.BusinessEntityId, Title, Firstname, Lastname, 
 NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, P.PhoneNumber, T.Name
 INTO #temp3 FROM #temp2 M JOIN [Person].[PersonPhone] P  ON P.BusinessEntityID =  M.BusinessEntityID
                         JOIN [Person].[PhoneNumberType] T ON T.PhoneNumberTypeID = P.PhoneNumberTypeID
Select * from #temp3 -- 290 lignes

/*

--------------------------------------------------------------
-----  autre façon de décomposer la jointure ------------------

 -- etape 1
IF object_id ('tempdb.dbo.#temp3a') is not null drop table #temp3a
Select M.BusinessEntityId, Title, Firstname, Lastname, 
 NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, P.PhoneNumber, P.PhoneNumberTypeID
 INTO #temp3a FROM #temp2 M JOIN [Person].[PersonPhone] P  ON P.BusinessEntityID =  M.BusinessEntityID
Select * from #temp3a -- 290 lignes

-- etape 2
Select * from [Person].[PhoneNumberType] 
IF object_id ('tempdb.dbo.#temp3c') is not null drop table #temp3c
Select M.BusinessEntityId, M.Title, M.Firstname, M.Lastname, 
 M.NationalIDNumber, M.BirthDate, M.MaritalStatus, M.Gender, M.EmailAddress, M.PhoneNumber, T.Name
 INTO #temp3c FROM #temp3a M JOIN [Person].[PhoneNumberType] T  ON M.PhoneNumberTypeID =  T.PhoneNumberTypeID
Select * from #temp3c -- 290 lignes

-- etape 3
IF object_id ('tempdb.dbo.#temp4a') is not null drop table #temp4a
Select * into #temp4a from #temp3c  where Title <> ''  -- 8 lignes
Select * from #temp4a -- 8 lignes

*/

Select COUnt (BusinessEntityId) FROM #temp3  -- 290 lignes uniques!
-- Filtre uniquement sur Title différent de NULL
IF object_id ('tempdb.dbo.#temp4') is not null drop table #temp4
Select *  into #temp4 from #temp3 where Title <> ''       -- 8 lignes

Select * from #temp4 -- 8 lignes


-- Sauvegarde dans une table en dur.
Drop table tbl_HR_BERNAIR_MICHEL
Select * INTO tbl_HR_BERNAIR_MICHEL FROM #temp4
Select * FROM tbl_HR_BERNAIR_MICHEL


----------------- Petit test pour la valeur 9 ------------------------------------------------------

-- Si je rentre un NationalIDNumber < 9

/***********************************************************************************************
TEST du nombre de caractère : LEN
 https://docs.microsoft.com/fr-fr/sql/t-sql/functions/len-transact-sql?view=sql-server-ver15
*************************************************************************************************/

ALTER TABLE tbl_HR_BERNAIR_MICHEL ADD test nvarchar(1)
DROP table tbl_HR_BERNAIR_MICHEL_BIS
Select * INTO tbl_HR_BERNAIR_MICHEL_BIS From tbl_HR_BERNAIR_MICHEL
Select * FROM tbl_HR_BERNAIR_MICHEL_BIS

-- Test NULLL
-- Vérfication à l'aide d'un nouveau champ de la table BIS si la valeur 9

IF object_id ('tempdb.dbo.#temp5') is not null 
Drop table #temp5
Select BusinessEntityId, Title, Firstname, Lastname, 
       NationalIDNumber, BirthDate, MaritalStatus, Gender, EmailAddress, PhoneNumber,
       Name,
      case 
       when (LEN([NationalIDNumber]) ) = 9 then '1'
	    ELSE '0'
 end test
 INTO #temp5 FROM tbl_HR_BERNAIR_MICHEL_BIS

Select * from #temp5
 
 
 -- Fin du test de la longueur pour le Triggger --



 /*******************************************
               DEBUT DU TRIGGER
 *******************************************/

DROP Table tbl_audit_hr
CREATE TABLE tbl_audit_hr
(
id nvarchar(10),
auditData nvarchar(255)
)
GO
-- TRIGGER qui va ne s'occuper que des insertions
-- INSERT INTO ..... ==> Il y a quelque chose qui doit se déclencher
-- en, l'occurence une copie de cette insertion dans l atable d'Audit que je viens de crée auparvant.

CREATE TRIGGER tr_HR_For_INSERT
  --- ALTER TRIGGER tr_HR_For_INSERT
 ON tbl_HR_BERNAIR_MICHEL
 FOR INSERT
 AS
 BEGIN                       -- Inserted est une table que le Trigger utilise uniquement dans son contexte
                             -- J'aurai pu avoir une table qui reprenne l'ensemble de mes insertions
							 -- que l'on nomme Audit (cfr.Etape n°2) -> tbl_employee_salary_audit
     Declare @id INT
	 Declare @test1 INT
	 Declare @NationalIDNumber_trig  nvarchar(9)
	 Declare @BusinessEntityID_trig int
	
	Select @BusinessEntityID_trig = BusinessEntityID From inserted  -- sur de ce qui a été inséré
   
	 -- Je peux aller chercher l'ID de ce qui a été inséré

--	SELECT @NationalIDNumber_trig = [NationalIDNumber] FROM Inserted where @Id = BusinessEntityID
	 --PRINT @Id	 
	 -- Je veux une copie dans une autre table de ce qui a été insérée > table tbl_employee_salary_audit
	INSERT into tbl_audit_hr 
	  VALUES ( cast(@BusinessEntityID_trig as nvarchar(10)) ,'Nouvel employé Ajouté : '+ cast (getdate() as varchar(20)) )
 
	    IF (Select (LEN([NationalIDNumber]) ) From Inserted where BusinessEntityID = @BusinessEntityID_trig ) < 9
			 BEGIN
			  UPDATE tbl_HR_BERNAIR_MICHEL 
				SET [NationalIDNumber] = '9999999' WHERE BusinessEntityID = @BusinessEntityID_trig 
	         END 
	
END -- fin du BEGIN du Trigger


Select * from tbl_audit_hr
-- truncate table tbl_audit_hr

Delete from tbl_audit_hr where id is NULL

Select * FROM tbl_HR_BERNAIR_MICHEL

-- Insertion après insertion sinon, cela ne fonctionne pas !
-- Soit on manage l'insertion de données
INSERT INTO tbl_HR_BERNAIR_MICHEL VALUES
('291','Mr.','XXXX','XXXX','12345678','1968-07-05','M','M','xxxxx@xxxx.com','1111111','Work')
-- Insertion après insertion
INSERT INTO tbl_HR_BERNAIR_MICHEL VALUES
('292','Ms.','YYYY','YYYY','123456789','1968-07-05','M','M','yyyyyy@yyy.com','222222','Cell')

 -- TRUNCATE TABLE tbl_employee_salary_audit
 DELETE FROM tbl_HR_BERNAIR_MICHEL WHERE BusinessEntityId in ('291','292')
 Select * FROM tbl_HR_BERNAIR_MICHEL

--- Je pourrai faire une boucle de 2 insertions de données
--  Il faut séquencer les insertions des 2 records dans la table via une boucle.
DECLARE @num INT = 1
DECLARE @i INT = 1
DECLARE @BusinessEntityID_Print nvarchar(10)
WHILE @num < 3
BEGIN  -- BEGIN n°1
  IF @i = 1
    INSERT INTO tbl_HR_BERNAIR_MICHEL VALUES
    ('291','Mr.','XXXX','XXXX','12345678','1968-07-05','M','M','xxxxx@xxxx.com','1111111','Work')
	ELSE
	 INSERT INTO tbl_HR_BERNAIR_MICHEL VALUES
	 ('292','Ms.','YYYY','YYYY','123456789','1968-07-05','M','M','yyyyyy@yyy.com','222222','Cell')
   SET @i = @i + 1
   SET @num = @num + 1
   SELECT @BusinessEntityID_Print = BusinessEntityID from tbl_HR_BERNAIR_MICHEL 
   PRINT @BusinessEntityID_Print    
END -- fin du BEGIN n°1
PRINT 'Fin de l''insertion des données dans la table'
Select * from tbl_HR_BERNAIR_MICHEL


GO

-- Pour ceux qui ne veulent pas faire via un Trigger
-- cela leur coûtera moins de point !!
-- Avec des CASE WHEN.....
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-local-variable-transact-sql?view=sql-server-ver15

https://docs.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver15


-- Dans ce cas, on n'utilise pas de Trigger

-- 1 er solution la plus simple en utilisant les case when
-------------------------------------------------------------
Select * FROM tbl_HR_BERNAIR_MICHEL
IF object_id ('tempdb.dbo.#temp6') is not null 
DROP TABLE #temp6
Select BusinessEntityID, Title, Firstname, Lastname, 
case 
       when (LEN([NationalIDNumber]) ) <= 8 then '999999'
	   ELSE NationalIDNumber
	    end NationalIDNumber,
BirthDate [Date_de_naissance], Maritalstatus, Gender, EmailAddress, PhoneNumber, Name
INTO #temp6 From tbl_HR_BERNAIR_MICHEL
Select * from #temp6

-- 2 ième solution si on ne veut pas écrire un Trigger, ici un peu plus compliqué
----------------------------------------------------------------------------------

Select * FROM tbl_HR_BERNAIR_MICHEL

IF object_id ('tempdb.dbo.#temp7') is not null 
DROP TABLE #temp7
Select * into #temp7 from tbl_HR_BERNAIR_MICHEL
Select * from #temp7

DECLARE @num INT = 1
DECLARE @BusinessEntityID1 nvarchar(10)
DECLARE @NationalIDNumber1 nvarchar(10)
WHILE @num < 2   -- sur 1 et 1 seul Record
BEGIN  -- BEGIN n°1
 	 INSERT INTO #temp7 VALUES
	 ('292','Ms.','YYYY','YYYY','12345678','1968-07-05','M','M','yyyyyy@yyy.com','222222','Cell')
	 Select @BusinessEntityID1 = BusinessEntityID, @NationalIDNumber1 = NationalIDNumber   From #temp7
	 PRINT  @BusinessEntityID1 
	 IF (Select (LEN([NationalIDNumber]) ) From #temp7  where BusinessEntityID = @BusinessEntityID1) < 9
			 BEGIN
			  UPDATE #temp7 
				SET [NationalIDNumber] = '9999999' where BusinessEntityID = @BusinessEntityID1
	         END 
	SET @num = @num + 1 
END
Select * from #temp7

-- Fin de la deuxième solution --- 








--
-- Tester si on rentre la date de naissance inférieure à 1950 alors on insère avec le champ égale à 1900
-- et on ajoute une remarque à ce champ : "Houston, i had a problem !"
-- TRIGGER

