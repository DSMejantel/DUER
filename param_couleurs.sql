SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        './/index.sql?restriction' AS link
        WHERE $group_id<'3';

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

    
-- formulaire
SELECT 
    'form'            as component,
    'Modifier' as validate,
    'param_couleurs_confirm.sql' as action,
    'green'           as validate_color;


    SELECT  TRUE as required, 'select' as type, 'Situation acceptable' AS label, 'c1' AS name, (SELECT color from seuils WHERE id=1) as value, 'Choisir une couleur...' as empty_option, '[{"label": "Vert", "value": "green"}, {"label": "Vert clair", "value": "teal"}, {"label": "Jaune", "value": "yellow"}, {"label": "Orange", "value": "orange"}, {"label": "Rouge", "value": "red"}, {"label": "Noir", "value": "black"}, {"label": "Bleu", "value": "blue"}, {"label": "Violet", "value": "purple"}, {"label": "Rose", "value": "pink"}, {"label": "Gris", "value": "gray-600"}]' as options, 3 as width;
    
    SELECT  TRUE as required, 'select' as type, 'Situation  de surveillance' AS label, 'c2' AS name, (SELECT color from seuils WHERE id=2) as value, 'Choisir une couleur...' as empty_option, '[{"label": "Vert", "value": "green"}, {"label": "Vert clair", "value": "teal"}, {"label": "Jaune", "value": "yellow"}, {"label": "Orange", "value": "orange"}, {"label": "Rouge", "value": "red"}, {"label": "Noir", "value": "black"}, {"label": "Bleu", "value": "blue"}, {"label": "Violet", "value": "purple"}, {"label": "Rose", "value": "pink"}, {"label": "Gris", "value": "gray-600"}]' as options, 3 as width;
    
    SELECT  TRUE as required, 'select' as type, 'Situation  de vigilance' AS label, 'c3' AS name, (SELECT color from seuils WHERE id=3) as value, 'Choisir une couleur...' as empty_option, '[{"label": "Vert", "value": "green"}, {"label": "Vert clair", "value": "teal"}, {"label": "Jaune", "value": "yellow"}, {"label": "Orange", "value": "orange"}, {"label": "Rouge", "value": "red"}, {"label": "Noir", "value": "black"}, {"label": "Bleu", "value": "blue"}, {"label": "Violet", "value": "purple"}, {"label": "Rose", "value": "pink"}, {"label": "Gris", "value": "gray-600"}]' as options, 3 as width;
    
    SELECT  TRUE as required, 'select' as type, 'Situation  d''alerte' AS label, 'c4' AS name, (SELECT color from seuils WHERE id=4) as value, 'Choisir une couleur...' as empty_option, '[{"label": "Vert", "value": "green"}, {"label": "Vert clair", "value": "teal"}, {"label": "Jaune", "value": "yellow"}, {"label": "Orange", "value": "orange"}, {"label": "Rouge", "value": "red"}, {"label": "Noir", "value": "black"}, {"label": "Bleu", "value": "blue"}, {"label": "Violet", "value": "purple"}, {"label": "Rose", "value": "pink"}, {"label": "Gris", "value": "gray-600"}]' as options, 3 as width;


