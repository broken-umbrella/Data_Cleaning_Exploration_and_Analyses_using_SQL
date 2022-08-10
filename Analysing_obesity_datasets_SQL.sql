-- Selecting, updating and formatting the tables
select *
from adult_men_overweight_or_obese_vs_calories

alter table adult_men_overweight_or_obese_vs_calories
add entities varchar (255)

update adult_men_overweight_or_obese_vs_calories
set entities = Entity

alter table adult_men_overweight_or_obese_vs_calories
drop column Entity

alter table adult_men_overweight_or_obese_vs_calories
add daily_calory_supplies float

alter table adult_men_overweight_or_obese_vs_calories
add years int

update adult_men_overweight_or_obese_vs_calories
set daily_calory_supplies = daily_calory_supply

update adult_men_overweight_or_obese_vs_calories
set years = convert(int, Year)

alter table adult_men_overweight_or_obese_vs_calories
drop column Daily_Calory

alter table adult_men_overweight_or_obese_vs_calories
drop column daily_calory_supply

alter table adult_men_overweight_or_obese_vs_calories
drop column Year

alter table adult_men_overweight_or_obese_vs_calories
drop column Continent

update adult_men_overweight_or_obese_vs_calories
set Years = convert(int, Year)

update adult_men_overweight_or_obese_vs_calories
set daily_calory_supplies = convert(float, daily_calory_supply)

delete from adult_men_overweight_or_obese_vs_calories
where overweight_or_obese is null or Code is null

delete from adult_men_overweight_or_obese_vs_calories
where years < 2000

delete from adult_men_overweight_or_obese_vs_calories
where daily_calory_supplies is null

delete from adult_men_overweight_or_obese_vs_calories
where entities = 'World'

select *
from adult_men_overweight_or_obese_vs_calories

select *
from adult_men_overweight_or_obese_vs_calories
order by daily_calory_supplies desc

select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'adult_men_overweight_or_obese_vs_calories'

alter table adult_men_overweight_or_obese_vs_calories
alter column overweight_or_obese float


select entities, cast(avg(overweight_or_obese) as decimal(10, 2)) as avg_overweight_or_obese, max(overweight_or_obese) as max_overweight_or_obese, min(overweight_or_obese) as min_overweight_or_obese
from adult_men_overweight_or_obese_vs_calories
group by entities
order by min_overweight_or_obese desc -- Samoa, Kuwait and US had the highest overweight or obese people on average, Cambodia, Ethiopia and Rwanda had the lowest.

select entities, cast(avg(daily_calory_supplies) as decimal(10, 2)) as avg_daily_calory_supplies, max(daily_calory_supplies) as max_daily_calory_supplies, min(daily_calory_supplies) as min_daily_calory_supplies
from adult_men_overweight_or_obese_vs_calories
group by entities
order by avg_daily_calory_supplies desc -- US, Belgium and Austria had the highest daily calory supplies, while Ethiopia, Afghanistan and Zambia had the lowest. 

select entities, cast(avg(daily_calory_supplies) as decimal(10, 2)) as avg_daily_calory_supplies, 
				 max(daily_calory_supplies) as max_daily_calory_supplies, 
				 min(daily_calory_supplies) as min_daily_calory_supplies, 

				 cast(avg(overweight_or_obese) as decimal(10, 2)) as avg_overweight_or_obese, 
				 max(overweight_or_obese) as max_overweight_or_obese, 
				 min(overweight_or_obese) as min_overweight_or_obese

from adult_men_overweight_or_obese_vs_calories
group by entities
order by entities

select entities, cast(avg(estimated_population) as decimal(30,2)) as avg_pop, 
				 cast(avg(overweight_or_obese) as decimal(10,2)) as avg_obese, 
				 cast(avg(daily_calory_supplies) as decimal(10,2)) as avg_calory

from adult_men_overweight_or_obese_vs_calories
group by entities
order by avg_pop desc

select *
from adult_men_overweight_or_obese_vs_calories

create table #temptable(
	entities varchar (255),
	years int,
	max_ov_ob float)

select entities, years, max(overweight_or_obese) as max_overweight_or_obese
from adult_men_overweight_or_obese_vs_calories
group by entities, years
order by entities desc

SELECT aoo.*
FROM adult_men_overweight_or_obese_vs_calories aoo
INNER JOIN
    (SELECT entities, MAX(overweight_or_obese) AS max_overweight_or_obese
    FROM adult_men_overweight_or_obese_vs_calories
    GROUP BY entities) groupedaoo 
