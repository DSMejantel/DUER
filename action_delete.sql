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
    'État' as markdown,
    'Fin' as markdown,
    'Actions' as markdown,
    'Description' as markdown,
    'Veuillez confirmer la suppression de cette fiche ou l''annuler.' as description,
    'Aucune fiche saisie' as empty_description,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE as sort;
SELECT
    id as _sqlpage_id,
    creation as Date,
    titre as Titre,
    --description as Description,
    SUBSTR(prenom, 1, 1) ||'. '||nom as Responsable,
    '
[
    ![](../icons/trash.svg)
](action_delete_confirm.sql?id='||$id||'&fiche='||id||' "Confirmer la suppression")
[
    ![](../icons/arrow-back.svg)
](risque_fiche.sql?id='||$id||' "Annuler la suppression")' as Actions
    FROM actions JOIN user_info on actions.responsable_id=user_info.username WHERE risque_id=$id and id=$fiche;


