SELECT   Parent.TABLE_NAME                     Parent_TABLE,
         Parent.CONSTRAINT_NAME                Parent_CONSTRAINT,
         Child.TABLE_NAME                      Child_TABLE,
         Child.CONSTRAINT_NAME                 Child_CONSTRAINT,
         CHILD.Delete_Rule,
         CHILD.STATUS
 FROM All_CONSTRAINTS Child, All_CONSTRAINTS Parent
 WHERE Child.R_CONSTRAINT_NAME = Parent.CONSTRAINT_NAME
 AND   Child.TABLE_NAME != Parent.TABLE_NAME
 AND   Child.TABLE_NAME = upper('&Child_Table_Name')
 ORDER BY Parent.TABLE_NAME
;





SELECT Parent.TABLE_NAME                       Parent_TABLE,
       Parent.CONSTRAINT_NAME                  Parent_CONSTRAINT,
       RTRIM(Child.TABLE_NAME)                 Child_TABLE, 
       atc.comments                         AS Table_Desc,
       Child.CONSTRAINT_NAME                   Child_CONSTRAINT,
       RTRIM(col.COLUMN_NAME)               AS Child_Col, 
       col.POSITION                         AS Child_Col_Positionb,
       CHILD.Delete_Rule, 
       CHILD.STATUS
 FROM All_CONSTRAINTS Child, All_CONSTRAINTS Parent, sys.all_tab_comments atc, ALL_CONS_COLUMNS col
 WHERE Child.R_CONSTRAINT_NAME = Parent.CONSTRAINT_NAME
 AND   Child.TABLE_NAME != Parent.TABLE_NAME
 AND   Parent.TABLE_NAME = upper('&Parent_Table_Name')
 AND   Child.owner = atc.Owner(+)
 AND   Child.TABLE_NAME = atc.table_name(+)
 AND   col.owner = child.owner
 AND   Child.constraint_name = col.constraint_name
 ORDER BY Child.TABLE_NAME
;


