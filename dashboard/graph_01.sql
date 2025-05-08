select 
    'chart'    as component,
    'Risques recensés' as title,
    'bar'      as type,
    350 as height,
    TRUE       as stacked,
    TRUE       as toolbar,
    10         as ystep,
    CASE WHEN EXISTS (SELECT color FROM risque WHERE color=(SELECT color FROM seuils WHERE id=4)) THEN (SELECT color FROM seuils WHERE id=4) END as color,
    CASE WHEN EXISTS (SELECT color FROM risque WHERE color=(SELECT color FROM seuils WHERE id=3)) THEN (SELECT color FROM seuils WHERE id=3) END as color,
    CASE WHEN EXISTS (SELECT color FROM risque WHERE color=(SELECT color FROM seuils WHERE id=2)) THEN (SELECT color FROM seuils WHERE id=2) END as color,
    CASE WHEN EXISTS (SELECT color FROM risque WHERE color=(SELECT color FROM seuils WHERE id=1)) THEN (SELECT color FROM seuils WHERE id=1) END as color;

select 
    seuil as series,
    lieu  as x,
    coalesce(count(distinct risque.id),0) as value
    FROM risque LEFT JOIN unite on risque.unite_id=unite.id LEFT JOIN seuils on seuils.color=risque.color GROUP BY seuil,unite_id ORDER BY seuils.id DESC;
