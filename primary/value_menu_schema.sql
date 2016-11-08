select * from restaurants ;
select * from items       ;
select * from meals       ;
select * from meal_items  ;


drop table     meal_items  ;
drop table     items       ;
drop table     meals       ;
drop table     restaurants ;




create table restaurants ( id            integer
                         , name          varchar2(30)  )
;
create table items       ( id            integer
                         , restaurant_id integer 
                         , name          varchar2(30)  
                         , price         number(3,2)   )
;

create table meals       ( id            integer
                         , restaurant_id integer 
                         , name          varchar2(30)  
                         , price         number(3,2)   )
;

create table meal_items  ( id            integer
                         , meal_id       integer       
                         , item_id       integer       )
;


 
alter table restaurants add constraint pk_restaurant  primary key( ID ) ;
alter table items       add constraint pk_items       primary key( ID ) ;
alter table meals       add constraint pk_meals       primary key( ID ) ;
alter table meal_items  add constraint pk_meal_items  primary key( ID ) ;




alter table items       add constraint fk_items_1       foreign key( restaurant_id ) REFERENCING restaurants( ID ) ;
alter table meals       add constraint fk_meals_1       foreign key( restaurant_id ) REFERENCING restaurants( ID ) ;
alter table meal_items  add constraint fk_meal_items_1  foreign key( meal_id       ) REFERENCING meals      ( ID ) ;
alter table meal_items  add constraint fk_meal_items_2  foreign key( item_id       ) REFERENCING items      ( ID ) ;




alter table items       modify restaurant_id not null  ;
alter table meals       modify restaurant_id not null  ;
alter table meal_items  modify meal_id       not null  ;
alter table meal_items  modify item_id       not null  ;





