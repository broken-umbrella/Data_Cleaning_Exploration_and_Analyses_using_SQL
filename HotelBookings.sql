select *
from hotel_bookings

select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'hotel_bookings'

alter table hotel_bookings
alter column reservation_status_date date

select *
from hotel_bookings
where arrival_date_day_of_month is null or  arrival_date_month is null or arrival_date_year is null

alter table hotel_bookings
add arrival_date varchar (255)

update hotel_bookings
set arrival_date =  concat(arrival_date_day_of_month, arrival_date_month, arrival_date_year)

alter table hotel_bookings
drop column company,
			arrival_date_day_of_month, 
			arrival_date_month, 
			arrival_date_year

delete
from hotel_bookings
where (adults = 0) and (children = 0) and (babies = 0)

select (cast(count(hotel) as float) / (select cast(count(*) as float) from hotel_bookings)) * 100
from hotel_bookings
where hotel = 'City Hotel' -- 66.45% people chose City Hotel

select (cast(count(hotel) as float) / (select cast(count(*) as float) from hotel_bookings)) * 100
from hotel_bookings
where hotel = 'Resort Hotel' -- 33.55% people chose Resort Hotel

select (cast(count(is_canceled) as float) / (select cast(count(*) as float) from hotel_bookings where hotel = 'City Hotel')) * 100
from hotel_bookings
where hotel = 'City Hotel' and is_canceled = 1 -- 41.73% of City Hotel's bookings got cancelled

select (cast(count(is_canceled) as float) / (select cast(count(*) as float) from hotel_bookings where hotel = 'Resort Hotel')) * 100
from hotel_bookings
where hotel = 'Resort Hotel' and is_canceled = 1 -- 27.76% of Resort Hotel's bookings got cancelled

select (cast(count(is_repeated_guest) as float) / (select cast(count(*) as float) from hotel_bookings where hotel = 'City Hotel')) * 100
from hotel_bookings
where hotel = 'City Hotel' and is_repeated_guest = 1 -- 2.56% of City Hotel's bookings are from repeated guests

select (cast(count(is_repeated_guest) as float) / (select cast(count(*) as float) from hotel_bookings where hotel = 'Resort Hotel')) * 100
from hotel_bookings
where hotel = 'Resort Hotel' and is_repeated_guest = 1 -- 4.44% of Resort Hotel's bookings are from repeated guests

alter view resort_hotel as 
select *
from hotel_bookings
where hotel = 'Resort Hotel'

create view vWTB as
select customer_type, cast(count(*) as float) as total_bookings 
from resort_hotel 
group by customer_type

select rh.customer_type, (cast(count(rh.customer_type) as float) / cast(tb.total_bookings as float)) * 100
from resort_hotel rh inner join vWTB tb
on rh.customer_type = tb.customer_type
where rh.is_canceled = 1
group by rh.customer_type, tb.total_bookings -- Transient customers have the highest cancellation rate (31.17%), Contract the lowest (8.84%) at Resort Hotel

select agent, count(agent)
from resort_hotel
where agent <> 'NULL'
group by agent
order by count(agent) desc -- Agents 240 and 250 have made the highest number of bookings at Resort Hotel

create view vwAgents as
select agent, count(agent) as agents_bookings
from resort_hotel
where agent <> 'NULL'
group by agent

select rh.agent, count(rh.agent), (cast(count(rh.agent) as float) / cast(ab.agents_bookings as float)) * 100 as cancel_percentage
from resort_hotel rh inner join vwAgents ab
on rh.agent = ab.agent
where rh.agent <> 'NULL' and rh.is_canceled = 1
group by rh.agent, ab.agents_bookings
having count(rh.agent) >= 20
order by cancel_percentage desc 
-- Agents with the highest cancellation percentage (100%): 252, 257, 310, 492 and 495
-- Agents with the lowest cancellation rate: 40 (8.18%) and 243 (5.45%)

alter view city_hotel as 
select *
from hotel_bookings
where hotel = 'City Hotel'

create view vwTBCH as
select customer_type, count(*) as total_bookings
from city_hotel
group by customer_type

select ch.customer_type, (cast(count(ch.customer_type) as float) / cast(tbch.total_bookings as float)) * 100
from city_hotel ch inner join vwTBCH tbch
on ch.customer_type = tbch.customer_type
where ch.is_canceled = 1
group by ch.customer_type, tbch.total_bookings -- Contract customers have the highest cancellation rate (48.04%), Group the lowest (9.90) at City Hotel

select agent, count(agent)
from city_hotel
where agent <> 'NULL'
group by agent
order by count(agent) desc -- Agents 9 and 1 have made the highest number of bookings at City Hotel

create view vwAgentsCH as
select agent, count(agent) as agents_bookings
from city_hotel
where agent <> 'NULL'
group by agent

