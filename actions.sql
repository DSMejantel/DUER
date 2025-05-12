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
    'table' as component,
    'Description'  as markdown,
    'État' as markdown,
    'Fin' as markdown,
    'Éditer' as markdown,
    'Risque' as markdown,
    'Rappel' as markdown,
    'Rappel' as align_center,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE as sort;
SELECT
    actions.id as _sqlpage_id,
    actions.creation as Date,
    titre as Titre,
    actions.description as Description,
    (SELECT '[
    ![](/icons/alert-square-'||risque.color||'.svg)](risque.sql "'||risque.score||'/'||(gravite*frequence*5)||'")' FROM risque WHERE risque.id=actions.risque_id) as Risque,
    SUBSTR(prenom, 1, 1) ||'. '||nom as Responsable,
    '[
    ![](/icons/percentage-'||avancement||'.svg)]()
     ' as État,
    CASE WHEN etat=1
    THEN '[
    ![](./icons/select.svg)
](/avancement/ouvert.sql?id='||actions.id||'&risque='||risque_id||')' 
ELSE '[
    ![](./icons/square.svg)
](/avancement/ferme.sql?id='||actions.id||'&risque='||risque_id||')' 
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
](risque_fiche.sql?id='||actions.risque_id||' "Voir la fiche risque")[
    ![](../icons/pencil.svg)
](action_edit.sql?id='||risque_id||'&fiche='||actions.id||')' as Éditer
    FROM actions LEFT JOIN user_info on actions.responsable_id=user_info.username LEFT JOIN risque on actions.risque_id=risque.id;
