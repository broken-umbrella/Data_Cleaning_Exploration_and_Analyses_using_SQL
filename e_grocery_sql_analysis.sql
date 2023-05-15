select top 10 *
from e_grocery_consumer_behaviour

with cte_duplicates as
(select *, ROW_NUMBER() over(partition by order_id,
									     [user_id], 
										 order_number,
										 order_dow,
										 order_hour_of_day,
										 days_since_prior_order,
										 product_id,
										 add_to_cart_order,
										 reordered,
										 department_id,
										 department,
										 product_name
										 order by order_id) as rn
from e_grocery_consumer_behaviour)
select *
from cte_duplicates
where rn > 1
order by rn desc

update e_grocery_consumer_behaviour
set department = 'uncategorized'
where department = 'missing' or department = 'other'

select distinct order_hour_of_day
from e_grocery_consumer_behaviour
order by order_hour_of_day

select distinct order_dow
from e_grocery_consumer_behaviour
order by order_dow

alter table e_grocery_consumer_behaviour
alter column order_dow varchar(max)

update e_grocery_consumer_behaviour
set order_dow = 'Saturday'
where order_dow = '6'

-- Total number of orders
select distinct order_id
from e_grocery_consumer_behaviour -- 2,000,000 total orders


--- users with the highest/lowest number of purchases
select [user_id], count([user_id]) as num_of_purchases
from e_grocery_consumer_behaviour
group by [user_id]
order by num_of_purchases
-- Customers with the highest number of orders:
--203166	240 purchases
--105213	245 purchases
--15503		258 purchases
--31903		270 purchases
--100330	271 purchases
--115495	283 purchases
--201268	347 purchases
--126305	384 purchases
--129928	405 purchases
--176478	460 purchases
-- Customers with the lowest number of orders:
-- More than 3,000 customers (3,309) customers had only one purchase, more than 16,000 (16121) had fewer than 5 purchases.

--- departments with the highest/lowest number of sales
select department, count(department)
from e_grocery_consumer_behaviour
group by department
order by count(department) desc 
-- Total 20 departments, highest/lowest departments
-- produce	588996
--dairy eggs	336915
--snacks	180692
--beverages	168126
--frozen	139536
--pantry	116262
--bakery	72983
--canned goods	66053
--deli	65176
--dry goods pasta	54054
--household	46446
--breakfast	44605
--meat seafood	44271
--personal care	28134
--babies	25940
--international	16738
--alcohol	9439
--uncategorized	6989
--pets	6013
--bulk	2133

--- products with highest/lowest sales from each department
select department, product_name, count(product_name)
from e_grocery_consumer_behaviour
group by department, product_name
order by department asc, count(product_name) desc
--department_name highest_sold_product lowest_sold_product
-- alcohol - beers coolers (3002) - specialty wines champagnes (614)
-- babies - baby food formula (23355) - baby accessories (504)
-- bakery - bread (36381) - bakery desserts (2214)
-- beverages - water seltzer sparkling water (52564) - cocoa drink mixes (1332)
-- breakfast - cereal (23754) - breakfast bars pastries (4621)
-- bulk - bulk grains rice dried goods (1074) - bulk dried fruits vegetables (1059)
-- canned goods - soup broth bouillon (21540) - canned meat seafood (4212)
-- dairy eggs - yogurt (90751) - refrigerated pudding desserts (2423)
-- deli - lunch meat (24470) - prepared soups salads (4384)
-- dry goods pasta - dry pasta (16414) - fresh pasta (2340)
-- frozen - frozen produce (32432) - frozen juice (279)
-- household - paper goods (15422) - kitchen supplies (561)
-- international - asian foods (10426) - kosher foods (697)
-- meat seafood - hot dogs bacon sausage (19037) - packaged seafood (1301)
-- pantry - baking ingredients (20137) - baking supplies decor (1451)
-- personal care - oral hygiene (4018) - beauty (387)
-- pets - cat food care (3835) - dog food care (2178)
-- produce - fresh fruits (226039) - packaged produce (17408)
-- snacks - chips pretzels (45306) - ice cream toppings (706)
-- uncategorized products are recorded as 'missing' or 'other'

--- departments reordered
select department, sum(reordered)
from e_grocery_consumer_behaviour
group by department
order by sum(reordered)
-- Prodducts from these departments were reordered the highest number of times
-- beverages	110117
-- dairy eggs	225798
-- produce	382425
-- Prodducts from these departments were reordered the lowest number of times
-- bbulk	1230
-- uncategorized	2765
-- pets	3634

