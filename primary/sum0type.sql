------------ Thanks to Jonathan Bennick, OracleMagazine -----------
create or replace type sum0type as object
(
  running_sum      NUMBER,   -- highest value seen so far 
  static function ODCIAggregateInitialize( sctx IN OUT sum0type                                          ) return number,
  member function ODCIAggregateIterate(    self IN OUT sum0type, value       IN  number                  ) return number,
  member function ODCIAggregateTerminate(  self IN     sum0type, returnValue OUT number, flags IN number ) return number,
  member function ODCIAggregateMerge(      self IN OUT sum0type, ctx2        IN sum0type                 ) return number
);
/
show errors

create or replace type body sum0type is 
static function ODCIAggregateInitialize(sctx IN OUT sum0type ) 
return number is 
begin             
  dbms_output.put_line('----------------------------- ODCIAggregateInitialize -----------------------------');             
  sctx := sum0type(0);         
  return ODCIConst.Success;    
end;

member function ODCIAggregateIterate(self IN OUT sum0type, value IN number) return number is
begin
    self.running_sum := self.running_sum + nvl(value,0);
  return ODCIConst.Success;
end;

member function ODCIAggregateTerminate(self IN sum0type, returnValue OUT number, flags IN number) return number is
begin
  returnValue := self.running_sum;
  return ODCIConst.Success;
end;

member function ODCIAggregateMerge(self IN OUT sum0type, ctx2 IN sum0type) return number is
begin
  dbms_output.put_line('----------------------------- ODCIAggregateMerge -----------------------------');
  self.running_sum := self.running_sum + ctx2.running_sum;
  return ODCIConst.Success;
end;
end;
/
show errors


CREATE or replace FUNCTION sum0 (input NUMBER) RETURN NUMBER 
PARALLEL_ENABLE AGGREGATE USING sum0type ;
/



drop   table some_numbers;
create table some_numbers( n number);
insert into  some_numbers values ( 1 );
insert into  some_numbers values ( 2 );
insert into  some_numbers values ( 3 );
insert into  some_numbers values ( 4 );
insert into  some_numbers values ( 5 );
insert into  some_numbers values ( null );
insert into  some_numbers values ( null );
insert into  some_numbers values ( null );
insert into  some_numbers values ( null );
insert into  some_numbers values ( null );
insert into  some_numbers values ( null );


select sum(n)     from some_numbers;
select sum0(n)    from some_numbers;
select sum(null)  from dual;
select sum0(null) from dual;

------------------------------------------
------------------------------------------
select sum(line)     from all_source;





