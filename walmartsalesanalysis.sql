create  database if not exists salesDataWalmart;
drop database salesdatawalmart;
create table if not exists sales(
 invoice_id varchar	(30) not null primary key,
branch varchar(5) not null,
 city varchar(30) not null,
 customer_type varchar (30) not null,
 gender varchar (10) not null,
 product_line varchar(100) not null,
 unit_price decimal (10,2) not null,
 quantity int not null,
 VAT float(6,4) not null,
 total decimal (12,4) not null,
 date datetime not null,
 time time not null,
 payment_method varchar (15) not null,
 cogs decimal(10,2) not null,
 gross_margin_pct float (11,9),
 gross_income decimal(12,4) not null,
 rating float(2,1)
);



-- ------------------------------------------------------------------------------------------------------------------
-- ---------------------------------Feature Engeneering--------------------------------------------------------------

select
 time,
 (CASE
     when `time`between "00:00:00" and "12:00:00" then 'Morning'
     When `time` between "12:01:00" and "16:00:00" then 'Afternoon'
     else 'Evening'
	end)
    as time_of_date 
 from sales;
 
 alter table sales add column time_of_day varchar (20);
 update sales 
 set time_of_day = (
 case
   when `time`between "00:00:00" and "12:00:00" then 'Morning'
     When `time` between "12:01:00" and "16:00:00" then 'Afternoon'
     else 'Evening'
	end)
    ;
    
-- Day Name ----
select date, dayname(date) from sales;
alter table sales add column day_name varchar (10);
update sales 
set 
day_name= dayname(date);

-- Month Name ----
select date, monthname(date)
from sales;

alter table sales add column month_name varchar (10);

update	sales 
set month_name = Monthname(date);


-- ------Generic Questions-------
-- -------------------------------
-- 1 How many unique cities does the data have?
 select
  distinct city from sales;
  
-- 2 In which city is each branch?
select 
 distinct city, 
 branch from sales;
 
 -- -----------------------------------------------------------------
 -- ------------------Product----------------------------------------
 
-- 1 How many unique product line does the data have?
  select 
		distinct
			product_line 
  from sales;
  
-- what is the most selling product line--
select 
		sum(quantity) as qty,
			Product_line
			from sales
            Group by Product_line
            Order by qty desc;

select * from sales;

-- what is total revenue by month 
select 
	month_name as Month,
    sum(total) as Total_revenue
from sales 
group by Month_name
order by total_revenue;

-- what month had the largest COGS?
select 
	month_name as Month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs;

-- what product had the largest revenue 
select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order  by total_revenue desc;

-- what is the city with the largest revenue?
select 
	branch,
    city,
    sum(total) as total_revenue
from sales 
group by city, branch 
order by total_revenue desc;

-- what product line had the largest VAT
select 
	product_line,
    avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
select 
	avg(quantity) as avg_qnty
from sales;

select 
	product_line,
    case
		when  avg(quantity) >6 then "Good"
        else "bad"
	end as remark
from sales
group by product_line;


-- Which branch sold more products than average product sold?
select 
	branch,
    sum(quantity)as qnty
from sales
group by branch
having	sum(quantity)  > (select avg(quantity) from sales);

-- What is the most common product line by gender
select
	product_line,gender,
    count(gender) as total_cnt
from sales
group by product_line, gender
order by total_cnt desc;

-- What is the average rating of each product line
select 
	round(avg(rating),2) as avg_rating,
    product_line
from sales 
group by product_line
order by Avg_rating desc;

-- -------------------------------------------------------------------------------
-- ----------------- Customers----------------------------------------------------

 --  How many unique customer types does the data have?
 select customer_type, 
	count(*) as count
from sales 
group by customer_type
order by count desc;

-- Which customer type buys the most?
select 
	customer_type,
    count(*)
from sales 
group by customer_type;

-- What is the gender of most of the customers?
select 
	gender,
    count(*) as gender_cnt
from sales 
group by gender
order by gender_cnt desc;

	
--  What is the gender distribution per branch?
select 
	gender,
    count(*) as gender_cnt 
    from sales 
    where branch = "c"
    group by gender
    order by gender_cnt desc;
    
-- Gender per branch is more or less the same hence, I don't think has an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
select 
	time_of_day,
    avg(rating) as avg_rating
from sales 
group by time_of_day
order by avg_rating desc;

-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch?
select 
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch= 'A'
group by time_of_day
order by avg_rating desc;

-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day fo the week has the best avg ratings?
select 
	Day_name,
    avg(rating) as avg_rating
from sales 
group by day_name
order by avg_rating desc;
-- Mon, Tue and Friday are the top best days for good ratings

-- Which day of the week has the best average ratings per branch?
select 
	day_name,
    count(day_name) total_sales
from sales 
where branch = "A" 
group by day_name
order by total_sales desc;

-- ----------------------------------------------------
-- -----------------Sales------------------------------
-- Number of sales made in each time of the day per weekday 
select 
	time_of_day,
    count(*) as total_sales
from sales 
where day_name = "Sunday"
group by time_of_day
order by total_sales Desc;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
select 
	customer_type,
    sum(total) as  total_revenue
from sales
group by customer_type
order by total_revenue;

-- Which city has the largest tax/VAT percent?
select 
	city,
    round(avg(vat),2) as avg_tax_pct
from sales 
group by city 
order by avg_tax_pct;

-- Which customer type pays the most in VAT?
select 
	customer_type,
    avg(vat) as avg_tax
from sales 
group by customer_type
order by avg_tax desc;