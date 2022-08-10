select *
from titles

-- checking the data types
select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'titles'

## release_year float to int, seasons float to int

alter table titles
add release_years int

update titles
set release_years = convert(int, release_year)

select COLUMN_NAME, DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'titles'

alter table titles
drop column release_year

alter table titles
add number_of_seasons int

update titles
set number_of_seasons = convert(int, seasons)

alter table titles
drop column seasons

select *
from titles where title is null

# 1 title is null, deleting...
delete from titles
where id = 'tm1063792'

# Changing null values
select *
from titles where description is null

update titles
set description = 'NA'
where description is null

select *
from titles
where age_certification is null

update titles
set age_certification = 'NA'
where age_certification is null

select *
from titles
where type = 'SHOW' and number_of_seasons is null

select *
from titles
where imdb_id is null

update titles
set imdb_id = 'NA'
where imdb_id is null

select *
from titles
where imdb_score is null

update titles
set imdb_score = 0
where imdb_score is null

select *
from titles
where imdb_votes is null

update titles
set imdb_votes = 0
where imdb_votes is null

select *
from titles
where tmdb_popularity is null

update titles
set tmdb_popularity = 0
where tmdb_popularity is null

select *
from titles
where tmdb_score is null

update titles
set tmdb_score = 0
where tmdb_score is null

update titles
set number_of_seasons = 0
where number_of_seasons is null

# Updating row values of the column type
update titles
set type = 'Show'
where type = 'SHOW'

update titles
set type = 'Movie'
where type = 'MOVIE'

# How many contents are there
select count(title)
from titles

