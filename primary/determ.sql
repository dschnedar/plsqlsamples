------------------------------------------------------------
-- Oracle 10gR2
-- Show tat DETERMINISTIC doesn't cache return values
------------------------------------------------------------


create or replace package xd
as
    function dsqrt(n number) return number deterministic ;
    procedure test;
end;
/
show errors


create or replace package body xd
as             
    procedure p(str varchar2) 
    is
    begin
        dbms_output.put_line(str);
    end p;                             
    function dsqrt(n number)  return number  deterministic

    is
    begin
        p('............calculate square root.................');
        return sqrt(n);
    end;
    procedure test 
    is
    begin
        for i in 1..10 loop
        p(to_char(i) ||':'||  dsqrt(i)  );
        end loop;
    end test;
end;
/
show err




create or replace package xdx
as
    function dsqrt(n number) return number deterministic ;
    procedure test;
end;
/
show errors


create or replace package body xdx
as           
    type sqrt_table_type is table of number index by pls_integer;  
    sqrt_table sqrt_table_type;
    --
    procedure p(str varchar2) 
    is
    begin
        dbms_output.put_line(str);
    end p;                             
    function dsqrt(n number)  return number  deterministic
    is
        ret_val number;
    begin
        if mod(n,1)=0  and  sqrt_table.exists(n) then 
            ret_val := sqrt_table(n);
        else
            p('............calculate square root.................');
            ret_val := sqrt(n);
            if mod(n,1) = 0 then
                sqrt_table(n) := ret_val;
            end if;
        end if;
        return ret_val;
    end;
    procedure test 
    is
    begin
        for i in 1..10 loop
            p(to_char(i) ||':'||  dsqrt(i)  );
        end loop;
        p( to_char(3.14)   ||':'||  dsqrt(3.14)   );
        p( to_char(100.01) ||':'||  dsqrt(100.01) );
        p( to_char(22/7)   ||':'||  dsqrt(22/7)   );
        for i in 1..10 loop
            p(to_char(i) ||':'||  dsqrt(i)  );
        end loop;
        p( to_char(3.14)   ||':'||  dsqrt(3.14)   );
        p( to_char(100.01) ||':'||  dsqrt(100.01) );
        p( to_char(22/7)   ||':'||  dsqrt(22/7)   );
    end test;
end;
/
show err
