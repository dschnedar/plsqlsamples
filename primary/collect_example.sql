create table emp(deptno integer , ename varchar2(15) , salary number(9,2) );

-------------------------------
insert into emp values( 1,'dave'   ,8.88888);
insert into emp values( 1,'david'  ,1234567.89);
insert into emp values( 2,'sue'    ,1567.89);
insert into emp values( 2,'sally'  ,1567.89);
insert into emp values( 3,'bill'    ,567.89);
-------------------------------
select deptno , collect(ename) as emps from emp group by deptno;
--DEPTNO|EMPS
--     1|SYSTPnALowYg3ToKYpC6MUA5OwA==('dave', 'david')
--     2|SYSTPnALowYg3ToKYpC6MUA5OwA==('sue', 'sally')
--     3|SYSTPnALowYg3ToKYpC6MUA5OwA==('bill')

CREATE OR REPLACE TYPE varchar2_ntt AS TABLE OF VARCHAR2(4000);
/


select    all  deptno                              as deptno
             , CAST(collect(ename) as varchar2_ntt) as emps 
               from emp 
               group by deptno
;
--    DEPTNO|EMPS
--         1|VARCHAR2_NTT('dave', 'david')
--         2|VARCHAR2_NTT('sue', 'sally')
--         3|VARCHAR2_NTT('bil')








DECLARE 
    type t is record (a integer ,b varchar2_ntt);
    type tt is table of t;
    myNames tt := tt();
BEGIN
    null;
    FOR i IN ( select    all  deptno                              as deptno
                           , CAST(collect(ename) as varchar2_ntt) as emps 
               from emp 
               group by deptno ) 
    LOOP
        NULL;
        myNames.extend;
        myNames(myNames.count) := i;
    END LOOP;
    FOR i IN 1..myNames.count LOOP
        dbms_output.put_line(  'myNames('||to_char(i)||')='||to_char(myNames(i).a)  );
        FOR j IN 1..myNames(i).b.COUNT  LOOP
            dbms_output.put_line( myNames(i).b(j)  );
        END LOOP;
    END LOOP;
END;
/
