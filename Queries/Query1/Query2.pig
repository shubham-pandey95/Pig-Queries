/*Top 10 Comedy Movies*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS(tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:boolean,startYear:chararray,endYear:chararray,runtimeMinutes:int,genres:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);
genre_table = FOREACH title GENERATE tconst, FLATTEN(TOKENIZE(genres,',')) as genre:chararray;
--name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
comedy = FILTER genre_table by genre=='Comedy';
title= FILTER title by titleType=='movie';
comedyTitle = JOIN comedy by tconst, title by tconst;
titleRating= JOIN comedyTitle by title::tconst, ratings by tconst;
descRating= ORDER titleRating BY averageRating DESC;
descRating= LIMIT descRating 10;
descRating = FOREACH descRating GENERATE comedyTitle::title::tconst, comedyTitle::title::titleType, ratings::averageRating, comedyTitle::comedy::genre,  comedyTitle::title::primaryTitle;
STORE descRating INTO '/home/cloudera/Desktop/Pig_HW/Query2';