select ch.agent, count(ch.agent), (cast(count(ch.agent) as float) / cast(abch.agents_bookings as float)) * 100 as cancel_percentage
from city_hotel ch inner join vwAgentsCH abch
on ch.agent = abch.agent
where ch.agent <> 'NULL' and ch.is_canceled = 1
group by ch.agent, abch.agents_bookings
having count(ch.agent) >= 20
order by cancel_percentage desc 
-- Agents with the highest cancellation percentage (100%): 162, 170, 235, 236, 286, 323, 326, 41, 47, 5, 64 and 78
-- Agents with the lowest cancellation rate: 27 (10%) and 28 (6.60%)

select convert(numeric(10, 2), avg(stays_in_week_nights)) as stays_in_week_nights, 
	   convert(numeric(10, 2), avg(stays_in_weekend_nights)) as stays_in_weekend_nights
from resort_hotel
where stays_in_week_nights <> 0 
	  and stays_in_weekend_nights <> 0 
	  and is_canceled <> 1 -- On average, people stayed more during weekdays/weeknights (4.15) than weekends (1.89)

select convert(numeric(10, 2), avg(stays_in_week_nights)) as stays_in_week_nights, 
	   convert(numeric(10, 2), avg(stays_in_weekend_nights)) as stays_in_weekend_nights
from city_hotel
where stays_in_week_nights <> 0 
	  and stays_in_weekend_nights <> 0 
	  and is_canceled <> 1 -- On average, people stayed more during weekdays/weeknights (2.44) than weekends (1.52)

select (cast(count(*) as float) / cast((select count(*) from resort_hotel) as float)) * 100
from resort_hotel
where children <> 0 and babies <> 0 -- 0.26% reservations included kids

select (cast(count(*) as float) / cast((select count(*) from city_hotel) as float)) * 100
from city_hotel
where children <> 0 and babies <> 0 -- 0.09% reservations included kids

select right(arrival_date, 4), count(arrival_date)
from resort_hotel
group by right(arrival_date, 4) -- 2016 was the most popular year

select SUBSTRING(arrival_date, len(arrival_date) - 7, 4)
from resort_hotel
group by right(arrival_date, 4)

select right(arrival_date, 4), count(arrival_date)
from city_hotel
group by right(arrival_date, 4) -- 2016 was the most popular year

select previous_cancellations, days_in_waiting_list, booking_changes, average_daily_rate, deposit_type, reserved_room_type, assigned_room_type
from resort_hotel
where is_canceled = 1 -- 11,120 bookings were cancelled

select avg(days_in_waiting_list)
from resort_hotel
where is_canceled = 1 and days_in_waiting_list <> 0 
-- 60.71 days avg waiting list where bookings got cancelled, while those not cancelled had an avg of 84.18 days of waiting list

select reserved_room_type, assigned_room_type
from resort_hotel
where is_canceled = 1 and (reserved_room_type <> assigned_room_type) -- 384, 3.45% (Not Significant)

with CTE_cancellations_rh as(
select previous_cancellations, count(previous_cancellations) as num_of_times
from resort_hotel
where is_canceled = 1 and previous_cancellations <> 0
group by previous_cancellations)

select sum(num_of_times) 
from CTE_cancellations_rh -- 924 (8.3%) people had previous cancellations

select (cast(count(*) as float) / cast((select count(*) from resort_hotel where is_canceled = 1) as float)) * 100
from resort_hotel
where is_canceled = 1 and stays_in_weekend_nights != 0 -- (70.84%)

select (cast(count(*) as float) / cast((select count(*) from resort_hotel where is_canceled = 1) as float)) * 100
from resort_hotel
where is_canceled = 1 and stays_in_week_nights <> 0 -- 96.12%, more cancellations during weekdays

select booking_changes
from resort_hotel
where is_canceled = 1 and booking_changes <> 0 -- 1154, 10.34% bookings invovlved changes before getting cancelled

select deposit_type, count(deposit_type)
from resort_hotel
where is_canceled = 1
group by deposit_type -- No Deposit (9448, 85%), Refundable (22, 0.20%), Non-Refund (1650, 14.84%)

select convert(numeric(10, 2), avg(average_daily_rate))
from resort_hotel
where is_canceled = 1 -- 105.81

select convert(numeric(10, 2), avg(average_daily_rate))
from resort_hotel
where is_canceled = 0 -- 90.82
-- People who cancelled their bookings had a higher average daily rate than those who did not




select previous_cancellations, previous_bookings_not_canceled, days_in_waiting_list, booking_changes, average_daily_rate, deposit_type, reserved_room_type, assigned_room_type
from city_hotel
where is_canceled = 1

with CTE_cancellations as(
select previous_cancellations, count(previous_cancellations) as num_of_times
from city_hotel
where is_canceled = 1 and previous_cancellations <> 0
group by previous_cancellations)

