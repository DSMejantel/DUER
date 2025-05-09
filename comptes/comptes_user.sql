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
-- Set a variable 
SET nom_edit = (SELECT nom FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SET prenom_edit = (SELECT prenom FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SET user_edit = (SELECT login_session.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SET tel_edit = (SELECT tel FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SET courriel_edit = (SELECT courriel FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
/*SELECT 'text' AS component,
$nom_edit as contents;*/

--Bouton retour sans valider
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Retour au tableau de bord' as title,
    'user.sql' as link,
    'arrow-back-up' as icon,
    'green' as outline;  
-- Rappel info user
SELECT 'text' AS component,
COALESCE((SELECT
    format('Connecté en tant que %s %s (Rappel de l''identifiant : %s)',
            user_info.prenom,
            user_info.nom,
            user_info.username)
    FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')
), 'Non connecté') AS contents;    

--- Formulaire de Mise à jour

SELECT 
    'form' as component,
    'comptes_user_confirm.sql?user_edit='||$user_edit as action,
    'Recommencer' as reset,
    'Mettre à jour' as validate;
    
    SELECT 'Nom' AS label, 'nom' AS name, 6 as width, $nom_edit as value;
    SELECT 'Prénom' AS label, 'prenom' AS name, 6 as width, $prenom_edit as value;
    SELECT 'Téléphone' AS label, 'tel' AS name, 6 as width, $tel_edit as value;
    SELECT 'Courriel' AS label, 'courriel' AS name, 6 as width, $courriel_edit as value;
  
 

