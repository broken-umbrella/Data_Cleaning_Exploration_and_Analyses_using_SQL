-- Selecting all
select *
from city_temperature

-- Dropping State column as it's null
alter table city_temperature
drop column State

-- Checking the data types
select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'city_temperature'

-- Checking for null values
select *
from city_temperature
where Region is null or  Country is null or City is null or  
		Month is null or Day is null or  Year is null or AvgTemperature is null -- No null values

-- Checking and deleting outliers
select distinct(Month)
from city_temperature
order by Month -- No outliers

select distinct(Day)
from city_temperature
order by Day -- Day 0 exists, outlier

select *
from city_temperature
where Day = 0 -- 6 records

delete from city_temperature
where Day = 0

select distinct(year)
from city_temperature
order by year -- Year 200 and 201 are outliers

select *
from city_temperature
where year = 200 or year = 201 -- 411 records

delete from city_temperature
where year = 200 or year = 201

-- Deleting -99 temperature
delete from city_temperature
where AvgTemperature = '-99'

-- Checking the existence of special characters using RegEx
select *
from city_temperature
where region like '%[^a-zA-z ]%' or Country like '%[^a-zA-z -]%' or City like '%[^a-zA-z -]%'

-- updating Australia/South Pacific to Oceania
update city_temperature
set Region = 'Oceania'
where Region like 'Australia%'

-- updating Myanmar(Burma) with the current name
update city_temperature
set Country = 'Myanmar'
where Country like 'Myanmar%'

-- Updaing Chennai(Madras) and Bombay(Mumbai) with their current names
update city_temperature
set City = 'Mumbai'
where City like 'Bombay%'

update city_temperature
set City = 'Chennai'
where City like 'Chennai%'

-- Counting how many cties are there
select count(distinct(City))
from city_temperature --121 cities are listed

-- Counting cities from each region
select region, count(distinct(City))
from city_temperature
group by region -- Asia (35), Africa (29), Australia (6), Europe (45), Middle East (6)

-- Counting the number of times each country appears
Select Country, count(Country)
from city_temperature
group by Country
order by count(Country) desc -- Australia, China and India are the most appeared countries, while Georgia, Serbia and Oman are the least appeared

-- The range of years
select distinct(Year)
from city_temperature
order by Year

-- The worldwide average temperature each year based on major cities
select year, convert(numeric(10, 2), avg(avgtemperature)) as avgtemp
from city_temperature
group by year
order by avgtemp -- Average temperature, though fluctuated at times, witnessed a marginal decline from 62.62 in 1995 to 59.47 in 2020. It peaked in 2019 with 64.34 degrees.

-- the average temperature of all major cities
select City, convert(numeric(10, 2), avg(avgtemperature)) as avgtemp
from city_temperature
group by City
order by avgtemp -- Muscat (-98.50), Bujumbura (-65.40), and Bonn (-46.87) were the coldest cities during the given period, whereas Singapore (81.65), Niamey (81.95), and Chennai (82.85) were the hottest.

-- the average temperature of all regions based on major cities
select region, convert(numeric(10, 2), avg(avgtemperature)) as avgtemp
from city_temperature
group by region
order by avgtemp -- Middle East (65.36) was the hottest, Europe (46.81) was the coldest

-- the average temperature of all countries based on major cities
select Country, convert(numeric(10, 2), avg(avgtemperature)) as avgtemp
from city_temperature
group by Country
order by avgtemp -- Oman (-98.50), Burundi (-65.40), and Malawi (-20.57) were the coldest, Bahrain (80.64), Philippines (81.54), and Singapore (81.65)  were the hottest

-- Highest/Lowest change in temperature
create table #avg2020(
City varchar (255),
AvgTemperature float)

insert into #avg2020
Select City, convert(numeric(10, 2), avg(AvgTemperature)) as avgtemp2020
from city_temperature
where Year = 2020
group by City
order by City

create table #avg1995(
City varchar (255),
AvgTemperature float)

insert into #avg1995
Select City, convert(numeric(10, 2), avg(AvgTemperature)) as avgtemp1995
from city_temperature
where Year = 1995
group by City
order by City

select a1.City, a1.AvgTemperature as avgTemp2020, a2.AvgTemperature as avgTemp1995, convert(numeric(10, 2), a1.AvgTemperature - a2.AvgTemperature) as tempChange, 
case when a1.AvgTemperature > a2.AvgTemperature then 'Increased'
when a1.AvgTemperature < a2.AvgTemperature then 'Decreased'
when a1.AvgTemperature = a2.AvgTemperature then 'Same'
end as IncOrDec
from #avg2020 a1 left join #avg1995 a2
on a1.City = a2.City
order by IncOrDec desc
-- Vientiane (0.04), and Singapore (1.30) had the lowest margin of change in temperature, 
-- Tirana (150.16), and Rangoon (181.55) had the highest increasing margin of change in temperature
-- Minsk (-19.80) and Islamabad (-14.76) had the highest decreasing margin of change in temperature
-- 37 Countries witnessed an increasing trend and the rest decreasing

