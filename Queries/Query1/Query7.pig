/*Movies starring Tom Hanks*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);
principals= LOAD '/home/cloudera/Desktop/imdb data/title_principals.tsv' using PigStorage('\t') AS (tconst:chararray,principalCast:chararray);
principalFinal = FOREACH principals GENERATE tconst, FLATTEN(TOKENIZE(principalCast,',')) as principalCast:chararray;

name = FOREACH name GENERATE nconst,primaryName,birthYear,deathYear;

tempA = FILTER name by primaryName=='Tom Hanks';
tempB = JOIN tempA by nconst, principalFinal by principalCast;
tempC = JOIN tempB by principalFinal::tconst, title by tconst;
tempC = FOREACH tempC GENERATE principalFinal::tconst, primaryTitle, titleType, startYear;
STORE tempC INTO '/home/cloudera/Desktop/Pig_HW/Query7';

