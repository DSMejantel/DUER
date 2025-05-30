SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

 UPDATE actions SET etat=1 WHERE id=$fiche;
 UPDATE actions SET avancement=100 WHERE id=$fiche
 RETURNING 
 'redirect' as component,
 '../action_view.sql?id='||$id||'&fiche='||$fiche as link;
