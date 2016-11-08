CURRVAL - Returns the current value of an Oracle sequence. 
NEXTVAL - Returns the current value of an Oracle sequence and then increments the sequence. 
LEVEL   - The current level in a hierarchy for a query using STARTWITH and CONNECT BY. 
ROWID   - An identifier (data file, block and row) for the physical storage of a row in a table. 
ROWNUM  - The integer indicating the order in which a row is returned from a query. 
------------------------------------------------------------------------------
SQL> desc v$mystat
 Name                                            Null?    Type
 ----------------------------------------------- -------- --------------------------------
 SID                                                      NUMBER
 STATISTIC#                                               NUMBER
 VALUE                                                    NUMBER
------------------------------------------------------------------------------------------






-- restaurants( id pk , name)
----------------------------------------------------------
insert into restaurants values  ( 1  , 'Arbys' );
insert into restaurants values  ( 2  , 'Burger King' );
insert into restaurants values  ( 3  , 'KFC' );
insert into restaurants values  ( 4  , 'McDonalds' );
insert into restaurants values  ( 5  , 'Taco Bell' );
insert into restaurants values  ( 6  , 'Wendys' );

-- primary key prevents inserts from 2nd session



create table eatery (id number, name varchar2(30) );

insert into eatery values  ( 1  , 'Arbys' );
insert into eatery values  ( 2  , 'Burger King' );
insert into eatery values  ( 3  , 'KFC' );
insert into eatery values  ( 4  , 'McDonalds' );
insert into eatery values  ( 5  , 'Taco Bell' );
insert into eatery values  ( 6  , 'Wendys' );




-- no pk, insert from both sessions ok


--------------------------------------------
-- session_ids
-- TOAD  = 256
-- white = 251
-- green = 248
--------------------------------------------

column lock_type       format a15
column mode_requested  format a15
column mode_held       format a15
column BLOCKING_OTHERS format a15
select d.session_id
     , v.sid
     , v.username
     , d.lock_type
     , d.mode_requested
     , d.mode_held
     , d.blocking_others
  from dba_locks        d  join  sys.V_$session v  on  v.sid = d.session_id
  order by session_id
;

select (select unique sid from v$mystat)    as      my_SID
     , d.session_id
     , v.username
     , d.lock_type
     , d.mode_requested
     , d.mode_held
     , d.blocking_others
  from dba_locks        d  
  join  sys.V_$session v  on  v.sid = d.session_id
  order by session_id
;

















