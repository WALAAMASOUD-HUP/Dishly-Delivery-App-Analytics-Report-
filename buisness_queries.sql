
--Kpis
--Total orders

select  distinct COUNT (order_id) as Total_orders
from fact_swiggy_orders;
--Total revenue
select SUM(price_INR) as Total_revenue
from fact_swiggy_orders;

select format(SUM(convert(float,price_INR))/1000000,'N2') + ' INR Million'  --- هنا استخدمنا الكويري دي لتحويل المبلغ و اضفنا بجانبه العملة 
as Total_revenue
from fact_swiggy_orders;

*****************************************************************************

--Average dish price 

select AVG(price_INR) as avg_dish_price 
from fact_swiggy_orders;

select format(avg(convert(float,price_INR)),'N2') + ' INR '
as Total_revenue
from fact_swiggy_orders;

****************************************************************************
--Average rating

select AVG(Rating) as AVG_Rating
from fact_swiggy_orders;

select format(avg(convert(float,Rating)),'N2') as AVG_Rating 
from fact_swiggy_orders;

****************************************************************************


--Buisness analysis
--Monthly order trend ( مجموع الطلبات حسب الشهر )

select 
d.year,
d.month,
d.month_name,
count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by 
d.year,
d.month,
d.month_name
order by Total_orders desc;

select * from dim_date;

****************************************************************************

--Quarterly trend (الايراد الكلي حسب ال quarter)

select 
d.year,
d.Quarter,
format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue,
format(avg(convert(float,Rating)),'N2') as Avg_Rating,
count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by 
d.year,
d.Quarter
order by Total_revenue desc;

*******************************************************************************

--Yearly trend (الايراد الكلي حسب السنة)

select 
d.year,
format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue,
format(avg(convert(float,Rating)),'N2') as Avg_Rating,
count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by 
d.year
order by Total_revenue desc;

select * from dim_date;

**********************************************************************************

--Orders By Day of week(mon-sun) (الايراد الكلي حسب ايام الاسبوع )

select
DATENAME(weekday,d.full_date) as day_name,
COUNT(*) as total_orders,
format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue,
format(avg(convert(float,Rating)),'N2') as Avg_Rating
from fact_swiggy_orders f 
join dim_date d on f.date_id = d.date_id
group by
DATENAME(weekday,d.full_date)
order by Total_revenue desc;

*********************************************************************************

--Top 10 cities by order volume (أفضل 10 مدن حسب عدد الطلبات )

select top 10
l.city,
COUNT(*) as total_orders
from fact_swiggy_orders f 
join dim_location l on f.location_id = l.location_id
group by 
l.city
order by COUNT(*) desc
;

**********************************************************************************

--Top 10 cities by Revenue volume (أفضل 10 مدن حسب الايراد)

select top 10
l.city,
 format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue
from fact_swiggy_orders f 
join dim_location l on f.location_id = l.location_id
group by 
l.city
order by Total_revenue desc

***********************************************************************************

--Revenue contribution by states (الإيراد الكلي حسب الولايات)

select
l.STATE,
 format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue
from fact_swiggy_orders f 
join dim_location l on f.location_id = l.location_id
group by 
l.STATE
order by Total_revenue desc;

************************************************************************************

--Food Performance 
--Top 10 resturants by orders (أفضل 10 مطاعم حسب عدد الطلبات)

select top 10
r.resturant_name,
COUNT(*) as Total_orders,
format(sum(convert(float,price_INR)/1000000),'N2') + ' Million INR' as Total_revenue
from fact_swiggy_orders f 
join dim_resturant r on f.resturant_id = r.resturant_id
group by r.resturant_name
order by Total_revenue desc;

************************************************************************************

--Top categories

select top 10
c.category,
COUNT(*) as Total_orders
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by c.category
order by Total_orders desc;

************************************************************************************

--Most ordered dish (أفضل 10 مطاعم حسب عدد الطلبات)

select top 10
dsh.dish_name,
count(*) as Total_orders
from fact_swiggy_orders f
join dim_dish dsh on f.dish_id = dsh.dish_id
group by dish_name
order by Total_orders desc;

************************************************************************************

--cuising performance (orders+avg_rating)

select 
c.category,
count(*) as Total_orders,
format(avg(convert(float,Rating)),'N2') as Avg_Rating
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by
c.category
order by Total_orders desc;

*************************************************************************************

--Customer spending insights

select case
     when convert(float,price_INR)<100 then 'under 100'
     when convert(float,price_INR) between 100 and 199 then '100-199'
     when convert(float,price_INR) between 200 and 299 then '200-299'
     when convert(float,price_INR) between 300 and 499 then '300-499'
     else '500+'
end as price_range,
count(*) as total_orders
from fact_swiggy_orders f
group by 
case
 when convert(float,price_INR)<100 then 'under 100'
     when convert(float,price_INR) between 100 and 199 then '100-199'
     when convert(float,price_INR) between 200 and 299 then '200-299'
     when convert(float,price_INR) between 300 and 499 then '300-499'
     else '500+'
     end
     order by total_orders desc;

**************************************************************************************

     --rating count distribution

select  
     rating,
     count(*) as total_orders
     from fact_swiggy_orders f
group by 
      rating
order by 
rating desc
