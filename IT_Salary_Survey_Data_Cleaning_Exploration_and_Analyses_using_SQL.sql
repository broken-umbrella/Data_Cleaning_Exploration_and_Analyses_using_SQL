select *
from it_salary_survey_eighteen

select column_name, data_type
from INFORMATION_SCHEMA.columns
where table_name = 'it_salary_survey_eighteen'

alter table it_salary_survey_eighteen
alter column age int

alter table it_salary_survey_eighteen
alter column years_of_experience int

alter table it_salary_survey_eighteen
alter column current_salary int

alter table it_salary_survey_eighteen
alter column salary_one_year_ago int

alter table it_salary_survey_eighteen
alter column salary_two_year_ago int

alter table it_salary_survey_eighteen
alter column timestamps date

delete from it_salary_survey_eighteen
where timestamps not like '2018%'

delete from it_salary_survey_eighteen
where position like '%[^A-Za-z./()+&# -]%'

update it_salary_survey_eighteen
set city = 'Munchen'
where city like '%[^A-Za-z]%' and city like 'M%'

update it_salary_survey_eighteen
set city = 'Saint Petersburg'
where city = 'saint petersburg'

update it_salary_survey_eighteen
set city = 'Nuremberg'
where city like '%[^A-Za-z]%' and city like 'N%'

update it_salary_survey_eighteen
set city = 'Cologne'
where city like '%[^A-Za-z]%' and city like 'K%'

delete from it_salary_survey_eighteen
where city like '%[^A-Za-z]%' and city <> 'Schleswig-Holstein' and city <> 'Saint Petersburg'

update it_salary_survey_eighteen
set city = substring(city, 1, charindex(',', city) - 1)
where city like '%,%'

update it_salary_survey_eighteen
set company_size = NULL
where company_size = 'Oct-50'

delete from it_salary_survey_eighteen
where position is null
--------------------------------

select *
from it_salary_survey_nineteen

select column_name, data_type
from INFORMATION_SCHEMA.columns
where table_name = 'it_salary_survey_nineteen'

alter table it_salary_survey_nineteen
alter column age int

alter table it_salary_survey_nineteen
alter column Years_of_experience int

alter table it_salary_survey_nineteen
alter column Yearly_salary int

alter table it_salary_survey_nineteen
alter column Yearly_bonus int

alter table it_salary_survey_nineteen
alter column salary_one_year_ago int

alter table it_salary_survey_nineteen
alter column bonus_one_year_ago int

alter table it_salary_survey_nineteen
alter column vacation_days int

alter table it_salary_survey_nineteen
alter column home_office_days_per_month int

update it_salary_survey_nineteen
set timestamps = SUBSTRING(timestamps, 1, 10)

delete from it_salary_survey_nineteen
where timestamps not like '%2019'

delete from it_salary_survey_nineteen
where position is null

select position
from it_salary_survey_nineteen
where position like '%[^A-Za-z ]%'

alter table it_salary_survey_nineteen
drop column yearly_stocks

update it_salary_survey_nineteen
set Company_name = 'NA'
where Company_name like '%[^A-Za-z0-9/. ]%'

update it_salary_survey_nineteen
set company_size = null
where company_size = 'Oct-50' 

update it_salary_survey_nineteen
set Company_sector = 'Ecommerce'
where Company_sector = 'Сommerce'

update it_salary_survey_nineteen
set Company_sector = 'Construction'
where Company_sector = 'Сonstruction'


select *
from it_salary_survey_twenty

select column_name, data_type
from INFORMATION_SCHEMA.columns
where table_name = 'it_salary_survey_twenty'

alter table it_salary_survey_twenty
alter column age int

alter table it_salary_survey_twenty
alter column Years_of_experience int

alter table it_salary_survey_twenty
alter column Yearly_salary int

alter table it_salary_survey_twenty
alter column Yearly_bonus int

alter table it_salary_survey_twenty
alter column Years_of_experience_in_Germany int

alter table it_salary_survey_twenty
alter column vacation_days int

alter table it_salary_survey_twenty
alter column timestamps date

delete from it_salary_survey_twenty
where timestamps like '2021%'

update it_salary_survey_twenty
set city = 'D�sseldorf'
where City = 'Düsseldorf'

