
/* TRIGGER */

Select  BusinessEntityID, Lastname, Firstname, Gender, DepartmentId  
    from tbl_Employee_Gender_Department  -- 296 enregistrements


---- Je ne prends que les 10 premiers enregistrements ==> TOP(10)
Select TOP(10) * 
    from tbl_Employee_Gender_Department 

	-- Ou ci-dessous - M�me r�sultat
Select TOP(10) BusinessEntityID, Lastname, Firstname, Gender, DepartmentId 
from tbl_Employee_Gender_Department 

-- tbl_Employee_Gender_Department 
-- Je vais ajouter un champ Salary 


-- Existence d'une table temporaire #temp1
IF object_id ('tempdb.dbo.#temp1') is not null 
drop table #temp1
select TOP (10) BusinessEntityID, Lastname, Firstname, Gender, DepartmentId into #temp1 from tbl_Employee_Gender_Department 
select * from #temp1 -- 10 

--  ajouter un champ Salary � la table #temp1
Alter table #temp1 ADD salary money  -- Type de Microsoft
Select * from #temp1  -- 10 lignes -- Salary NULL ! pas de valeur!

-- Je devrais modifier (UPDATE) l'ensemble des ces 10 enregistrements avec une donn�e dans le champ salaire
-- Boucle d'insertion de donn�es : Mise � jour des donn�es
-- J'affecte uniquement le champ salaire -> SET salary = ....

DECLARE @num INT = 0;
WHILE @num < 10
BEGIN  
   UPDATE #temp1  -- [dbo].[tbl_Employee_Gender_Department_Salary]
      SET [salary] = 1000
   WHERE [BusinessEntityID]  = @num   
   PRINT 'Insertion de donn�es de salaire ' + ' ' + 'Pour le BusinessEntityID n� : ' + cast(@num as nvarchar(10));
   SET @num = @num + 1;
END;
PRINT 'Fin de l''insertion des donn�es dans la table';
GO
Select * from #temp1   -- 

--je sauve @temp1 en dur : tbl_Employee_Gender_Department_Salary

drop table tbl_Employee_Gender_Department_Salary   -- Table en dur
select * into tbl_Employee_Gender_Department_Salary from #temp1
select * from  tbl_Employee_Gender_Department_Salary -- Pourvue d�sormais du champ salaire pour les employ�s !


-- Id�e d'une traigger, d'un d�clencher
-- Lorsque je vais ins�rer une donn�e dans la table  tbl_Employee_Gender_Department_Salary 
-- Je souhaiterai que ce que je viens d'ins�rer se marque en tant log dans une table Audit, 
-- avec la date Syst�me au jour et � l'heure o� l'insertion s'est pass�

/*
-- 2 tables : tbl_Employee_Gender_Department_Salary 
              audit
			  */


-- Cr�ation de la table d'Audit pour r�cup�rer les donn�es ins�r�es ou supprim�es
USE AdventureWorks2017
DROP Table tbl_employee_salary_audit
CREATE TABLE tbl_employee_salary_audit
(
id nvarchar(10),
auditData nvarchar(255)
)
GO
-- TRIGGER qui va ne s'occuper que des insertions
-- INSERT INTO ..... ==> Il y a quelque chose qui doit se d�clencher
-- en, l'occurence une copie de cette insertion dans l atable d'Audit que je viens de cr�e auparvant.

CREATE TRIGGER tr_Employee_Gender_Department_Salary_For_INSERT
  --- ALTER TRIGGER tr_Employee_Gender_Department_Salary_For_INSERT
 ON tbl_Employee_Gender_Department_Salary
 FOR INSERT
 AS
 BEGIN                       -- Inserted est une table que le Trigger utilise uniquement dans son contexte
                             -- J'aurai pu avoir une table qui reprenne l'ensemble de mes insertions
							 -- que l'on nomme Audit (cfr.Etape n�2) -> tbl_employee_salary_audit
     --Select * From inserted  -- sur de ce qui a �t� ins�r�

	 -- Je peux aller chercher l'ID de ce qui a �t� ins�r�
    Declare @id INT
	 SELECT @Id = BusinessEntityID FROM Inserted
	 -- Je veux une copie dans une autre table de ce qui a �t� ins�r�e > table tbl_employee_salary_audit
	 INSERT into tbl_employee_salary_audit 
	  VALUES ( cast(@id as nvarchar(10)) ,'Nouvel employ� Ajout� : '+ cast (getdate() as varchar(20)) )
	  
END -- fin du BEGIN du Trigger

GO
Select * from tbl_Employee_Gender_Department_Salary -- 10
Select * from tbl_employee_salary_audit 

-- Nouvel enregistrement
INSERT INTO tbl_Employee_Gender_Department_Salary 
  VALUES ('12','Donald', 'Trump','M','16','200000000000000')

  -- Apr�s ce nouvel enregistrement, nous avons donc :

Select * from tbl_Employee_Gender_Department_Salary -- 10
Select * from tbl_employee_salary_audit 


/***************************************************
* Trigger pour la suppression d'un enregistrement
*****************************************************/
GO
CREATE TRIGGER tr_Employee_Gender_Department_Salary_For_DELETE
  --- ALTER TRIGGER tr_Employee_Gender_Department_Salary_For_DELETE
 ON tbl_Employee_Gender_Department_Salary
 FOR DELETE   -- �a concerne une supression d'un rengistrement
 AS
 BEGIN                       -- Deleted est une table que le Trigger utilise uniquement dans son contexte
                             
     ---Select * From deleted  -- sur de ce qui a �t� supprim�

	 -- Je peux aller chercher l'ID de ce qui a �t� ins�r�
	 Declare @idd INT
	 SELECT @Idd = BusinessEntityID FROM deleted 
	 -- Je veux une copie dans une autre table de ce qui a �t� supprim� > table tbl_employee_salary_audit
	 INSERT into tbl_employee_salary_audit 
	  VALUES ( cast(@idd as nvarchar(10)) ,'Employ� Supprim� ! '+ cast (getdate() as varchar(20)) )

 END
 
 -- TRUNCATE TABLE tbl_employee_salary_audit
 DELETE FROM tbl_Employee_Gender_Department_Salary WHERE BusinessEntityId = '13'



 Select * from tbl_Employee_Gender_Department_Salary  
 Select * from tbl_employee_salary_audit

---  Select * From deleted  -- en dehors du Trigger -> j'ai une erreur car objet inconnu mais connu uniquement 
                                                      -- dans son contexte du Trigger
