SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

--
select 
    'columns' as component;
select 
    4 as size,
    UPPER(nature) as description_md,
    lieu as title,
    json_group_array(json_object(
      'icon', 'user',
      'color', color,
      'description', agent.categorie
    )) as item,
    color               as button_color,
    'fiche_action_ajout.sql?id='||$id as link,
    'Ajouter une fiche action'     as button_text
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id JOIN risque_agent on risque.id=risque_agent.risque_id JOIN agent on risque_agent.agent_id=agent.id WHERE risque.id=$id;
select 
    4 as size,
    'Évaluation' as title,
    'Description : '||description as item,
    'Gravité : '||grav as item,
    'Fréquence : '||freq as item,
    'Maîtrise : '||maitr as item,
    color               as button_color,
    'risque_fiche.sql?id='||$id||'&edit=1' as link,
    'Modifier'     as button_text
    FROM risque JOIN frequence on risque.frequence=frequence.vfreq JOIN gravite on risque.gravite=gravite.vgrav JOIN maitrise on risque.maitrise=maitrise.vmaitr WHERE risque.id=$id;
select 
    4 as size,
    'Niveau de maîtrise du risque : '             as title,
    score                  as value,
    'alert-triangle'               as icon,
    'risque_fiche.sql?id='||$id||'&maj=1' as link,
    'Réévaluer le niveau'     as button_text,
    color               as icon_color,
    color               as button_color,
    color               as value_color,
    '/100'               as small_text
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id;

SELECT 
    'table' as component,
    'État' as markdown,
    'Fin' as markdown,
    'Description' as markdown,
    TRUE    as small;
SELECT
    creation as Date,
    titre as Titre,
    description as Description,
    SUBSTR(prenom, 1, 1) ||'. '||nom as Responsable,
    '[
    ![](/icons/percentage-'||avancement||'.svg)]()
     ' as État,
    CASE WHEN etat=1
    THEN '[
    ![](./icons/select.svg)
]()' 
ELSE '[
    ![](./icons/square.svg)
]()' 
END as Fin
    FROM actions JOIN user_info on actions.responsable_id=user_info.username WHERE id=$fiche;
    
-- formulaire modification fiche action
SELECT 
    'form' as component,
    'Mise à jour :' as title,
    'Mettre à jour' as validate,
    'action_edit_confirm.sql?id='||$id||'&fiche='||$fiche as action,
    'green' as validate_color;
SELECT  TRUE as required, 'Date' AS label, 'creation' AS name, 'date' as type, (select creation FROM actions WHERE id=$fiche) as value, 3 as width;
    SELECT TRUE as required, 'titre' as name, 'Titre' as label, (select titre FROM actions WHERE id=$fiche) as value, 9 as width;
    SELECT TRUE as required, 'description' as name, 'Description' as label, 'textarea' as type, (select description FROM actions WHERE id=$fiche) as value,12 as width;
    SELECT TRUE as required, 'Responsable' AS label, 'resp' AS name, 'select' as type, 4 as width, (SELECT responsable_id FROM actions WHERE id=$fiche) as value, json_group_array(json_object("label" , prenom||' '||nom, "value", username )) as options FROM (select * FROM user_info WHERE username<>'duer_admin' ORDER BY nom ASC);
    SELECT TRUE as required, 'Avancement' AS label, 'av' AS name, 'select' as type, 3 as width, (select avancement FROM actions WHERE id=$fiche) as value, '[{"label": "0 %", "value": 0}, {"label": "10 %", "value": 10}, {"label": "20 %", "value": 20},{"label": "30 %", "value": 30}, {"label": "40 %", "value": 40}, {"label": "50 %", "value": 50}, {"label": "60 %", "value": 60}, {"label": "70 %", "value": 70},{"label": "80 %", "value": 80}, {"label": "90 %", "value": 90}, {"label": "100 %", "value": 100}]'  as options;
    SELECT 'Achèvement' AS label, 'ach' AS name, etat=1 as checked, 1 as value,2 as width, 'checkbox' as type FROM actions WHERE id=$fiche;  
