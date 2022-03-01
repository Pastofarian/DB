-- SQL_N_devant_une_chaine_de_caractere
/*
 --  A quoi sert le N devant une chaîne de caractère ?
 Question courante, pourquoi Management Studio s'obstine à mettre un N devant les chaînes de caractère quand on lui demande de générer un script ? 
Source 1.: http://blogs.developpeur.org/christian/archive/2007/12/20/sql-server-a-quoi-sert-le-n-devant-une-cha-ne-de-caract-re.aspx
Source 2.: https://docs.microsoft.com/en-us/sql/t-sql/functions/unicode-transact-sql?view=sql-server-2017
Source 3.: https://www.sqlservercentral.com/forums/topic/why-use-n-before-any-string
*/

-- ETAPE 1 :
DECLARE @chaine varchar(50); -- chaîne de caractères VARCHAR ...est un type de donnée
                             -- qui stocke la chaine de caractère en ANSI
							 -- c'est-à-dire sur 1 octect (256 possibilités) !

							 -- https://chine.in/mandarin/dictionnaire/index.php?q=hello
							 -- je veux écrire Hello en mandarin dans mon code SQL!
/*
VARCHAR est codé en code ANSI
*/
SET @chaine = '哈罗';   -- alangage qui a probablement plus de 256 possibilités,
                       -- SQL ne pourra stocker sur 1 octet ce type de signe !
					   -- En effet, cfr.résultat !!! 
-- SET @chaine = espagnol'
SELECT @chaine, LEN(@chaine) as [LEN],
DATALENGTH(@chaine) as [datalenght];

--Résultat, SQL attribue un caractère de remplacement ??? qui  nous indique
-- que SQL ne connaît pas ce type de caractère puisqu'il n'est pas de type ANSI.

-- SOLUTION ?
-- Stocker en UNICODE !
-- Ce dernier permet 2 octets et donc plus de 64.000 possibilités !
-- Le chinois devrait donc rentrer dans ce type de format.
-- UNICODE (UTF8 ou UTF16)

/*********************
 -- ETAPE 2 --
************************/
DECLARE @chaine nvarchar(50);
SET @chaine = N'哈罗';  
SELECT @chaine, LEN(@chaine) as [LEN],
DATALENGTH(@chaine) as [datalenght];


/*********************************************************
 -- ETAPE 3 -- 
il faut indiquer aussi le littéral comme du UNICODE
comme nous l'avons fait à l'étape 2 sinon l'affichage
ne sera pas correct !
**********************************************************/
DECLARE @chaine nvarchar(50);
-- J'ai omis volontairment le N pour unicode
SET @chaine = '哈罗'; 
SELECT @chaine, LEN(@chaine) as [LEN],
DATALENGTH(@chaine) as [datalenght];


/* -- ETAPE 4 -- 
Caractère spéciaux s'ils sont LATIN
Pas besoin d'utiliser de l'UNICODE.
Le code ANSI Suffit !
**********************************************************/
DECLARE @chaine varchar(50);
-- J'ai omis volontairment le N pour unicode
SET @chaine = 'espagñol';  -- ñ ALT 164
SELECT @chaine, LEN(@chaine) as [LEN],
DATALENGTH(@chaine) as [datalenght];







-- Autre exemple -)

/*

IF OBJECT_ID('Test_Collate', 'U') IS NOT NULL
    DROP TABLE Test_Collate
GO

CREATE TABLE Test_Collate
(
    Id int,
    ch1 varchar(50) COLLATE Latin1_General_CI_AS, -- On s'attend à des caractères latins
    ch2 varchar(50) COLLATE Greek_CI_AS, -- Ici à du grec
    ch3 varchar(50) COLLATE Cyrillic_General_CI_AS -- Et ici du russe par exemple
)
GO
Select * from Test_Collate
-- Sans le N
INSERT Test_Collate
VALUES(1, 'Français', 'ΔΖΗΘΛπςσφ', 'ЪЫЬЮЯав')

GO
Select * from Test_Collate
-- Avec le N
INSERT Test_Collate
VALUES(2, N'Français', N'ΔΖΗΘΛπςσφ', N'ЪЫЬЮЯав')
GO

SELECT * FROM Test_Collate
GO

/*
Que faut-il en conclure ? Et bien que le moteur de base de données traite la chaîne comme étant non Unicode sans le N, 
 et comme étant Unicode avec le N.

On voit aussi un autre comportement intéressant du moteur. 
Ce dernier lorsque vous insérez des caractères dans une page de code données, 
 il remplace tous les caractères inconnus de cette page de code par « ? ». Ce n'est pas à l'affichage, c'est bien le caractère « ? » qui est stockée dans le champ. 
*/

*/

