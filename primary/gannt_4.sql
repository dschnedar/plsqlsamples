

drop   table    x_activities;
drop   sequence x_activities_pk_seq;
create sequence x_activities_pk_seq;
create table    x_activities
(   id            INTEGER
,   label         varchar2(100)
,   days          INTEGER
,   start_date    date
,   end_date      date
)
/


create or replace 
function to_activity(   p_id            x_activities.id         %TYPE  DEFAULT NULL
                    ,   p_label         x_activities.label      %TYPE  DEFAULT NULL
                    ,   p_days          x_activities.days       %TYPE  DEFAULT NULL
                    ,   p_start_date    x_activities.start_date %TYPE  DEFAULT NULL
                    ,   p_end_date      x_activities.end_date   %TYPE  DEFAULT NULL
                    )
return x_activities%rowtype 
is 
    ret_val x_activities%ROWTYPE;
    bad_args EXCEPTION;
     ---PRAGMA EXCEPTION_INIT( bad_args , -20999 ); -- -20,999 to -20,000
begin 
    ret_val.id          := p_id          ;
    ret_val.label       := p_label       ;
    ret_val.days        := p_days        ;
    ret_val.start_date  := p_start_date  ;
    ret_val.end_date    := p_end_date    ;
    RETURN  ret_val; 
exception
    when bad_args then raise_application_error( -20999,'Bad Arguments: FUNCTION to_activity()' );
end; 
/
show errors
declare
  dummy x_activities%rowtype;
begin
  dummy := to_activity(0,'',0,sysdate,sysdate);
end;
/


create or replace function ins_activity( p_activity x_activities%rowtype ) return integer 
IS
    bad_args    EXCEPTION;  --- start_date, end_date, and days must agree or be NULL
    ret_val     INTEGER;
    v_activity  x_activities%rowtype := p_activity; 
begin
    IF v_activity.days IS NULL THEN   v_activity.days := trunc(v_activity.end_date) - trunc(v_activity.start_date) + 1;   END IF;
    CASE
        WHEN v_activity.start_date IS NULL     AND v_activity.end_date   IS NOT NULL THEN v_activity.start_date := trunc(v_activity.end_date)   - v_activity.days;
        WHEN v_activity.end_date   IS NULL     AND v_activity.start_date IS NOT NULL THEN v_activity.end_date   := trunc(v_activity.start_date) + v_activity.days;
        WHEN v_activity.end_date   IS NOT NULL AND v_activity.start_date IS NOT NULL THEN
            IF NOT(v_activity.days-1 = trunc(v_activity.end_date)-trunc(v_activity.start_date)  ) THEN RAISE bad_args; END IF;
        ELSE NULL;
    END CASE;
    SELECT x_activities_pk_seq.NEXTVAL INTO v_activity.id FROM dual;
    INSERT INTO x_activities VALUES v_activity RETURNING id INTO ret_val;
    RETURN ret_val;
exception
    when bad_args then raise_application_error( -20999,'Bad Arguments: FUNCTION ins_activity()' );
end;
/
show errors


delete x_activities;
declare
    pk INTEGER;