--- popular/unpopular days of week
select order_dow, count(order_dow)
from e_grocery_consumer_behaviour
group by order_dow
order by count(order_dow) desc
-- Sunday	391831
-- Monday	349236
-- Saturday	280751
-- Friday	262157
-- Tuesday	261912
-- Wednesday	238730
-- Thursday	234884

-- dpeartments each day of week
select order_dow, department, count(department)
from e_grocery_consumer_behaviour
group by order_dow, department
order by order_dow, count(department) desc
-- dow - highest dep - lowest dep
-- Friday - produce (73188) - bulk (284)
-- Monday - produce (103835) - bulk (367)
-- Saturday - produce (83083) - bulk (278)
-- Sunday - produce (122185) - bulk (389)
-- Thursday	produce (65814) - bulk (265)
-- Tuesday - produce (74381) - bulk (282)
-- Wednesday - produce (66510) - bulk (268)

-- products each day of week
select order_dow, product_name, count(product_name)
from e_grocery_consumer_behaviour
group by order_dow, product_name
order by order_dow, count(product_name) desc
-- dow - highest product - lowest product
-- Friday - fresh fruits (29265) - frozen juice (35)
-- Monday - fresh fruits (41126) - frozen juice (39)
-- Saturday - fresh vegetables (31831) - frozen juice (41)
-- Sunday - fresh vegetables (46643) - frozen juice (51)
-- Thursday - fresh fruits (25744) - frozen juice (41)
-- Tuesday - fresh fruits (28830) - frozen juice (35)
-- Wednesday - fresh fruits (26102) - frozen juice (37)

--- porducts sold highest/lowest number of times
select product_name, count(product_name)
from e_grocery_consumer_behaviour
group by product_name
order by count(product_name) desc
-- Highest sold
--fresh fruits 226039
--fresh vegetables 212611
--packaged vegetables fruits 109596
-- Lowest sold
-- baby accessories	504
-- beauty	387
-- frozen juice	279


--- popular/unpopular hours
select order_hour_of_day, count(order_hour_of_day)
from e_grocery_consumer_behaviour
group by order_hour_of_day
order by count(order_hour_of_day) desc
--10	173306
--11	170291
--14	167831
--15	167157
--13	166376
--12	163511
--16	158247
--9	150248
--17	129383
--8	106754
--18	102416
--19	78516
--20	62110
--7	54143
--21	48857
--22	40762
--23	24331
--6	18293
--0	13481
--1	7283
--5	5732
--2	4210
--4	3269
--3	2994

-- popular/least popular hours every day
select order_dow, order_hour_of_day, count(order_hour_of_day)
from e_grocery_consumer_behaviour
group by order_dow, order_hour_of_day
order by order_dow, count(order_hour_of_day) desc
-- Day - pop - unpop
-- Friday - 11	22771, 10	22306 - 4	497, 3	425
-- Monday - 10	34326, 9	31299 - 4	510, 3	510
-- Saturday - 14	24241, 12	23832 - 4	493, 3	490
-- Sunday - 13	36586, 14	35256 - 4	438, 3	415
-- Thursday - 16	19253, 10	18924 - 4	526, 3	441
-- Tuesday - 11	22113, 10	21813 - 3	459, 2	430
-- Wednesday - 15	20525, 10	19623 - 4	342, 3	254

-- Percentage of customers who reordered
select convert(numeric(10, 2), count(*)) / (select convert(numeric(10, 2), count(*)) from e_grocery_consumer_behaviour)
from e_grocery_consumer_behaviour
where reordered = 1
-- 59.74% customers reordered


--- users with purchases from the highest number of departments
with CTE_super_customers as (
select [user_id], department
from e_grocery_consumer_behaviour
group by [user_id], department)

select [user_id], count([user_id]) as user_appearances
from CTE_super_customers
group by [user_id]
order by user_appearances desc
-- user id 160693 purchased items from 19 different departments, the highest
-- 26 customers purchased items from at least 17 departments

--- orders with the highest number of items
select order_id, count(order_id)
from e_grocery_consumer_behaviour
group by order_id
order by count(order_id) desc
-- three orders with 100 or more items
--790903	137 - ordered by 129928
--2621625	109 - ordered by 60694
--416346	100 - ordered by 129928

-- customers who ordered 100 items
select *
from e_grocery_consumer_behaviour
where order_id in ('790903', '2621625', '416346')
-- 129928 ordered 100 items twice