select sum(num_of_times) 
from CTE_cancellations -- 5016 (15%) people had previous cancellations


select (cast(count(*) as float) / cast((select count(*) from city_hotel where is_canceled = 1) as float)) * 100
from city_hotel
where is_canceled = 1 and stays_in_weekend_nights != 0 -- 16837 (50.90%)

select (cast(count(*) as float) / cast((select count(*) from city_hotel where is_canceled = 1) as float)) * 100
from city_hotel
where is_canceled = 1 and stays_in_week_nights <> 0 -- 31610 (95.56%); more cancellations during weekdays

select avg(days_in_waiting_list)
from city_hotel
where is_canceled = 0 and days_in_waiting_list <> 0 -- 66.86 days avg waiting list where bookings got cancelled, while those not cancelled had an avg of 90.37 days

select booking_changes
from city_hotel
where is_canceled = 1 and booking_changes <> 0 -- 1676, 5.01% bookings invovlved changes before getting cancelled

select reserved_room_type, assigned_room_type
from city_hotel
where is_canceled = 1 and (reserved_room_type <> assigned_room_type) -- 417, 1.26% (Not Significant)

select convert(numeric(10, 2), avg(average_daily_rate))
from city_hotel
where is_canceled = 1 -- 104.76

select convert(numeric(10, 2), avg(average_daily_rate))
from city_hotel
where is_canceled = 0 -- 106.04
-- Not much of a difference

select deposit_type, count(deposit_type)
from city_hotel
where is_canceled = 1
group by deposit_type -- No Deposit	(20221, 61.13%), Refundable (14, 0.04%), Non-Refund (12844, 38.83%)


select *
from resort_hotel
where is_repeated_guest <> 0 -- 1778 (4.43%)

select *
from city_hotel
where is_repeated_guest <> 0 -- 1977 (2.49%)

select country, count(*)
from resort_hotel
group by country
order by count(*) desc
-- Top countries: Portugal (17622, 44.00%), Great Britain (6813,17.01%), and Spain (3956, 9.88%). More than 70% guests were from these three countries.

select country, count(*)
from resort_hotel
where is_canceled <> 0
group by country
order by count(*) desc 
-- Top countries' cancelled records: Portugal (17622, 42.21%), Great Britain (6813,13.08%), and Spain (3956, 21.51%).

select country, count(*)
from city_hotel
group by country
order by count(*) desc
-- Top countries: Portugal (30861, 38.98%), France (8791,11.10%), and Germany (6082, 7.68%). More than 55% guests were from these three countries.

select country, count(*)
from city_hotel
where is_canceled <> 0
group by country
order by count(*) desc 
-- Top countries' cancelled records: Portugal (20068, 25.35%), France (1722, 2.18%), and Great Britain (1561, 1.97%).


select country, convert(numeric(10, 2), avg(average_daily_rate))
from resort_hotel
group by country
having count(country) > 50
order by avg(average_daily_rate) desc 
-- Average Daily Rate was the highest for these countries: Morocco (177.40, cancellation rate: 48%), Luxemburg (154.19, CR: 33%), and USA (133.87, CR: 15%)

select country, count(*)
from resort_hotel
where (country = 'MAR' or country = 'LUX' or country = 'USA') and is_canceled <> 0
group by country

select country, convert(numeric(10, 2), avg(average_daily_rate))
from city_hotel
group by country
having count(country) > 50
order by avg(average_daily_rate) desc 
-- Average Daily Rate was the highest for these countries: Iran (129.74, cancellation rate: 29%), Columbia (125.53, CR: 34%), and Norway (124.24, CR: 32%)

select country, count(*)
from city_hotel
where country = 'IRN' or country = 'COL' or country = 'NOR'
group by country

select avg(average_daily_rate)
from resort_hotel
where stays_in_week_nights <> 0 and stays_in_weekend_nights = 0 -- Average Daily Rate during weeknights(86.67)

select avg(average_daily_rate)
from resort_hotel
where stays_in_week_nights = 0 and stays_in_weekend_nights <> 0 -- Average Daily Rate during weekends(82.06)

select avg(average_daily_rate)
from city_hotel
where stays_in_week_nights <> 0 and stays_in_weekend_nights = 0 -- Average Daily Rate during weeknights(104.38)

select avg(average_daily_rate)
from city_hotel
where stays_in_week_nights = 0 and stays_in_weekend_nights <> 0 -- Average Daily Rate during weekends(104.98)

select avg(days_in_waiting_list)
from resort_hotel
where is_canceled = 0 and days_in_waiting_list != 0 -- 60.71 average wating days when cancelled, 84.18 when not cancelled

select avg(days_in_waiting_list)
from city_hotel
where is_canceled = 0 and days_in_waiting_list != 0 -- 66.86 average wating days when cancelled, 90.37 when not cancelled
