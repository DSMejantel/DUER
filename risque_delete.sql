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
    'Niveau' as markdown,
    'Niveau' as align_center,
    'Actions' as markdown,
    'Veuillez confirmer la suppression de ce risque ou annuler cette action.' as description,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE as sort;
SELECT
    '[
    ![](/icons/alert-square-'||risque.color||'.svg)](risque.sql "'||score||'/'||(gravite*frequence*5)||'")' as Niveau,
    lieu as Unité,
    nature as Risque,
    risque.description as Description,
    '
[
    ![](../icons/trash.svg)
](risque_delete_confirm.sql?risque='||$risque||'&unite='||$unite||' "Confirmer la suppression")
[
    ![](../icons/arrow-back.svg)
](unite_tableau.sql?unite='||$unite||'#'||$risque||' "Annuler la suppression")' as Actions
    FROM risque LEFT JOIN unite on risque.unite_id=unite.id LEFT JOIN risques on risque.type_id=risques.id  WHERE risque.id=$risque;