-- Global Monthly Analysis
select Month, convert(numeric(10, 2), avg(AvgTemperature)) as avgMonthlyTemp
from city_temperature
group by Month
order by avgMonthlyTemp desc -- July (65.33) and August (64.61) are the hottest months, December (43.54) and January (43.45) are the coldest

-- Region-wise Monthly Analysis
select Region, Month, convert(numeric(10, 2), avg(AvgTemperature)) as avgMonthlyTemp
from city_temperature
group by Region, Month
order by Region, avgMonthlyTemp
-- In Africa, December is the coldest, March is the hottest. In Asia, January is the coldest, July the hottest. Same goes for Europe.
-- In Middle East, January is the coldest, August is the hottest. In Oceania, July is the coldest while January the hottest.

-- Latest recorded Year's Monthly Analysis
select Year, Month, convert(numeric(10, 2), avg(AvgTemperature)) as avgMonthlyTemp
from city_temperature
where Year = '2020'
group by Year, Month
order by Year, avgMonthlyTemp -- Highly increasing trend as it went from 53.63 in January to 66.70 in May.

-- Region-wise change in temperature
select Region, Year, convert(numeric(10, 2), avg(AvgTemperature))
from city_temperature
where year = 1995 or year = 2020
group by Region, Year
order by Region, year
-- All continents experienced increases. Europe had the least margin of change, while Middle East's almost doubled during the given period.

-- Global Daily Analysis
select Day, convert(numeric(10, 2), avg(AvgTemperature)) as avgDailyTemp
from city_temperature
group by Day
order by avgDailyTemp desc -- On average, 29th day was the hottest, while 31st was the coldest

-- Comparing Different regions' countries' weather
select Region, Country, avg(AvgTemperature)
from city_temperature
group by Region, Country
order by Region, avg(AvgTemperature) 
-- In the African region, The major cities of Burundi and Malawi were the coldest, while Senegal and Benin were the hottest.
-- In the Asian region, The major cities of Bangladesh and Mongolia were the coldest, while Philippines and Singapore were the hottest.
-- In the European region, The major cities of Germany and Cyprus were the coldest, while Greece and Portugal were the hottest.
-- In the Middle Eastern region, The major cities of Oman the coldest, while Kuwait and Bahrain were the hottest.
-- In the Oceanian region, The major cities of Australia were hotter than New Zealand's.

-- Highest/Lowest Temp
select max(AvgTemperature), min(AvgTemperature)
from city_temperature

select * 
from city_temperature
where AvgTemperature = '110' -- Kuwait had the highest temperature recorded between 1995 and 2020 which was 110 (2012)

select * 
from city_temperature
where AvgTemperature = '-37.2' -- Ulan-bator had the lowest temperature recorded between 1995 and 2020 which was 110 (2001)

-- Analysing UK's major cities' weather
select *
from city_temperature
where Country = 'United Kingdom'
order by city -- Two cities: Belfast and London

select *
from city_temperature
where Country = 'United Kingdom' and City = 'London'
order by AvgTemperature -- Highest recorded temperature was 83.4 on 25th of July in 2019, the lowest 24.6 was on 28th of February 2018.

select *
from city_temperature
where Country = 'United Kingdom' and City = 'Belfast'
order by AvgTemperature -- Lowest 12.5 on 21st December 2010, Highest 77.6 on 29th June 1995.

select avg(AvgTemperature)
from city_temperature
where Country = 'United Kingdom' and City = 'London' -- Average temperature in London is 52.84

select avg(AvgTemperature)
from city_temperature
where Country = 'United Kingdom' and City = 'Belfast' -- Average temperature in Belfast is 53.63

select Year, avg(AvgTemperature)
from city_temperature
where Country = 'United Kingdom' and City = 'Belfast'
group by Year
order by avg(AvgTemperature)
-- The temperature in Belfast constantly fluctuated and there was no substantial change as the highest was 53.49 (1995) and the lowest 45.21 (2020)

select Year, avg(AvgTemperature)
from city_temperature
where Country = 'United Kingdom' and City = 'London'
group by Year
order by avg(AvgTemperature) -- London also did not experience any significant change. The highest was 54.37 in 2014, lowest 48.08 (2020)

select Month, avg(AvgTemperature)
from city_temperature
where Country = 'United Kingdom' and City = 'London'
group by Month
order by avg(AvgTemperature) -- The hottest months in London are July and August, coldest are January and February
