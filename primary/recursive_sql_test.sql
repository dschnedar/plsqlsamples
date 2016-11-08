create table r ( parent varchar2(6) , name varchar2(6) );

select * from r;

insert into r values (null, 'a');
insert into r values (null, 'b');
insert into r values (null, 'c');
--
insert into r values ('a', 'aa');
insert into r values ('a', 'ab');
insert into r values ('a', 'ac');
insert into r values ('b', 'ba');
insert into r values ('b', 'bb');
insert into r values ('b', 'bc');
insert into r values ('c', 'ca');
insert into r values ('c', 'cb');
insert into r values ('c', 'cc');
--
insert into r values ('aa' , 'aa0' );
insert into r values ('ab' , 'ab0' );
insert into r values ('ac' , 'ac0' );
insert into r values ('ba' , 'ba0' );
insert into r values ('bb' , 'bb0' );
insert into r values ('bc' , 'bc0' );
insert into r values ('ca' , 'ca0' );
insert into r values ('cb' , 'cb0' );
insert into r values ('cc' , 'cc0' );
insert into r values ('aa' , 'aa1' );
insert into r values ('ab' , 'ab1' );
insert into r values ('ac' , 'ac1' );
insert into r values ('ba' , 'ba1' );
insert into r values ('bb' , 'bb1' );
insert into r values ('bc' , 'bc1' );
insert into r values ('ca' , 'ca1' );
insert into r values ('cb' , 'cb1' );
insert into r values ('cc' , 'cc1' );
insert into r values ('aa' , 'aa2' );
insert into r values ('ab' , 'ab2' );
insert into r values ('ac' , 'ac2' );
insert into r values ('ba' , 'ba2' );
insert into r values ('bb' , 'bb2' );
insert into r values ('bc' , 'bc2' );
insert into r values ('ca' , 'ca2' );
insert into r values ('cb' , 'cb2' );
insert into r values ('cc' , 'cc2' );
-----------------------------------------------
select all to_char(level) || lpad(' ',3*(level-1)) || '('||parent ||','|| name||')' 
from       r 
start with parent is null
connect by prior name=parent
;


/**********************************
with x( p n ) as
(  select all parent , name 
   from   r
   where  parent = n  
)
select * from x
;
***********************************/

 

