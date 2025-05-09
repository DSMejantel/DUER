SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

select 
    'columns' as component;
select 
    lieu as title, 4 as size,
    '[![Risque](/icons/circle-plus.svg)](risque_ajout.sql?id='||unite.id||' "Ajouter") Ajouter un risque'||CHAR(10) || CHAR(10)  as description_md,
    group_concat('[!['||description||'](/icons/alert-square-'||risque.color||'.svg)](risque_fiche.sql?id='||risque.id||' "'||risque.score||'/100")[!['||description||'](/icons/files.svg)](risque_fiche.sql?id='||risque.id||' "'||description||'")'||risques.nature,  CHAR(10) || CHAR(10) ORDER BY score DESC) as description_md,

    'unite_tableau.sql' as link,
    'Détails'     as button_text
    FROM unite LEFT JOIN risque on unite.id=risque.unite_id LEFT JOIN risques on risque.type_id=risques.id LEFT JOIN maitrise on risque.maitrise=maitrise.id GROUP by unite.id;

/*select 
    'foldable' as component;
select 
    lieu as title,
    unite.id as id,
    '[![Risque](/icons/circle-plus.svg)](risque_ajout.sql?id='||unite.id||' "Ajouter") Ajouter [![Détails](/icons/eye.svg)](unite_tableau.sql?id='||unite.id||' "Tableau complet") Tableau'||  CHAR(10) || CHAR(10)||
    group_concat('RISQUE : '||risques.nature||' --> maîtrise : '||maitrise.maitr||'[!['||description||'](/icons/eye.svg)](risque_fiche.sql?id='||risque.id||' "'||description||'")',  CHAR(10) || CHAR(10)) as description_md
    FROM unite LEFT JOIN risque on unite.id=risque.unite_id LEFT JOIN risques on risque.type_id=risques.id LEFT JOIN maitrise on risque.maitrise=maitrise.id GROUP by unite.id;
*/
