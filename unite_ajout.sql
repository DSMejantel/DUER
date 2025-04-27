SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

-- formulaire
select 
    'form'            as component,
    'Créer une unité de travail'            as title,
    'Enregistrer' as validate,
    'green'           as validate_color;
select 
    'lieu' as name,
    'Lieu' as label,
    4            as width;
    
Insert into unite (lieu)
SELECT :lieu WHERE :lieu IS NOT NULL;

select 
    'table' as component;
select 
    lieu as Unité
    FROM unite;
