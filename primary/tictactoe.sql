
---------------------------------
---------------------------------
-- Drop Everything --------------
---------------------------------
---------------------------------
/*
DROP PACKAGE BODY ttt_pkg;
DROP PACKAGE      ttt_pkg;
DROP TABLE        ttt_memory;
DROP SEQUENCE     ttt_mem_seq;
DROP TABLE        ttt;
/**/

select object_name from user_objects where object_name like '%TTT%';


CREATE TABLE ttt
(    row_num    INTEGER
  ,  col_1      VARCHAR(1)
  ,  col_2      VARCHAR(1)
  ,  col_3      VARCHAR(1)
)
;

CREATE TABLE ttt_memory
(    id         INTEGER
  ,  col_1      VARCHAR(1)
  ,  col_2      VARCHAR(1)
  ,  col_3      VARCHAR(1)
  ,  col_4      VARCHAR(1)
  ,  col_5      VARCHAR(1)
  ,  col_6      VARCHAR(1)
  ,  col_7      VARCHAR(1)
  ,  col_8      VARCHAR(1)
  ,  col_9      VARCHAR(1)
)
;

CREATE sequence ttt_mem_seq;


CREATE OR REPLACE PACKAGE ttt_pkg
AS
    PROCEDURE start_game;
    PROCEDURE erase;
    FUNCTION place( xo VARCHAR , row INTEGER, col INTEGER ) RETURN BOOLEAN;
END ttt_pkg;
/



CREATE OR REPLACE PACKAGE BODY ttt_pkg
AS
    game_id  INTEGER;
    --
    FUNCTION place( xo VARCHAR , row INTEGER, col INTEGER ) RETURN BOOLEAN
    IS
        v_row VARCHAR(30);
    BEGIN
        ---------------------- check parameters ---------------------- 
        IF        ( row       IS NULL  OR  col       > 3   )
           AND    ( col       IS NULL  OR  col       > 3   )
           AND NOT( upper(xo) = 'X'    OR  upper(xo) = 'O' )
        THEN
            RETURN FALSE;
        END IF;

        ---------------------- check for empty space ---------------------- 
        SELECT nvl(col_1,'_') || nvl(col_2,'_') || nvl(col_3,'_')
        INTO   v_row
        FROM   ttt
        WHERE  row_num = row;

        IF substr(v_row,col,1) != '_' THEN
            RETURN FALSE;
        END IF;

         ---------------------- place X or O ---------------------- 
         UPDATE  ttt
         SET     col_1 =  CASE  row  WHEN 1  THEN  upper(xo)   ELSE col_1   END
           ,     col_2 =  CASE  row  WHEN 2  THEN  upper(xo)   ELSE col_2   END
           ,     col_3 =  CASE  row  WHEN 3  THEN  upper(xo)   ELSE col_3   END
         WHERE   row_num = row;

        RETURN TRUE;
    END place;
    --
    PROCEDURE erase
    IS
    BEGIN
      DELETE ttt;
    END erase;
    --
    PROCEDURE erase_memory
    IS
    BEGIN
      DELETE ttt_memory;
    END erase_memory;
    --
    PROCEDURE erase_game_memory  
    IS
    BEGIN
      DELETE ttt_memory WHERE game_id > 0;
    END erase_game_memory; 
    --
    PROCEDURE integrate_memory
    IS
    BEGIN
        NULL;
    END  integrate_memory;
    --
    PROCEDURE start_game
    IS
        memory_count INTEGER := 0;
    BEGIN
      erase;
      --
      INSERT INTO ttt ( row_num , col_1 , col_2 , col_3 ) VALUES ( 1 , '_' , '_' , '_' );
      INSERT INTO ttt ( row_num , col_1 , col_2 , col_3 ) VALUES ( 2 , '_' , '_' , '_' );
      INSERT INTO ttt ( row_num , col_1 , col_2 , col_3 ) VALUES ( 3 , '_' , '_' , '_' );
      --
      SELECT  ttt_mem_seq.NEXTVAL INTO game_id FROM sys.dual WHERE ROWNUM = 1;
      --
    END start_game;
    --
BEGIN
    NULL;
    ---ttt_pkg.start_game;
END ttt_pkg;
/
show errors









SELECT * FROM ttt ORDER BY row_num;
BEGIN
   ttt_pkg.start_game;
END;
/
SELECT * FROM ttt ORDER BY row_num;

DECLARE
   move_success BOOLEAN;
BEGIN
   move_success  := ttt_pkg.place('X', 2 , 2);
END;
/
SELECT * FROM ttt ORDER BY row_num;


BEGIN
   ttt_pkg.erase;
END;
/
SELECT * FROM ttt ORDER BY row_num;