ON aoo.entities = groupedaoo.entities
AND aoo.overweight_or_obese = groupedaoo.max_overweight_or_obese
order by aoo.years desc -- Every country witnessed an increasing obesity trend, except Brunei

select years, max(overweight_or_obese) as max_overweight_or_obese
from adult_men_overweight_or_obese_vs_calories
group by years
order by max_overweight_or_obese desc -- Obesity rate has been increasing over the years


select *
from obesity_death_rate

select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'obesity_death_rate'

alter table obesity_death_rate
alter column Year int

alter table obesity_death_rate
add death_rate float

update obesity_death_rate
set death_rate = Deaths

alter table obesity_death_rate
drop column Deaths

update obesity_death_rate
set death_rate = cast(death_rate as decimal(10, 2))

select *
from obesity_death_rate
where Entity is null or Code is null or Entity = 'World' or Year is null or death_rate is null

create table #temp_odr(
Entity varchar (255),
Code varchar (255),
Year int,
death_rate float)

insert into #temp_odr
select odr.*
from obesity_death_rate odr
inner join
(select Entity, max(death_rate) as max_death_rate
from obesity_death_rate
group by Entity) group_odr
on odr.Entity = group_odr.Entity
and
odr.death_rate = group_odr.max_death_rate
order by max_death_rate desc -- Fiji(2000) and Kiribati(2005) had the highest death rate, North Korea(2007) and Japan(2000) had the lowest

select *
from #temp_odr
where year = '2019' -- 55 countries witnessed the highest death_rate in 2019, the latest recorded year on the dataset 

select *
from overweight_children

select *
from overweight_children
where Entity is null or Code is null or Entity = 'World' or Year is null or overweight_prevalence_among_children_under_5 is null

create table #temp_opac(
Entity varchar (255),
Code varchar (255),
Year float,
max_opac float)

insert into #temp_opac
select oc.*
from overweight_children oc
inner join
(select Entity, max(overweight_prevalence_among_children_under_5) as max_opac
from overweight_children
group by Entity) grouped_oc
on oc.Entity = grouped_oc.Entity
and
oc.overweight_prevalence_among_children_under_5 = grouped_oc.max_opac
order by max_opac desc -- Ukraine (2007) and Libya (2014) had the highest overweight prevalence among children in recorded history, Sri lanka (2019) and Niger (2019) had the lowest

select *
from #temp_opac
where Year = '2019'
order by max_opac desc-- 67 countries had the highest overweight prevalence among children in 2019, the latest year on this dataset.


select *
from share_of_deaths_obesity
where Entity is null or Code is null or Entity = 'World' or Year is null or share_of_deaths is null

delete from share_of_deaths_obesity
where Entity is null or Code is null or Entity = 'World' or Year is null or share_of_deaths is null

create table #temp_sd(
Entity varchar (255),
Code varchar (255),
Year float,
max_sd float)

insert into #temp_sd
select sd.*
from share_of_deaths_obesity sd
inner join
(select Entity, max(share_of_deaths) as max_sd
from share_of_deaths_obesity
group by Entity) grouped_sd
on sd.Entity = grouped_sd.Entity
and
sd.share_of_deaths = grouped_sd.max_sd
order by max_sd desc -- Fiji (2005) and Cook Islands (2019) had the highest share of deaths in recorded history, Somalia (2019) and Central African Republic (2019) had the lowest

select *
from #temp_opac
where Year = '2019'
order by max_opac desc -- 67 countries had the highest share of deaths in 2019

-- analysing the United Kingdom's obesity data
select *
from adult_men_overweight_or_obese_vs_calories
where entities = 'United Kingdom'

select *
from obesity_death_rate
where entity = 'United Kingdom'

select *
from share_of_deaths_obesity
where entity = 'United Kingdom'

select oo.*, dr.death_rate, sd.share_of_deaths
from adult_men_overweight_or_obese_vs_calories oo, obesity_death_rate dr, share_of_deaths_obesity sd
where oo.Code = 'GBR' and dr.Code = 'GBR' and sd.Code = 'GBR' 
and oo.years = dr.Year and oo.years = sd.Year -- Obesity rate increased constantly, though calory supply fluctuated, death rate decreased, share of deaths decreased

