SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));


--Mise à jour de la fiche action
UPDATE actions SET titre=:titre, description=:description, responsable_id=:resp, avancement=:av, etat=coalesce(:ach,0), creation=:creation WHERE id=$fiche

RETURNING
'redirect' as component,
'risque_fiche.sql?id='||$id as link;


