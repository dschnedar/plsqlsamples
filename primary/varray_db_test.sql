create or replace type str_list as varray(30) of varchar2(60)
;
/

create table 
       v_table ( id integer
               , list str_list )
;

insert into v_table values ( 1, str_list( 'A','quick','brown','fox','jumped','over','the','lazy','dogs' ) );
insert into v_table values ( 2, str_list( 'Mars','Venus','Terra','Mars' ) );
insert into v_table values ( 3, str_list( 'Jupiter','Saturn','Uranus','Neptune' ) );
insert into v_table values ( 5, str_list( 'Pluto','Xena' ) );
insert into v_table values ( 6, str_list( '1','2','5','10','20','50','100' ) );
insert into v_table values ( 7, str_list( 'A','quick','brown','fox','jumped','over','the','lazy','dogs' ) );




select * from v_table;


select column_value
from   the ( select cast(str_list as str_list);
/

create or replace type varray_nested_table is table of varchar2(60);

select COLUMN_VALUE                    ----------------works------------
  from THE ( select cast( list as varray_nested_table  )
               from v_table
              where id = 1
           )
;

select COLUMN_VALUE                    ----------------works------------
  from THE ( select cast( list as str_list  )
               from v_table
              where id = 3
           )
;

select COLUMN_VALUE                    ----------------works------------
  from THE ( select list
               from v_table
              where id = 3
           )
;


select column_value
  from THE ( select  list
               from v_table
              where id = 3
           )
;

