SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

-- Calculs suite à réévaluation du risque
UPDATE risque SET maitrise=:maitr WHERE risque.id=$id and :maj=2;
UPDATE risque SET score=gravite*frequence*5/4*maitrise WHERE risque.id=$id and :maj=2;
SET score=(SELECT score FROM risque WHERE risque.id=$id and :maj=2);
UPDATE risque SET color = (SELECT color FROM seuils WHERE $score>smin and $score<=smax) WHERE risque.id=$id and :maj=2;
-- Calculs suite à mise à jour
UPDATE risque SET type_id=:type, description=:description, gravite=:grav, frequence=:freq WHERE id=$id and :edit=0;
UPDATE risque SET score=gravite*frequence*5/4*maitrise WHERE risque.id=$id and :edit=0;
SET score=(SELECT score FROM risque WHERE risque.id=$id and :edit=0);
UPDATE risque SET color = (SELECT color FROM seuils WHERE $score>=smin and $score<=smax) WHERE risque.id=$id and :edit=0;
DELETE FROM risque_agent WHERE risque_id=$id  and :edit=0;
INSERT INTO risque_agent(risque_id,agent_id)
SELECT  $id, CAST(value AS INTEGER) as agent_id from json_each(:agent) WHERE :edit=0;

--
select 
    'columns' as component;
select 
    4 as size,
    UPPER(nature) as description_md,
    lieu as title,
    json_group_array(json_object(
      'icon', 'user',
      'color', color,
      'description', agent.categorie
    )) as item,
    color               as button_color,
    'fiche_action_ajout.sql?id='||$id as link,
    'Ajouter une fiche action'     as button_text
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id JOIN risque_agent on risque.id=risque_agent.risque_id JOIN agent on risque_agent.agent_id=agent.id WHERE risque.id=$id;
select 
    4 as size,
    'Évaluation' as title,
    JSON('{"icon":"files","color":"black","description":"Description : '||description||'"}') as item,
    JSON('{"icon":"ambulance","color":"'||(CASE WHEN gravite=1 THEN 'green' WHEN gravite=2 THEN 'yellow' WHEN gravite=3 THEN 'orange' ELSE 'red' END)||'","description":"Gravité : '||grav||'"}') as item,
    JSON('{"icon":"activity","color":"'||(CASE WHEN frequence<2 THEN 'green' WHEN gravite=2 THEN 'yellow' WHEN gravite=3 THEN 'orange' ELSE 'red' END)||'","description":"Probabilité : '||freq||'"}') as item,
    JSON('{"icon":"brand-speedtest","color":"'||(CASE WHEN maitrise=1 THEN 'green' WHEN maitrise=2 THEN 'yellow' WHEN maitrise=3 THEN 'orange' ELSE 'red' END)||'","description":"Maîtrise : '||maitr||'"}') as item,
    --'Description : '||description as item,
    --'Gravité : '||grav as item,
    --'Probabilité : '||freq as item,
    --'Maîtrise : '||maitr as item,
    color               as button_color,
    'risque_fiche.sql?id='||$id||'&edit=1' as link,
    'Modifier'     as button_text
    FROM risque JOIN frequence on risque.frequence=frequence.vfreq JOIN gravite on risque.gravite=gravite.vgrav JOIN maitrise on risque.maitrise=maitrise.vmaitr WHERE risque.id=$id;
select 
    4 as size,
    'Niveau de maîtrise du risque : '             as title,
    score                  as value,
    'alert-triangle'               as icon,
    'risque_fiche.sql?id='||$id||'&maj=1' as link,
    'Réévaluer le niveau'     as button_text,
    color               as icon_color,
    color               as button_color,
    color               as value_color,
    '/100'               as small_text
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id;

/*
SELECT 
    'alert'     as component,
    UPPER(lieu)||' / Risque : '||UPPER(nature) as title,
    description as description_md,
    'github' as color
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id;

SELECT 
    'alert'     as component,
    'Niveau de maîtrise du risque : '||score||'/100' as title,
    'alert-triangle' as icon,
    color as color,
    description as description_md
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id; 

 
SELECT 
    'button' as component;
SELECT 
    'fiche_action_ajout.sql?id='||$id     as link,
    'green' as outline,
    'Ajouter une fiche action'  as title,
    'circle-plus'  as icon;
SELECT 
    'risque_fiche.sql?id='||$id||'&maj=1'     as link,
    'green' as outline,
    'Réévaluer le niveau'  as title,
    'status-change'  as icon;
*/
select 'divider' as component,
    CASE WHEN $edit=1 THEN 'Mise à jour' WHEN $maj=1 THEN 'Nouvelle évaluation' ELSE 'Fiches ACTIONS' END as contents;    
