select *
from covid_data

-- Cleaning Data

-- Keeping only the needed columns 
alter table covid_data
drop column iso_code, 
			new_cases_smoothed, 
			new_deaths_smoothed, 
			new_cases_smoothed_per_million, 
			new_deaths_smoothed_per_million, 
			reproduction_rate, 
			new_tests_smoothed, 
			new_tests_smoothed_per_thousand, 
			new_vaccinations_smoothed, 
			new_vaccinations_smoothed_per_million, 
			new_people_vaccinated_smoothed, 
			new_people_vaccinated_smoothed_per_hundred, 
			handwashing_facilities,
			excess_mortality_cumulative_absolute,
			excess_mortality_cumulative,
			excess_mortality_cumulative_per_million

delete
from covid_data
where continent is null

-- Converting data type
select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'covid_data'

alter table covid_data
alter column [date] varchar(255)

alter table covid_data
alter column total_cases bigint

alter table covid_data
alter column new_cases int

alter table covid_data
alter column total_deaths int

alter table covid_data
alter column new_deaths int

alter table covid_data
alter column people_vaccinated bigint

alter table covid_data
alter column people_fully_vaccinated bigint

alter table covid_data
alter column total_boosters bigint

-- Checking Duplicates
with CTE_dup as(
select *, ROW_NUMBER() over(partition by [location],
										 [date]
										 order by [location], [date]) row_num
from covid_data)

select * 
from CTE_dup
where row_num > 1 -- No duplicates

select [date]
from covid_data
order by [date]

delete from covid_data
where [date] = '1899-12-30'


-- Exploration and Analysis
select continent, avg(cast(total_cases as bigint)) as tc, avg(cast(total_deaths as bigint)) as td
from covid_data
group by continent
order by tc 
-- On average, South America had the highest number of total cases (2133177) and total deaths (63961), 
-- Africa had the lowest number of total cases (105480), but Oceania had the lowest number of total deaths (506)

select [location], substring([date], 6, 2), avg(total_cases), avg(total_deaths)
from covid_data
where SUBSTRING([date], 1, 4) = '2021'
group by [location], substring([date], 6, 2)
order by avg(total_cases) desc
-- In 2020, US, India and Brazil were the worst hit countries in terms of total cases and deaths
-- In 2021, Brazil was able to tackle the virus to an extent, United States and India were still struggling with a soaring rate of total cases and deaths 

select [location], avg(cast(people_vaccinated as bigint)), avg(cast(people_fully_vaccinated as bigint)), avg(cast(total_boosters as bigint))
from covid_data
group by [location]
order by avg(total_boosters) desc
-- China, India and United States are the countries with the most number of vaccinated and fully vaccinated people 
-- China, Mexico and Vietnam are the countries with the highest number of boosters administered



-- Let's see how the Covid situation was in the UK
select *
from covid_data
where [location] = 'United Kingdom'
-- As of the 18th of August 2022, 23457428 people have been affected, 185247 people died, 50483527 people fully vaccinated, 40196024 people took boosters

select cast(185247 as float) / cast(23457428 as float) * 100
-- 0.78% of the Covid-affected people died in the UK
select cast(23457428 as float) / cast(67281040 as float) * 100
-- 34.86% of the overall poplulation got affected by Covid
select cast(50483527 as float) / cast(67281040 as float) * 100
-- 75.03% of the population have so far been fully vaccinated


select substring([date], 1, 7) as months,
	   avg(new_cases) as new_cases, 
	   avg(new_deaths) as new_deaths,
	   avg(total_cases) as total_cases,
	   avg(total_deaths) as total_deaths,
	   avg(people_vaccinated) as people_vaccinated
from covid_data
group by substring([date], 1, 7)
order by months
-- Number of cases and deaths constantly increased throughout the whole 2020
-- In 2021, there were a few ups and downs in terms of the number of new cases, while the death rate was constantly decreasing
-- The number of cases peaked in January 2022, then decreased again, death rate plummeted in 2022
-- As the number of vaccinated people increased, the number of deaths decreased

-- The role population played
select [location], 
	   avg(new_cases) as new_cases,
	   avg(total_cases) as total_cases,
	   avg([population]) as pop
from covid_data
group by [location]
order by pop desc
-- Top 5 average new cases: United States, India, Brazil, France and Germany
-- Top 5 average total cases: United States, India, Brazil, France and United Kingdom
-- Top 5 average population: China, India, United States, Indonesia and Pakistan
-- 3 of the 5 most populated countries were the worst hit countries, population might have played a role

select [location], avg(cast(total_cases as float)) / avg(cast([population] as float)) * 100 as pop_per
from covid_data
group by [location]
order by pop_per desc
-- The highest percentage of population infected by Covid: Andorra, Gibraltar, San Marino, Montenegro, Slovakia

select [location], avg(cast(total_deaths as float)) / avg(cast([population] as float)) * 100 as pop_per
from covid_data
group by [location]
order by pop_per desc
-- The highest percentage of population died of Covid: Peru, Gibraltar, Bulgaria, Bosnia and Herzegovina and Hungary

select [location], avg(cast(total_deaths as float)) / avg(cast(total_cases as float)) * 100 as deaths_per
from covid_data
group by [location]
order by deaths_per desc
-- These countries witnessed the highest percentage of death from the number of infected people 

select [location], avg(cast(people_vaccinated as float)) / avg(cast([population] as float)) * 100 as perc_people_vaccinated,
				   avg(cast(people_fully_vaccinated as float)) / avg(cast([population] as float)) * 100 as perc_people_fully_vaccinated, 
				   avg(cast(total_boosters as float)) / avg(cast([population] as float)) * 100 as perc_total_boosters
from covid_data
group by [location]
order by perc_total_boosters desc
-- UAE, China, Cuba, Aruba and Kuwait have so far vaccinated the highest percentage of their population
-- UAE, China, Pitcairn, Kuwait and Bahrain have so far fully vaccinated the highest percentage of their population
-- Malta, Bhutan, Chile, Bahrain and Guernsey have so far administered booster to the highest percentage of their population

select [date], sum(new_cases), sum(new_deaths)
from covid_data
group by [date]
order by sum(new_deaths) desc -- The highest number of people got affected by Covid in January, 2022. The highest number of people died from Covid in January and February, 2021

select [location], convert(numeric(10, 2), avg(human_development_index)),
				   convert(numeric(10, 2), avg(cast(extreme_poverty as float))),
				   convert(numeric(10, 0), avg(total_cases)),
				   convert(numeric(10, 0), avg(total_deaths))
from covid_data
where [location] is not null and human_development_index is not null and extreme_poverty is not null
group by [location]
order by avg(total_deaths) desc 
-- Socio-economic situation of a country did not seem have an impact on the number of cases or deaths