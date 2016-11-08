select
    col.table_name || '.' || col.column_name as foreign_key,
    rel.table_name || '.' || rel.column_name as references
from
    all_tab_columns col
    join all_cons_columns con   on col.table_name       = con.table_name 
                               and col.column_name      = con.column_name
    join all_constraints cc     on con.constraint_name  = cc.constraint_name
    join all_cons_columns rel   on cc.r_constraint_name = rel.constraint_name 
                               and con.position          = rel.position
where
    cc.constraint_type = 'R'
;





select all owner,constraint_name,constraint_type,table_name,r_owner,r_constraint_name 
     from  all_constraints 
    where  constraint_type='R' 
      and  r_constraint_name in (   select constraint_name 
                                      from all_constraints 
                                     where constraint_type in ('P','U') 
                                       and table_name= 'BOS_USER_SESSION'   )
;


select all owner,constraint_name,constraint_type,table_name,r_owner,r_constraint_name 
     from  all_constraints 
    where  constraint_type='R' 
      and  r_constraint_name in (   select constraint_name 
                                      from all_constraints 
                                     where constraint_type in ('P','U') 
                                       and table_name= 'BOS_USER' )
;


 
BANK
BOS_CONFIG
BOS_USER
BOS_USER_SESSION
DB_OBJECT
DB_OBJECT_ITEM
DB_OBJECT_ITEM_TYPE
DB_OBJECT_TYPE
DENOM
FISCAL_MONTH
FY_ORDER
FY_PARM
FY_PARM_DTL
HOST