-- formulaire modification fiche
SELECT 
    'form' as component,
    --'Mise à jour :' as title,
    'Mettre à jour' as validate,
    'risque_fiche.sql?id='||$id||'&edit=0' as action,
    'green' as validate_color WHERE $edit=1;

    SELECT 'Catégorie' AS label, 'type' AS name, 'select' as type, 8 as width, (SELECT risque.type_id FROM risque WHERE risque.id=$id) as value, json_group_array(json_object("label" , nature, "value", id )) as options FROM (select nature,id FROM risques ORDER BY nature ASC);
   
    SELECT 'Gravité' AS label, 'grav' AS name, 'select' as type, 2 as width, (SELECT risque.gravite FROM risque WHERE risque.id=$id) as value, json_group_array(json_object("label" , grav, "value", vgrav )) as options FROM (select grav,vgrav FROM gravite ORDER BY vgrav ASC) WHERE $edit=1;
    
    SELECT 'Probabilité' AS label, 'freq' AS name, 'select' as type, 2 as width,(SELECT risque.frequence FROM risque WHERE risque.id=$id) as value, json_group_array(json_object("label" , freq, "value", vfreq )) as options FROM (select freq,vfreq FROM frequence ORDER BY vfreq ASC) WHERE $edit=1;
    
    SELECT TRUE as required, 'description' as name,(SELECT description FROM risque WHERE risque.id=$id) as value,  'Description' as label, 8 as width WHERE $edit=1;

    SELECT TRUE as required, 'Agent(s) concerné(s)' AS label, 'agent[]' AS name, 'select' as type, 4 as width, TRUE as multiple, TRUE as dropdown, json_group_array(json_object("label" , categorie, "value", id,
     'selected', risque_agent.agent_id is not null)) as options FROM agent LEFT JOIN risque_agent on risque_agent.agent_id=agent.id AND risque_id=$id WHERE $edit=1 ORDER BY categorie ASC;
         
    SELECT 'hidden'    as type, 'edit' AS name, 0 as value  WHERE $edit=1;

select 'text' as component;   
-- formulaire MAJ niveau de risque  
SELECT 
    'form' as component,
    --'Nouvelle évaluation :' as title,
    TRUE   as auto_submit WHERE $maj=1;
SELECT 
    'select'    as type,
    'Maîtrise' AS label, 'maitr' AS name, 3 as width,(SELECT CAST(risque.maitrise as integer) FROM risque WHERE risque.id=$id) as value, json_group_array(json_object("label" , maitr, "value", vmaitr)) as options FROM (select maitr,vmaitr FROM maitrise ORDER BY vmaitr ASC)  WHERE $maj=1;
SELECT 
    'hidden'    as type,
    'maj' AS name, 2 as value  WHERE $maj=1;

select 'title' as component,
     --'Fiches ACTIONS :' as contents;   
      2 as level;
SELECT 
    'table' as component,
    'État' as markdown,
    'Fin' as markdown,
    'Actions' as markdown,
    'Description' as markdown,
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
    '[
    ![](/icons/arrow-back.svg)
](/avancement/recule.sql?id='||id||'&risque='||$id||' "Reculer dans le processus")
     [![](/icons/percentage-'||avancement||'.svg)](risque_fiche.sql?id='||$id||' "'||avancement||'%")
     [
    ![](/icons/arrow-forward.svg)
](/avancement/avance.sql?id='||id||'&risque='||$id||' "Avancer dans le processus")' as État,
    CASE WHEN etat=1
    THEN '[
    ![](./icons/select.svg)
](/avancement/ouvert.sql?id='||id||'&risque='||$id||')' 
ELSE '[
    ![](./icons/square.svg)
](/avancement/ferme.sql?id='||id||'&risque='||$id||')' 
END as Fin,
    '[
    ![](../icons/pencil.svg)
](action_edit.sql?id='||$id||'&fiche='||id||')
[
    ![](../icons/trash.svg)
](action_delete.sql?id='||$id||'&fiche='||id||')
[
    ![](../icons/eye.svg)
](action_view.sql?id='||$id||'&fiche='||id||')' as Actions
    FROM actions JOIN user_info on actions.responsable_id=user_info.username WHERE risque_id=$id;
    
    
