SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        './/index.sql?restriction' AS link
        WHERE $group_id<'3';

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('menu.json') AS properties;
--
-- Set variables 
SET nom_edit = (SELECT nom FROM user_info WHERE username = $id);
SET prenom_edit = (SELECT prenom FROM user_info WHERE username = $id);
SET group_edit = (SELECT groupe FROM user_info WHERE username = $id);
SET tel_edit = (SELECT tel FROM user_info WHERE username = $id);
SET courriel_edit = (SELECT courriel FROM user_info WHERE username = $id);

--Bouton retour sans valider
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Retour à la liste des comptes' as title,
    'comptes.sql' as link,
    'arrow-back-up' as icon,
    'green' as outline;  
/* 
-- En théorie l'administrateur ne devrait pas changer le mot de passe d'un utilisateur et ne devrait pas le connaître.
-- Cela reste techniquement possible en réactivant le bloc ci-dessous.
select 
    'Changer le mot de passe' as title,
    'comptes_edit_password.sql?id='||$id as link,
    'lock' as icon,
    'red' as outline;
*/  
select 
    'Nouveau code d''activation' as title,
    'comptes_edit_activation.sql?id='||$id as link,
    'lock' as icon,
    'red' as outline; 

-- Rappel du Compte concerné par la modification
SELECT 
    'alert' as component,
    'Alerte' as title,
    'Visualiser les changements opérés' as description,
    'alert-triangle' as icon,
    'green' as color;
    
SELECT 'table' as component;
SELECT 
  username as Identifiant,
  nom AS Nom,
  prenom AS Prénom,
  tel as Téléphone,
  courriel as courriel
FROM user_info WHERE username=$id; 
    
--- Formulaire de Mise à jour
SELECT 
    'form' as component,
    'comptes_edit_confirm.sql?id='||$id as action,
    'Mettre à jour' as validate,
    'orange'           as validate_color;
    SELECT 'Nom' AS label, 'nom' AS name, $nom_edit as value, 4 as width;
    SELECT 'Prénom' AS label, 'prenom' AS name, $prenom_edit as value, 4 as width;
    SELECT 'Téléphone' AS label, 'tel' AS name, $tel_edit as value, 4 as width;
    SELECT 'Courriel' AS label, 'courriel' AS name, $courriel_edit as value, 4 as width;
    SELECT 'Droits :' AS label, 'groupe' AS name, 'select' as type,
    '[{"label": "Consultation", "value": 1}, {"label": "Édition", "value": 2}, {"label": "Administrateur", "value": 3}]' as options,
 4 as width;


 
   
 

