-------------------------------------------------------
--  Very simple encoder/decoder
--  Rotate letters by 13 letter positions
--  A becomes N, B becomes O,...N becomes A...
--  Leave other characters alone
-------------------------------------------------------
---
--- rot13
---
declare
    function rot13c(c char ) return char
    is  
    begin
        case 
          when c between 'A' and 'Z' then
                return chr( mod( ascii(c)-ascii('A')+ 13 , 26 ) + ascii('A') );
          when c between 'a' and 'z' then
                return chr( mod( ascii(c)-ascii('a')+ 13 , 26 ) + ascii('a') );
          else
                return c;
        end case;
    end rot13c;
    --
    function rot13(str varchar2 ) return varchar2
    is  
        str13 varchar2(32767);
    begin
        for i in 1..length(str) loop                   -- I hope substr is efficient 
            str13 := str13 || rot13c(substr(str,i,1)); -- going straight to letter N
        end loop;                                      -- and not traversing from
        return str13;                                  -- start of string each time.
    end rot13;
begin
    for i in 32..126 loop
        dbms_output.put(   'ascii('
                         ||to_char(i,'999')
                         || ')=('
                         || chr(i)
                         || ')'
                       );
        dbms_output.put(       '   rot13('       || rot13c(         chr(i) )  ||')'   );
        dbms_output.put_line(  '   rot13(rot13(' || rot13c(rot13c(  chr(i) )) ||'))'  );
    end loop;
    dbms_output.put_line( '>     orginal: ' || 'abcdefg..ABCDEFG'                 );
    dbms_output.put_line( '>       rot13: ' || rot13('abcdefg..ABCDEFG')          );
    dbms_output.put_line( '>rot13(rot13): ' || rot13( rot13('abcdefg..ABCDEFG') ) );
end;
/

