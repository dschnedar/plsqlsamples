CREATE OR REPLACE PACKAGE hex
AS
    FUNCTION to_i( p_hex VARCHAR2 ) RETURN INTEGER;
END hex;
/
