


drop   table xxclob;
create table xxclob ( c clob);
insert into  xxclob values ('I am CLOB, CLOB I am.');


DECLARE
    clob1 CLOB;
    clob2 CLOB;
    clob3 CLOB;
    PROCEDURE p( str VARCHAR2) IS BEGIN dbms_output.put_line(str);  END p;
BEGIN
    p('-------------------------------------------------------------');
    BEGIN    clob1 := empty_clob(); p('Empty clob1');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob1');    END;
    BEGIN    clob2 := empty_clob(); p('Empty clob2');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob2');    END;
    BEGIN    clob3 := empty_clob(); p('Empty clob3');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob3');    END;
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
    dbms_lob.createtemporary( lob_loc => clob1 
                            , cache   => FALSE 
                            , dur     => dbms_lob.call ) ; -- dbms_lob.session
    clob2 := 'hello';
    select * into clob3  from xxclob ;
    p('-------------------------------------------------------------');
    p('-------------------------------------------------------------');
    BEGIN    clob1 := empty_clob(); p('Empty clob1');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob1');    END;
    BEGIN    clob2 := empty_clob(); p('Empty clob2');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob2');    END;
    BEGIN    clob3 := empty_clob(); p('Empty clob3');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob3');    END;
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
    dbms_lob.createtemporary( lob_loc => clob1 
                            , cache   => FALSE 
                            , dur     => dbms_lob.call ) ; -- dbms_lob.session
    clob2 := 'hello';
    select * into clob3  from xxclob ;
    p('-------------------------------------------------------------');
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
    IF dbms_lob.istemporary(clob1) = 1  THEN   p('free lob1');  dbms_lob.freetemporary(clob1);  ELSE p('can''t free persistent LOB');  END IF;
    IF dbms_lob.istemporary(clob2) = 1  THEN   p('free lob2');  dbms_lob.freetemporary(clob2);  ELSE p('can''t free persistent LOB');  END IF;
    IF dbms_lob.istemporary(clob3) = 1  THEN   p('free lob3');  dbms_lob.freetemporary(clob3);  ELSE p('can''t free persistent LOB');  END IF;  --invalid LOB locator specified:--
    p('-------------------------------------------------------------');
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
    clob1 := ' ';
    clob2 :=  '';
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
    BEGIN    clob1 := empty_clob(); p('Empty clob1');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob1');    END;
    BEGIN    clob2 := empty_clob(); p('Empty clob2');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob2');    END;
    BEGIN    clob3 := empty_clob(); p('Empty clob3');    EXCEPTION WHEN OTHERS THEN   p('Can NOT Empty clob3');    END;
    p(nvl(dbms_lob.istemporary(clob1),-1));
    p(nvl(dbms_lob.istemporary(clob2),-1));
    p(nvl(dbms_lob.istemporary(clob3),-1));
    p('-------------------------------------------------------------');
END;
/




