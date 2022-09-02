select *
from shark_attacks

select *
from shark_attacks
order by Case_Number

delete from shark_attacks
where Case_Number = 'xx'

delete from shark_attacks
where Case_Number is null 
and [date] is null 
and [year] is null 
and [type] is null

alter table shark_attacks
alter column [date] date

alter table shark_attacks
drop column [year]

select distinct country
from shark_attacks
where country like '%[^A-Za-z/& ]%'
order by country

update shark_attacks
set country = trim(country)

update shark_attacks
set country = 'ASIA'
where country = 'ASIA?'

update shark_attacks
set country = 'RED SEA'
where country = 'RED SEA?'

update shark_attacks
set country = 'SUDAN'
where country = 'SUDAN?'

update shark_attacks
set country = 'SIERRA LEONE'
where country = 'SIERRA LEONE?'

update shark_attacks
set country = 'INDIAN OCEAN'
where country = 'INDIAN OCEAN?'

select distinct activity
from shark_attacks
order by Activity

update shark_attacks
set Activity = trim(activity)

select [name]
from shark_attacks
order by [name]

update shark_attacks
set [name] = trim([name])

update shark_attacks
set [name] = 'Unknown'
where [name] is null

select [name]
from shark_attacks
where [name] like '%[0-9]%'

update shark_attacks
set [name] = 'Not Applicable'
where [name] like '%[0-9]%'

select [name]
from shark_attacks
where [name] like '"%'
order by [name]

update shark_attacks
set [name] = 'Unknown'
where [name] like '"%'

select [name], count([name])
from shark_attacks
group by [name]
order by count([name]) desc

update shark_attacks
set [name] = 'Unknown'
where [name] = 'male' or [name] = 'female' or [name] = 'boy' or [name] = 'boat' or [name] = 'Anonymous' or [name] = 'sailor' or
	  [name] = 'child' or [name] = 'a sailor' or [name] = 'girl' or [name] = 'fisherman' or [name] = 'Unidentified' or [name] = 'males' or 
	  [name] = 'a native' or [name] = 'a pearl diver' or [name] = 'a soldier' or [name] = 'Aboriginal male'

select distinct sex
from shark_attacks

update shark_attacks
set sex = 'Unknown'
where sex = 'lli' or sex = 'N'

select age
from shark_attacks
order by age

select distinct injury
from shark_attacks

#rest of the columns, #duplicates, 
select fatal, count(fatal)
from shark_attacks
group by fatal

update shark_attacks
set fatal = trim(fatal)

update shark_attacks
set fatal = 'Unknown'
where fatal = '#VALUE!' or fatal = '2017' or Fatal = 'UNKNOWN' or Fatal = 'F'

select [time]
from shark_attacks
order by [time]

select species
from shark_attacks
order by species

select investigator_or_source
from shark_attacks
order by Investigator_or_Source

select *
from shark_attacks
order by original_order































