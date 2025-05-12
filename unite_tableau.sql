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
    'Détails des risques' as description,
    'orange' as color
    FROM unite WHERE id=$unite;

SELECT 
    'table' as component,
    'Niveau' as markdown,
    'Niveau' as align_center,
    'Responsables'  as markdown,
    'Détails' as markdown,
    'Actions' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE    as sort;
SELECT
    risque.id as _sqlpage_id,
    '[
    ![](/icons/alert-square-'||risque.color||'.svg)](risque.sql "'||score||'/'||(gravite*frequence*5)||'")' as Niveau,
    --lieu as Unité,
    nature as Risque,
    risque.description as Description,
    group_concat(coalesce(SUBSTR(prenom, 1, 1) ||'. '||nom,'--'), CHAR(10)||CHAR(10)) as Responsables,
    CASE WHEN coalesce((SELECT count(distinct id) from actions WHERE risque_id=risque.id),0)<2
    THEN coalesce((SELECT count(distinct id) from actions WHERE risque_id=risque.id),0)||' Fiche '||
    '[
    ![](/icons/eye.svg)
](risque_fiche.sql?id='||risque.id||')'
    ELSE (SELECT count(distinct id) from actions WHERE risque_id=risque.id)||' Fiches '||
     '[
    ![](/icons/eye.svg)
](risque_fiche.sql?id='||risque.id||')' END as Détails,
    CASE WHEN NOT EXISTS (SELECT risque.id FROM actions WHERE risque.id = actions.risque_id)
    THEN'[
    ![](../icons/pencil.svg)
](risque_fiche.sql?id='||risque.id||'&edit=1)
[
    ![](../icons/trash.svg)
](risque_delete.sql?risque='||risque.id||'&unite='||$unite||')'
    ELSE '[
    ![](../icons/pencil.svg)
](risque_fiche.sql?id='||risque.id||'&edit=1)' END as Actions
    FROM risque LEFT JOIN unite on risque.unite_id=unite.id LEFT JOIN risques on risque.type_id=risques.id LEFT JOIN actions on actions.risque_id=risque.id LEFT JOIN user_info on actions.responsable_id=user_info.username WHERE unite.id=$unite GROUP BY risque.id ORDER BY score DESC;
    
    
