column a format a10
column b format a10
drop   table xclob;
create table xclob ( id integer , a clob , b clob DEFAULT empty_clob() );
insert into xclob ( id        ) values (1);
insert into xclob ( id, a , b ) values (2,empty_clob(),empty_clob());
select id, a        , b         from xclob; -- 2 rows look the same but they aren't
select id, length(a), length(b) from xclob; -- empty_clob() has length, NULL does not


column a format a30
column b format a10
column c format a10
drop   table xclob;
create table xclob ( id integer , a clob , b clob , c clob DEFAULT 'The quick brown fox jumped over the lazy dogs.' );
insert into xclob ( id             ) values ( 1 );
insert into xclob ( id , a , b , c ) values ( 2 , null           , null         , null         );
insert into xclob ( id , a , b , c ) values ( 3 , empty_clob()   , empty_clob() , empty_clob() );
insert into xclob ( id , a , b , c ) values ( 4 , 'Hello World!' , ''           , NULL         );
insert into xclob ( id , a , b , c ) values ( 5 , 'SamIAm.'      , ''           , NULL         );
insert into xclob ( id , a , b , c ) values ( 6 , 'Sam
I
Am.'      , ''           , NULL         );
select id, a        , b         , c        from xclob;
select id, length(a), length(b) ,length(c) from xclob;

















drop table xclob;
create table xclob ( id integer , a clob , b clob DEFAULT empty_clob(), c clob DEFAULT 'The quick brown fox jumped over the lazy dogs.' );
insert into xclob values ( 1,null, empty_clob(), 'The ' );

declare 
    v_id integer;
    v_a  clob;
    v_b  clob;
    v_c  clob;
begin
    select a,b,c into v_a,v_b,v_c from xclob where rownum = 1 for update;
    --
    BEGIN
        dbms_lob.write(v_a,1,1,'AAA'); --- orignal table clob must exist ( 'xxx' OR empty_clob() )
    EXCEPTION 
        WHEN OTHERS THEN dbms_output.put_line('can not write to NULL lob');
    END;
    dbms_lob.write(v_b,1,1,'BBB');  -- can write to empty() or non empty lob
    dbms_lob.write(v_c,3,4,'CCC');
    commit;
end;
/

select * from xclob;












