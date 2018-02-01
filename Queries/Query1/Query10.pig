
/*Top 10 rated movies of Christopher Nolan*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);
crew = LOAD '/home/cloudera/Desktop/imdb data/title_crew.tsv' using PigStorage('\t') AS (tconst:chararray, directors:chararray, writers:chararray);
directorsFile = FOREACH  crew generate tconst, FLATTEN(TOKENIZE(directors,',')) as directors:chararray;
name = FOREACH name GENERATE nconst,primaryName,birthYear,deathYear;

titleRating=  JOIN title by tconst, ratings by tconst;
tempA = FILTER name by primaryName=='Christopher Nolan';
tempB = JOIN tempA by nconst, directorsFile by directors;
tempC = JOIN tempB by directorsFile::tconst, titleRating by title::tconst;

tempC = FOREACH tempC GENERATE directorsFile::tconst, titleRating::title::primaryTitle, titleRating::title::runtimeMinutes, titleRating::ratings::averageRating;
tempC = ORDER tempC BY averageRating DESC;
topTen= LIMIT tempC 10;
STORE topTen INTO '/home/cloudera/Desktop/Pig_HW/Query10';
