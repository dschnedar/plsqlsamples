DROP   TYPE ARRAY2;
DROP TYPE two;
CREATE OR REPLACE TYPE two AS OBJECT ( a NUMBER , b NUMBER )
/
CREATE TYPE ARRAY2 AS TABLE OF two
/


CREATE OR REPLACE FUNCTION gen_numbers_r( 
  n                            IN NUMBER DEFAULT NULL )
  RETURN ARRAY2
AS
  v_array                        ARRAY2 := ARRAY2( );
BEGIN
  FOR i IN 1 .. Nvl( n, 9 ) LOOP
    v_array.Extend;
    v_array(v_array.COUNT)        := two(null,null);
    v_array( v_array.COUNT ).a    := i ;
    v_array( v_array.COUNT ).b    := i * i;
  END LOOP;
  RETURN v_array;
END;
/
show errors


CREATE OR REPLACE FUNCTION gen_numbers_p(  n  IN NUMBER DEFAULT NULL )
  RETURN ARRAY2 
  PIPELINED
AS
  v_two two := two(null,null); -- one object instantiation, recycled 
BEGIN
  FOR i IN 1 .. Nvl( n, 999999999 ) LOOP
    v_two.a := i*i;       -- could do PIPE ROW( two(i*i,i) );
    v_two.b := i;         -- but would have multiple
    PIPE ROW( v_two );    -- instantiations to clean up
  END LOOP;
  RETURN;
END;
/
show errors


SELECT * FROM   TABLE( gen_numbers_r( 4 ) );
SELECT * FROM   TABLE( gen_numbers_r( 4 ) ) WHERE  Rownum < 33;
SELECT * FROM   TABLE( gen_numbers_r( 5 ) ) WHERE  Rownum < 3;

SELECT * FROM   TABLE( gen_numbers_p( 4 ) );
SELECT * FROM   TABLE( gen_numbers_p( 4 ) ) WHERE  Rownum < 33;
SELECT * FROM   TABLE( gen_numbers_p( 5 ) ) WHERE  Rownum < 3;



