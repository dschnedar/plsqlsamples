drop package life;

exec dbms_output.enable(1000000)



CREATE OR REPLACE PACKAGE life
AS
    PROCEDURE init;
END life;
/
show errors


CREATE OR REPLACE PACKAGE BODY life
AS   
    TYPE    columns_type  IS TABLE OF  BOOLEAN       INDEX BY PLS_INTEGER;
    TYPE    rows_type     IS TABLE OF  columns_type  INDEX BY PLS_INTEGER;
    --
    matrix        rows_type;
    copy_matrix   rows_type;
    mirror_matrix rows_type;
    --
    PROCEDURE init 
    IS BEGIN 
        NULL; 
    END init;
    FUNCTION neighbor_count( r PLS_INTEGER ,c PLS_INTEGER )  RETURN INTEGER
    IS
        ret_val INTEGER := 0;
    BEGIN
        FOR i IN r-1..r+1 LOOP
            FOR j IN c-1..c+1 LOOP
                IF matrix.exists(i) AND matrix(i).exists(j) THEN
                    IF NOT (i=r AND j=c) AND matrix(i)(j) THEN 
                            ret_val := ret_val + 1; 
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
        RETURN ret_val;
    END neighbor_count;
    --
    PROCEDURE populate_mirror_matrix
    IS 
        min_row PLS_INTEGER;
        max_row PLS_INTEGER;
        min_col PLS_INTEGER := 0;
        max_col PLS_INTEGER := 0;
        l       PLS_INTEGER;
    BEGIN
        mirror_matrix.DELETE;
        min_row := matrix.FIRST;
        max_row := matrix.LAST; 
        l := matrix.FIRST;
        WHILE l IS NOT NULL LOOP
            IF matrix(l).FIRST < min_col OR min_col IS NULL THEN   min_col := matrix(l).FIRST;   END IF;
            IF matrix(l).LAST  > max_col OR max_col IS NULL THEN   max_col := matrix(l).LAST ;   END IF;
            l := matrix.NEXT(l);
        END LOOP;
        --
        FOR i IN min_row-1..max_row+1 LOOP
          FOR j IN min_col-1..max_col+1 LOOP
            IF  neighbor_count(i,j) = 3 THEN
                    mirror_matrix(i)(j) := true;                         -- stays alive or becomes alive         
            ELSIF matrix.EXISTS(i)    AND    matrix(i).EXISTS(j) 
              AND matrix(i)(j)        AND    neighbor_count(i,j) = 2 THEN
                    mirror_matrix(i)(j) := true;                                          -- stays alive
            ELSE
                    NULL;                             -- (is dead and stays dead) or (is alive but dies)              
            END IF;
          END LOOP;
        END LOOP;        
    END populate_mirror_matrix;
    --
    PROCEDURE show_matrix
    IS 
        min_row PLS_INTEGER;
        max_row PLS_INTEGER;
        min_col PLS_INTEGER;
        max_col PLS_INTEGER;
        l       PLS_INTEGER;
    BEGIN
        min_row := matrix.FIRST;
        max_row := matrix.LAST; 
        l := matrix.FIRST;
        WHILE l IS NOT NULL LOOP
            IF matrix(l).FIRST < min_col OR min_col IS NULL THEN   min_col := matrix(l).FIRST;   END IF;
            IF matrix(l).LAST  > max_col OR max_col IS NULL THEN   max_col := matrix(l).LAST ;   END IF;
            l := matrix.NEXT(l);
        END LOOP;
        dbms_output.put_line('Rows ' || to_char(min_row) || ' to ' || to_char(max_row) );
        dbms_output.put_line('Cols ' || to_char(min_col) || ' to ' || to_char(max_col) );
        FOR i IN min_row..max_row LOOP
            FOR j IN min_col..max_col LOOP
                IF  matrix.EXISTS(i) AND matrix(i).EXISTS(j)  AND matrix(i)(j) THEN
                    dbms_output.put('*');
                ELSE                                                   
                    dbms_output.put('.');
                END IF;
                null;
            END LOOP;
            dbms_output.put_line('');
        END LOOP;        
    END show_matrix;
    PROCEDURE run( iteration_num INTEGER := 10)
    IS
    BEGIN
        FOR i IN 1..iteration_num  LOOP
            populate_mirror_matrix;
            matrix := mirror_matrix; 
            dbms_output.put_line('========================== show matrix( '|| to_char(i) || ' ) =================================');
            show_matrix;
        END LOOP;    
    END run;
BEGIN
    FOR i IN 8..10 LOOP            -- 3x3 solid square
        FOR j IN 8..10 LOOP        -- of live cells
            matrix(i)(j) := TRUE;  -- round 5, turns into 2 phase blinker
        END LOOP;
    END LOOP;
    matrix(0)(1) := TRUE; -- simple blinker
    matrix(0)(2) := TRUE; --  alternates horizontal line to vertical line
    matrix(0)(3) := TRUE; --
    ------------------------------------
    dbms_output.put_line('========================== Show Matrix(0) =================================');
    show_matrix;
    run(7);

    --
END life;
/



exec life.init
