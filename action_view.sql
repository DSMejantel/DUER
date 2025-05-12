SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

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
    JSON('{"icon":"activity","color":"'||(CASE WHEN frequence<2 THEN 'green' WHEN frequence=2 THEN 'yellow' WHEN frequence=3 THEN 'orange' ELSE 'red' END)||'","description":"Probabilité : '||freq||'"}') as item,
    JSON('{"icon":"brand-speedtest","color":"'||(CASE WHEN maitrise=1 THEN 'green' WHEN maitrise=2 THEN 'yellow' WHEN maitrise=3 THEN 'orange' ELSE 'red' END)||'","description":"Maîtrise : '||maitr||'"}') as item,
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
    '/'||(gravite*frequence*5) as small_text
    FROM risque JOIN risques on risque.type_id=risques.id JOIN unite on risque.unite_id=unite.id WHERE risque.id=$id;

SELECT 
    'table' as component,
    'État' as markdown,
    'Fin' as markdown,
    'Actions' as markdown,
    'Description' as markdown,
    'Rappel' as markdown,
    'Rappel' as align_center,
    TRUE    as small;
SELECT
    creation as Date,
    titre as Titre,
    --description as Description,
    SUBSTR(prenom, 1, 1) ||'. '||nom as Responsable,
    '[
    ![](/icons/arrow-back.svg)
](/avancement/view_recule.sql?id='||$id||'&fiche='||id||' "Reculer dans le processus")
     [![](/icons/percentage-'||avancement||'.svg)](risque_fiche.sql?id='||$id||' "'||avancement||'%")
     [
    ![](/icons/arrow-forward.svg)
](/avancement/view_avance.sql?id='||$id||'&fiche='||id||' "Avancer dans le processus")' as État,
    CASE WHEN etat=1
    THEN '[
    ![](./icons/select.svg)
](/avancement/view_ouvert.sql?id='||$id||'&fiche='||id||')' 
ELSE '[
    ![](./icons/square.svg)
](/avancement/view_ferme.sql?id='||$id||'&fiche='||id||')' 
END as Fin,
    '[
    ![](../icons/pencil.svg)
](action_edit.sql?id='||$id||'&fiche='||id||')
[
    ![](../icons/files.svg)
](risque_fiche.sql?id='||$id||')' as Actions,
    CASE WHEN rappel=1  and edition>datetime(date('now','-365 day'))
    THEN '[
    ![](/icons/bell.svg)
]()' 
    WHEN rappel=1 and edition<datetime(date('now','-365 day')) 
    THEN '[
    ![](/icons/bell-ringing.svg)
]()' END as Rappel
    FROM actions JOIN user_info on actions.responsable_id=user_info.username WHERE id=$fiche;
    
select 'text' as component;
select
    TRUE as italics,
    'Dernière modification le : '||strftime('%d/%m/%Y',edition) as contents
    FROM actions WHERE id=$fiche;
select 'text' as component,
    true as article,
    description as contents_md
    FROM actions WHERE id=$fiche;
