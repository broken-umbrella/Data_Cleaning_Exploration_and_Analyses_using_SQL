select *
from WorldCupMatches

select column_name, data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'WorldCupMatches'

alter table WorldCupMatches
alter column match_date varchar (255)

with CTE_duplicates as(
select *, ROW_NUMBER() OVER (partition by match_date,
										  stage,
										  stadium,
										  city, 
										  home_team,
										  home_team_goals,
										  away_team_goals, 
										  away_team
										  order by match_date) row_num
from WorldCupMatches
)

delete
from CTE_duplicates
where row_num > 1 -- 16 duplicate records deleted


select SUBSTRING(match_date, 1, 4), count(match_date)
from WorldCupMatches
group by SUBSTRING(match_date, 1, 4)
order by SUBSTRING(match_date, 1, 4) -- The highest number of matches played in 2014, lowest in 1934

select *
from WorldCupMatches
order by MatchID

select *
from WorldCupMatches
where referee like '%[^A-Za-z ()]%'

update WorldCupMatches
set referee = 'Stéphane LANNOY (FRA)'
where referee = 'Stï¿½phane LANNOY (FRA)'

update WorldCupMatches
set referee = 'Olegário Benquerença (POR)'
where referee = 'Olegï¿½rio BENQUERENï¿½A (POR)'

update WorldCupMatches
set referee = 'Björn Kuipers (NED)'
where referee = 'Bjï¿½rn KUIPERS (NED)'

update WorldCupMatches
set referee = 'Cüneyt Çakir (TUR)'
where referee = 'Cï¿½neyt ï¿½AKIR (TUR)'

select *
from WorldCupMatches
where home_team like '%[^A-Za-z ]%'

update WorldCupMatches
set home_team = 'United Arab Emirates'
where home_team = 'rn">United Arab Emirates'

update WorldCupMatches
set home_team = 'Republic of Ireland'
where home_team = 'rn">Republic of Ireland'

update WorldCupMatches
set home_team = 'Trinidad and Tobago'
where home_team = 'rn">Trinidad and Tobago'

update WorldCupMatches
set home_team = 'Serbia and Montenegro'
where home_team = 'rn">Serbia and Montenegro'

update WorldCupMatches
set home_team = 'Bosnia and Herzegovina'
where home_team = 'rn">Bosnia and Herzegovina'

update WorldCupMatches
set home_team = 'Ivory Coast'
where home_team = 'Cï¿½te d''Ivoire'

select *
from WorldCupMatches
where away_team like '%[^A-Za-z ]%'

update WorldCupMatches
set away_team = 'United Arab Emirates'
where away_team = 'rn">United Arab Emirates'

update WorldCupMatches
set away_team = 'Republic of Ireland'
where away_team = 'rn">Republic of Ireland'

update WorldCupMatches
set away_team = 'Trinidad and Tobago'
where away_team = 'rn">Trinidad and Tobago'

update WorldCupMatches
set away_team = 'Serbia and Montenegro'
where away_team = 'rn">Serbia and Montenegro'

update WorldCupMatches
set away_team = 'Bosnia and Herzegovina'
where away_team = 'rn">Bosnia and Herzegovina'

update WorldCupMatches
set away_team = 'Ivory Coast'
where away_team = 'Cï¿½te d''Ivoire'

update WorldCupMatches
set home_team = 'Germany'
where home_team = 'Germany FR'

update WorldCupMatches
set away_team = 'Germany'
where away_team = 'Germany FR'

select count(*)
from WorldCupMatches
where home_team_goals < away_team_goals -- 174

select count(*)
from WorldCupMatches
where home_team_goals > away_team_goals -- 488

select count(*)
from WorldCupMatches
where home_team_goals = away_team_goals -- 190

select *
from WorldCupMatches
where (halftime_home_goals > halftime_away_goals) and (home_team_goals < away_team_goals) -- 4 instances where home team scored more goals before halftime, but away team won

select *
from WorldCupMatches
where (halftime_home_goals < halftime_away_goals) and (home_team_goals > away_team_goals) -- 34 instances where away team scored more goals before halftime, but home team won

select *
from WorldCupMatches
where stage = 'final'

select team, count(team)
from (select home_team as team
from WorldCupMatches
where stage = 'Final'
union all
select away_team as team
from WorldCupMatches
where stage = 'Final') as ft
group by team
order by count(team) desc -- Germany, Brazil, Italy and Argentina played the highest number of world cup finals  

create view VWChampion as
select home_team, home_team_goals, away_team_goals, away_team, win_conditions,
case when home_team_goals > away_team_goals then home_team + ' Won'
	 when home_team_goals < away_team_goals then away_team + ' Won'	
	 when win_conditions = 'Brazil win on penalties (3 - 2) ' then 'Brazil Won'
	 when win_conditions = 'Italy win on penalties (5 - 3) ' then 'Italy Won'
	 end as champion
from WorldCupMatches
where stage = 'Final'

select substring(champion, 1, CHARINDEX(' ', champion)), COUNT(champion)
from VWChampion
group by substring(champion, 1, CHARINDEX(' ', champion))
order by COUNT(champion) desc -- Brazil (5), Germany (4) and Italy (4) have won the world cup more than others

select substring(match_date, 1, 4), sum(attendance)
from WorldCupMatches
group by substring(match_date, 1, 4)
order by sum(attendance) -- 2010, 2006, 2014 and 1994 world cups witnessed the highest number of attendance, lowest in 1934, 1938 and 1930

select win_conditions
from WorldCupMatches
where win_conditions like '%[()]%' -- 26 games were decided in penalties

select t, count(t)
from (select home_team as t
from WorldCupMatches
union all
select away_team as t
from WorldCupMatches) teams
group by t
order by count(t) desc -- Germany, Brazil, Argentina and Italy played the highest number of matches

select max(attendance), min(attendance)
from WorldCupMatches -- Maximum attendance recorded was 173850, minimum 2000

select referee, count(referee)
from WorldCupMatches
group by referee
order by count(referee) -- Ravshan IRMATOV (UZB) was the match referee the highest number of times

select *
from WorldCupPlayers

alter table WorldCupPlayers
drop column [Event]

select matchID
from WorldCupMatches
where stage = 'Final'

with CTE_Player as (
select Player_Name
from WorldCupPlayers
where MatchID in (select matchID
from WorldCupMatches
where stage = 'Final'))

select Player_Name, count(Player_Name)
from CTE_Player
group by Player_Name
order by count(Player_Name) desc -- 7 players in total have played the final the highest number of times (3)

select Player_Name, COUNT(Player_Name)
from WorldCupPlayers
group by Player_Name
order by count(Player_Name) desc -- RONALDO and KLOSE played the highest number of world cup matches

