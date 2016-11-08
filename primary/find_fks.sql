COL constraint_source FORMAT A60 HEADING "Table.Column"
COL references_column FORMAT A60 HEADING "Table.Column"

 
SELECT   uc.constraint_name                                                            as constraint_name
        ,                           '('||ucc1.table_name||'.'||ucc1.column_name||')'   as constraint_source
        ,       '--REF--'
        ,                           '('||ucc2.table_name||'.'||ucc2.column_name||')'   as references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
ORDER BY ucc1.table_name
,        uc.constraint_name;


