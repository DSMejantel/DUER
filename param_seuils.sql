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
SELECT 
    'form'            as component,
    'Modifier' as validate,
    'param_seuils_confirm.sql' as action,
    'green'           as validate_color;

        SELECT  TRUE as readonly,'Minimum' AS label, 'Minimum' AS suffix, 's0' AS name, 2 as width, 0 as value, 'Situation acceptable de 0 au seuil 1' as description;
    SELECT  TRUE as required, 'Seuil 1' AS label, 's1' AS name, 'number' as type, smin as value, 2 as width, 'Situation de surveillance du seuil 1 au seuil 2' as description FROM seuils WHERE id=2;
    SELECT  TRUE as required, 'Seuil 2' AS label, 's2' AS name, 'number' as type, smin as value, 2 as width, 'Situation de vigilance du seuil 2 au seuil 3' as description  FROM seuils WHERE id=3;
    SELECT  TRUE as required, 'Seuil 3' AS label, 's3' AS name, 'number' as type, smin as value, 2 as width, 'Situation d''alerte au dessus du seuil 3' as description  FROM seuils WHERE id=4;
        SELECT  TRUE as readonly,'Maximum' AS label, 'Maximum' AS suffix, 's5' AS name, 2 as width, 100 as value;

