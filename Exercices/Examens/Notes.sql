
Examen_2021_ProcStockee : 

JOIN 
SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]
SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]


CASE WHEN téléphone maison, travail

CONCAT C1 C2

PROC LEFT/RIGHT + CONCAT pour adresse email Mike.Bern.Mrn@ifosup

----------

Examen_2020_ProcStockee :

IF @genre = 'M' ELSE Sally RIDE

SET date et heure WHILE GETDATE

PROC @nom + @prenom + @id + date et heure OUTPUT

-----------

Examen_2020_Transaction : 

JOIN 
SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [Person].[Person]
SELECT * FROM [Person].[PersonPhone]
SELECT * FROM [Person].[PhoneNumberType]

TRANS IF @date > 1900 Rollback
IF @date >= (SELECT SUBSTRING(CAST(Date_de_naissance AS NVARCHAR(10)),1,4) AS Date_de_naissance 
----------

Examen_blanc_2021_Curseur :

INSERT INTO ROWID

UPDATE %2=1

Double curseur
SET 'x' WHERE test1 = test2
 
---------

Examen_2021_Trigger INSERT: Trigger_Benja_Mathieu :

WHILE between 70 AND 100 vaccin astra

CASE WHEN 'M' THEN 'Mr'

TRIGGER if @age >= 70 UPDATE

---------

Examen_blanc_2019_Curseur :

SET identity ON/OFF

CURSOR IF @sexe = 1 UPDATE

---------

Examen_blanc_2019_Trigger :

JOIN 
SELECT * FROM Person.person
SELECT * FROM Person.EmailAddress
SELECT * FROM Person.PersonPhone
SELECT * FROM person.PhoneNumberType

TRIGGER INSERT  IF @length > 9 UPDATE 
SELECT LEN(NationalIDNumber) FROM INSERTED

---------

Examen_blanc_2021_ProcStockee :

CONVERT date 103
PROC COUNT id WHERE gender AND SUBSTRING(date)

--------

Examen_blanc_2022_ProcStockee :

JOIN 

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee
SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]
SELECT * FROM [HumanResources].[Department]

Function SUBSTRING date 19_12_22
SET @a = SUBSTRING (cast(@date AS varchar),9,2)

PROC getemployee WHERE Research and Development%

---------

Examen_blanc_2022_Trigger :

UPDATE nationalite  = BE/US

TRIGGER INSERT(audit) UPDATE SET Login



























