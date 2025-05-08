--Menu
SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id>0 and $group_id<3;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id=3;


-- Message si droits insuffisants sur une page
SELECT 'alert' as component,
    'Attention !' as title,
    'Vous ne possédez pas les droits suffisants pour accéder à cette page.' 
    as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $restriction IS NOT NULL;

--Dashboard
select 
    'card' as component,
    'Tableau de bord' as title,
    2      as columns
    where $group_id>0;
select 
    '/dashboard/graph_01.sql?_sqlpage_embed' as embed where $group_id>0;
select 
    '/dashboard/graph_02.sql?_sqlpage_embed' as embed where $group_id>0;
    
select 
    'card' as component,
    'Tableau des risques' as title,
    1      as columns
    where $group_id>0;
select 
    '/dashboard/graph_03.sql?_sqlpage_embed' as embed where $group_id>0;



