-- --------------------------------------------------------------------
-- ---------------------------- Walmart sales from Myanmar------------------------------
-- --------------------------------------------------------------------
-- Creating the database
create database if not exists Walmart; 
-- Creating and uploading the table
create table sales (
invoice_id varchar(30) not null primary key, branch varchar(5) not null, city varchar(30) not null, 
customer_type varchar(30) not null,  gender varchar(10) not null, product_line varchar(100) not null, 
unit_price decimal(10,2) not null, quantity int not null, tax float(6,4) not null, 
total decimal(10,2), order_date datetime not null, order_time time not null, 
payment varchar(30) not null, cogs decimal(10, 2) not null, 
gross_margin_percentage  float(11,9) not null, gross_income decimal(10, 2) not null, 
rating float(2, 1) not null);
-- Backup of the database 
create table sales_staging
like sales;

insert sales_staging
select *
from sales;
-- Adding and populating new columns to enhance the analysis
-- time of the day
select order_time, (
case when order_time between "00:00:00" and "12:00:00" then "Morning"
when order_time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end) as time_of_date
from sales_staging;

alter table sales_staging
add column time_of_day varchar(20); 

update sales_staging
set time_of_day = (case when order_time between "00:00:00" and "12:00:00" then "Morning"
when order_time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end);
-- Day name
alter table sales_staging add column day_name varchar(10);

update sales_staging
set day_name = dayname(order_date);
-- Month name 
alter table sales_staging add column month_name varchar(10);

select order_date, monthname(order_date)
from sales_staging;

update sales_staging 
set month_name = monthname(order_date);

-- Exploratory Data Analysis --
-- What cities does the dataset cover? 
select distinct city, branch
from sales_staging;
 -- How many product lines does the data have?
select distinct product_line
from sales_staging;

select count(distinct product_line) as num_of_product_line
from sales_staging;
-- What is the most common payment method?
select payment, count(*)
from sales_staging
group by payment
order by count(*) desc;
-- Which product line did sell the most?
select product_line, sum(quantity)
from sales_staging
group by product_line
order by sum(quantity)desc;
-- Which product line did sell the most on january, february, march,?
select month_name ,product_line, sum(quantity)
from sales_staging
group by month_name ,product_line
order by month_name ,sum(quantity) desc;
-- What us the total revenue by month?
select month_name, sum(total)
from sales_staging
group by month_name
order by sum(total) desc;
-- What month had the largest cogs?
select month_name, sum(cogs)
from sales_staging
group by month_name
order by sum(cogs) desc;
-- What product line had the largest revenue?
select product_line, sum(total)
from sales_staging
group by product_line
order by sum(total) desc;
-- What is the city with the largest revenue?
select city, sum(total)
from sales_staging
group by city
order by sum(total) desc;
-- What product line had the largest Tax?
select product_line, sum(tax)
from sales_staging
group by product_line
order by sum(tax) desc;
select product_line, avg(tax)
from sales_staging
group by product_line
order by avg(tax) desc;
-- Determine which product lines sold less than average
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.49 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
-- What is the most common product line by gender?
select gender, product_line, sum(quantity)
from sales_staging
group by gender, product_line
order by sum(quantity) desc;
select gender, product_line, count(gender)
from sales_staging
group by gender, product_line
order by count(gender) desc;
--  What is the average rating of each product line?
select product_line, round(avg(rating),2) as avg_rating
from sales_staging
group by product_line
order by avg_rating desc;
-- number of sales in each time of the day per weekday
select day_name, time_of_day, sum(quantity), sum(total)
from sales_staging
group by day_name, time_of_day
order by day_name desc;

select day_name, time_of_day, sum(quantity), sum(total)
from sales_staging
where day_name = "Monday"
group by time_of_day
order by day_name desc;

-- Which of the customer types brings the most revenue?
select customer_type, sum(quantity), sum(total)
from sales_staging
group by customer_type
order by sum(quantity) desc;
-- Which city has the largest tax percent
select city, avg(tax/cogs)
from sales_staging
group by city
order by avg(tax/cogs) desc;
-- Which customer type pays the most in Tax?
select customer_type, avg(tax/quantity)
from sales_staging
group by customer_type
order by avg(tax/quantity) desc;
-- What are the 3 payments methods?
select distinct payment
from sales_staging;
-- What is the most common customer type?
select customer_type, count(*)
from sales_staging
group by customer_type
order by count(*) desc;
-- what customer type buys the most?
select customer_type, sum(quantity), sum(total)
from sales_staging
group by customer_type
order by sum(quantity) desc;
-- What is the gender distribution per branch?
select branch, gender, count(gender)
from sales_staging
group by branch, gender
order by count(gender) desc;

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating)	
from sales_staging
group by time_of_day
order by avg(rating) desc;
-- Which time of the day do customers give most ratings per branch?
select branch, time_of_day, avg(rating)	
from sales_staging
group by branch, time_of_day
order by avg(rating) desc;

-- Which day of the week has the best avg ratings? 
select day_name, avg(rating)	
from sales_staging
group by day_name
order by avg(rating) desc;
-- Which day of the week has the best average ratings per branch?
select branch, day_name, avg(rating)	
from sales_staging
group by branch, day_name
order by branch;

select *
from sales_staging;