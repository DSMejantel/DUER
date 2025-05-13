select 
    'big_number' as component,
    1 as columns;
select 
    'Niveau de départ'           as title,
    ROUND(AVG(gravite*frequence*5),1)  as value,
    '%'               as unit,
    'red' as color
    FROM risque;
select 
    'Niveau d''arrivée'           as title,
    ROUND(AVG(score),1)  as value,
    '%'               as unit,
    'Gain sur la maîtrise des risques : ' as description,
    ROUND(((AVG(gravite*frequence*5))-AVG(score)),1)           as change_percent,
    (100-((AVG(score))*100/(AVG(gravite*frequence*5))))       as progress_percent,
    'green'  as progress_color,
    'green' as color
    FROM risque;
