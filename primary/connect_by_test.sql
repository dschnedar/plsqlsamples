set feedback off
------------------------------------------------
--  compare a PL/SQL recursive procedure to 
--  Oracle SQL's CONNECT BY mechanism 
------------------------------------------------
--  The table TEST_BY_CONNECT just holds numbers
--  that are the sums of their child numbers
------------------------------------------------





create table test_connect_by (
  parent     number,
  child      number,
  constraint uq_tcb unique (child)
);


insert into test_connect_by values ( 5, 2);
insert into test_connect_by values ( 5, 3);

insert into test_connect_by values (18,11);
insert into test_connect_by values (18, 7);

insert into test_connect_by values (17, 9);
insert into test_connect_by values (17, 8);

insert into test_connect_by values (26,13);
insert into test_connect_by values (26, 1);
insert into test_connect_by values (26,12);

insert into test_connect_by values (15,10);
insert into test_connect_by values (15, 5);

insert into test_connect_by values (38,15);
insert into test_connect_by values (38,17);
insert into test_connect_by values (38, 6);

insert into test_connect_by values (null, 38);
insert into test_connect_by values (null, 26);
insert into test_connect_by values (null, 18);

select lpad(' ',2*(level-1)) || to_char(child) s 
  from test_connect_by 
  start with parent is null
  connect by prior child = parent;



DECLARE
    PROCEDURE travel( p_parent_key NUMBER := NULL , p_level NUMBER := 0 )
    IS
    BEGIN
        FOR i IN ( SELECT ALL  * 
                         FROM  test_connect_by 
                        WHERE  nvl(parent,-999) = nvl(p_parent_key,-999)
                     ORDER BY  parent,child
                  )
        LOOP
            dbms_output.put_line( rpad( '.',(p_level*3) ) || to_char(i.child));
            travel(i.child,p_level+1);
        END LOOP;  
    END travel;
BEGIN
    travel;
END;
/
