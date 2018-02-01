/*Top 20 movies of 2015*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);

tempA = FILTER title by titleType=='movie' and startYear==2015;
tempB = JOIN tempA by tconst, ratings by tconst;
tempB = ORDER tempB BY averageRating DESC;
tempB = LIMIT tempB 20;
tempB = FOREACH tempB GENERATE tempA::tconst, tempA::titleType, ratings::averageRating, tempA::originalTitle;
STORE tempB INTO '/home/cloudera/Desktop/Pig_HW/Query8';

