/************** INNER JOIN *****************

En se basant sur les tables de la DB AdventureWorks2017.
Veuillez les rassembler dans une et une seule table (temporaire) en prenant en compte le modèle relationnel INNER JOIN.


(c) MB - Ifosupwavre

**********************************/

 /*https://www.exacthelp.com/2012/04/cannot-create-select-into-target-table.html
 Now if will execute following sql query in sql server:

SELECT * INTO #tblTemp
FROM  tblXML

We will get error message :

Cannot create the SELECT INTO target table "" because the xml column "" is typed with a schema collection "" from database "". Xml columns cannot refer to schemata across databases.

Cause: As we know the tables are create in tempdp. We cannot create table (event temp table) in other database which any columns use xml collection which has created in other database.

Solution:

We have to create the table in the current database. So instead of creating temp table we have to create actual table and insert into the recodes. For example:

SELECT * INTO tblTemp
FROM  tblXML*/

USE AdventureWorks2017;  
GO  

IF Object_Id('tempdb.#temp1') is not null
DROP table #temp1

    SELECT *
    --INTO tableTemp1 ne marche pas 
    FROM Person.Person AS P
    INNER JOIN person.EmailAddress
    ON P.BusinessEntityID = Person.EmailAddress.EmailAddressID
    INNER JOIN Person.[Password]
    ON P.BusinessEntityID = [Password].BusinessEntityID
    INNER JOIN Person.BusinessEntityAddress
    ON Person.BusinessEntityAddress.AddressID = P.BusinessEntityID
    INNER JOIN Person.ContactType
    ON Person.ContactType.ContactTypeID = Person.BusinessEntityAddress.AddressID
    INNER JOIN Person.PersonPhone
    ON Person.PersonPhone.BusinessEntityID = P.BusinessEntityID
    INNER JOIN Person.PhoneNumberType
    ON Person.PhoneNumberType.PhoneNumberTypeID = P.BusinessEntityID
    INNER JOIN Person.AddressType
    ON Person.AddressType.AddressTypeID = Person.BusinessEntityAddress.AddressID
    INNER JOIN Person.Address
    ON Person.Address.AddressID = Person.BusinessEntityAddress.BusinessEntityID
    INNER JOIN Person.StateProvince
    ON Person.StateProvince.StateProvinceID = Person.Address.AddressID
    INNER JOIN Person.CountryRegion
    ON Person.CountryRegion.CountryRegionCode = Person.StateProvince.StateProvinceID


    
