--------------------------------------------------------------------
--------------------------------------------------------------------
-- nested tables and varrays can be extracted from DB and manipulated
-- Although, a sparse table will be compacted as it is put into a db table
--------------------------------------------------------------------
--------------------------------------------------------------------



column favorite_colors format a35
--
DROP TABLE personality_inventory;
CREATE OR REPLACE TYPE Color_tab_t AS TABLE OF VARCHAR2(30);
/
CREATE TABLE personality_inventory(
    person_id         NUMBER
   ,favorite_colors   Color_tab_t
   ,date_tested       DATE
   )
  NESTED TABLE favorite_colors STORE AS favorite_colors  --
;
insert into personality_inventory values ( 1, color_tab_t('red','green','blue'),sysdate);
select *   from personality_inventory;

select *   from personality_inventory;
-----
declare
    p personality_inventory%rowtype;
    ---indx     pls_integer;
begin
    SELECT * into p from personality_inventory where rownum = 1;
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    for i in 1..p.favorite_colors.LAST loop
        dbms_output.put( to_char(i,'990') ||':');
        if p.favorite_colors.exists(i) then dbms_output.put_line( p.favorite_colors(i) ); else dbms_output.put_line(' '); end if;
    end loop;
    dbms_output.put_line('-----delete(2)');
    ---
    p.favorite_colors.delete(2);
    ---    
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    for i in 1..p.favorite_colors.LAST loop
        dbms_output.put( to_char(i,'990') ||':');
        if p.favorite_colors.exists(i) then dbms_output.put_line( p.favorite_colors(i) ); else dbms_output.put_line(' '); end if;
    end loop;
    -----------------------------------------------------------
    update personality_inventory set row = p;
    -----------------------------------------------------------
    dbms_output.put_line( '------------sparse array put into db table and brought back out as a non-sparse array------------');
    SELECT * into p from personality_inventory where rownum = 1;
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    for i in 1..p.favorite_colors.LAST loop
        dbms_output.put( to_char(i,'990') ||':');
        if p.favorite_colors.exists(i) then dbms_output.put_line( p.favorite_colors(i) ); else dbms_output.put_line(' '); end if;
    end loop;
end;	
/
select *   from personality_inventory;








--select * from user_tables
--where table_name = upper('personality_inventory')
--   or table_name = upper('favorite_colors');
---^------------------------------------------------^----
---|  FAVORITE_COLORS will show up in USER_TABLES --|----
---|----  NESTED column = YES  ---------------------|----
-------------------------------------------------------







column favorite_colors format a35
DROP TABLE personality_inventory;
CREATE OR REPLACE TYPE Color_tab_t AS VARRAY(20) OF VARCHAR2(30);
/

CREATE TABLE personality_inventory(
    person_id         NUMBER
   ,favorite_colors   Color_tab_t
   ,date_tested       DATE
   )
;
insert into personality_inventory values ( 1, color_tab_t('red','blue','green'),sysdate);
select *   from personality_inventory;


declare
    p personality_inventory%rowtype;
begin
    SELECT * into p from personality_inventory where rownum = 1;
    --
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    --
    for i in 1..p.favorite_colors.count loop
        dbms_output.put_line( p.favorite_colors(i) );
    end loop;
    --
    p.favorite_colors.trim;
    for i in 1..p.favorite_colors.count loop
        dbms_output.put_line( p.favorite_colors(i) );
    end loop;
    -----------------------------------------------------------
    update personality_inventory set row = p;
    -----------------------------------------------------------
    SELECT * into p from personality_inventory where rownum = 1;
    --
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    --
    for i in 1..p.favorite_colors.count loop
        dbms_output.put_line( p.favorite_colors(i) );
    end loop;
    --
    --
    -----------------------------------------------------------
    p.favorite_colors.extend(1);
    update personality_inventory set row = p;
    -----------------------------------------------------------
    SELECT * into p from personality_inventory where rownum = 1;
    --
    dbms_output.put_line('(first,last,count)=(' || to_char(p.favorite_colors.first)||','||to_char(p.favorite_colors.last)||','||to_char(p.favorite_colors.count)      ||')'    );
    --
    for i in 1..p.favorite_colors.count loop
        dbms_output.put_line( nvl(p.favorite_colors(i),'~') );
    end loop;
    --
    --
    --
end;
/