# Checking the contents with special character in their names
select title
from titles
where title like '%[^0-9a-zA-Z $@$.$-$''''$,]%'

# Updating rows of the column genres
update titles
SET genres = REPLACE(REPLACE(genres, '[', ''), ']', '')
WHERE genres like '[%' OR genres like '%]'

update titles
set genres = replace(genres, '''', '')
where genres like '%''' or genres like '''%'

select *
from titles
where genres = ''

update titles
set genres = 'Not Provided'
where genres = ''

# Longest and shortest movies
select title, runtime
from titles
order by runtime

# Updating rows of the column production_countries
update titles
set production_countries = replace(replace(production_countries, '[', ''), ']', '')
where production_countries like '[%' or production_countries like '%]'

update titles
set production_countries = replace(replace(production_countries, '''', ''), '''', '')
where production_countries like '''%' or production_countries like '%'''

update titles
set production_countries = 'Not Provided'
where production_countries = ''

# Which countries produce the highest number of contents, and which lowest
select production_countries, count(production_countries)
from titles
group by production_countries
order by count(production_countries) desc

# Converting the number format of the column tmdb_popularity
update titles
set tmdb_popularity = convert(numeric(10,2), tmdb_popularity)

# Cleaning the credits dataset
select *
from credits

select *
from credits
where name is null

delete from credits
where name is null

select *
from credits
where character is null

update credits
set character = 'NA'
where character is null

alter table credits
drop column movie_id

alter table credits
add movie_id varchar (255)

update credits
set movie_id = id

alter table credits
drop column id

alter table credits
add roles varchar (255)

update credits
set roles = role

alter table credits
drop column role

select distinct(roles)
from credits

update credits
set roles = lower(roles)

-- Cleaning part done

-- Analyses Begin

select *
from titles

select type, count(type)
from titles
group by type -- Netflix has more movies than Shows

select release_years, count(title) as num_of_movies
from titles
where type = 'Movie'
group by release_years
order by num_of_movies
 -- oldest year, 1953 (1 movie). Newest year, 2022 (108 movies).... highest number of movies were uploaded in 2019 (540) an the lowest (1) in multiple years, the number started to surge from 2016
 -- however, in both 2020 and 2021, the number decreased.


select release_years, title
from titles
where type = 'Show'
order by release_years -- oldest year 1945 (1 Show), newest year 2022 (109 Shows).

select release_years, count(title) as num_of_TV
from titles
where type = 'Show'
group by release_years
order by num_of_TV desc -- highest number of shows uploaded in 2019 (308), slightly decreased in 2020 and 2021. The lowest number (1) in multiple years

select title, imdb_score
from titles
where type = 'Movie'
order by imdb_score -- 4 movies have the highest imdb rating (9), lowest Aerials (1.5). There are few movies with 0 which are just ouliers

select title, imdb_score
from titles
where type = 'Show'
order by imdb_score -- 2 shows have the highest score (9.6), lowest He's expecting (1.6). There are few shows with 0 which are just ouliers

select count(age_certification) as num_of_movies, age_certification
from titles
where type = 'Movie' and age_certification != 'NA'
group by age_certification
order by count(age_certification) -- R (575) and PG-13 (440) rated movies appeared the most, NC-17 (14) is the least appeared.

select count(age_certification) as num_of_shows, age_certification
from titles
where type = 'Show' and age_certification != 'NA'
group by age_certification
order by count(age_certification) -- TV-MA (841) and TV-14 (470) are the most appeared TV genres while TV-G (76) is the least appeared.

select title, imdb_votes
from titles
where type = 'Movie' and imdb_votes is not null and imdb_votes != 0
order by imdb_votes -- Inception and Forrest Gump are the most voted movies on IMDB, thus the most popular ones. There are 1138 movies with fewer than a 1000 votes, thus conisdered least popular

select title, imdb_votes
from titles
where type = 'Show' and imdb_votes is not null and imdb_votes != 0
order by imdb_votes -- Breaking Bad and Stranger Things are the most voted on IMDB so most popular. There are 739 shows with fewer than a 1000 votes so least popular.

select title, tmdb_popularity
from titles
where type = 'Movie' and tmdb_popularity is not null and tmdb_popularity != 0
order by tmdb_popularity -- 365 Days: This Day and Yaksha: Ruthless Operations are the most popular movies. There are 1564 movies with popularity ratings below 5.

select title, tmdb_popularity
from titles
where type = 'Show' and tmdb_popularity is not null and tmdb_popularity != 0
order by tmdb_popularity -- The Marked Heart and Wheel of Fortune are the most popular shows. There are 617 shows with popularity ratings below 5.

select title, imdb_score, tmdb_score
from titles
where type = 'Movie' and imdb_score != 0 and tmdb_score != 0 and tmdb_score > imdb_score
order by tmdb_score -- 1709 movies have higher rating on TMDB

select title, imdb_score, tmdb_score
from titles
where type = 'Movie' and imdb_score != 0 and tmdb_score != 0 and tmdb_score < imdb_score
order by tmdb_score -- 1357 movies have higher rating on IMDB, the rest have the same rating

select title, imdb_score, tmdb_score
from titles
where type = 'Show' and imdb_score != 0 and tmdb_score != 0 and tmdb_score > imdb_score
order by tmdb_score -- 1068 shows have higher rating on TMDB

select title, imdb_score, tmdb_score
from titles
where type = 'Show' and imdb_score != 0 and tmdb_score != 0 and tmdb_score < imdb_score
order by tmdb_score -- 627 shows have higher rating on IMDB, the rest have the same rating

# Selecting Western movies
select count(genres)
from titles
where genres like '%western%'

#Creating temp table for better analysis of the genres
create table #temp_table(
genre varchar (255))

insert into #temp_table
SELECT value as genre
FROM titles
CROSS APPLY STRING_SPLIT(genres, ',')

# Removing spaces from gneres' name
update #temp_table
set genre = ltrim(genre)
where genre like ' %'

select *
from #temp_table

select distinct(genre)
from #temp_table
where genre != 'Not Provided' -- 19 genres

select genre, count(genre) as no_of_content
from #temp_table
where genre != 'Not Provided'
group by genre
order by no_of_content -- Netflix has the most number of contents of Comedy (2269) and Drama (2901) genres, and the least of Western (44) and War (149)

create table #countries_table(
countries varchar (255))

insert into  #countries_table
select value as production_countries
from titles
cross apply string_split(production_countries, ',')

update #countries_table
set countries = ltrim(countries)
where countries like ' %'

select distinct(countries)
from #countries_table
where countries! = 'NA' -- 107 countries

select countries, count(countries) as num_of_contents
from #countries_table
where countries != 'NA'
group by countries
order by num_of_contents -- USA (2327) and India (629) have the highest contents, 24 countries have only 1 content

select count(production_countries)
from titles
where production_countries like '%US%' and type = 'Movie' -- USA produced 1533 movies and the rest (794) are shows

select count(production_countries)
from titles
where production_countries like '%IN%' and type = 'Movie' -- India 585 Movies, 44 shows

select avg(imdb_score)
from titles
where genres like '%comedy%' and imdb_score != 0 and 

create table #temp_table_genre_score(
genre varchar (255),
score float)

insert into  #temp_table_genre_score
select value as genres, imdb_score
from titles
cross apply string_split(genres, ',')

select *
from  #temp_table_genre_score

update  #temp_table_genre_score
set genre = ltrim(genre)
where genre like ' %'

update #temp_table_genre_score
set score = convert(numeric(10, 1), score)

select genre, convert(numeric(10,1), avg(score)) as avg_imdb_score
from  #temp_table_genre_score
where score != 0 and genre != 'Not Provided'
group by genre
order by avg_imdb_score -- War (7.1) and History (7.1) genres have the highest imadb rating while Horror (6.0) and Family (6.3) genres have the lowest

select top 10 *
from titles
where imdb_votes > 10000 and type = 'Movie'
order by imdb_score desc

select top 10 *
from titles
where imdb_votes > 10000 and imdb_score != 0 and type = 'Movie'
order by imdb_score

select top 10 *
from titles
where imdb_votes > 5000 and type = 'Show'
order by imdb_score desc

select top 10 *
from titles
where imdb_votes > 5000 and imdb_score != 0 and type = 'Show'
order by imdb_score

select title, imdb_score, number_of_seasons, imdb_votes
from titles
where type = 'Show' and number_of_seasons != 0 and imdb_score != 0 and imdb_votes >= 5000
order by imdb_score desc

select convert(numeric(10,1), avg(imdb_score)), count(title)
from titles
where number_of_seasons > 1 and number_of_seasons < 6 and imdb_score != 0 and imdb_votes >= 5000 -- Shows (292) with seasons between 2 and 5 have an average rating of 7.6. Shows with one season were discarded in this query as they are considered as miniseries

select convert(numeric(10,1), avg(imdb_score)), count(title)
from titles
where number_of_seasons > 5 and imdb_score != 0 and imdb_votes >= 5000 -- Shows (66) with more than 5 seasons have an average rating of 7.8.

select *
from credits

select movie_id, count(movie_id)
from credits
group by movie_id
order by count(movie_id) desc -- Highest credits: La Miserable (416), The irishman(348), Hairspray(300)

select title
from titles
where id = 'tm84613'

select name, count(name)
from credits
group by name
order by count(name) desc -- Shah Rukh Khan, Boman Irani, Anupam Kher, Kareena Kapoor Khan, Takahiro Sakurai are the most appeared names on Netflix

create table #temp_desc(
content_desc varchar (8000))

insert into #temp_desc
select value as description
from titles
cross apply string_split(description, ' ')

select content_desc, count(content_desc)
from #temp_desc
where content_desc is not null and content_desc != 'NA'
group by content_desc
having count(content_desc) > 29
order by count(content_desc) desc





