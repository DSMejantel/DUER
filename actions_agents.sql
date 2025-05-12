SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;


--Choix
SELECT 
    'form' as component,
    TRUE   as auto_submit;
SELECT 
    'select'    as type,
    'Catégorie d''agent :' AS label, 'cat' AS name, 'Choisir' as empty_option, json_group_array(json_object("label" , categorie, "value", id)) as options FROM agent ORDER BY categorie ASC;

-- Titre
select 'divider' as component,
     'Fiches-actions pour : '||categorie as contents
     FROM agent WHERE id=:cat;  

-- Résultat
SELECT 
    'table' as component,
    'Aucune information à afficher pour le moment' as empty_description,
    'Description'  as markdown,
    'État' as markdown,
    'Fin' as markdown,
    'Éditer' as markdown,
    'Rappel' as markdown,
    'Rappel' as align_center,
    'Risque' as markdown,
    'Agents' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE as sort;
SELECT
    actions.id as _sqlpage_id,
    actions.creation as Date,
    lieu as Unité,
    titre as Titre,
    actions.description as Description,
    --group_concat(categorie, CHAR(10)||CHAR(10)) as Agents,
    (SELECT '[
    ![](/icons/alert-square-'||risque.color||'.svg)](risque.sql "'||score||'/100")' FROM risque WHERE risque.id=actions.risque_id) as Risque,
    SUBSTR(prenom, 1, 1) ||'. '||nom as Responsable,
    '[
    ![](/icons/percentage-'||avancement||'.svg)]()
     ' as État,
    CASE WHEN etat=1
    THEN '[
    ![](/icons/select.svg)
](/avancement/ouvert.sql?id='||actions.id||'&risque='||actions.risque_id||')' 
ELSE '[
    ![](/icons/square.svg)
](/avancement/ferme.sql?id='||actions.id||'&risque='||actions.risque_id||')' 
END as Fin,
    CASE WHEN rappel=1  and edition>datetime(date('now','-365 day'))
    THEN '[
    ![](/icons/bell.svg)
]()' 
    WHEN rappel=1 and edition<datetime(date('now','-365 day')) 
    THEN '[
    ![](/icons/bell-ringing.svg)
]()' END as Rappel,
    '[
    ![](/icons/eye.svg)
](risque_fiche.sql?id='||actions.risque_id||' "Voir la fiche risque")
    [
    ![](/icons/pencil.svg)
](action_edit.sql?id='||actions.id||'&risque='||actions.risque_id||' "Éditer")' as Éditer
    FROM actions LEFT JOIN user_info on actions.responsable_id=user_info.username LEFT JOIN risque on actions.risque_id=risque.id  LEFT JOIN unite on risque.unite_id=unite.id LEFT JOIN risque_agent on risque_agent.risque_id=risque.id LEFT JOIN agent on agent.id=risque_agent.agent_id WHERE agent.id=$cat GROUP BY actions.id;
