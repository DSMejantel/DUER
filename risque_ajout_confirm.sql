SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));


SET score=(:freq)*(:grav)*5;

SET color = (SELECT color FROM seuils WHERE $score>smin and $score<=smax); 

/*
SET color='green' WHERE CAST($score AS INTEGER)<25;
SET color='yellow' WHERE CAST($score AS INTEGER)>=25 AND CAST($score AS INTEGER)<50;
SET color='orange' WHERE CAST($score AS INTEGER)>=50 AND CAST($score AS INTEGER) <75;
SET color='red' WHERE CAST($score AS INTEGER)>=75;
*/
--enregistrement du risque
INSERT INTO risque(unite_id, type_id, description, gravite, frequence, maitrise, score, color, creation)
SELECT $id,:type,:description,:grav,:freq,4,$score,$color,:creation;


-- enregistrement des agents dans une table différente
INSERT INTO risque_agent(risque_id,agent_id)
SELECT
     (SELECT last_insert_rowid() FROM risque) as risque_id, 
     CAST(value AS INTEGER) as agent_id from json_each(:agent)

RETURNING
'redirect' as component,
'unite.sql' as link;


