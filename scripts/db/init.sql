-- Databases and their Users

CREATE
DATABASE projectx;
CREATE
USER projectx_admin with encrypted password 'changeme';
GRANT ALL PRIVILEGES ON DATABASE
projectx to projectx_admin;

CREATE
DATABASE keycloak;
CREATE
USER keycloak_admin with encrypted password 'changeme';
GRANT ALL PRIVILEGES ON DATABASE
keycloak to keycloak_admin;

-- Create Tables and Populate them

\c projectx projectx_admin

CREATE TABLE oauth_access_token
(
    token_id          VARCHAR(255),
    tokenBlacklist    BYTEA,
    authentication_id VARCHAR(255),
    user_name         VARCHAR(255),
    client_id         VARCHAR(255),
    authentication    BYTEA,
    refresh_token     VARCHAR(255)
);

CREATE TABLE oauth_approvals
(
    userId         VARCHAR(255),
    clientId       VARCHAR(255),
    scope          VARCHAR(255),
    status         VARCHAR(10),
    expiresAt      TIMESTAMP,
    lastModifiedAt TIMESTAMP
);

CREATE TABLE oauth_client_details
(
    client_id               varchar(255) NOT NULL,
    resource_ids            varchar(255) DEFAULT NULL,
    client_secret           varchar(255) DEFAULT NULL,
    scope                   varchar(255) DEFAULT NULL,
    authorized_grant_types  varchar(255) DEFAULT NULL,
    web_server_redirect_uri varchar(255) DEFAULT NULL,
    authorities             varchar(255) DEFAULT NULL,
    access_token_validity   integer      DEFAULT NULL,
    refresh_token_validity  integer      DEFAULT NULL,
    additional_information  varchar(255) DEFAULT NULL,
    autoapprove             varchar(255) DEFAULT NULL
);

CREATE TABLE oauth_client_token
(
    token_id          VARCHAR(255),
    tokenBlacklist    BYTEA,
    authentication_id VARCHAR(255),
    user_name         VARCHAR(255),
    client_id         VARCHAR(255)
);

CREATE TABLE oauth_code
(
    code           VARCHAR(255),
    authentication BYTEA
);

CREATE TABLE oauth_refresh_token
(
    token_id       VARCHAR(255),
    tokenBlacklist BYTEA,
    authentication BYTEA
);

CREATE TABLE projectx_user
(
    id               SERIAL PRIMARY KEY,
    version          INT       DEFAULT 1     NOT NULL,
    created_on       TIMESTAMP DEFAULT now() NOT NULL,
    modified_on      TIMESTAMP DEFAULT now() NOT NULL,
    created_by       VARCHAR(255)            NOT NULL,
    modified_by      VARCHAR(255)            NOT NULL,
    username         VARCHAR(255)            NOT NULL,
    password         VARCHAR(255)            NOT NULL,
    first_name       VARCHAR(255) NULL,
    last_name        VARCHAR(255) NULL,
    enabled          BOOLEAN                 NOT NULL,
    expired          BOOLEAN                 NOT NULL,
    locked           BOOLEAN                 NOT NULL,
    password_expired BOOLEAN                 NOT NULL
);

CREATE
UNIQUE INDEX idx_projectx_user_username ON projectx_user (username);

CREATE TABLE role
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    name        varchar(255)
);

CREATE TABLE user_role
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    user_id     int                     not null,
    role_id     int                     not null,
    FOREIGN KEY (user_id) REFERENCES projectx_user (id),
    FOREIGN KEY (role_id) REFERENCES role (id)
);

CREATE TABLE privilege
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    name        varchar(255)
);

CREATE TABLE role_privilege
(
    id           SERIAL PRIMARY KEY,
    version      INT       DEFAULT 1     NOT NULL,
    created_on   TIMESTAMP DEFAULT now() NOT NULL,
    modified_on  TIMESTAMP DEFAULT now() NOT NULL,
    created_by   VARCHAR(255)            NOT NULL,
    modified_by  VARCHAR(255)            NOT NULL,
    role_id      int                     not null,
    privilege_id int                     not null,
    FOREIGN KEY (role_id) REFERENCES role (id),
    FOREIGN KEY (privilege_id) REFERENCES privilege (id)
);

CREATE TABLE token_blacklist
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    jti         VARCHAR(255)            NOT NULL,
    user_id     int                     not null,
    expires     TIMESTAMP,
    blacklisted BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES projectx_user (id)
);

CREATE TABLE project
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    user_id     int                     not null,
    name        VARCHAR(50)             NOT NULL,
    description VARCHAR(255)            NOT NULL,
    status      VARCHAR(1)              NOT NULL,
    FOREIGN KEY (user_id) REFERENCES projectx_user (id)
);

CREATE TABLE user_token
(
    id          SERIAL PRIMARY KEY,
    version     INT       DEFAULT 1     NOT NULL,
    created_on  TIMESTAMP DEFAULT now() NOT NULL,
    modified_on TIMESTAMP DEFAULT now() NOT NULL,
    created_by  VARCHAR(255)            NOT NULL,
    modified_by VARCHAR(255)            NOT NULL,
    user_id     int                     not null,
    type        VARCHAR(50)             NOT NULL,
    token       VARCHAR(255)            NOT NULL,
    status      VARCHAR(1)              NOT NULL,
    FOREIGN KEY (user_id) REFERENCES projectx_user (id)
);


-- secret: changeme

INSERT INTO oauth_client_details(client_id,
                                 client_secret,
                                 resource_ids,
                                 scope,
                                 authorized_grant_types,
                                 authorities,
                                 access_token_validity,
                                 refresh_token_validity,
                                 additional_information,
                                 autoapprove,
                                 web_server_redirect_uri)
