SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));


--Mise à jour de la fiche action
DELETE FROM risque_agent WHERE risque_id=$risque;
DELETE FROM risque WHERE id=$risque

RETURNING
'redirect' as component,
'unite_tableau.sql?unite='||$unite as link;


