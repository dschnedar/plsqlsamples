Create table print_media( id  number , c clob , b blob);
insert into print_media values (1,empty_clob(),empty_blob());
insert into print_media values (2,'hello',null );
insert into print_media values (3,'hello',empty_blob());
insert into print_media values (4,empty_clob(),to_blob('hello'));
insert into print_media values (5,empty_clob(),to_blob(null));
insert into print_media values (5,empty_clob(),to_blob('00AADD343CDBBD'));