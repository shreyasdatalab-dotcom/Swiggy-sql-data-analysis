create database swiggy_db;
use swiggy_db;

create table swiggy(
restaurant_no int not null,
restaurant_name varchar(50) not null,
city varchar(10) not null,
address varchar(250),
rating decimal(3,1) not null,
cost_per_person integer,
cuisine varchar(50) not null,
resutaurant_link varchar(150) not null,
menu_category varchar(100),
item varchar(200),
price varchar(15) not null,
veg_or_nonveg varchar(10)
);

select * from swiggy limit 10;

-- 01 how many restaurant have a rating greater than 4.5?
select count(distinct restaurant_no) as high_rated_restaurants
from swiggy
where rating > 4.5;

-- 02 which city has the highest number of restaurants?
select city, count(distinct restaurant_name) as restaurant_count
from swiggy
group by city 
order by restaurant_count desc
limit 1;

-- how many restaurants have the word "pizza" in their name?
select count(distinct restaurant_name) as pizza_restaurants
from swiggy
where restaurant_name like '%pizza%';

-- 03 names of pizza restaurant
select distinct restaurant_name as pizza_restaurants
from swiggy
where restaurant_name like '%pizza%';

-- 04 what is the most common cuisine among the restaurant?
select cuisine, count(cuisine) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

-- 05 what is the average rating of restaurants in each city?
select city, avg(rating) as average_rating
from swiggy 
group by city;

-- what is the highest-priced item under the 'recommended' menu category for each restaurant?
select restaurant_name, max(price) as highest_price
from swiggy 
where menu_category = 'recommended'
group by restaurant_name;

-- 07 find the top 5 most expensive restaurants that offer cuisine other than indian?
select distinct restaurant_name, cost_per_person
from swiggy 
where cuisine <> 'indian'
order by cost_per_person desc
limit 5;

-- 08 which restaurant provides the lowest average price for all items?
select restaurant_name, avg(cost_per_person) as avg_price
from swiggy 
group by restaurant_name
order by avg_price
limit 1;

# Intermediate level

-- 01 which restaurant offers the most items in the 'main course' category?
select restaurant_name, count(item) as no_of_items
from swiggy 
where menu_category = 'main course'
group by restaurant_name 
order by no_of_items desc
limit 1;

-- 02 find restaurants whose avarage cost is higher than the overall average cost?
select distinct restaurant_name, cost_per_person
from swiggy 
where cost_per_person > (select avg (cost_per_person) from swiggy);


-- 03 retrive details of restaurants with the same name but located in diffrent cities?
select distinct t1.restaurant_name, t1.city, t2.city
from swiggy as t1
join swiggy as t2
  on t1.restaurant_name = t2.restaurant_name
  and t1.city <> t2.city;
  
  -- 04 which top 5 restaurant offer the highest number of catergories?
  select restaurant_name, count(distinct menu_category) as no_of_categories
  from swiggy 
  group by restaurant_name
  order by no_of_categories desc
  limit 5;
  
  
  # Advanced level
  
  -- 01 list restaurants that are 100% veg, ordered alphabetically?
  select restaurant_name,
	(count(case when veg_or_nonveg = 'veg' then 1 end) * 100 / count(*)) as vegetarian_percentage
    from swiggy 
    group by restaurant_name
    having vegetarian_percentage = 100
    order by restaurant_name;
    
    -- 02 which restaurant provides the higest percentage of non-veg food?
    select restaurant_name,
    (count( case when veg_or_nonveg = 'non-veg' then 1 end) * 100/ count(*)) as nonvegetarian_percentage
    from swiggy 
    group by restaurant_name
    order by nonvegetarian_percentage desc
    limit 1;

-- 03 determine the most expensive and least expensive cities for dining?
with city_expense as (
		select city,
        max(cost_per_person) as max_cost,
        min(cost_per_person) as min_cost
        from swiggy 
        group by city
        )
        select city, max_cost , min_cost
        from city_expense
        order by max_cost desc;
        
        
-- 04 calculate the rating rank for each restaurant within its city (rank = 1)?
with rating_rank_by_city as (
	select distinct restaurant_name, city, rating,
		dense_rank() over (partition by city order by rating desc) as rating_rank
        from swiggy
)
select restaurant_name, city, rating, rating_rank
from rating_rank_by_city
where rating_rank = 1;
