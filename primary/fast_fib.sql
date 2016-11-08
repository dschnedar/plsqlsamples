select all table_name ||'.'|| column_name ||':'|| data_type ||'.'|| data_length 
from       user_tab_columns
where      data_length=1



set null "~NuLL"


column x format a300
select all  'SELECT UNIQUE ' || column_name || ' FROM ' || table_name || ' ORDER BY ' || column_name || ' NULLS LAST ' || ';' as x
      from  user_tab_columns
     where  data_length=1
  order by  data_type
;



set serveroutput on
DECLARE
  TYPE a_type IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
  a a_type;
  b a_type;
BEGIN
  FOR i IN 1..5 LOOP
    a(i) := i;
  END LOOP;

  b := a;  -- b and a are seperate objects

  dbms_output.put_line('=============');
  FOR i IN a.first..a.last LOOP
    dbms_output.put_line(a(i));
  END LOOP;
  dbms_output.put_line('==');
  FOR i IN b.first..b.last LOOP
    dbms_output.put_line(b(i));
  END LOOP;


   FOR i IN 1..5 LOOP
    b(i) := i*2;
  END LOOP;

  dbms_output.put_line('=============');
  FOR i IN a.first..a.last LOOP
    dbms_output.put_line(a(i));
  END LOOP;
  dbms_output.put_line('==');
  FOR i IN b.first..b.last LOOP
    dbms_output.put_line(b(i));
  END LOOP;

END;
/


declare
  x varchar2(60);
begin
  execute immediate 'select * from dual' into x;
  dbms_output.put_line('x='||x);
end;
/

declare
  x  varchar2(60);
  y  varchar2(60);
  z  varchar2(60);
  x1 varchar2(60);
  y1 varchar2(60);
  z1 varchar2(60);
begin
  execute immediate 'select ''a'',''b'',''c'' from dual' into x,y,z,x1,y1,z1;
  dbms_output.put_line('x='||x);
  dbms_output.put_line('y='||y);
  dbms_output.put_line('z='||z);
end;
/


declare
  x  varchar2(60);
  y  varchar2(60);
  z  varchar2(60);
  x1 varchar2(60);
  y1 varchar2(60);
  z1 varchar2(60);
  xxx x_tbl%ROWTYPE;
  type yyy_type is  record( a varchar2(20) , b varchar2(20) , c varchar2(20) );
  yyy  yyy_type;
  type zzz_type is  record( a varchar2(20) , b varchar2(20) , c varchar2(20) , d varchar2(20) );
  zzz  zzz_type;
begin
  execute immediate 'select * from x_tbl' into xxx;
  dbms_output.put_line('xxx.a='||xxx.a);
  dbms_output.put_line('xxx.b='||xxx.b);
  dbms_output.put_line('xxx.b='||xxx.c);
  execute immediate 'select * from x_tbl' into yyy;
  dbms_output.put_line(' yyy.a='||yyy.a);
  dbms_output.put_line(' yyy.b='||yyy.b);
  dbms_output.put_line(' yyy.b='||yyy.c);
  execute immediate 'select * from x_tbl' into zzz;
  dbms_output.put_line(' zzz.a='||zzz.a);
  dbms_output.put_line(' zzz.b='||zzz.b);
  dbms_output.put_line(' zzz.b='||zzz.c);
end;
/




-------------------------
-------------------------
-------------------------
-------------------------
CREATE OR REPLACE PACKAGE X_TEST
AS
    FUNCTION  fact(      n INTEGER ) RETURN INTEGER; -- recursive
    --------------------------------------------------------------------------------
    FUNCTION  fib(       n INTEGER ) RETURN INTEGER; -- NOT recursive
    FUNCTION  fast_fib(  n INTEGER ) RETURN INTEGER; -- recursive
    FUNCTION  slow_fib(  n INTEGER ) RETURN INTEGER; -- recursive with cacheing
    PROCEDURE clear_cache;
END;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY x_test
AS
    TYPE fib_table_type IS TABLE OF INTEGER INDEX BY BINARY_INTEGER;
    fibs fib_table_type;
    --
    PROCEDURE p( str VARCHAR2 )
    IS
    BEGIN
        dbms_output.put_line(str);
    END P;
    --
    PROCEDURE clear_cache IS BEGIN  fibs.DELETE;   END clear_cache;
    --
    FUNCTION fact( n INTEGER ) RETURN INTEGER
    IS
    BEGIN
        IF MOD(n,1) != 0 THEN
            RETURN NULL;
        ELSIF n < 1 THEN
            RETURN NULL;
        ELSIF n = 1 THEN
            RETURN 1;
        ELSE 
            RETURN n*fact(n-1);
        END IF;   
    END FACT;
    --
    FUNCTION fib( n INTEGER ) RETURN INTEGER
    IS
        fib_minus2 INTEGER := 0; 
        fib_minus1 INTEGER := 1;
        fib_total  INTEGER;
    BEGIn
        p( 'fib(' || trim(to_char(n)) || ')' );
        IF n IS NULL OR mod(n,1) != 0 THEN  RETURN NULL;  END IF;
        IF n = 0                      THEN  RETURN 0;     END IF;
        IF n = 1                      THEN  RETURN 1;     END IF;
        FOR k IN 2..n LOOP
            fib_total  := fib_minus2 + fib_minus1;
            fib_minus2 := fib_minus1;
            fib_minus1 := fib_total;
        END LOOP;
        RETURN fib_total;
    END fib;
    --
    FUNCTION slow_fib( n INTEGER ) RETURN INTEGER
    IS
    BEGIN
        p( 'slow_fib(' || trim(to_char(n)) || ')' );
        RETURN CASE
                 WHEN mod(n,1) != 0 OR n < 0    THEN NULL
                 WHEN n = 0                     THEN 0
                 WHEN n=1                       THEN 1
                 ELSE                                slow_fib(n-1) + slow_fib(n-2)              
               END;   
    END slow_fib;
    --
    FUNCTION fast_fib( n INTEGER ) RETURN INTEGER
    IS
        retval INTEGER;
    BEGIN
        p( 'fast_fib(' || trim(to_char(n)) || ')' );
        CASE
          WHEN  fibs.EXISTS(n)          THEN retval := fibs(n);
          WHEN  mod(n,1) != 0 OR n < 0  THEN retval := NULL;
          WHEN  n = 0                   THEN retval := 0;
          WHEN  n = 1                   THEN retval := 1;
          ELSE                               retval := fast_fib(n-1) + fast_fib(n-2);           
        END CASE;
        --
        IF retval IS NOT NULL THEN fibs(n) := retval; END IF;
        RETURN retval;
    END fast_fib;
