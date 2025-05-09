SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

--Choix de maîtrise du risque
SELECT 
    'form' as component,
    TRUE   as auto_submit;
SELECT 
    'select'    as type,
    'Niveau de maîtrise :' AS label, 'maitrise' AS name, 'Choisir...' as empty_option, json_group_array(json_object("label" , maitr, "value", vmaitr)) as options FROM maitrise ORDER BY id ASC;

-- Titre
select 'divider' as component,
     'Niveau de maîtrise : '||maitr as contents
     FROM maitrise WHERE vmaitr=:maitrise;  

-- Légende       
SELECT 
    'alert'     as component,
    'Légende :' as title,
    TRUE as dismissible,
    (SELECT group_concat('!['||seuil||'](/icons/alert-square-'||color||'.svg)'||seuil) FROM seuils) as description_md,
    'gray-700' as color;
     
        
--Tableau
select 
    'table' as component,
    'Évaluation en fonction de la probabilité et de la gravité du risque et de sa maîtrise' as description,
    'Mineure' as markdown,
    'Significative' as markdown,
    'Grave' as markdown,
    'Critique' as markdown,
    'Mineure' as align_center,
    'Significative' as align_center,
    'Grave' as align_center,
    'Critique' as align_center,
        'Probabilité' as align_right,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE as border,
    TRUE    as small;
select 
    freq as Probabilité,
    '[
    ![](/icons/alert-square-'||(SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4))<=smax)||'.svg)](risque.sql "'||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4))||'/100")' as Mineure,
    '[
    ![](/icons/alert-square-'||(SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4))<=smax)||'.svg)](risque.sql "'||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4))||'/100")' as Significative,
    '[
    ![](/icons/alert-square-'||(SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4))<=smax)||'.svg)](risque.sql "'||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4))||'/100")' as Grave,
    '[
    ![](/icons/alert-square-'||(SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4))<=smax)||'.svg)](risque.sql "'||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4))||'/100")' as Critique
    FROM frequence; 
/*    
--Tableau
select 
    'table' as component,
    'Évaluation en fonction de la fréquence et gravité du risque et de sa maîtrise' as description,
    'Mineure' as markdown,
    'Significative' as markdown,
    'Grave' as markdown,
    'Critique' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small;
select 
    freq as Fréquence,
    (SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4))<=smax)||' '||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4)) as Mineure,
    (SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4))<=smax)||' '||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4)) as Significative,
     (SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4))<=smax)||' '||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4)) as Grave,
     (SELECT seuils.color FROM seuils WHERE ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4))>smin and ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4))<=smax)||' '||ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4)) as Critique
    FROM frequence;

    
--Tableau
select 
    'table' as component,
    'Évaluation en fonction de la fréquence et gravité du risque et de sa maîtrise' as description,
    'Mineure' as markdown,
    'Significative' as markdown,
    'Grave' as markdown,
    'Critique' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small;
select 
    freq as Fréquence,
    ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=1)*(:maitrise)/4)) as Mineure,
    ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=2)*(:maitrise)/4)) as Significative,
    ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=3)*(:maitrise)/4)) as Grave,
    ROUND((vfreq*5*(SELECT vgrav FROM gravite WHERE id=4)*(:maitrise)/4)) as Critique
    FROM frequence;   
*/
