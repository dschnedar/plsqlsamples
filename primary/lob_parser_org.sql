------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--   
--   
--   
--   
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
CREATE OR REPLACE PACKAGE lob_parser
AS
    --
    TYPE tokens_type IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    tokens tokens_type;
    --
    PROCEDURE parse( p_clob CLOB , seperator VARCHAR2 := ',' );
    PROCEDURE print_tokens;
    PROCEDURE test;
    --
END lob_parser;
/
show errors
  
  
CREATE OR REPLACE PACKAGE BODY lob_parser
AS 
    PROCEDURE p( str VARCHAR2 )
    IS
    BEGIN
        dbms_output.put_line( '>' || substr(str,1,254) );
    END p;
    --
    PROCEDURE parse( p_clob CLOB , seperator VARCHAR2 := ',' )
    IS
        i                INTEGER := 0;
        offset           INTEGER := 1;
        token_size     INTEGER := NULL;
        abs_comma_column INTEGER := NULL;
    BEGIN
        tokens.DELETE; -- clear token cache
        i      := 0;
        offset := 1;
        LOOP 
            --p('');
            i := i+1;
            --p('i='||to_char(i)||'   offset='||to_char(offset)|| '   seperator=' || to_char(seperator) );
            abs_comma_column := dbms_lob.instr( p_clob , seperator, offset , 1 );
            token_size := abs_comma_column-offset;
            --p(  'abs_comma_column=' || to_char(abs_comma_column) );
            --p(  'token_size='     || to_char(token_size)     );
            IF abs_comma_column = 0 THEN
                tokens(i) := dbms_lob.substr(p_clob,32767,offset);
                EXIT;
            ELSE
                tokens(i) := dbms_lob.substr(p_clob,token_size,offset);                
                --p( 'substr(*** ,' || token_size  ||' , '|| offset ||' )' );
                --p( 'token('||to_char(i)||')='  ||  '"'||tokens(i)||'"' );
                offset := offset + token_size + 1;
            END IF;
            IF i > 20 THEN EXIT; END IF;
        END LOOP;
        NULL;
    END parse; 
    --
    PROCEDURE print_tokens
    IS
    BEGIN
        FOR i IN tokens.FIRST..tokens.LAST LOOP
            p( substr( nvl(tokens(i),'~NULL~'), 1,255) );  
        END LOOP;
    END print_tokens;
    --
    PROCEDURE test
    IS
        clob1 CLOB := ',1,2,3,4,,55,6,7,8,9,';
    BEGIN
        p('-------------------------------------');
        p('------------ TEST START -------------');
        p('-------------------------------------');
        parse(clob1);
        print_tokens;
        p('-------------------------------------');
        p('------------ TEST FINISH ------------');
        p('-------------------------------------');
    END test;
END lob_parser;
/
show errors
  
begin
    lob_parser.test;
end;
/








