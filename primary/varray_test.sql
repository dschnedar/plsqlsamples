declare
    type i_array is varray(10) of integer not null;
    my_array i_array;
begin
    --dbms_output.put_line( my_array.limit);    --err-- not init yet
    --my_array := i_array(1,2,null,4,5,6,7,8,9); cannot pass NULL to a NN formal parameter
    my_array := i_array(11,12,13,4,5,6,7,8,9);
    
    dbms_output.put_line( my_array.limit);--10
    dbms_output.put_line( my_array.count);--9

    --my_array(10) := 100;                      --err-- slot 10 does not exist yet


    my_array.extend;
    my_array(10) := 100;
    --my_array.extend;                         --err-- outside of limit

    dbms_output.put_line( my_array.limit);--10
    dbms_output.put_line( my_array.count);--10

    
    --my_array(10).delete;                     --err-- can only delete entire array
    --my_array.delete(1,10);                   --err-- can only delete entire array
    dbms_output.put_line( my_array.limit);--10
    dbms_output.put_line( my_array.count);--9 


    my_array.delete;
    --dbms_output.put_line( my_array(1) );     --err-- beyond count
    --my_array(1):=1;                          --err-- beyond count

    dbms_output.put_line( my_array.limit);--10
    dbms_output.put_line( my_array.count);--9 


    null;
    my_array.delete;
end;
/








