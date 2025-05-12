--Variables 
set alerte=SELECT count(distinct id) FROM actions WHERE rappel=1 and edition<datetime(date('now','-365 day'));
set suivi= SELECT 1 FROM actions WHERE rappel=1 and edition>datetime(date('now','-365 day'));

-- Message
select 
    'alert'              as component,
    'Alerte'              as title,
    CASE WHEN $alerte>1 THEN $alerte||' Actions en retard' ELSE $alerte||' Action en retard' END as description,
    'bell-ringing'       as icon,
    CASE WHEN $alerte>0 THEN 'red' ELSE 'green' END as color;
select 
    '/actions_alerte.sql?info=1'    as link,
    'En retard' as title,
    'red'    as color where $alerte>0;
select 
    '/actions_alerte.sql?info=2'    as link,
    'À suivre' as title,
    'orange'    as color
    WHERE $suivi=1;
select 
    '/actions_alerte.sql?info=3'    as link,
    'En cours' as title,
    'yellow'    as color;
