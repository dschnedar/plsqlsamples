---------------------------------------------------------------------------------------
--  x.is_prime(N) returns true if N is prime
--                returns NULL if N is NULL
---------------------------------------------------------------------------------------
-- Prime = integer that is only divisible by two numbers 1 and itself
--         1 is not prime, 2 is lowest prime
---------------------------------------------------------------------------------------
--  This is not an efficient way to find all the prime numbers between 1 and 1,000,000
---------------------------------------------------------------------------------------
create or replace package x
as
    function is_prime(n number) return boolean;
    procedure test;
end;
/
show errors


create or replace package body  x
as
    TYPE ints_type IS TABLE OF CHAR(1 BYTE) INDEX BY BINARY_INTEGER;
    primes      ints_type;
    not_primes  ints_type;
    -----------------------------------------------------------------------
    procedure p(s varchar2) is begin dbms_output.put_line(s); end p;
    procedure p(n number  ) is begin dbms_output.put_line(n); end p;
    procedure p(d date    ) is begin dbms_output.put_line(d); end p;
    --
    FUNCTION IS_PRIME(n NUMBER) RETURN BOOLEAN
    IS
    BEGIN
        IF primes.exists(n)     THEN RETURN TRUE;  END IF;            
        IF not_primes.exists(n) THEN RETURN FALSE; END IF;
        CASE 
            WHEN  n IS NULL      THEN RETURN NULL;  
            WHEN  mod(N,1) !=0   THEN RETURN NULL;  -- must be an integer
            WHEN  n < 2          THEN RETURN FALSE; --
            WHEN  n = 2          THEN RETURN TRUE;  -- 2 is lowest prime number
            ELSE                      NULL;
        END CASE;
        FOR i IN 2..TRUNC(n/2) LOOP
            IF MOD(n,i) = 0 THEN 
                  not_primes(n) := NULL;
                  RETURN FALSE; 
            END IF;
        END LOOP;
        primes(n) := NULL;
        RETURN TRUE;
    END IS_PRIME;
    --    
    procedure test
    is
    begin
        if   is_prime(null)   then   p('null is prime');   else   p('null is NOT prime');   end if;
        if   is_prime(-1)     then   p('-1   is prime');   else   p('-1   is NOT prime');   end if;
        if   is_prime(2.2)    then   p('2.2  is prime');   else   p('2.2  is NOT prime');   end if;
        for i in 1..23 loop
            null;
            if   is_prime(i)   then   p(to_char(i) ||' is prime');  else   p(to_char(i) ||' is NOT prime');   end if;
        end loop;
    end test;
end;
/
show errors

exec x.test
