

begin
    dbms_output.put_line('PLSQL_CCFlags: '     ||$$PLSQL_CCFlags);
    dbms_output.put_line('PLSQL_Code_Type: '   ||$$PLSQL_Code_Type);
    dbms_output.put_line('PLSQL_Unit: '        ||$$PLSQL_Unit);
    dbms_output.put_line('PLSQL_Line: '        ||$$PLSQL_Line);
    dbms_output.put_line('PLSQL_USER: '        ||$$PLSQL_USER);
    dbms_output.put_line('PLSQL_owner: '       ||$$PLSQL_OWNER);
    dbms_output.put_line('Flag1: '||$$Flag1);
end;
/


