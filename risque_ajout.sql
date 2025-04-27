SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

SELECT 
    'alert'     as component,
    lieu as title,
    'Création d''une évaluation de risque' as description,
    'orange' as color
    FROM unite WHERE id=$id;
    
-- formulaire
SELECT 
    'form'            as component,
    'Enregistrer' as validate,
    'risque_ajout_confirm.sql?id='||$id as action,
    'green'           as validate_color;

    SELECT  TRUE as required, 'Date' AS label, 'creation' AS name, 'date' as type, (select date('now')) as value, 3 as width;
    SELECT TRUE as required, 'Catégorie' AS label, 'type' AS name, 'select' as type, 9 as width, 'Choisir la nature du risque' as empty_option, json_group_array(json_object("label" , nature, "value", id )) as options FROM (select * FROM risques ORDER BY nature ASC);
    SELECT TRUE as required, 'description' as name, 'Description' as label, 12 as width;
        SELECT TRUE as required, 'Gravité' AS label, 'grav' AS name, 'select' as type, 2 as width, 'Choisir' as empty_option, json_group_array(json_object("label" , grav, "value", vgrav )) as options FROM (select * FROM gravite ORDER BY vgrav ASC);
        SELECT TRUE as required, 'Fréquence' AS label, 'freq' AS name, 'select' as type, 2 as width, 'Choisir' as empty_option, json_group_array(json_object("label" , freq, "value", vfreq )) as options FROM (select * FROM frequence ORDER BY vfreq ASC);
        SELECT  TRUE as readonly,'Maîtrise' AS label, 'maitr' AS name, 2 as width, maitr as value FROM maitrise where vmaitr=4;
    SELECT TRUE as required, 'Agent(s) concerné(s)' AS label, 'agent[]' AS name, 'select' as type, 6 as width, TRUE as multiple, TRUE as dropdown, 'Choisir' as empty_option, json_group_array(json_object("label" , categorie, "value", id)) as options FROM agent ORDER BY categorie ASC;