update it_salary_survey_twenty
set city = 'Nuremberg'
where City = 'Nürnberg'

update it_salary_survey_twenty
set Employment_status = 'Working Student'
where (Employment_status = 'Werkstudent') or  (Employment_status = 'working student') or (Employment_status like 'full-time, but 32 hours per week (it was my request,%')

select distinct Employment_status
from it_salary_survey_twenty
where Employment_status like '%[A-Za-z ]%'
 
delete from it_salary_survey_twenty
where Main_language_at_work = '50/50' or  Main_language_at_work = 'Русский'

select distinct Company_size
from it_salary_survey_twenty

update it_salary_survey_twenty
set Company_size = null
where Company_size = 'Nov-50'

delete from it_salary_survey_twenty
where Company_type like '%[^A-Za-z /&-]%'

select distinct [Have you lost your job due to the coronavirus outbreak?]
from it_salary_survey_twenty
where [Have you lost your job due to the coronavirus outbreak?] like '%[A-Za-z ]%'

select distinct Seniority_level
from it_salary_survey_twenty
where Seniority_level like '%[^A-Za-z -]%'

select distinct expertise
from it_salary_survey_twenty
where expertise like '%[^A-Za-z +/,-]%'

select distinct other_expertises
from it_salary_survey_twenty
where other_expertises like '%[^A-Za-z /,+.-]%'

select *
from it_salary_survey_twenty
where position like '%data%'
order by len(expertise) asc -- Only a couple of rows had multiple skills listed as areas of expertise, no need to use CROSS APPLY STRING_SPLIT function

select expertise, count(expertise)
from it_salary_survey_twenty
where position like '%data%'
group by expertise
order by count(expertise) desc 

create table #top_skill(
skills varchar (255))

insert into #top_skill
select value as skills
from it_salary_survey_twenty
cross apply string_split(other_expertises, ',')
where position like '%data%' 

select skills, count(skills)
from #top_skill
group by skills
order by count(skills) desc -- Python and SQL were the most used skills in data fields, cloud computing skills (AWS, GCP, Docker) are also quite popular among data enthusiasts

alter view vWavgSalaryEighteen as
select city, avg(current_salary) avg_salary_eighteen
from it_salary_survey_eighteen
group by city
having count(city) > 5

alter view vWavgSalaryNinteen as
select city, avg(Yearly_salary) avg_salary_nineteen
from it_salary_survey_nineteen
group by city
having count(city) > 5

alter view vWavgSalaryTwenty as
select city, avg(Yearly_salary) avg_salary_twenty
from it_salary_survey_twenty
group by city
having count(city) > 5

create table #temp_avg(
city varchar (255),
avg_salary float)

select e.city, e.avg_salary_eighteen, n.avg_salary_nineteen, t.avg_salary_twenty
from vWavgSalaryEighteen e 
inner join vWavgSalaryNinteen n 
on  e.city = n.city
inner join vWavgSalaryTwenty t
on n.city = t.city -- The avg salary in Amsterdam, Berlin and Cologne increased while in Frankfurt, Hamburg and Stuttgart descreased

select avg(current_salary) as avg_salary
from it_salary_survey_eighteen
where position like '%data%' -- Avg salary of people working in data-related fields in 2018: 74895

select count(*)
from it_salary_survey_eighteen
where position like '%data%' -- 36 people from data field

select avg(Yearly_salary) as avg_salary
from it_salary_survey_nineteen
where position like '%data%' -- Avg salary of people working in data-related fields in 2019: 71991

select count(*)
from it_salary_survey_nineteen
where position like '%data%' -- 163 people from data field, a noteworthy spike in the field

select avg(Yearly_salary) as avg_salary
from it_salary_survey_twenty
where position like '%data%' -- Avg salary of people working in data-related fields in 2019: 69239

select count(*)
from it_salary_survey_twenty
where position like '%data%' -- 155 people from data field

create proc spShowTables as
begin
select * from it_salary_survey_eighteen
select * from it_salary_survey_nineteen
select * from it_salary_survey_twenty
end

spShowTables

