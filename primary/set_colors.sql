spool   set_colors.tmp

select 'spool default.lst' from sys.dual;

select decode(user||'@'||global_name , 'BOSDEV@YCODBD1.BEP.TREAS.GOV'               , 'host color 1A'  -- green  on blue
                                     , 'BEARPLUS@BEARDBD1.BEP.TREAS.GOV'            , 'host color 17'  -- white  on blue
                                     , 'FRRS_DEV@FRRSDBD1.BEP.TREAS.GOV'            , 'host color 1E'  -- yellow on blue
                                     ------------------------------------------------------------------------------------
                                     , 'BEP\SCHNEDARD@YCODBD1.BEP.TREAS.GOV'        , 'host color 0B'  -- green  on black
                                     , 'BEP\SCHNEDARD@BEARDBD1.BEP.TREAS.GOV'       , 'host color 07'  -- white  on black
                                     , 'BEP\SCHNEDARD@FRRSDBD1.BEP.TREAS.GOV'       , 'host color 0E'  -- yellow on black
                                     ------------------------------------------------------------------------------------
                                     ,                                                'host color Fc'  -- red    on white
             )  
from   sys.global_name
;


select 'host title ' || user||'@'||global_name from sys.global_name
;



spool off
