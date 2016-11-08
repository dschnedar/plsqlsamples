DROP   TYPE ARRAY;
CREATE TYPE ARRAY AS TABLE OF NUMBER
/
CREATE OR REPLACE FUNCTION gen_numbers_r( ---------------- regular table function ---
  n                            IN NUMBER DEFAULT NULL )
  RETURN ARRAY
AS
  v_array                        ARRAY := ARRAY( );
BEGIN
  FOR i IN 1 .. Nvl( n, 9 ) LOOP
    v_array.Extend;
    v_array( v_array.COUNT )    := i * v_array.COUNT;
  END LOOP;
  RETURN v_array;
END;
/
CREATE OR REPLACE FUNCTION gen_numbers_p( ---------------- pipelined table function ---
  n                            IN NUMBER DEFAULT NULL )
  RETURN ARRAY PIPELINED
AS
BEGIN
  FOR i IN 1 .. Nvl( n, 999999999 ) LOOP
    PIPE ROW( i );
  END LOOP;
  RETURN;
END;
/



SELECT * FROM   TABLE( gen_numbers_r( 4 ) );
SELECT * FROM   TABLE( gen_numbers_r( 4 ) ) WHERE  Rownum < 33;
SELECT * FROM   TABLE( gen_numbers_r( 5 ) ) WHERE  Rownum < 3;

SELECT * FROM   TABLE( gen_numbers_p( 4 ) );
SELECT * FROM   TABLE( gen_numbers_p( 4 ) ) WHERE  Rownum < 33;
SELECT * FROM   TABLE( gen_numbers_p( 5 ) ) WHERE  Rownum < 3;



