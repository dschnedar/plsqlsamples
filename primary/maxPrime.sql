/* Formatted on 6/20/2011 11:30:56 AM (QP5 v5.114.809.3010) custom header tag text */
CREATE OR REPLACE TYPE maxPrime 
AS OBJECT
(   maxP   NUMBER   -- highest prime value seen so far
    --
,   STATIC FUNCTION ODCIAggregateInitialize ( sctx IN OUT maxPrime                                          )     RETURN number
,   MEMBER FUNCTION ODCIAggregateIterate    ( self IN OUT maxPrime, Value IN        number                  )     RETURN number
,   MEMBER FUNCTION ODCIAggregateTerminate  ( self IN     maxPrime, returnValue OUT number, flags IN number )     RETURN number
,   MEMBER FUNCTION ODCIAggregateMerge      ( self IN OUT maxPrime, ctx2 IN maxPrime                        )     RETURN number
);
/
show errors


/* Formatted on 6/20/2011 11:34:51 AM (QP5 v5.114.809.3010) custom header tag text */
CREATE OR REPLACE TYPE BODY maxPrime 
IS
   STATIC FUNCTION ODCIAggregateInitialize ( sctx IN OUT maxPrime                                          )     RETURN number
   IS
   BEGIN
      sctx   := maxPrime( NULL );
      RETURN ODCIConst.Success;
   END;
   MEMBER FUNCTION ODCIAggregateIterate    ( self IN OUT maxPrime, Value IN        number                  )     RETURN number
   IS
   BEGIN 
      IF     self.maxP IS NULL                         THEN self.maxP := Value; 
      ELSIF  Value > self.maxP  AND  x.is_prime(value) THEN self.maxP := Value;
      END IF;
      RETURN ODCIConst.Success;
   END;
   MEMBER FUNCTION ODCIAggregateTerminate( self IN maxPrime, returnValue OUT number, flags IN number )
      RETURN number IS
   BEGIN
      returnValue   := self.maxP;
      RETURN ODCIConst.Success;
   END;
   MEMBER FUNCTION ODCIAggregateMerge      ( self IN OUT maxPrime, ctx2 IN maxPrime                   )     RETURN number
   IS
   BEGIN
      IF ctx2.maxP > self.maxP THEN
          self.maxP := ctx2.maxP;
      END IF;
      RETURN ODCIConst.Success;
   END;
END ;
/
show errors


CREATE OR REPLACE FUNCTION max_prime (input NUMBER) RETURN NUMBER PARALLEL_ENABLE AGGREGATE USING maxPrime;
/




