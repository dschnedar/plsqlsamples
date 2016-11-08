--multiset except
--multiset intersect
--multiset union
--set


/**************************************
COUNT      -- all
FIRST      -- all
LAST       -- all
LIMIT      -- varray
PRIOR()    -- all
NEXT()     -- all
EXISTS()   -- all 
----------
DELETE()   -- all, delete (n) element
DELETE(,)  -- all, delete n through m
EXTEND     -- varray,table -- add 1 element,
EXTEND()   -- varray,table -- add N elements,
EXTEND(,)  -- varray,table -- add N elements filled with value(N)
TRIM       -- all, trim last element   
TRIM()     -- all, trim last N elements
***************************************/

/************EXCEPTIONS****************
COLLECTION_IS_NULL
NO_DATA_FOUND
SUBSCRIPT_BEYOND_COUNT
SUBSCRIPT_OUTSIDE_LIMIT
VALUE_ERROR
***************************************/



-- VARRAY          .12345678901    . can trim from end
-- TABLE           .123456 890 234 .--> no LIMIT, can trim and delete internal cells
-- ASSOC   <-- -3-10   4   8   2 4  --> no LIMITS, just an ordered hash table

DECLARE
    ------------------------------------------------------------------------
    TYPE t_varry_strings IS VARRAY(7)  OF VARCHAR2(30);
    TYPE t_table_strings IS TABLE      OF VARCHAR2(30);
    TYPE t_assoc_strings IS TABLE      OF VARCHAR2(30) INDEX BY PLS_INTEGER;
    ------------------------------------------------------------------------
    v_varry t_varry_strings ;
    v_table t_table_strings ;
    v_assoc t_assoc_strings ;
    ------------------------------------------------------------------------
    PROCEDURE p( str VARCHAR2 := NULL )    IS    BEGIN    dbms_output.put_line( substr( nvl(str,'~'),1,255) );    END p;
BEGIN
    NULL;
    p('');
    p('FIRST,LAST,COUNT,LIMIT-------------------------');
    p( v_assoc.FIRST );
    p( v_assoc.LAST  );
    p( v_assoc.COUNT );
    p( v_assoc.LIMIT );-------------------------------------------------------------- LIMIT always NULL   
    v_assoc.DELETE; 
    --


    v_table := t_table_strings('A','B','C');                  -- needs to be initialized
    v_table := t_table_strings('first','second','third');     -- can be reinitialized
    --
    p('FIRST,LAST,COUNT,LIMIT-------------------------');
    p( v_table.FIRST );
    p( v_table.LAST  );
    p( v_table.COUNT );
    p( v_table.LIMIT );
    --
    p('---------- count trim(1) count ----------');
    p( v_table.COUNT );
    p( v_table.LIMIT );
    v_table.TRIM(1);
    p( v_table.COUNT );
    p( v_table.LIMIT );
    --
    v_table.DELETE;
    --
    

    
    v_varry := t_varry_strings('A','B','C');             -- needs to be initialized
    v_varry := t_varry_strings('first','second');        -- can be reinitialized
    --
    p('FIRST,LAST,COUNT,LIMIT,NEXT(1)-----------------');
    p( v_varry.FIRST );
    p( v_varry.LAST  );
    p( v_varry.COUNT );
    p( v_varry.LIMIT );
    p( v_varry.NEXT(1));
    v_varry.DELETE;  -- 
    p('FIRST,LAST,COUNT,LIMIT,NEXT(1)-----------------');
    p( v_varry.FIRST );
    p( v_varry.LAST  );
    p( v_varry.COUNT );
    p( v_varry.LIMIT );
    p( v_varry.NEXT(1));
    IF v_varry.EXISTS(1) THEN p('(1) exists'); ELSE  p('(1) NOT exist');  END IF;
    IF v_varry.EXISTS(1) THEN p('(8) exists'); ELSE  p('(8) NOT exist');  END IF;
    -- 
    v_varry := NULL;   ----------------------------------------------------- unititializes
END;
/



