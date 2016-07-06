/* DDL File - Thomas Ledford / Gabrielle Overholt / Sathyan Sundaram */

CREATE database zipse;
USE zipse;

/* make the setup tables */

CREATE table creation_type (type_id int primary key auto_increment
, creation_type varchar(30) not null
);

CREATE TABLE role (role varchar(20) primary key);

CREATE TABLE file_type (file_type varchar(5) primary key);

/* preload the setup tables */

INSERT INTO creation_type (creation_type) VALUES ('music');
INSERT INTO creation_type (creation_type) VALUES ('film');
INSERT INTO creation_type (creation_type) VALUES ('photography');
INSERT INTO creation_type (creation_type) VALUES ('writing');
INSERT INTO creation_type (creation_type) VALUES ('illustration');

INSERT INTO role VALUES ('creator');
INSERT INTO role VALUES ('viewer');

INSERT INTO file_type VALUES('mp3');
INSERT INTO file_type VALUES('aac');
INSERT INTO file_type VALUES('svg');
INSERT INTO file_type VALUES('png');
INSERT INTO file_type VALUES('jpg');
INSERT INTO file_type VALUES('gif');
INSERT INTO file_type VALUES('webm');
INSERT INTO file_type VALUES('flv');
INSERT INTO file_type VALUES('pdf');
INSERT INTO file_type VALUES('txt');


/* make the main tables */

CREATE TABLE users (user_id int primary key auto_increment
, first varchar(25)
, last varchar(25)
, email varchar(25) unique
, hash_pw varchar(225) not null
, role varchar(20)  default 'viewer'
, status boolean default 0
, foreign key (role) references role(role)
);



CREATE table creations (creation_id int primary key auto_increment
, title varchar(60) not null
, type_id int
, user_id int
, description varchar(250)
, nbr_favorites int default 0
, upload_dttm timestamp default current_timestamp
, foreign key (user_id) references users(user_id)
, foreign key (type_id) references creation_type(type_id)
);

CREATE table favorites (user_id int
, creation_id int
, foreign key (user_id) references users(user_id)
, foreign key (creation_id) references creations(creation_id)
, primary key (user_id, creation_id)
);

CREATE table metadata (creation_id int primary key
, volume int
, file_type varchar(5) 
, file_size bigint
, sample_rate decimal (5,1)
, foreign key (creation_id) references creations(creation_id)
, foreign key (file_type) references file_type(file_type)
);


/* home page views */

CREATE view portfolio_vw as
(select user_id, creations.creation_id, title, creation_type, description, nbr_favorites, upload_dttm, volume, file_type, file_size, sample_rate
from (creations join creation_type on creations.type_id = creation_type.type_id)
left outer join metadata on creations.creation_id=metadata.creation_id);

CREATE VIEW favorites_vw as
(select favorites.user_id, creations.creation_id, title, creation_type, description, nbr_favorites, upload_dttm,volume, file_type, file_size, sample_rate
from (favorites join
creations on favorites.creation_id= creations.creation_id
join creation_type on creations.type_id = creation_type.type_id)
left outer join metadata on creations.creation_id=metadata.creation_id);

/* popularity tracking */

delimiter //
CREATE TRIGGER fav_add
AFTER INSERT ON favorites
For each row
BEGIN
UPDATE creations SET nbr_favorites = (nbr_favorites + 1)
WHERE creations.creation_id = new.creation_id;
END//

CREATE TRIGGER fav_del
BEFORE DELETE ON favorites
For each row
BEGIN
UPDATE creations SET nbr_favorites = (nbr_favorites - 1)
WHERE creations.creation_id = old.creation_id;
END//

delimiter ;