VALUES ('projectx',
        '$2a$10$oitRvZPIdqEPBbhsAnVQWeH/jW1AEOv3Qg.m1S1JsqNUvE76GVuy2',
        'projectx_resource_id',
        'read,write',
        'password,refresh_token,client_credentials,authorization_code,implicit',
        'ROLE_TRUSTED_CLIENT',
        10,
        30000,
        NULL,
        'true',
        'http://localhost:8080/ui/login,http://localhost:8080/ui/notes');

-- password: changeme

INSERT INTO projectx_user(id, created_on, modified_on, created_by, modified_by, username, first_name, last_name,
                          password, enabled, expired, locked, password_expired)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 'admin.test@softwarestrategies.io', 'Admin', 'Smith',
        '$2a$10$Nbg3XSVRVoLLOGmR0XCEeuwmiMt0C8RXdIap.3PFO4/duTyrpD3Be', true, false, false, false);

-- password: changeme

INSERT INTO projectx_user(id, created_on, modified_on, created_by, modified_by, username, first_name, last_name,
                          password, enabled, expired, locked, password_expired)
VALUES (2, now(), now(), 'bootstrap', 'bootstrap', 'user1.test@softwarestrategies.io', 'User1', 'Jones',
        '$2a$10$1Tb.4g3Ts4EL9BbgMFWNgOml9N0QPHLDlOMQFdAQPRp5nF5Yjgw2S', true, false, false, false);

-- password: changeme

INSERT INTO projectx_user(id, created_on, modified_on, created_by, modified_by, username, first_name, last_name,
                          password, enabled, expired, locked, password_expired)
VALUES (3, now(), now(), 'bootstrap', 'bootstrap', 'actuator.test@softwarestrategies.io', 'Actuator', 'User',
        '$2a$10$bR4HSF9PVNABTDCllxUVJe2ctOxgpCdk6t7CthsN2niSyLCjlzT9G', true, false, false, false);

-- password: changeme

INSERT INTO projectx_user(id, created_on, modified_on, created_by, modified_by, username, first_name, last_name,
                          password, enabled, expired, locked, password_expired)
VALUES (4, now(), now(), 'bootstrap', 'bootstrap', 'user2.test@softwarestrategies.io', 'User2', 'Jones',
        '$2a$10$jY0V.NsbGQ3jtuUNW45nzOmaz.mGTeDXaqB9aRvjJiYyEF3cjJ4VO', true, false, false, false);

-- password: changeme

INSERT INTO projectx_user(id, created_on, modified_on, created_by, modified_by, username, first_name, last_name,
                          password, enabled, expired, locked, password_expired)
VALUES (5, now(), now(), 'bootstrap', 'bootstrap', 'system.test@softwarestrategies.io', 'System', 'User',
        '$2a$10$y7bxcY9Da8fR91pKvIBccODrbDJ.3E5r716QvJuuMdO4hpli3a.Pi', true, false, false, false);

INSERT INTO role(id, created_on, modified_on, created_by, modified_by, name)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 'ROLE_ADMIN');
INSERT INTO role(id, created_on, modified_on, created_by, modified_by, name)
VALUES (2, now(), now(), 'bootstrap', 'bootstrap', 'ROLE_USER');
INSERT INTO role(id, created_on, modified_on, created_by, modified_by, name)
VALUES (3, now(), now(), 'bootstrap', 'bootstrap', 'ROLE_ACTUATOR');
INSERT INTO role(id, created_on, modified_on, created_by, modified_by, name)
VALUES (4, now(), now(), 'bootstrap', 'bootstrap', 'ROLE_SYSTEM');

INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 1);
INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 2);
INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (2, now(), now(), 'bootstrap', 'bootstrap', 2);
INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (3, now(), now(), 'bootstrap', 'bootstrap', 3);
INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (4, now(), now(), 'bootstrap', 'bootstrap', 2);
INSERT INTO user_role(user_id, created_on, modified_on, created_by, modified_by, role_id)
VALUES (5, now(), now(), 'bootstrap', 'bootstrap', 4);

INSERT INTO privilege(id, created_on, modified_on, created_by, modified_by, name)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 'READ');
INSERT INTO privilege(id, created_on, modified_on, created_by, modified_by, name)
VALUES (2, now(), now(), 'bootstrap', 'bootstrap', 'WRITE');
INSERT INTO privilege(id, created_on, modified_on, created_by, modified_by, name)
VALUES (3, now(), now(), 'bootstrap', 'bootstrap', 'CREATE');
INSERT INTO privilege(id, created_on, modified_on, created_by, modified_by, name)
VALUES (4, now(), now(), 'bootstrap', 'bootstrap', 'DELETE');
INSERT INTO privilege(id, created_on, modified_on, created_by, modified_by, name)
VALUES (5, now(), now(), 'bootstrap', 'bootstrap', 'CREATE USER');

INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (1, 1, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (1, 2, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (1, 3, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (1, 4, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (1, 5, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (2, 1, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (2, 2, now(), now(), 'bootstrap', 'bootstrap');

INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (4, 1, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (4, 2, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (4, 3, now(), now(), 'bootstrap', 'bootstrap');
INSERT INTO role_privilege(role_id, privilege_id, created_on, modified_on, created_by, modified_by)
VALUES (4, 4, now(), now(), 'bootstrap', 'bootstrap');

INSERT INTO project(id, created_on, modified_on, created_by, modified_by, user_id, name, description, status)
VALUES (1, now(), now(), 'bootstrap', 'bootstrap', 2, 'project 1-1', 'First test project', 'O');

INSERT INTO project(id, created_on, modified_on, created_by, modified_by, user_id, name, description, status)
VALUES (2, now(), now(), 'bootstrap', 'bootstrap', 2, 'project 1-2', 'Second test project', 'N');
