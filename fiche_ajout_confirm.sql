SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

--enregistrement de la fiche action
INSERT INTO actions(risque_id, titre, description, responsable_id, avancement, etat, creation, edition, rappel)
SELECT $id,:titre,:description,:resp,:av,coalesce(:ach,0),:creation,date('now'),coalesce(:rappel,0)



RETURNING
'redirect' as component,
'risque_fiche.sql?id='||$id as link;


