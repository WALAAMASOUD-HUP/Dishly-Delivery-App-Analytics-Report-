

-- تنظيف البيانات 
1/التأكد من القيم الفارغة

select
SUM(case when state is null then 1 else 0 end) as null_state,
SUM(case when City is null then 1 else 0 end) as null_city,
SUM(case when Order_Date is null then 1 else 0 end) as null_order,
SUM(case when Restaurant_Name is null then 1 else 0 end) as null_restaurant,
SUM(case when Location is null then 1 else 0 end) as null_location,
SUM(case when Category is null then 1 else 0 end) as null_category,
SUM(case when Dish_Name is null then 1 else 0 end) as null_dish,
SUM(case when Price_INR is null then 1 else 0 end) as null_price,
SUM(case when Rating is null then 1 else 0 end) as null_Rating,
SUM(case when Rating_Count is null then 1 else 0 end) as null_Rating_Count
from Swiggy_Data;

2/Blank or empty strings

select * 
from Swiggy_Data
where 
State ='' or city ='' or Order_Date = '' or Restaurant_Name = '' or Location = ''
or Category = '' or Dish_Name = '';

3/Duplicate detection

select 
State,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,Price_INR,Rating,Rating_Count,
count(*) as CNT
from Swiggy_Data
group by
State,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,Price_INR,Rating,Rating_Count
having count(*)>1

4/Delete the duplication 

with CTE AS (
select *,ROW_NUMBER() over(
partition by State,City,Order_Date,Restaurant_Name,Location,Category,Dish_Name,Price_INR,Rating,Rating_Count
order by (select null)) as rn 
from Swiggy_Data 
)
delete from CTE where rn>1;

