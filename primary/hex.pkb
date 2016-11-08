CREATE OR REPLACE PACKAGE body hex
AS
   ------------ PRIVATE ---------------------------
    FUNCTION c_to_i( p_c VARCHAR2 ) RETURN INTEGER
    IS
        retval INTEGER;
        c VARCHAR2(1) := upper(p_c);
    BEGIN
        CASE 
          WHEN   c        BETWEEN '0' AND '9'  THEN  retval := to_number(c);
          WHEN   upper(c) BETWEEN 'A' AND 'F'  THEN  retval := ascii(upper(substr(c,1,1))) - ascii('A') +10 ;
          ELSE                                       retval := NULL;
        END CASE;
        RETURN retval;
    END c_to_i;
    ----------- PUBLIC ----------------------------
    FUNCTION to_i( p_hex VARCHAR2 ) RETURN INTEGER
    IS
        tmp INTEGER         := 0;
        v_hex  VARCHAR2(32767) := trim(p_hex);
        sign   INTEGER         := 1;
    BEGIN
        IF substr(v_hex,1,1) = '-' THEN 
            sign := -1; 
            v_hex := trim(substr(v_hex,2));
        END IF;
        FOR i IN 1..length(v_hex) LOOP
            tmp := tmp *16 + c_to_i( substr(  v_hex  , i  ,  1 )     );
        END LOOP;
        RETURN tmp*sign;
    END to_i;
END hex;
/
