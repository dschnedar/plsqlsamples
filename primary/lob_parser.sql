------------------------------------------------------
------------------------------------------------------
--  lob parser, will get each token in a CLOB(Character Large Object)
--  tokens are seperated by a seperator
--  the default seperator is a comma
------------------------------------------------------
--  Null tokens are allowed so when get_next() returns 
--       a null you might not be at the end
--  has_next() will return FALSE when at the end
--  extra get_next()s return the last token, no error
--  lob_parser.tokens Table/Array can be used 
--     to directly access the Nth token
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
    FUNCTION  has_next RETURN BOOLEAN;
    FUNCTION  get_next RETURN VARCHAR2;
    --
END lob_parser;
/
show errors
  
  
CREATE OR REPLACE PACKAGE BODY lob_parser
AS  
    next_token INTEGER := NULL;
    curr_token INTEGER := NULL;
    --
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
    FUNCTION  has_next RETURN BOOLEAN
    IS
    BEGIN
        RETURN next_token IS NOT NULL
               OR
               ( curr_token IS NULL   AND   tokens.count > 0 );
    END has_next;
    FUNCTION  get_next RETURN VARCHAR2
    IS
        return_value VARCHAR2(32767);
    BEGIN
        IF has_next THEN
            IF curr_token IS NULL and next_token IS NULL THEN
                return_value := tokens(1);
                curr_token   := 1;
                next_token   := tokens.NEXT(1);
            ELSE
                curr_token   := next_token;
                next_token   := tokens.NEXT(next_token);
                return_value := tokens(curr_token);
            END IF;
        ELSE
            return_value := NULL;
        END IF;
        RETURN return_value;
    END get_next;
    --
    PROCEDURE reset 
    IS 
    BEGIN
        next_token := NULL;
        curr_token := NULL;
    END reset;
    --
    PROCEDURE test
    IS
        clob1 CLOB := ',1,2,3,4,,55,6,7,8,9,';
    BEGIN
        p('-------------------------------------');
        p('------------ TEST START -------------');
        p('-------------------------------------');
        --
        p('---- parse a blob and show tokens ---');
        parse(clob1);
        print_tokens;
        p('---- parse a blob and iterate through tokens ---');
        parse(clob1);
        while lob_parser.has_next loop
            p(  nvl(lob_parser.get_next,'~null~')   );
        end loop;
        p('---- try to loop again without resting---');
        while lob_parser.has_next loop
            p(  nvl(lob_parser.get_next,'~null~')   );
        end loop;
        p('-----------------------------------------');
        p('---- try to loop again after resting---');
        lob_parser.reset;
        while lob_parser.has_next loop
            p(  nvl(lob_parser.get_next,'~null~')   );
        end loop;
        p('-----------------------------------------');
        p('---- at end try extra gets  ---');
        p(nvl(lob_parser.get_next,'~null~'));        
        p(nvl(lob_parser.get_next,'~null~'));
        p(nvl(lob_parser.get_next,'~null~'));
        --
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