begin
    pk :=  ins_activity( to_activity( null, 'Gather Requriements' ,null, to_date('01-01-2011','DD-MM-YYYY'), to_date('01-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Initial Design'      ,null, to_date('02-01-2011','DD-MM-YYYY'), to_date('02-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Develop R1'          ,null, to_date('03-01-2011','DD-MM-YYYY'), to_date('09-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Test R1'             ,null, to_date('04-01-2011','DD-MM-YYYY'), to_date('09-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Develop R1'          ,null, to_date('05-01-2011','DD-MM-YYYY'), to_date('09-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Test R2'             ,null, to_date('06-01-2011','DD-MM-YYYY'), to_date('09-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Celebrate'           ,null, to_date('07-01-2011','DD-MM-YYYY'), to_date('10-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Sleep'               ,null, to_date('08-01-2011','DD-MM-YYYY'), to_date('10-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'Relax'               ,null, to_date('09-01-2011','DD-MM-YYYY'), to_date('10-01-2011','DD-MM-YYYY') ) ) ;
    pk :=  ins_activity( to_activity( null, 'IPO'                 ,null, to_date('10-01-2011','DD-MM-YYYY'), to_date('10-01-2011','DD-MM-YYYY') ) ) ;
    dbms_output.put_line(pk);
end;
/
 



 
         


column label     format a25
column work_line format a25
column rest_line format a25
column line      format a25
------------------------------------
WITH my_constants AS ( SELECT 5 WIDTH FROM dual )
   , boundaries AS ( SELECT max(days)                               max_days
                          , min(start_date)                         min_date
                          , max(end_date)                           max_date
                          , max(days)                               max_WIDTH
                          , (max(end_date)-min(start_date)+1)       total_days
                          , WIDTH/(max(end_date)-min(start_date)+1)    scaler
                     FROM   x_activities 
                     JOIN   my_constants ON 1=1
                   )
,   X AS   (  SELECT ALL  max_days
                  ,  label                                                label
                  ,  ceil(days/total_days*WIDTH)                          stretch_work --working days stretched
                  ,   WIDTH-ceil(days/total_days*WIDTH)                   stretch_rest --nonworking days stretched
                  ,  floor(  (    (start_date-min_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                          )                                                                  stretch_pre
                  ,  ceil(  (     (max_date-end_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                         )                                                                    stretch_post
                  ,  days                                           work_days    --working days
                  ,  (start_date-min_date)                          pre_days     --days before
                  ,  (max_date-end_date)                            post_days    --days after
         FROM        x_activities
         CROSS JOIN  boundaries   
         CROSS JOIN  my_constants 
         )
SELECT     label                              AS label
     ,     rpad('.',stretch_pre  ,'.')
        || rpad('*',stretch_work ,'*') 
        || rpad('.',stretch_post ,'.')        AS bar  
FROM    x
;
         





column label     format a25
column work_line format a25
column rest_line format a25
column line      format a25
------------------------------------
WITH my_constants AS ( SELECT 20 WIDTH FROM dual )
   , boundaries AS ( SELECT max(days)                               max_days
                          , min(start_date)                         min_date
                          , max(end_date)                           max_date
                          , max(days)                               max_WIDTH
                          , (max(end_date)-min(start_date)+1)       total_days
                          , WIDTH/(max(end_date)-min(start_date)+1)    scaler
                     FROM   x_activities 
                     JOIN   my_constants ON 1=1
                   )
,   X AS   (  SELECT ALL  max_days
                  ,  label                                                label
                  ,  ceil(days/total_days*WIDTH)                          stretch_work --working days stretched
                  ,   WIDTH-ceil(days/total_days*WIDTH)                   stretch_rest --nonworking days stretched
                  ,  floor(  (    (start_date-min_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                          )                                                                  stretch_pre
                  ,  ceil(  (     (max_date-end_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                         )                                                                    stretch_post
                  ,  days                                           work_days    --working days
                  ,  (start_date-min_date)                          pre_days     --days before
                  ,  (max_date-end_date)                            post_days    --days after
         FROM        x_activities
         JOIN        boundaries ON 1=1
         JOIN        my_constants ON 1=1
         )
SELECT     label                              AS label
     ,     rpad('.',stretch_pre  ,'.')
        || rpad('*',stretch_work ,'*') 
        || rpad('.',stretch_post ,'.')        AS bar  
FROM    x
;
         

















-----------------------------------
column label     format a25
column work_line format a25
column rest_line format a25
column line      format a25
------------------------------------
WITH boundaries AS ( SELECT max(days)                               max_days
                          , min(start_date)                         min_date
                          , max(end_date)                           max_date
                          , max(days)                               max_WIDTH
                          , (max(end_date)-min(start_date)+1)       total_days
                          , 5                                      WIDTH
                          , 5/(max(end_date)-min(start_date)+1)    scaler
                     FROM   x_activities
                   )
,   X AS   (  SELECT ALL  max_days
                  ,  label                                                label
                  ,  ceil(days/total_days*WIDTH)                          stretch_work --working days stretched
                  ,   WIDTH-ceil(days/total_days*WIDTH)                   stretch_rest --nonworking days stretched
                  ,  floor(  (    (start_date-min_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                          )                                                                  stretch_pre
                  ,  ceil(  (     (max_date-end_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                         )                                                                    stretch_post
                  ,  days                                           work_days    --working days
                  ,  (start_date-min_date)                          pre_days     --days before
                  ,  (max_date-end_date)                            post_days    --days after
         FROM        x_activities
         JOIN        boundaries ON 1=1
         )
SELECT     label                              AS label
     ,     rpad('.',stretch_pre  ,'.')
        || rpad('*',stretch_work ,'*') 
        || rpad('.',stretch_post ,'.')        AS bar  
FROM    x
;
         
         
         



column label     format a25
column work_line format a25
column rest_line format a25
column line      format a25
------------------------------------
WITH boundaries AS ( SELECT max(days)                               max_days
                          , min(start_date)                         min_date
                          , max(end_date)                           max_date
                          , max(days)                               max_WIDTH
                          , (max(end_date)-min(start_date)+1)       total_days
                          , 20                                      WIDTH
                          , 20/(max(end_date)-min(start_date)+1)    scaler
                     FROM   x_activities
                   )
,   X AS   (  SELECT ALL  max_days
                  ,  label                                                label
                  ,  ceil(days/total_days*WIDTH)                          stretch_work --working days stretched
                  ,   WIDTH-ceil(days/total_days*WIDTH)                   stretch_rest --nonworking days stretched
                  ,  floor(  (    (start_date-min_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                          )                                                                  stretch_pre
                  ,  ceil(  (     (max_date-end_date)   
                                  /  (  (start_date-min_date)+(max_date-end_date)  )
                             )
                             *  (WIDTH-ceil(days/total_days*WIDTH)) 
                         )                                                                    stretch_post
                  ,  days                                           work_days    --working days
                  ,  (start_date-min_date)                          pre_days     --days before
                  ,  (max_date-end_date)                            post_days    --days after
         FROM        x_activities
         JOIN        boundaries ON 1=1
         )
SELECT     label                              AS label
     ,     rpad('.',stretch_pre  ,'.')
        || rpad('*',stretch_work ,'*') 
        || rpad('.',stretch_post ,'.')        AS bar  
FROM    x
;
         
         
         

         