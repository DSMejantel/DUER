SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        './/index.sql?restriction' AS link
        WHERE $group_id<'3';

UPDATE seuils SET color=:c1 WHERE id=1;
UPDATE seuils SET color=:c2 WHERE id=2;
UPDATE seuils SET color=:c3 WHERE id=3;
UPDATE seuils SET color=:c4 WHERE id=4;


UPDATE risque SET color = (SELECT seuils.color FROM seuils WHERE score>smin and score<=smax)

RETURNING 
'redirect' as component,
'risque.sql' as link;
