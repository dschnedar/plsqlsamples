column a format 99990
column b format 99990
column c format 99990


CREATE TABLE abc ( a NUMBER , b NUMBER , C NUMBER );
INSERT INTO abc VALUES ( 1, 2, 3 );
INSERT INTO abc VALUES ( 2, 4, 6 );
INSERT INTO abc VALUES ( 3, 6, 9 );
INSERT INTO abc VALUES ( 1, 2, 3 );
INSERT INTO abc VALUES ( 2, 4, 6 );
INSERT INTO abc VALUES ( 3, 6, 9 );



CREATE OR REPLACE PROCEDURE show_abc(   where_in IN VARCHAR2 := '2=2' )
IS
    cur  INTEGER := DBMS_SQL.OPEN_CURSOR;
    fdbk INTEGER;
    a    NUMBER;
    b    NUMBER;
    c    NUMBER;
BEGIN
    dbms_output.put_line( 'show_abc( )   where_in=  ' || where_in );
    DBMS_SQL.PARSE(  cur 
                  ,  'SELECT a , b , c FROM abc WHERE ' || NVL( where_in, '1=1' )
                  ,  DBMS_SQL.NATIVE)
    ;
    DBMS_SQL.DEFINE_COLUMN ( cur, 1, 1 );
    DBMS_SQL.DEFINE_COLUMN ( cur, 2, 1 );
    DBMS_SQL.DEFINE_COLUMN ( cur, 3, 1 );
 
    fdbk := DBMS_SQL.EXECUTE (cur);
    LOOP
        EXIT WHEN DBMS_SQL.FETCH_ROWS (cur) = 0;
        DBMS_SQL.COLUMN_VALUE ( cur, 1, a );
        DBMS_SQL.COLUMN_VALUE ( cur, 2, b );
        DBMS_SQL.COLUMN_VALUE ( cur, 2, c );
        DBMS_OUTPUT.PUT_LINE( '( ' ||to_char(a)  ||','||  to_char(b)  ||','||  to_char(c)  || ' ) ');
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR (cur);
END;
/



--------------------------------------------------------
-- Method 4: treat all columns as string
--           show column names and values
--------------------------------------------------------
declare
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    procedure execute_immediate( p_sql in varchar2 )
    is
    BEGIN
        dbms_sql.parse(l_theCursor,p_sql,dbms_sql.native);
        l_status := dbms_sql.execute(l_theCursor);
    END;
begin
    dbms_sql.parse(  l_theCursor , 'select * from abc' , dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor,l_colCnt, l_descTbl );
    for i in 1 .. l_colCnt loop
        dbms_sql.define_column( l_theCursor, i,l_columnValue, 4000 );
    end loop;
    l_status := dbms_sql.execute(l_theCursor);
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i,l_columnValue );
            dbms_output.put_line( rpad( l_descTbl(i).col_name,30 ) || ': ' || l_columnValue );
        end loop;
        dbms_output.put_line( '-----------------' );
    end loop;
exception
    when others then
        raise;
end;

