create or replace procedure x_gen( tbl_name varchar2 ) 
is
    type column_record_type is record (col_name varchar2(30 ), col_type varchar2(30) );
    type column_table_type  is table of column_record_type index by binary_integer;
    column_table            column_table_type  ;
    --
    insert_function_name   varchar2(30);
    i                      integer := 0;
    pk                     varchar2(30);
    pk_seq                 varchar2(30);
    --
    procedure p(str varchar2)
    is
    begin
        dbms_output.put_line( '>' || str );
    end p;
    --
    function n_comma(i number) return varchar2
    is
    begin
        if i > 1 then
            return ' , '; 
        else
            return '   ';
        end if;
    end n_comma;
    --
begin
    null;
    column_table.delete;
    pk_seq := tbl_name||'_seq';
    --
    for kol_data in ( select all  user_tab_columns.column_name , user_tab_columns.data_type 
                            from  user_tab_columns 
                           where  table_name = upper(x_gen.tbl_name) 
                        order by  user_tab_columns.column_id 
             ) 
    loop
        column_table(column_table.count+1) := kol_data;
    end loop;
    --
    insert_function_name := 'ins_'||tbl_name; 
    --
    p( '    FUNCTION  '|| insert_function_name || '(' );
    for j in 1..column_table.count loop
        if j=1 then pk := column_table(j).col_name;  end if;
        p(  '         ' || n_comma(j) ||  rpad('p_'||column_table(j).col_name,32)  ||'   '|| rpad(column_table(j).col_type,10)   ||'=> default null '    );
    end loop;
     p('          ) '  );
     p('    RETURN NUMBER '                                                   );
     p('    IS'                                                               );
     p('        new_pk  integer := null; '                                    );
     p('    BEGIN'                                                            );
     p('        NULL;'                                                        );
     p('        IF ' || pk || ' IS NULL THEN '                                );
     p('            SELECT ' || pk_seq ||'.NEXTVAL INTO new_pk FROM DUAL; '   );
     p('        ELSE                                                     '    );
     p('            new_pk := ' || pk || ';'                                  );
     p('        END IF; '                                                     );


     p('    INSERT INTO ' || tbl_name  || ' ( '                               );
     ---------------------------------------------------------------------------
     p('    ) VALUES ( '                                                      );
     ---------------------------------------------------------------------------
     p('    ) ; '                                                             );



     p('    INSERT INTO ' || tbl_name  || ' ( '                               );
     p('    INSERT INTO ' || tbl_name  || ' ( '                               );




     ---------------------------------------------------------------------------
     p('    END '|| insert_function_name ||';'                                );
------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------




    p ( '    PROCEDURE upd_'||lower(tbl_name)|| '(' ||')' );
    p ( '    PROCEDURE del_'||lower(tbl_name)|| '(' ||')' );
    



end;
/
show errors




begin
    x_gen('x_person');
end;
/



