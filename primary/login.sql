

SET ECHO         OFF
SET FEEDBACK     1
SET WRAP         OFF
SET colsep       "|"
SET DEFINE       "&"
SET LONG         100
SET NULL         "~"
SET LINESIZE     32767
SET PAGESIZE     50000
SET sqlprompt    "SQL> "
SET TRIMOUT      ON
SET TRIMSPOOL    ON
SET TIMING       ON
SET SERVEROUTPUT ON
host color       DF
---
exec dbms_output.enable(1000000)

SET FEEDBACK     OFF
SET ECHO         OFF
SET HEAD         OFF
SET TIMING       OFF
spool set_colors.tmp
@set_colors.sql
@set_colors.tmp


SET TIMING       ON
SET TIME         ON
SET FEEDBACK     1
SET HEAD         ON