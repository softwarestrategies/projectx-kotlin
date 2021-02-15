CREATE TABLE projectx_user (
  id BIGSERIAL PRIMARY KEY,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NULL,
  last_name VARCHAR(255) NULL,
  enabled BOOLEAN NOT NULL,
  expired BOOLEAN NOT NULL,
  locked BOOLEAN NOT NULL,
  password_expired BOOLEAN NOT NULL
);

CREATE UNIQUE INDEX idx_projectx_user_username ON projectx_user (username);

CREATE TABLE role (
  id SERIAL PRIMARY KEY,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  name varchar(255)
);

CREATE TABLE user_role (
  id SERIAL PRIMARY KEY,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  user_id int not null,
  role_id int not null,
  FOREIGN KEY (user_id) REFERENCES projectx_user (id),
  FOREIGN KEY (role_id) REFERENCES role (id)
);

CREATE TABLE privilege (
  id SERIAL PRIMARY KEY,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  name varchar(255)
);

CREATE TABLE role_privilege (
  id SERIAL PRIMARY KEY,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  role_id int not null,
  privilege_id int not null,
  FOREIGN KEY (role_id) REFERENCES role (id),
  FOREIGN KEY (privilege_id) REFERENCES privilege (id)
);

CREATE TABLE project (
  id BIGSERIAL NOT NULL,
  version INT DEFAULT 1 NOT NULL,
  created_on TIMESTAMP DEFAULT now() NOT NULL,
  modified_on TIMESTAMP DEFAULT now() NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  modified_by VARCHAR(255) NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NOT NULL,
  user_id int not null,
  status VARCHAR(12) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES projectx_user (id),
  CONSTRAINT pk_project_id PRIMARY KEY (id)
);

INSERT INTO projectx_user(id,created_by,modified_by,username,first_name,last_name,enabled,expired,locked,password_expired)
VALUES (1,'bootstrap','bootstrap','admin.test@softwarestrategies.io','Admin','Smith',true,false,false,false);

INSERT INTO projectx_user(id,created_by,modified_by,username,first_name,last_name,enabled,expired,locked,password_expired)
VALUES (2,'bootstrap','bootstrap','user1.test@softwarestrategies.io','User1','Jones',true,false,false,false);

INSERT INTO projectx_user(id,created_by,modified_by,username,first_name,last_name,enabled,expired,locked,password_expired)
VALUES (3,'bootstrap','bootstrap','actuator.test@softwarestrategies.io','Actuator','User',true,false,false,false);

INSERT INTO projectx_user(id,created_by,modified_by,username,first_name,last_name,enabled,expired,locked,password_expired)
VALUES (4,'bootstrap','bootstrap','user2.test@softwarestrategies.io','User2','Jones',true,false,false,false);

INSERT INTO projectx_user(id,created_by,modified_by,username,first_name,last_name,enabled,expired,locked,password_expired)
VALUES (5,'bootstrap','bootstrap','system.test@softwarestrategies.io','System','User',true,false,false,false);

INSERT INTO role(id,created_by,modified_by,name) VALUES(1,'bootstrap','bootstrap','ROLE_ADMIN');
INSERT INTO role(id,created_by,modified_by,name) VALUES(2,'bootstrap','bootstrap','ROLE_USER');
INSERT INTO role(id,created_by,modified_by,name) VALUES(3,'bootstrap','bootstrap','ROLE_ACTUATOR');
INSERT INTO role(id,created_by,modified_by,name) VALUES(4,'bootstrap','bootstrap','ROLE_SYSTEM');

INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (1,'bootstrap','bootstrap',1);
INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (1,'bootstrap','bootstrap',2);
INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (2,'bootstrap','bootstrap',2);
INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (3,'bootstrap','bootstrap',3);
INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (4,'bootstrap','bootstrap',2);
INSERT INTO user_role(user_id,created_by,modified_by,role_id) VALUES (5,'bootstrap','bootstrap',4);

INSERT INTO privilege(id,created_by,modified_by,name) VALUES(1,'bootstrap','bootstrap','READ');
INSERT INTO privilege(id,created_by,modified_by,name) VALUES(2,'bootstrap','bootstrap','WRITE');
INSERT INTO privilege(id,created_by,modified_by,name) VALUES(3,'bootstrap','bootstrap','CREATE');
INSERT INTO privilege(id,created_by,modified_by,name) VALUES(4,'bootstrap','bootstrap','DELETE');
INSERT INTO privilege(id,created_by,modified_by,name) VALUES(5,'bootstrap','bootstrap','CREATE USER');

INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (1,1,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (1,2,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (1,3,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (1,4,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (1,5,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (2,1,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id, privilege_id,created_by,modified_by) VALUES (2,2,'bootstrap','bootstrap');

INSERT INTO role_privilege(role_id,privilege_id,created_by,modified_by) VALUES (4,1,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id,privilege_id,created_by,modified_by) VALUES (4,2,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id,privilege_id,created_by,modified_by) VALUES (4,3,'bootstrap','bootstrap');
INSERT INTO role_privilege(role_id,privilege_id,created_by,modified_by) VALUES (4,4,'bootstrap','bootstrap');

INSERT INTO project(created_by,modified_by,name,description,user_id,status)
VALUES ('bootstrap','bootstrap','project 1','First test project',2,'O');

INSERT INTO project(created_by,modified_by,name,description,user_id,status)
VALUES ('bootstrap','bootstrap','project 2','Second test project',2,'N');

