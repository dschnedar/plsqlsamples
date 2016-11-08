-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------
select all  * 
      from  monthly_delivery_sched
     where  fy=2006
;

explain plan set statement_id = 'X3'
             for
select all  * 
      from  monthly_delivery_sched
      join  mds_plant        using(mds_seq_id)
      join  mfg_order        using(plant_seq_id)
     where  fy=2006
;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------
column operation     format a20
column options       format a15
column object_name   format a15
column statement_id  format a15

SELECT ALL  lpad(' ',2*(level-1))||operation AS operation
         ,  options
         ,  object_name
         ,  position
         ,  statement_id
         ,  plan_id
      FROM  plan_table
START WITH  id=0
       AND  statement_id = 'test1'
CONNECT BY  prior id = parent_id
       AND  statement_id = 'test1'
;



column operation     format a20
column options       format a15
column object_name   format a15
column statement_id  format a15

SELECT ALL  lpad(' ',2*(level-1))||operation AS operation
         ,  options
         ,  object_name
         ,  position
         ,  statement_id
         ,  plan_id
      FROM  plan_table
START WITH  id=0
       AND  statement_id = 'test1'
CONNECT BY  prior id = parent_id
       AND  statement_id = 'test1'
;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
EXPLAIN PLAN SET STATEMENT_ID = 'X' 
FOR
select all  * 
      from  master_sched
      join  master_dtl using (sched_seq_id)
     where  master_fy = 2006
;


column operation     format a20
column options       format a15
column object_name   format a15
column statement_id  format a15

SELECT ALL  lpad(' ',2*(level-1))||operation AS operation
         ,  options
         ,  object_name
         ,  position
         ,  statement_id
         ,  plan_id
         ,  parent_id
      FROM  plan_table
START WITH  id=0
       AND  statement_id = 'X'
CONNECT BY  prior id = parent_id
       AND  statement_id = 'X'
;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
EXPLAIN PLAN SET STATEMENT_ID = 'X3' 
FOR
select all  * 
      from  monthly_delivery_sched
      join  mds_plant       using( mds_seq_id   )
      join  special_order   using( plant_seq_id )
     where  monthly_delivery_sched.fy = 2006
;


-------------------------------------------------------------------------------------
column operation     format a20
column options       format a15
column object_name   format a15
column statement_id  format a15

SELECT ALL  lpad(' ',2*(level-1))||operation AS operation
         ,  options
         ,  object_name
         ,  position
         ,  statement_id
         ,  plan_id
         ,  id
         ,  parent_id
         ,  level
      FROM  plan_table
START WITH  id=0
       AND  statement_id = 'X3'
CONNECT BY  prior id = parent_id
       AND  statement_id = 'X3'
;
-------------------------------------------------------------------------------------

DECLARE
    PROCEDURE x( p_parent_id number ) 
    IS
    BEGIN
       FOR s IN ( SELECT ALL * 
                                FROM plan_table 
                      WHERE statement_id = 'X3'
                        AND nvl(p_parent_id ,-42) = nvl(plan_table.parent_id,-42)
                   ORDER BY plan_table.parent_id ASC NULLS FIRST
                )
       LOOP
           dbms_output.put_line( '>'  || rpad( lpad(' ',2*(nvl(s.parent_id,-1)+1))  ||s.operation, 30 )
                                      || rpad( nvl( to_char( s.options      ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.object_name  ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.position     ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.statement_id ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.plan_id      ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.id           ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.parent_id    ),'~Null' )  ,15 )
                               )
           ;
           x(s.id);
       END LOOP;
    END x;
BEGIN
   x(null);
END;
/


DECLARE
    PROCEDURE x( p_statement_id varchar2 , p_parent_id integer := NULL ) 
    IS
    BEGIN
       FOR s IN ( SELECT ALL * 
                                FROM plan_table 
                      WHERE statement_id = p_statement_id
                        AND nvl(p_parent_id ,-42) = nvl(plan_table.parent_id,-42)
                   ORDER BY plan_table.parent_id ASC NULLS FIRST
                )
       LOOP
           dbms_output.put_line( '>'  || rpad( lpad(' ',2*(nvl(s.parent_id,-1)+1))  ||s.operation, 30 )
                                      || rpad( nvl( to_char( s.options      ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.object_name  ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.position     ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.statement_id ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.plan_id      ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.id           ),'~Null' )  ,15 )
                                      || rpad( nvl( to_char( s.parent_id    ),'~Null' )  ,15 )
                               )
           ;
           x(p_statement_id,s.id);
       END LOOP;
    END x;
BEGIN
   x('X3');
END;
/


DECLARE
    PROCEDURE x( p_statement_id varchar2 , p_parent_id integer := NULL , p_recursive boolean := FALSE ) 
    IS
    BEGIN
       IF NOT p_recursive  THEN
           dbms_output.put_line( '>'  || rpad( 'operation    ', 30 )
                                      || rpad( 'options      ', 10 )
                                      || rpad( 'object_name  ', 30 )
                                      || rpad( 'position     ', 10 )
                                      || rpad( 'statement    ', 10 )
                                      || rpad( 'plan_id      ', 10 )
                                      || rpad( 'id           ', 10 )
                                      || rpad( 'parent_id    ', 10 )
                               )
           ;
       END IF;
       FOR s IN ( SELECT ALL * 
                                FROM plan_table 
                      WHERE statement_id = p_statement_id
                        AND nvl(p_parent_id ,-42) = nvl(plan_table.parent_id,-42)
                   ORDER BY plan_table.parent_id ASC NULLS FIRST
                )
       LOOP
           dbms_output.put_line( '>'  || rpad( lpad(' ',2*(nvl(s.parent_id,-1)+1))  ||s.operation, 30 )
                                      || rpad( nvl( to_char( s.options      ),'~Null' )  ,10 )
                                      || rpad( nvl( to_char( s.object_name  ),'~Null' )  ,30 )
                                      || rpad( nvl( to_char( s.position     ),'~Null' )  ,10 )
                                      || rpad( nvl( to_char( s.statement_id ),'~Null' )  ,10 )
                                      || rpad( nvl( to_char( s.plan_id      ),'~Null' )  ,10 )
                                      || rpad( nvl( to_char( s.id           ),'~Null' )  ,10 )
                                      || rpad( nvl( to_char( s.parent_id    ),'~Null' )  ,10 )
                               )
           ;
           x(p_statement_id,s.id,TRUE);
       END LOOP;
    END x;
BEGIN
   x('X3');
END;
/