create view vWEighteen as
select position, avg(current_salary) as avg_salary_eighteen
from it_salary_survey_eighteen
group by position
having count(position) > 10 -- Software Engineers, Data Scientist and Software Developers had the highest salary

create view vWNineteen as
select position, avg(Yearly_salary) avg_salary_nineteen
from it_salary_survey_nineteen
group by position
having count(position) > 10 -- Software Architects, Machine Learning Engineers, DevOps' and Data Scientists had the highest salary

create view vWTwenty as
select position, avg(Yearly_salary) avg_salary_twenty
from it_salary_survey_twenty
group by position
having count(position) > 10 -- DevOps', Frontend Developers and Data Engineers had the highest salary

select n.position, e.avg_salary_eighteen, n.avg_salary_nineteen, t.avg_salary_twenty
from vWNineteen n full join vWEighteen e
on n.position = e.position
full join vWTwenty t 
on t.position = n.position
where n.position is not null 
-- Mobile Developers, Frontend Developers, Backend Developers, Data Engineers, DevOps' and QA professionals witnessed an increase
-- Data Scientists witnessed a decrease

select expertise, count(expertise)
from it_salary_survey_twenty
group by expertise
order by count(expertise) desc -- Python, Java, Javascript and Php are the predominant primary skills among IT professionals

select other_expertises, count(other_expertises)
from it_salary_survey_twenty
group by other_expertises
order by count(other_expertises) desc -- SQL and Cloud Platform are the most appeared secondary skills among IT professionals

with CTE_Nineteen as(
select position, gender, avg(Yearly_salary) avg_salary_eighteen
from it_salary_survey_nineteen
group by position, gender
having count(position) > 5)

select * 
from CTE_Nineteen
where position in (select position
from CTE_Nineteen
group by position
having count(position) > 1)

with CTE_Twenty as(
select position, gender, avg(Yearly_salary) as avg_salary
from it_salary_survey_twenty
group by position, gender
having count(position) > 5)

select * 
from CTE_Twenty
where position in (select position
from CTE_Twenty
group by position
having count(position) > 1)
-- Males earn more, working the same as females

select avg(current_salary)
from it_salary_survey_eighteen
where position like '%data%' --74895

select position
from it_salary_survey_eighteen
where position not like '%data%' and position in (select position
from it_salary_survey_eighteen
group by position
having count(position) > 10) and current_salary > (select avg(current_salary) from it_salary_survey_eighteen) 
group by position -- 9 Job positions in it sector had a higher earning than data professionals in 2018

select avg(current_salary)
from it_salary_survey_eighteen
where position not like '%data%' -- 68016

select avg(Yearly_salary)
from it_salary_survey_nineteen
where position like '%data%' -- 71991

select position
from it_salary_survey_nineteen
where position not like '%data%' and position in (select position
from it_salary_survey_nineteen
group by position
having count(position) > 10) and Yearly_salary > (select avg(Yearly_salary) from it_salary_survey_nineteen) 
group by position -- 12 Job positions in it sector had a higher earning than data professionals in 2019

select avg(Yearly_salary)
from it_salary_survey_nineteen
where position not like '%data%' -- 72790

select avg(Yearly_salary)
from it_salary_survey_twenty
where position like '%data%' -- 69239

select avg(Yearly_salary)
from it_salary_survey_twenty
where position not like '%data%' -- 71975
-- Though data professionals in 2018 were earning more than others, other professioanls outstrip data professionals in 2019 and 2020

select position
from it_salary_survey_twenty
where position not like '%data%' and position in (select position
from it_salary_survey_twenty
group by position
having count(position) > 10) and Yearly_salary > (select avg(Yearly_salary) from it_salary_survey_twenty) 
group by position -- 10 Job positions in it sector had a higher earning than data professionals in 2020

select position, avg(vacation_days)
from it_salary_survey_twenty
group by position
having count(position) > 5
order by avg(vacation_days) desc -- On average, most of the people have 26 to 28 days of vacation

delete
from it_salary_survey_twenty
where vacation_days = 365

select lost_job_due_to_covid, count(lost_job_due_to_covid)
from it_salary_survey_twenty
group by lost_job_due_to_covid

select cast(58 as float) / cast(1200 as float) -- 0.05% people lost their job because of Covid

