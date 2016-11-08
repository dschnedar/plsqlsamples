-----------------------------------------------------------------
-- Towers of Hanoi
-- A simple game where you move rings from one tower to another
-- Only smaller rings can be moved on top of larger rings
-- Move all the rings off the first tower to another tower
-- There are three towers
-----------------------------------------------------------------
CREATE OR REPLACE PACKAGE toh
AS
    DEFAULT_NUMBER_OF_DISKS    CONSTANT INTEGER :=    4; -- number of disks = size of biggest disk
    Number_Of_Disks                     INTEGER := NULL; -- can be changed by init_towers()
    --
    PROCEDURE test;
    PROCEDURE init_towers( p_number_of_disks INTEGER DEFAULT DEFAULT_NUMBER_OF_DISKS );
    PROCEDURE show_towers;
    PROCEDURE move( source_tower INTEGER , target_tower INTEGER);
    PROCEDURE MoveTower( p_disk integer , p_from integer , p_to integer , p_using integer);
END toh;
/
show errors




CREATE OR REPLACE PACKAGE BODY toh
AS
    TYPE tower_type  IS TABLE OF INTEGER    INDEX BY PLS_INTEGER;
    TYPE towers_type IS TABLE OF tower_type INDEX BY PLS_INTEGER;
    --
    towers towers_type;
    NUMBER_OF_TOWERS           CONSTANT INTEGER :=    3;
    --
    -----------------------------------------------------------------------
    --  This is the classic algorithm                                    --
    --  PUBLIC: Move all or some disks from source tower to target tower --
    -----------------------------------------------------------------------
    PROCEDURE MoveTower( p_disk integer , p_from integer , p_to integer , p_using integer)
    IS
    BEGIN
        IF p_disk > 0 THEN
            MoveTower( p_disk - 1 , p_from  , p_using , p_to   );
            move( p_from , p_to );
            MoveTower( p_disk - 1 , p_using , p_to    , p_from );
        END IF;
    END MoveTower;
    --
    --
    --
    --
    --
    --
    --
    -- PRINT --
    PROCEDURE p( str VARCHAR2 ) IS BEGIN dbms_output.put_line(substr( '>' || str ,1 ,255 ) ); END p; -- PRINT
    --
    FUNCTION tower_top( t PLS_INTEGER ) RETURN PLS_INTEGER
    IS
    BEGIN
        CASE                  -- quick decision --
            WHEN towers(t)(towers(t).FIRST) IS NULL     THEN RETURN    0;
            WHEN towers(t)(towers(t).LAST ) IS NOT NULL THEN RETURN    towers(t).LAST ; -- no more room
            ELSE                               NULL;
        END CASE;  
        FOR i IN  1..towers(t).LAST    LOOP  -- every other option --
            IF towers(t)(i) IS NULL THEN RETURN i-1; END IF;
        END LOOP;
    END tower_top;
    --
    FUNCTION tower_disk_capacity( t PLS_INTEGER ) RETURN PLS_INTEGER IS
    BEGIN
        CASE tower_top(t)
            WHEN towers(t).LAST THEN  RETURN 0;
            WHEN 0              THEN  RETURN towers(t).LAST;
            ELSE                      RETURN towers(t)( tower_top(t) );
        END CASE;
    END tower_disk_capacity;
    --
    --------------------------------------------------------------------------------------
    --  Display 3 towers left to right                                                  --
    --    The number of stars per disk is 2 more than size of disk except for 1st disk  --
    --------------------------------------------------------------------------------------
    PROCEDURE show_towers
    IS                                                    --     .           .         .
        level       integer;                              --     .           .         .    
        tower       integer;                              --   *****         *         .      
        display_str varchar2(2000) := NULL;               --  *******       ***        .       
        my_trim     VARCHAR2(2000) := NULL;      
        d           VARCHAR2(2000) := NULL;
    BEGIN
        FOR j IN 1..NUMBER_OF_DISKS LOOP
            display_str := '   ';
            level := Number_Of_Disks + 1 - j;
            FOR i IN 1..NUMBER_OF_TOWERS LOOP
                tower := i;
                d         := nvl( rpad( '*' ,  towers(tower)(level)*2-1 , '*' ) ,'.' );
                my_trim   := rpad( ' ' ,  ( (NUMBER_OF_DISKS*3)-length(d) ) /2  );
                d         := my_trim || d || my_trim;
                display_str :=   display_str || d     ;
            END LOOP; 
            p(display_str);
        END LOOP;  
        p('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    END show_towers;
    
    --------------------------------------------------------------------------------
    -- Put all disks on first 1    -- Side affect: Number_Of_Disks is initialized --
    --------------------------------------------------------------------------------
    PROCEDURE init_towers( p_number_of_disks INTEGER DEFAULT DEFAULT_NUMBER_OF_DISKS ) 
    IS
    BEGIN
        Number_Of_Disks := p_number_of_disks;
        FOR i IN 1..NUMBER_OF_TOWERS LOOP
            FOR j IN 1..NUMBER_OF_DISKS LOOP
                towers(i)(j) := NULL;         
            END LOOP;                                  -- indx    Tower1      Tower2  Tower3
        END LOOP;                                      --  4      1   *       Null    Null    
        FOR j IN 1..NUMBER_OF_DISKS LOOP               --  3      2  ***      Null    Null    
            towers(1)(NUMBER_OF_DISKS+1-j) := j;       --  2      3 *****     Null    Null    
        END LOOP;                                      --  1      4*******    Null    Null
        show_towers;
    END init_towers;
    --
    -------------------------------------------------------------------------------------
    --  Move top disk from source tower to target tower   --Must be valid move to work --
    -------------------------------------------------------------------------------------
    PROCEDURE move( source_tower INTEGER , target_tower INTEGER)
    IS
    BEGIN
         ----- order of checks prevents index out of range error ----
         IF    source_tower <> target_tower                                                              -- different towers?
               AND  source_tower BETWEEN towers.FIRST AND towers.LAST                                    -- good index?
               AND  target_tower BETWEEN towers.FIRST AND towers.LAST                                    -- good index?
               AND  tower_top(target_tower) <   towers(target_tower).LAST                                -- target not full
               AND  tower_top(source_tower) >=  towers(source_tower).FIRST                               -- source tower not empty
               AND  tower_disk_capacity(target_tower) >= towers(source_tower)(tower_top(source_tower) )  -- size legal move?
         THEN
             towers(target_tower)(tower_top(target_tower)+1) := towers(source_tower)(tower_top(source_tower)  );
             towers(source_tower)(tower_top(source_tower)  ) := NULL;
         ELSE
             p('*** ERROR *** Illegal Move: from ' || to_char(source_tower) || ' to ' || to_char(target_tower)  );
         END IF;
        show_towers;
    END move;
    --
    -----------------------
    -- Basic test cases  --
    -----------------------
    PROCEDURE test IS
    BEGIN
        p('---------------------------------------------------------------');
        p('-- move tests: 4 illegal moves --------------------------------');
        p('---------------------------------------------------------------');
        init_towers();
        move(1,1);  --illegal
        move(2,3);  --illegal
        move(2,2);  --illegal
        --
        move(1,2);
        move(1,2);  --illegal
        --
        p('---------------------------------------------------------------');
        p('-- move tests: manually solve for 5 disks----------------------');
        p('-- there will be errors if there are less than 5 disks --------');
        p('-- if there are more, disks will be left on the source tower --');
        p('---------------------------------------------------------------');
        init_towers( 5 );
        move(1,2);
        move(1,3);
        move(2,3);
        move(1,2);
        move(3,1);
        move(3,2);
        move(1,2);
        move(1,3);
        move(2,3);
        move(2,1);
        move(3,1);
        move(2,3);
        move(1,2);
        move(1,3);
        move(2,3);
        p('---------------------------------------------------------------');
        p('-- auto solve for N, all, disks     ---------------------------');
        p('---------------------------------------------------------------');
        init_towers(); 
        MoveTower( Number_Of_Disks , 1 , 3 , 2  );
        p('---------------------------------------------------------------');
        p('-- auto solve for N-1, disks     ------------------------------');
        p('--- one disk will be left on the source tower -----------------');
        p('---------------------------------------------------------------');
        init_towers(5); 
        MoveTower( Number_Of_Disks-1, 1 , 3 , 2  );
    END test;
    
END toh;
/
show errors



begin
    toh.test;
    dbms_output.put_line(' ----------------------------------------------------------------------- ');
    dbms_output.put_line(' --  TEST FROM OUTSIDE PACKAGE                                           ');
    dbms_output.put_line(' ----------------------------------------------------------------------- ');
    toh.init_towers(4); 
    toh.MoveTower( toh.NUMBER_OF_DISKS, 1 , 3 , 2  );
end;
/
