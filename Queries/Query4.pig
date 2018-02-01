/*First 50 movies of 1952 having rating less than 5.00*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);

titleYear = FILTER title by startYear==1952 and titleType=='movie';
titleRating = JOIN titleYear by tconst, ratings by tconst;
titleRatingUpdated = FILTER titleRating BY averageRating<5.00;
titleRatingUpdated= FOREACH titleRatingUpdated GENERATE titleYear::tconst,  titleYear::titleType, ratings::averageRating, titleYear::originalTitle;
titleRatingLimited= LIMIT titleRatingUpdated 50;
STORE titleRatingLimited INTO '/home/cloudera/Desktop/Pig_HW/Query4';


