select 
    'chart'   as component,
    'Fiches actions' as title,
    'pie'     as type,
    200 as height,
    'orange' as color,
    'green' as color;
select 
    CASE WHEN etat=1 THEN 'Terminées' WHEN etat=0 THEN 'En cours' END as label,
    count(etat)    as value
    FROM actions GROUP BY etat;
