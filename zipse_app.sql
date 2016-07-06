/* registration */

insert into users (first, last, email, hash_pw) 
values ('fname','lname','email@isp.net','whbjhgftrey65y54365r665ytr');

select * from users;

/* activate */

update users set status = 1 where user_id = 14;

select * from users;

/* upgrade to a creator account */

update users set role = 'creator' where user_id = 14;
select * from users;

/* revoke creator rights */

update users set role = 'viewer' where user_id = 14;
select * from users;

/* login */

/* in PHP if username in select email from users 
AND hashed password in select hash_password from users; in other words the following returns one row */
$sql = "select user_id, role from users 
where email = ".$username. 
" and hash_pw = ".$hash_password. 
"and status = 1;"
$login=$conn->prepare($sql);$login->execute();$login_status=$login->columnCount();
if ($login_status > 0) { echo "Login successful";} else {echo "Login failed";}

/* example */

select user_id, role from users 
where email = 'jpkolpin@gmail.com' 
and hash_pw = 'hhf739fhvnkih123j24391jfn309' 
and status = 1;

/* go to home page */

/* for a creator */

select * from portfolio_vw where user_id = 3;

/* and also a link faves view  */
/* a link to search */


/* add a creation */
start transaction;
INSERT INTO creations (`title`, `type_id`, `user_id`, `description`) VALUES ('New Writing',4,3,'writing'); 
INSERT INTO metadata (creation_id, volume, file_type, file_size, sample_rate) values(23, null, 'txt', 3500, null);
commit;

/* use this version for unknown last id # */
/*start transaction;
INSERT INTO creations (`title`, `type_id`, `user_id`, `description`) VALUES ('New Writing',4,3,'writing'); 
INSERT INTO metadata (creation_id, volume, file_type, file_size, sample_rate) (select max(creation_id), null, 'txt', 3500, null from creations);
commit; */


select * from portfolio_vw where user_id = 3;

/*edit title */

select * from creations;

/* change the id # */

update creations c set c.title = 'Different Title' where c.creation_id= 23;


/* use this version for unknown last id # */
/*update creations c1 
join (select max(creation_id) as last_id from creations) c2
set c1.title = 'Different Title' 
where c1.creation_id = c2.last_id; */

select * from portfolio_vw where user_id = 3;

/* for a viewer */

select * from favorites_vw where user_id = 3;

/* add a fav */

select * from creations;

insert into favorites values (3,7);

select * from creations;

/* remove a fav */

delete from favorites where user_id = 3 and creation_id = 7;

select * from creations;

select * from favorites_vw where user_id = 3;

/* a link to search */

/* search results */

select * from portfolio_vw where title like '%blues%';

/* remove a creation */
start transaction;
delete from metadata where creation_id = 23;
delete from favorites where creation_id = 23;
delete from creations where creation_id = 23;
commit;

/* use this version for unknown last id # */
/*start transaction;
delete from metadata where creation_id = (select max(creation_id) from creations);
delete from favorites where creation_id = (select max(creation_id) from creations);
delete from creations where creation_id = (select max(creation_id) from creations);
commit;*/


select * from portfolio_vw where user_id = 3;