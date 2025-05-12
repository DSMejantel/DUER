SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

SELECT 
    'alert'     as component,
    'Risque : '||UPPER(nature) as title,
    lieu||CHAR(10) || CHAR(10)||description as description_md,
    color as color
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id;
    
SELECT 
    'alert'     as component,
    'Création d''une fiche action' as description,
    TRUE as important,
    'edit' as icon,
    'green' as color;
    
-- formulaire
SELECT 
    'form'            as component,
    'Enregistrer' as validate,
    'fiche_ajout_confirm.sql?id='||$id as action,
    'green'           as validate_color;

    SELECT  TRUE as required, 'Date' AS label, 'creation' AS name, 'date' as type, (select date('now')) as value, 3 as width;
    SELECT TRUE as required, 'titre' as name, 'Titre' as label, 9 as width;
    SELECT 'description' as name, 'Description' as label, 'textarea' as type, 12 as width;
    SELECT TRUE as required, 'Responsable' AS label, 'resp' AS name, 'select' as type, 3 as width, 'Choisir' as empty_option, json_group_array(json_object("label" , prenom||' '||nom, "value", username )) as options FROM (select * FROM user_info WHERE username<>'duer_admin' ORDER BY nom ASC);
    SELECT TRUE as required, 'Avancement' AS label, 'av' AS name, 'select' as type, 2 as width, 'Choisir' as empty_option, '[{"label": "0 %", "value": 0}, {"label": "10 %", "value": 10}, {"label": "20 %", "value": 20},{"label": "30 %", "value": 30}, {"label": "40 %", "value": 40}, {"label": "50 %", "value": 50}, {"label": "60 %", "value": 60}, {"label": "70 %", "value": 70},{"label": "80 %", "value": 80}, {"label": "90 %", "value": 90}, {"label": "100 %", "value": 100}]'  as options;
    SELECT 'Achèvement' AS label, 'ach' AS name, 2 as width, 'checkbox' as type, 1 as value;
    SELECT 'Rappel' AS label, 'rappel' AS name, 2 as width, 'checkbox' as type, 1 as value;
