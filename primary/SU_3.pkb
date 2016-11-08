CREATE OR REPLACE PACKAGE BODY "BEP\SCHNEDARD".su AS
-------------------------------------------------------------------------------
--   NAME:       su
--   PURPOSE:
--
--   REVISIONS:
--   Ver        Date        Author           Description
--   ---------  ----------  ---------------  ------------------------------------
--   1.0        01.04.2010  David Schnedar   1. Created this package body.
---------------------------------------------------------------------------------
    TYPE row_type    IS TABLE OF INTEGER;
    TYPE matrix_type IS TABLE OF row_type;
    matrix matrix_type;
    ----------------
    
    PROCEDURE p(p_str VARCHAR2) IS BEGIN dbms_output.put_line('>'||substr(p_str,1,254)); END p;
    
    
    FUNCTION valid RETURN BOOLEAN  -- all rows, columns, and squares can not repeat a digit (1,2,3,4,5,6,7,8,9)
    IS
        TYPE counter_type IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
        --
        digit_counts counter_type;   -- see  (digit_counts_init,digit_counts_each_less_than_2)
        
        PROCEDURE digit_counts_init 
        IS 
        BEGIN
            FOR i IN  1..9 LOOP     digit_counts(i) := 0;     END LOOP; 
        END digit_counts_init;
        
        FUNCTION digit_counts_each_less_than_2 RETURN BOOLEAN -- is each digit (1..9) used no more than once
        IS 
        BEGIN
            FOR i IN  1..9 LOOP  
                IF  digit_counts(i) > 1 THEN     RETURN FALSE;     END IF;     
            END LOOP;
            RETURN TRUE; 
        END digit_counts_each_less_than_2;
        --
    BEGIN
        -----check rows--------
        FOR r IN 1..matrix.COUNT     LOOP
            digit_counts_init;
            FOR c IN 1..matrix(r).COUNT     LOOP
                IF matrix(r)(c) IS NOT NULL THEN     digit_counts(matrix(r)(c)) := digit_counts(matrix(r)(c)) + 1;     END IF;
            END LOOP;
            IF NOT digit_counts_each_less_than_2 THEN     RETURN FALSE;     END IF;
        END LOOP;
        
        -----check columns-----
        FOR c IN 1..9     LOOP
            digit_counts_init;
            FOR r IN 1..9     LOOP
                IF matrix(r)(c) IS NOT NULL THEN     digit_counts(matrix(r)(c)) := digit_counts(matrix(r)(c)) + 1;     END IF;
            END LOOP;
            IF NOT digit_counts_each_less_than_2 THEN     RETURN FALSE;     END IF;
        END LOOP;
        
        ------check squares----
        DECLARE
            r INTEGER := 0; -- row
            c INTEGER := 0; -- column
        BEGIN
            FOR i IN 1..3 LOOP
                FOR j in 1..3 LOOP
                    digit_counts_init;
                    FOR k IN 1..3 LOOP
                        FOR l in 1..3 LOOP
                            r := k+(i-1)*3;
                            c := l+(j-1)*3; 
                            IF matrix(r)(c) IS NOT NULL THEN     digit_counts(matrix(r)(c)) := digit_counts(matrix(r)(c)) + 1;     END IF;
                        END LOOP; 
                    END LOOP;
                    IF NOT digit_counts_each_less_than_2 THEN     RETURN FALSE;     END IF;
                END LOOP;     
            END LOOP;
        END; ---squares---
        
        RETURN TRUE; -- rows, columns, and squares ok
    END valid;
    
    
    PROCEDURE show 
    IS
        TmpVar NUMBER;
        print_str VARCHAR2(255);
    BEGIN
        p('----------------show row/col -----------------');
        FOR r IN 1..matrix.COUNT LOOP   
            print_str := NULL;         
            FOR c IN 1..matrix(r).COUNT LOOP
                print_str := print_str || ' [' || trim(to_char(r,'0')) ||','|| trim(to_char(c,'0')) || '] ';
            END LOOP;
            p(print_str);            
        END LOOP;
        --
        p('----------------show------------------');
        FOR r IN 1..matrix.COUNT LOOP
            print_str := NULL;
            FOR c IN 1..matrix(r).COUNT LOOP
                print_str := print_str || nvl( to_char(matrix(r)(c)) ,'_' );
            END LOOP;
            p(print_str);            
        END LOOP;
        --
        IF su.valid THEN
            p('valid');
        ELSE
            p('NOT valid');
        END If;
    END show;
    
    
    PROCEDURE init_matrix 
    IS 
    BEGIN
        matrix := matrix_type(  row_type( 1       ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  9        )
                             ,  row_type( NULL    ,  2       ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  3       ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  NULL    ,  4       ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  NULL    ,  NULL    ,  5       ,  NULL    ,  NULL    ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  6       ,  NULL    ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  7       ,  NULL    ,  NULL     )
                             ,  row_type( NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  8       ,  NULL     )
                             ,  row_type( 9       ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  NULL    ,  5       ,  1        )
                             );
    END init_matrix;
    ---------------------
    FUNCTION solve( rc INTEGER ) RETURN BOOLEAN
    IS 
        r INTEGER;
        c INTEGER;
    BEGIN
        p(  'solve(' ||to_char(rc)|| ' )'  ); ---dfs---
        IF nvl(rc,-1) < 1 THEN 
            dbms_output.put_line('********************** ERROR matrix key is < 1 ***************'); 
            RETURN solve(1); 
        END IF;
        -------------------
        r := ceil(rc/9);
        c := mod(rc,9);
        IF c = 0 THEN    c := 9;    END IF;
        
        /***************************************/
        BEGIN
            IF rc > 81 THEN 
                RETURN TRUE; 
            ELSIF matrix(r)(c) IS NOT NULL THEN
                RETURN solve(rc+1);
            ELSE
                FOR i IN 1..9 LOOP
                    matrix(r)(c) := i;
                    IF valid THEN
                        IF solve(rc+1) THEN
                            RETURN TRUE;
                        END IF;
                    END IF;
                END LOOP;
                matrix(r)(c) := NULL;
                RETURN FALSE;
            END IF;
        EXCEPTION 
            WHEN OTHERS THEN 
                p(  ' --- OTHERS ---'   ); ---dfs---
                NULL;
        END;
        /**************************************/
        
        p(  'solve  returns  NULL'   ); ---dfs---
        RETURN NULL;
        
    END solve;
    -------------------------------------- 
    PROCEDURE test
    IS
    BEGIN
        init_matrix;
        show;
        IF solve(1) THEN
            p(':)   :)   :)   :)   :)   :)   :)   :)   :)   :)   :)   :)   solved');
        ELSE
            p(':(   :(   :(   :(   :(   :(   :(   :(   :(   :(   :(   :(   NOT solved.');
        END IF;
        show;
    END test;


BEGIN
    dbms_output.enable(1000000);
    init_matrix;
END su;
/

exec su.test
