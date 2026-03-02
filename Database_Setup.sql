
--creating schema
--Dimension tables
--Date tables

create table dim_date (
     date_id INT IDENTITY(1,1) primary key,
     full_date date,
     year int,
     month int,
     month_name varchar(20),
     Quarter int,
     Day int,
     Week int
)

SELECT * FROM dim_date;

************************************************************************
--dim location

CREATE TABLE dim_location 
(
location_id INT IDENTITY(1,1) PRIMARY KEY,
STATE VARCHAR(100),
CITY VARCHAR(100),
LOCATION VARCHAR(200)
);

SELECT * FROM dim_location;

************************************************************************
--dim restaurant

CREATE TABLE dim_resturant
(
resturant_id INT IDENTITY(1,1) primary key,
resturant_name varchar(200)
);
select * from dim_resturant;

************************************************************************
--dim dish

create table dim_dish
(
dish_id INT IDENTITY(1,1) primary key,
dish_name varchar(100)
)
select* from dim_dish;

************************************************************************
--dim category

create table dim_category
(
category_id INT IDENTITY(1,1) primary key,
Category varchar(100)
)
select* from dim_category;

***********************************************************************
--fact table 

create table fact_swiggy_orders
(
order_id INT IDENTITY(1,1),
date_id INT,
price_INR decimal(10,2),
Rating decimal(4,2),
Rating_count int,

location_id int,
category_id int,
dish_id int,
resturant_id int,

foreign key (date_id) references dim_date(date_id),
foreign key (location_id) references dim_location(location_id),
foreign key (category_id) references dim_category(category_id),
foreign key (dish_id) references dim_dish(dish_id),
foreign key (resturant_id) references dim_resturant(resturant_id),
);

select* from fact_swiggy_orders;

************************************************************************
هنا ح نستورد البيانات للجداول التي قمنا ب إنشائها 

--insert data in tables 
--dim date

insert into dim_date (full_date,year,month,month_name,Quarter,Week,Day)
    select distinct 
    Order_Date,
    YEAR(Order_Date),
    MONTH(Order_Date),
    DATENAME(MONTH,Order_Date),
    DATEPART(QUarter,Order_Date),
    DAY(Order_Date),
    DATEPART(week,Order_Date)
from Swiggy_Data
where Order_Date IS NOT NULL;

select * from dim_date;

--جدول ال تواريخ طلع معرف نصي حنغير لي تاريخ
update Swiggy_Data
set Order_Date=CONVERT(date,order_date,103);
alter table swiggy_data
alter column order_date date;

select * from Swiggy_Data;

***************************************************************************

--insert into dim_location

insert into dim_location(STATE,CITY,LOCATION)
select distinct
      state,
      city,
      location
from Swiggy_Data;

select * from dim_location;

***************************************************************************

--insert into dim_category

insert into dim_category(Category)
select distinct
        Category
from Swiggy_Data;

***************************************************************************

--insert into dim_dish

alter table dim_dish
alter column dish_name varchar(255);

insert into dim_dish(dish_name)
select distinct 
       Dish_Name
from Swiggy_Data;

***************************************************************************

--insert into dim_resturant

insert into dim_resturant(resturant_name)
select distinct 
       Restaurant_Name
from Swiggy_Data;

select * from fact_swiggy_orders;

select * from dim_resturant;

**************************************************************************

-- insert into fact table

insert into fact_swiggy_orders
(
date_id,
price_INR,
Rating,
Rating_count,
location_id,
category_id,
dish_id,
resturant_id
)
select
dd.date_id,
s.price_INR,
s.Rating,
s.Rating_count,
dl.location_id,
dc.category_id,
dsh.dish_id,
dr.resturant_id

from Swiggy_Data s

join dim_date dd
on dd.full_date = s.Order_Date

join dim_location dl
on dl.STATE = s.State
and dl.CITY = s.City
and dl.LOCATION = s.Location

join dim_resturant dr
on dr.resturant_name = s.Restaurant_Name

join dim_dish dsh
on dsh.dish_name = s.Dish_Name

join dim_category dc
on dc.Category = s.Category
;

select * from fact_swiggy_orders;

select * from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
join dim_category c on f.category_id = c.category_id
join dim_dish sh on f.dish_id = sh.dish_id
join dim_location l on f.location_id = l.location_id
join dim_resturant r on f.resturant_id = r.resturant_id;



   
























