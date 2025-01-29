select * from orders;
-- where product_id = 'TEC-CO-10004722';

-- Top 10 products by revenue;
select product_id, sum(sale_price) as sales from orders
group by product_id
order by sales desc
limit 10;

-- Find top 5 highest selling product in each region;
with cte as (
select region, product_id, sum(sale_price) as sales from orders
group by region, product_id),
sales_rank as (select *, row_number()over(partition by region order by sales desc) as rank_sales from cte)
select * from sales_rank where rank_sales <= 5;

-- Find month over month comparison of the sales;
with sale as(
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales from orders
group by year(order_date), month(order_date)),
sales_month as (select s1.order_month as order_month, s1.sales as Sales_2022, s2.sales as Sales_2023 from sale s1 inner join sale s2
on s1.order_month = s2.order_month and s2.order_year = s1.order_year + 1)
select *, (Sales_2023 - Sales_2022) as Sales_Growth from sales_month
order by order_month;

 -- It can be done in the other way as;
 with sale as(
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales from orders
group by year(order_date), month(order_date))
select order_month, 
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from sale
group by order_month
order by order_month;

-- For each category which month has the highest sales;
with high_sale as (select category, DATE_FORMAT(order_date, '%Y-%m') AS order_year_month, sum(sale_price) as sales from orders
group by category, DATE_FORMAT(order_date, '%Y-%m')),
rank_high_sale as (select *, row_number()over(partition by category order by sales desc) as rn from high_sale)
select * from rank_high_sale where rn = 1;

-- Which sub-category has the highest sale growth from 2022 to 2023;
with sale as(
select sub_category, year(order_date) as order_year, sum(sale_price) as sales from orders
group by sub_category,year(order_date)),
sub_category_sale as (select sub_category, 
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from sale
group by sub_category)
-- order by sub_category;
select *, ((sales_2023 - sales_2022) * 100/ sales_2022) as sales_growth from sub_category_sale
order by sales_growth desc
limit 1;

-- Which sub-category has the highest profit growth from 2022 to 2023;
with profit as(
select sub_category, year(order_date) as order_year, sum(profit) as profits from orders
group by sub_category,year(order_date)),
sub_category_profit as
(select sub_category, 
sum(case when order_year = 2022 then profits else 0 end) as profits_2022,
sum(case when order_year = 2023 then profits else 0 end) as profits_2023
from profit
group by sub_category)
-- order by sub_category;
select *, ((profits_2023 - profits_2022) * 100/ profits_2022) as profits_growth from sub_category_profit
order by profits_growth desc
limit 1;
