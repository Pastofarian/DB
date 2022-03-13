


/*********************************************

Programmer la requête suivante en utilisant l'expression syntaxique suivante : 
 
IF Boolean_expression   
     { sql_statement | statement_block }   
[ ELSE   
     { sql_statement | statement_block } ]   

En se basant sur l'exercice 6 et l'exercice 7,
veuillez rassembler ces 2 précédents exercices dans une et une seule requête.

Nous travaillerons avec les tables temporaires.

Source : https://docs.microsoft.com/en-us/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-2017 


(c) MB - Ifosupwavre

******************************************************/




DECLARE @West_Coast VARCHAR(50)
SET @West_Coast = 'OR', 
print @West_Coast
IF(@West_Coast = (SELECT StateProvinceCode FROM [Person].[StateProvince] WHERE StateProvinceCode)) 
Print 'WestCoast'
