/************************************************
SQL% { FOUND
     | ISOPEN
     | NOTFOUND
     | ROWCOUNT
     | BULK_ROWCOUNT ( index )
     | BULK_EXCEPTIONS ( index ).{ ERROR_INDEX | ERROR_CODE }
     }

%FOUND     Attribute: Has a DML Statement Changed Rows?
%ISOPEN    Attribute: Always FALSE for SQL Cursors
%NOTFOUND  Attribute: Has a DML Statement Failed to Change Rows?
%ROWCOUNT  Attribute: How Many Rows Affected So Far?
/************************************************/


drop   table xx_table;
create table xx_table ( id number );
begin
        for i in 1..6 loop
            insert into xx_table values (i);
        end loop;
end;
/
declare
    cursor x_cur is select * from xx_table where rownum < 4;
    --
    type xx_array_type is table of number index by pls_integer;
    xx_array   xx_array_type ;
    --
    x varchar2(60);
    --
    procedure p(str varchar2) is begin    dbms_output.put_line('>'|| substr(str,1,254));    end p;
    --
    procedure show is
        found       varchar2(30);
        notfound    varchar2(30);
        rowcount    varchar2(30);
        isopen      varchar2(30);
    begin
        IF   SQL%FOUND      THEN   found    := 'TRUE';   else   found    := 'FALSE';   end if;
        IF   SQL%NOTFOUND   THEN   notfound := 'TRUE';   else   notfound := 'FALSE';   end if;
        IF   SQL%ISOPEN     THEN   isopen   := 'TRUE';   else   isopen   := 'FALSE';   end if;
        rowcount := nvl(to_char(SQL%ROWCOUNT),'~');
        p('SQL%FOUND    =' || found     );
        p('SQL%NOTFOUND =' || notFound  );
        p('SQL%ISOPEN   =' || isOpen    );
        p('SQL%ROWCOUNT =' || rowCount  );
    end show;
    --
    procedure show_cur  is
        found       varchar2(30);
        notfound    varchar2(30);
        rowcount    varchar2(30);
        isopen      varchar2(30);
    begin
        IF   x_cur%ISOPEN     THEN
            IF   x_cur%FOUND      THEN   found    := 'TRUE';   else   found    := 'FALSE';   end if;
            IF   x_cur%NOTFOUND   THEN   notfound := 'TRUE';   else   notfound := 'FALSE';   end if;
            rowcount := nvl(to_char(x_cur%ROWCOUNT),'~');
        END IF;
        IF   x_cur%ISOPEN     THEN   isopen   := 'TRUE';   else   isopen   := 'FALSE';   end if;
        p('x_cur%FOUND    =' || found     );
        p('x_cur%NOTFOUND =' || notFound  );
        p('x_cur%ISOPEN   =' || isOpen    );
        p('x_cur%ROWCOUNT =' || rowCount  );
    end show_cur;
    --
begin
    p('select ''x'' into x from dual;');
    select 'x' into x from dual;
    show;
    p('insert into xx_table select * from xx_table;');
    insert into xx_table select * from xx_table;
    show;
    p('delete xx_table where mod(id,2) = 0;');
    delete xx_table where mod(id,2) = 0;
    show;
    select * bulk collect into xx_array from xx_table;
    if xx_array.count > 0 then
        for i in xx_array.first .. xx_array.last loop
            p(  to_char(i) || ':' || to_char(xx_array(i))  );
        end loop;
    end if;
    show;
    p('insert into xx_table select * from xx_table where 1=2;');
    insert into xx_table select * from xx_table where 1=2;
    show;
    p('------------------------------------------------------------------------');   
    declare
        i integer := 0;
    begin
        open x_cur;
        loop
            fetch x_cur into x; i := i+1;
            p('..........................fetch('  ||to_char(i)|| ')' );
            show_cur;
            if x_cur%NOTFOUND then
                close x_cur;
                p('.....................close');
                show_cur;
                exit;
            end if; 
        end loop;
    end;
end;
/
