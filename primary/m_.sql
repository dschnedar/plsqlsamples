
CREATE OR REPLACE PACKAGE m
AS
    TYPE coordinate_type       IS RECORD ( x BINARY_INTEGER, y BINARY_INTEGER );
    TYPE coordinate_stack_type IS TABLE OF coordinate_type       INDEX BY BINARY_INTEGER;
    --
    TYPE maze_cell_type        IS TABLE OF CHAR           INDEX BY BINARY_INTEGER;   -- ('S',' ','F')  (Start, open cell , Finish)
    TYPE maze_type            IS TABLE OF maze_cell_type INDEX BY BINARY_INTEGER;   
    --
    point_stack  coordinate_stack_type;  -- starts at index(0)
    maze         maze_type;
    --
    FAIL    CONSTANT INTEGER := -1;
    SUCCESS CONSTANT INTEGER :=  1;
    --
    FUNCTION  pop_coordinate  RETURN coordinate_type;
    PROCEDURE push_coordinate( p_point coordinate_type );
    PROCEDURE show_stack;
    PROCEDURE show_point( p_point coordinate_type );
    PROCEDURE test;
END;
/
show errors

CREATE OR REPLACE PACKAGE BODY m
AS
    PROCEDURE pl( p_str VARCHAR2 ) IS BEGIN    dbms_output.put_line( p_str );    END pl;
    PROCEDURE p(  p_str VARCHAR2 ) IS BEGIN    dbms_output.put( p_str      );    END p ;
    --
    PROCEDURE show_point( p_point coordinate_type ) IS
    BEGIN
        pl( '(' || to_char(p_point.x) || ',' || to_char(p_point.y) || ')' );
    END show_point;
    --
    FUNCTION pop_coordinate RETURN coordinate_type
    IS
        v_coordinate coordinate_type;
    BEGIN
        v_coordinate := point_stack( point_stack.COUNT-1 );   -- starts at index(0)
        point_stack.DELETE(          point_stack.COUNT-1 );
        RETURN v_coordinate;
    END pop_coordinate;
    --
    PROCEDURE push_coordinate( p_point coordinate_type )
    IS
    BEGIN
        point_stack( point_stack.COUNT ) := p_point;
    END push_coordinate;
    ----------------------------------------------------------------------------------
    PROCEDURE show_stack
    IS
    BEGIN 
        pl('====stack====');
        FOR i IN 1..point_stack.COUNT LOOP
            show_point( point_stack(point_stack.COUNT-i)  ); 
        END LOOP;
        pl('=============');
    END show_stack;   
    ----------------------------------------------------------------------------------
    PROCEDURE show_maze
    IS
        min_col INTEGER;
        max_col INTEGER;
    BEGIN 
        FOR i_row IN maze.FIRST..maze.LAST LOOP
            IF maze.exists(i_row) THEN
                IF    min_col IS NULL OR min_col < maze(i_row).FIRST    THEN     min_col := maze(i_row).FIRST;    END IF;
                IF    max_col IS NULL OR max_col > maze(i_row).LAST     THEN     max_col := maze(i_row).LAST;     END IF;
            END IF;
        END LOOP;
        pl('=====maze size ====');
        pl( 'rows ' || to_char(maze.FIRST) ||' to '|| to_char( maze.LAST )  );
        pl( 'cols ' || to_char(min_col)    ||' to '|| to_char( max_col )    );
        pl('===================');
        pl('===== draw maze ===='); 
        FOR i_row IN maze.FIRST-1..maze.LAST+1 LOOP
            p('.');       
            IF   maze.exists(i_row) THEN
                FOR i_col IN min_col-1..max_col+1 LOOP
                    IF maze(i_row).exists(i_col)   THEN
                        p( maze(i_row)(i_col) );
                    ELSE
                        p('*');
                    END IF;
                END LOOP;
            ELSE
                FOR i IN min_col-1..max_col+1 LOOP     p('*');     END LOOP;
            END IF;
            pl('.');
        END LOOP;
        p('====================');
    END show_maze;   
    ----------------------------------------------------------------------------------
    ------------------------
    FUNCTION left ( p coordinate_type ) RETURN coordinate_type IS p_tmp coordinate_type; BEGIN   p_tmp.x:=p.x-1;     p_tmp.y:=p.y;     RETURN p_tmp;   END;
    FUNCTION up   ( p coordinate_type ) RETURN coordinate_type IS p_tmp coordinate_type; BEGIN   p_tmp.x:=p.x;       p_tmp.y:=p.y+1;   RETURN p_tmp;   END;
    FUNCTION right( p coordinate_type ) RETURN coordinate_type IS p_tmp coordinate_type; BEGIN   p_tmp.x:=p.x+1;     p_tmp.y:=p.y;     RETURN p_tmp;   END;
    FUNCTION down ( p coordinate_type ) RETURN coordinate_type IS p_tmp coordinate_type; BEGIN   p_tmp.x:=p.x;       p_tmp.y:=p.y-1;   RETURN p_tmp;   END;
    --FUNCTION move ( p ) RETURN INTEGER -- 1=win , -1=failure
    --IS
    --BEGIN
    --    null;
    --    IF maxz
    --END move;
    ------------------------
    --
    PROCEDURE test 
    IS 
        my_point      coordinate_type;
    BEGIN
        my_point.x := 1;
        my_point.y := 3;
        pl('push');
        push_coordinate( my_point );
        my_point.x := 11;
        my_point.y := 33;
        show_stack; 
        pl('push');
        push_coordinate( my_point );
        show_stack;
        --
        --
        pl('pop');
        my_point := pop_coordinate;
        show_point(my_point);
        show_stack;
        pl('pop');
        my_point := pop_coordinate;
        show_point(my_point);
        show_stack;
        --
        --
        maze(1)(3) := ' ';
        maze(1)(4) := 'S';    -- ...S...
        maze(2)(4) := ' ';    -- ... ...
        maze(2)(5) := ' ';
        maze(2)(6) := ' ';
        maze(2)(4) := ' ';
        maze(3)(4) := 'F';    -- ...F...
        maze(1)(5) := ' ';
        show_maze;
        --
        --
    END test;
END;
/
show errors



