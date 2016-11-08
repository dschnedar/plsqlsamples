COLUMN  tab       FORMAT a30
COLUMN  col       FORMAT a30
COLUMN  nullable  FORMAT a4
COLUMN  type      FORMAT a15
COLUMN  comments  FORMAT a40



SELECT ALL user_tab_columns.table_name                                                               AS tab
         , user_tab_columns.column_name                                                              AS col
         , user_tab_columns.nullable                                                                 AS nullable
         , concat(concat(concat(user_tab_columns.data_type,'('),user_tab_columns.data_length),')')   AS type
         , user_col_comments.comments                                                                AS comments
FROM       user_tab_columns     
LEFT JOIN  user_col_comments        ON user_tab_columns.table_name    =   user_col_comments.table_name 
                                   AND user_tab_columns.column_name   =   user_col_comments.column_name 
WHERE      user_tab_columns.table_name  NOT LIKE '%BAK%'
AND        user_tab_columns.table_name  NOT LIKE '%BK%'
AND        user_tab_columns.table_name  NOT LIKE 'X%'
AND        user_tab_columns.table_name  NOT LIKE '%TMP%'
--
UNION
--
SELECT ALL user_tables.table_name            AS tab
         , NULL                              AS col
         , NULL                              AS nullable
         , NULL                              AS type
         , user_tab_comments.comments        AS comments
FROM       user_tables  
LEFT JOIN  user_tab_comments        ON user_tables.table_name    =   user_tab_comments.table_name 
WHERE      user_tables.table_name  NOT LIKE '%BAK%'
AND        user_tables.table_name  NOT LIKE '%BK%'
AND        user_tables.table_name  NOT LIKE 'X%'
AND        user_tables.table_name  NOT LIKE '%TMP%'
ORDER BY   tab ASC , col ASC NULLS FIRST
;