end;
/
show errors


 

BEGIN
    dbms_output.put_line('================== fib(6) ====================================='   );
    dbms_output.put_line( 'fib(6)='      || to_char(x_test.fib(6))      );
    
    dbms_output.put_line('================== slow_fib(6) ================================'   );
    dbms_output.put_line( 'slow_fib(6)=' || to_char(x_test.slow_fib(6)) );
    
    dbms_output.put_line('================== fast_fib(6) ================================'   );
    dbms_output.put_line( 'fast_fib(6)=' || to_char(x_test.fast_fib(6)) );
    dbms_output.put_line('================== fast_fib(6) AGAIN =========================='   );
    dbms_output.put_line( 'fast_fib(6)=' || to_char(x_test.fast_fib(6)) );
    x_test.clear_cache();
    dbms_output.put_line('================== fast_fib(4) AFTER clear_cache() ============'   );
    dbms_output.put_line( 'fast_fib(4)=' || to_char(x_test.fast_fib(4)) );
    dbms_output.put_line('================== fast_fib(4) AGAIN =========================='   );
    dbms_output.put_line( 'fast_fib(4)=' || to_char(x_test.fast_fib(4)) );
    x_test.clear_cache();
END;
/









begin
  for i in -1..6 loop
      dbms_output.put_line('====================' || trim(to_char(i)) || '===================='  );
      dbms_output.put_line( 'fib('||trim(to_char(i))||')=' || to_char(x_test.fib(i)) );
      dbms_output.put_line('===================================================='  );
  end loop;
end;
/

begin
  for i in -1..6 loop
      dbms_output.put_line('====================' || trim(to_char(i)) || '===================='  );
      dbms_output.put_line( 'slow_fib('||trim(to_char(i))||')=' || to_char(x_test.slow_fib(i)) );
      dbms_output.put_line('===================================================='  );
  end loop;
end;
/


begin
  for i in -1..4 loop
      dbms_output.put_line('====================' || trim(to_char(i)) || '===================='  );
      dbms_output.put_line( 'fast_fib('||trim(to_char(i))||')=' || to_char(x_test.fast_fib(i)) );
      dbms_output.put_line('===================================================='  );
  end loop;
end;
/





begin
  for i in (-1)..5 loop
    dbms_output.put_line( to_char(i) || '!=' || to_char(x_test.fact(i) ) );
  end loop;
  dbms_output.put_line( to_char(3.14159) || '!=' || to_char(x_test.fact(3.14159) ) );
  --
  for i in (-1)..5 loop
    dbms_output.put_line( 'fib('||to_char(i) || ')=' || to_char(x_test.fib(i) ) );
  end loop;
  dbms_output.put_line( 'fib('||to_char(3.14159) || ')=' || to_char(x_test.fib(3.14159) ) );
  --
  for i in (-1)..5 loop
    dbms_output.put_line( 'fast_fib('||to_char(i) || ')=' || to_char(x_test.fast_fib(i) ) );
  end loop;
  dbms_output.put_line( 'fast_fib('||to_char(3.14159) || ')=' || to_char(x_test.fast_fib(3.14159) ) );
end;
/




declare
    f integer;
begin
  for i in -1..7 loop
      dbms_output.put_line( 'fast_fib('||trim(to_char(i))||')=' || to_char(x_test.fast_fib(i)) );
  end loop;
end;
/


declare
    f integer;
begin
  for i in -1..7 loop
      dbms_output.put_line( 'slow_fib('||trim(to_char(i))||')=' || to_char(x_test.slow_fib(i)) );
  end loop;
end;
/


declare
    i integer := 30;
begin
 dbms_output.put_line( 'fast_fib('||to_char(i) || ')=' || to_char(x_test.fast_fib(i) ) );
end;
/

declare
    i integer := 30;
begin
 dbms_output.put_line( 'slow_fib('||to_char(i) || ')=' || to_char(x_test.slow_fib(i) ) );
end;
/


