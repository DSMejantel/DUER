CREATE TABLE user_info (
	username	TEXT PRIMARY KEY,
	password_hash	TEXT DEFAULT NULL,
	nom	TEXT,
	prenom	TEXT,
	tel	TEXT,
	courriel	TEXT,
	groupe	INTEGER,
	connexion	TIMESTAMP DEFAULT Null,
	activation	TEXT DEFAULT Null)
;
CREATE TABLE login_session (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL REFERENCES user_info(username),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agent(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    categorie TEXT
);
CREATE TABLE unite(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lieu TEXT
);

CREATE TABLE risques(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nature TEXT
);

CREATE TABLE risque(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    unite_id INTEGER NOT NULL,
    type_id INTEGER,
    description TEXT,
    gravite INTEGER NOT NULL,
    frequence INTEGER NOT NULL,
    maitrise INTEGER NOT NULL,
    score INTEGER NOT NULL,
    color TEXT,
    creation TIMESTAMP NOT NULL,
    FOREIGN KEY (type_id) REFERENCES risques (id),
    FOREIGN KEY (unite_id) REFERENCES unite (id),
    FOREIGN KEY (gravite) REFERENCES gravite (id),
    FOREIGN KEY (frequence) REFERENCES frequence (id),
    FOREIGN KEY (maitrise) REFERENCES maitrise (id)
);

CREATE TABLE risque_agent(
    risque_id INTEGER,
    agent_id INTEGER,
    FOREIGN KEY (risque_id) REFERENCES risque (id),
    FOREIGN KEY (agent_id) REFERENCES agent (id)
);
   
CREATE TABLE frequence(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    freq TEXT  NOT NULL,
    vfreq NUMERIC NOT NULL
);
CREATE TABLE gravite(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    grav TEXT  NOT NULL,
    vgrav NUMERIC NOT NULL
);
CREATE TABLE maitrise(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    maitr TEXT  NOT NULL,
    vmaitr NUMERIC NOT NULL
);
CREATE TABLE seuils(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    seuil TEXT  NOT NULL,
    smin NUMERIC NOT NULL,
    smax NUMERIC NOT NULL,
    color TEXT
);
CREATE TABLE actions(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    risque_id INTEGER NOT NULL, 
    titre TEXT,
    description TEXT,
    avancement INTEGER NOT NULL DEFAULT 0,
    responsable_id TEXT NOT NULL,
    etat  INTEGER NOT NULL DEFAULT 0,
    creation TIMESTAMP NOT NULL,
    FOREIGN KEY (risque_id) REFERENCES risque (id)
);
