select 
    'chart'   as component,
    'Fiches actions' as title,
    'pie'     as type,
    'orange' as color,
    'green' as color,
    TRUE      as labels;
select 
    CASE WHEN etat=1 THEN 'Terminés' WHEN etat=0 THEN 'en cours' END as label,
    count(distinct etat)    as value
    FROM actions GROUP BY etat;
