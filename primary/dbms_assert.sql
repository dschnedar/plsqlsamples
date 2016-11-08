-----------------------------------------------------------------------------------------
---- Clean strings cut down on SQL injection attacks ------------------------------------
---- Returns string unless an EXCEPTION is raised ---------------------------------------
---- Exceptions will 'break' your code logic, preventing dangerous dynamic SQL ----------
-----------------------------------------------------------------------------------------
begin
    ----------------------------------------------------------------------------------------   
    -------- NOOP, No Operation,  anything goes --------------------------------------------     
    ----------------------------------------------------------------------------------------  
    dbms_output.put_line( dbms_assert.NOOP               (    'A quick ''brown fox'    ) ); -- A quick 'brown fox
    dbms_output.put_line( dbms_assert.NOOP               (    'jumped `~over the '     ) ); -- jumped `~over the
    dbms_output.put_line( dbms_assert.NOOP               (    'lazy "dogs.'            ) ); -- lazy "dogs.
    ----------------------------------------------------------------------------------------   
    -------- SQL_OBJECT_NAME, Name of Existing Object --------------------------------------     
    ---------------------------------------------------------------------------------------- 
    dbms_output.put_line( dbms_assert.SQL_OBJECT_NAME    (    'dual'                   ) );  -- dual
    dbms_output.put_line( dbms_assert.SQL_OBJECT_NAME    (    'sys.dual'               ) );  -- sys.dual         -- case insensitive
    dbms_output.put_line( dbms_assert.SQL_OBJECT_NAME    (    '"SYS"."DUAL"'           ) );  -- "SYS"."DUAL"     -- "case sensitive" 
    --dbms_output.put_line( dbms_assert.SQL_OBJECT_NAME  (    'fish'                   ) );  -- NOT OK,  "fish" is not an existing object     
    ----------------------------------------------------------------------------------------   
    -------- ENQUOTE_NAME, does not allow internally "quoted" strings ----------------------   
    --- Upper Cases string unless in ""; because string is considered a DB Object Name -----  
    ---------------------------------------------------------------------------------------- 
    dbms_output.put_line( dbms_assert.ENQUOTE_NAME       (    '1hello world!'           ) );  -- "1HELLO WORLD!"
    dbms_output.put_line( dbms_assert.ENQUOTE_NAME       (    '"2hello  world!"'        ) );  -- "2hello  world!"
    dbms_output.put_line( dbms_assert.ENQUOTE_NAME       (    '3hello "" '              ) );  -- "3HELLO "" "
    dbms_output.put_line( dbms_assert.ENQUOTE_NAME       (    '"4hello "" "'            ) );  -- "4hello "" "
    dbms_output.put_line( dbms_assert.ENQUOTE_NAME       (    '5hello '' world!'''      ) );  -- "5HELLO ' WORLD!'"
    --dbms_output.put_line( dbms_assert.ENQUOTE_NAME     (    'hello  world!"'          ) );  -- NOT OK  
    --dbms_output.put_line( dbms_assert.ENQUOTE_NAME     (    'hello "a" world!'        ) );  -- NOT OK   
    --dbms_output.put_line( dbms_assert.ENQUOTE_NAME     (    'hello " world!'          ) );  -- NOT OK 
    ----------------------------------------------------------------------------------------   
    -------- ENQUOTE_LITERAL , does not allow internally 'quoted' strings ------------------   
    ----------------------------------------------------------------------------------------   
    dbms_output.put_line( dbms_assert.ENQUOTE_LITERAL    (    '1.Hello World!'           ) );  -- '1.Hello World!'  
    dbms_output.put_line( dbms_assert.ENQUOTE_LITERAL    (    '''2.heLLo  world!'''      ) );  -- '2.heLLo  world!' 
    dbms_output.put_line( dbms_assert.ENQUOTE_LITERAL    (    '3.HELLO '''' '            ) );  -- '3.HELLO '' '  
    dbms_output.put_line( dbms_assert.ENQUOTE_LITERAL    (    '4.hello ''''a'''' '       ) );  -- '4.hello ''a'' ' 
    --dbms_output.put_line( dbms_assert.ENQUOTE_LITERAL  (    'HELLO ''a'' '             ) );  -- NOT OK   
    ----------------------------------------------------------------------------------------   
    -------- Existing Schema name  ---------------------------------------------------------     
    ----------------------------------------------------------------------------------------                                
    dbms_output.put_line( dbms_assert.SCHEMA_NAME        (    'SYS'                     ) ); --
    dbms_output.put_line( dbms_assert.SCHEMA_NAME        (    'BEP\SCHNEDARD'           ) ); --    authenticated  schema name      
    --dbms_output.put_line( dbms_assert.SCHEMA_NAME      (    'DOMAIN\USER'             ) ); --    possible Windows system      
    --dbms_output.put_line( dbms_assert.SCHEMA_NAME      (    'WIN_DOMAIN\WIN_USER'     ) ); --    authenticated  schema name 
    ----------------------------------------------------------------------------------------   
    -------- Valid potential name for a DB OBJECT ------------------------------------------    
    -------- "" allows for lowercase and special chars in object name ----------------------
    ----------------------------------------------------------------------------------------                
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    'sys.dual.dummy'         ) );  --   sys.dual.dummy             
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    'SYS.DUAL'               ) );  --   SYS.DUAL              
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    'SYS'                    ) );  --   SYS              
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    'FISH'                   ) );  --   FISH             
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    '"SYS.DUAL..~DUMMY"'     ) );  --   "SYS.DUAL..~DUMMY"
    dbms_output.put_line( dbms_assert.QUALIFIED_SQL_NAME (    '"SYS"."DUAL".".~DUMMY"' ) );  --   "SYS"."DUAL".".~DUMMY        
    ----------------------------------------------------------------------------------------    
    -------- Valid simple name for a DB OBJECT ---------------------------------------------     
    ----------------------------------------------------------------------------------------   
    dbms_output.put_line( dbms_assert.SIMPLE_SQL_NAME    (    'SYS'                    ) );  --   SYS             
    dbms_output.put_line( dbms_assert.SIMPLE_SQL_NAME    (    'FISH'                   ) );  --   FISH              
    dbms_output.put_line( dbms_assert.SIMPLE_SQL_NAME    (    '"SYS.DUAL./DU^~`MMY"'   ) );  --   "SYS.DUAL./DU^~`MMY"
    dbms_output.put_line( dbms_assert.SIMPLE_SQL_NAME    (    '"SYS.DUAL"'             ) );  --   "SYS.DUAL"   -- "." is just a char in name
    --dbms_output.put_line( dbms_assert.SIMPLE_SQL_NAME  (    'SYS.DUAL'               ) );  --   NOT OK       -- "." is name seperator
end;
/










