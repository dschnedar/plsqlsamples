-----------------------------------------------------------------------
-- This was a learning experiment for me.
-- I started with an example.
-- Possibly PL/SQL User's Guide and Reference 9.2
-- I don't know how much has been changed.
-- I do return NULLs on stack errors instead of raising an error.
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
CREATE OR REPLACE TYPE IntegerArray AS VARRAY(10) OF INTEGER
/

------------------------------------------------------------
--  self IN OUT ===> mutator
------------------------------------------------------------
CREATE OR REPLACE TYPE int_stack 
AS 
OBJECT (   top                                           INTEGER        --  top = # of items in stack
       ,   integers                                      IntegerArray   --  stack data
       ,   CONSTRUCTOR FUNCTION   int_stack(    self IN OUT int_stack              )   RETURN self      AS RESULT 
       ,   MEMBER      FUNCTION   push(         self IN OUT int_stack , n  INTEGER )   RETURN INTEGER   -- return pushed int, null on fail
       ,   MEMBER      FUNCTION   pop(          self IN OUT int_stack              )   RETURN INTEGER   -- return null on empty stack
       ,   MEMBER      FUNCTION   current_size( self IN     int_stack              )   RETURN INTEGER
       ,   MEMBER      FUNCTION   max_size(     self IN     int_stack              )   RETURN INTEGER 
       ,   MEMBER      FUNCTION   is_empty(     self IN     int_stack              )   RETURN BOOLEAN
       ,   MEMBER      FUNCTION   is_full(      self IN     int_stack              )   RETURN BOOLEAN
       ,   MEMBER      PROCEDURE  show_stack(   self IN     int_stack              )
       )
/
show errors



CREATE OR REPLACE TYPE BODY int_stack 
AS
    CONSTRUCTOR FUNCTION   int_stack(    self IN OUT int_stack              )   RETURN self    AS RESULT
    IS
    BEGIN
        self.top := 0;
        self.integers := IntegerArray(null,null,null,null,null,null,null,null,null,null);
        RETURN;
    END
    ;
    MEMBER FUNCTION push( self  IN OUT int_stack , n  INTEGER )  RETURN INTEGER   -- return pushed value, null on overflow
    IS
    BEGIN
        IF top+1 > integers.LIMIT THEN
            dbms_output.put_line('-----------STACK OVERFLOW---------- NO EFFECT');
            RETURN NULL;
        ELSE
            null;
            self.top := self.top + 1;
            integers( top ) := n;
            RETURN n;   ---RETURN top;
        END IF;
    END
    ;
    MEMBER FUNCTION pop( self IN OUT int_stack ) RETURN INTEGER
    IS
        ret_val INTEGER;
    BEGIN
        IF top < 1 THEN
            dbms_output.put_line('-----------STACK UNDERFLOW---------- EMPTY STACK');
            RETURN NULL;
        ELSE
            ret_val         := integers(top); 
            integers(top)   := NULL;
            top             := top - 1;
            RETURN ret_val;
        END IF;
    END
    ;
    MEMBER FUNCTION  current_size( self IN     int_stack ) RETURN INTEGER IS BEGIN RETURN nvl(top,0);               END;
    MEMBER FUNCTION  max_size(     self IN     int_stack ) RETURN INTEGER IS BEGIN RETURN integers.LIMIT;           END;
    MEMBER FUNCTION  is_empty(     self IN     int_stack ) RETURN BOOLEAN IS BEGIN RETURN top=0;                    END;
    MEMBER FUNCTION  is_full(      self IN     int_stack ) RETURN BOOLEAN IS BEGIN RETURN self.top=self.max_size;   END;
    ---------------------------------------------------------------------------------------------------------------------
    MEMBER PROCEDURE show_stack(   self IN     int_stack              )   
    IS
    BEGIN
        dbms_output.put_line('******************************');
        dbms_output.put_line('top='||self.top);
        FOR i IN 1..self.integers.COUNT LOOP
            dbms_output.put_line( '.    ' || to_char(i,'99999990') || '=     ' || to_char(self.integers(i),'99999990') );
        END LOOP;
        dbms_output.put_line('******************************');
    END show_stack
    ;
END ;
/
show errors




DECLARE
  my_stack int_stack := int_stack();
  PROCEDURE stack_empty_or_full IS 
  BEGIN
    dbms_output.put_line('=============================================');   
    IF my_stack.is_empty                              THEN dbms_output.put_line('stack is empty'); END IF;      
    IF my_stack.is_full                               THEN dbms_output.put_line('stack is full');  END IF;  
    IF NOT my_stack.is_empty AND NOT my_stack.is_full THEN dbms_output.put_line('stack NOT full and NOT empty');  END IF;
    dbms_output.put_line('=============================================');    
  END stack_empty_or_full;
BEGIN 
  dbms_output.put_line('~~~~~~~~~~~~~~~~~~~~~start with empty stack ~~~~~~~~~~~~~~~~~~~~~');
  my_stack.show_stack;
  dbms_output.put_line('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  --
  FOR i IN 1..my_stack.max_size LOOP
    dbms_output.put_line( 'Push ' || to_char(i*2) ||' into index  ' || nvl(to_char(my_stack.push(i*2)),'NULL') 
                      ||  '     ' || to_char(my_stack.current_size) ||'/'|| to_char(my_stack.max_size) );
  END LOOP;
  dbms_output.put_line('======= Don''t push it too far! =======');
  dbms_output.put_line( 'Push ' || to_char(99) ||' into index  ' || nvl(to_char(my_stack.push(99)),'NULL') 
                      ||'     ' || to_char(my_stack.current_size) ||'/'|| to_char(my_stack.max_size) );
  --
  stack_empty_or_full;
  my_stack.show_stack;
  --
  WHILE my_stack.current_size > 4 LOOP
    dbms_output.put_line(  'Pop  ' || nvl( to_char(my_stack.pop) , 'NULL' )
                       || '     ' || to_char(my_stack.current_size) ||'/'|| to_char(my_stack.max_size) );
  END LOOP;
  --
  stack_empty_or_full;
  --
  WHILE my_stack.current_size > 0 LOOP
    dbms_output.put_line(  'Pop  ' || nvl( to_char(my_stack.pop) , 'NULL' )
                       || '     ' || to_char(my_stack.current_size) ||'/'|| to_char(my_stack.max_size) );
  END LOOP;
  --
  stack_empty_or_full;
  --
  dbms_output.put_line( 'Pop  ' || nvl( to_char(my_stack.pop) , 'NULL' )
                      ||'     ' || to_char(my_stack.current_size) ||'/'|| to_char(my_stack.max_size) );
  --
  stack_empty_or_full;
  --
END;
/
