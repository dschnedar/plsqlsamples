create or replace package m
as
    function to_bstr( p_i integer ) return varchar2;
    function to_ostr( p_i integer ) return varchar2;
    function to_hstr( p_i integer ) return varchar2;
end;
/
show errors
create or replace package body m
as
    
    function pow2( p_i integer ) return integer is
        ret_val integer := 1;
    begin
        for i in 1..p_i-1 loop
            ret_val := ret_val*2;
        end loop;
        return ret_val;
    end pow2;

    function to_bstr( p_i integer ) return varchar2 is
        n integer := p_i;
        x integer := null;
        ret_str varchar2(2000) := '';
    begin
        ----------------------------for i in 2..25 loop
        ----------------------------for i in 2..13 loop
        for i in 2..25 loop
            x := mod(n,pow2(i));
            n := n - x;
            if x != 0 then
                ret_str :=  '1' || ret_str; 
            else
                ret_str :=  '0' || ret_str; 
            end if;
        end loop;
        return ret_str;
    end to_bstr;

    function to_ostr( p_i integer ) return varchar2 is
        b_str     varchar2(65)  ;
        ret_str   varchar2(60)  := '';
        i         integer       := 1;
        j         integer       := null;
        odigit    varchar2(100) := '~';
    begin
        b_str := to_bstr(p_i);
        while i <= ceil(length(b_str)/3) loop
            j := i*-3;
            --odigit := case lpad(substr(nvl(b_str,'0'),j,3),3,'0')
            odigit := case substr(b_str,j,3)
                          when '000' then '0'
                          when '001' then '1'
                          when '010' then '2'
                          when '011' then '3'
                          when '100' then '4'
                          when '101' then '5'
                          when '110' then '6'
                          when '111' then '7'
                          else            ''
                      end; 
            ret_str := odigit || ret_str;
            i := i+1;
        end loop;
        return ret_str;
    end to_ostr;

    function to_hstr( p_i integer ) return varchar2 is
        b_str     varchar2(65)  ;
        ret_str   varchar2(60)  := '';
        i         integer       := 1;
        j         integer       := null;
        odigit    varchar2(100) := '~';
    begin
        b_str := to_bstr(p_i);
        while i <= ceil(length(b_str)/4) loop
            j := i*-4;
            odigit := case substr(b_str,j,4)
                          when '0000' then '0'
                          when '0001' then '1'
                          when '0010' then '2'
                          when '0011' then '3'
                          when '0100' then '4'
                          when '0101' then '5'
                          when '0110' then '6'
                          when '0111' then '7'
                          when '1000' then '8'
                          when '1001' then '9'
                          when '1010' then 'A'
                          when '1011' then 'B'
                          when '1100' then 'C'
                          when '1101' then 'D'
                          when '1110' then 'E'
                          when '1111' then 'F'
                          else            '.'||substr(b_str,j,4)||'.'
                      end; 
            ret_str := odigit || ret_str;
            i := i+1;
        end loop;
        return ret_str;
    end to_hstr;

end;
/
show errors


begin
    for i in 1..25 loop
    dbms_output.put_line( m.to_bstr(i) );
    end loop;
end;
/




begin
    for i in 1..12 loop
    dbms_output.put_line( m.pow2(i) );
    end loop;
end;
/

begin
    for i in 1..25 loop
        dbms_output.put_line( '10('||to_char(i)||')   ' || '8('||m.to_ostr(i)||')' );
    end loop;
end;
/


begin
    for i in 100000..100100  loop
        dbms_output.put_line( 'd('||to_char(i,'999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
end;
/

begin
    for i in 10000..10100  loop
        dbms_output.put_line( 'd('||to_char(i,'999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
end;
/

begin
    for i in 60000..60900  loop
        dbms_output.put_line( 'd('||to_char(i,'999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
end;
/


begin
    for i in 65000..65535  loop
        dbms_output.put_line( 'd('||to_char(i,'999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
end;
/



begin
    for i in 32767-10..32767+10  loop
        dbms_output.put_line( 'd('||to_char(i,'999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
end;
/


declare
    x integer := 15999000;
begin
    for i in x-100..x  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/






declare
    x integer := 15999999;
begin
    for i in x-100..x  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/





declare
    x integer := 16770000;
begin
    for i in x-100..x  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/

declare
    x integer := 16200000;
begin
    for i in x-100..x  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/




declare
    x integer := 16777000+214+1;
begin
    for i in x-100..x  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/


declare
    x integer := 16777000+214+1;
begin
    for i in 250..257  loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/

declare
    x integer := 32767;
begin
    for i in x-2..x+2 loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/

declare
    x integer := 1024;
begin
    for i in x-2..x+2 loop
        dbms_output.put_line( 'd('||to_char(i,'99999990')||')   ' || 'b('||m.to_bstr(i)||')   '  || 'o('||m.to_ostr(i)||')   ' || 'h('||m.to_hstr(i)||')' );
    end loop;
    dbms_output.put_line(x);
end;
/





/****** 
d(    32767)   b(000000000111111111111111)   o(00077777)   h(007FFF) -- max signed 16 bits, max unsigned 15 bits
d(    65535)   b(000000001111111111111111)   o(00177777)   h(00FFFF) -- max signed 17 bits, max unsigned 16 bits
d( 16777215)   b(111111111111111111111111)   o(77777777)   h(FFFFFF) -- max signed 25 bits, max unsigned 24 bits
*******/
