
/*Movies whose cast was either born before 1900 or died after 2015 and has a rating of 6*/

name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);
principals= LOAD '/home/cloudera/Desktop/imdb data/title_principals.tsv' using PigStorage('\t') AS (tconst:chararray,principalCast:chararray);
title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
principalFinal= FOREACH principals GENERATE tconst, FLATTEN(TOKENIZE(principalCast,',')) as principalCast:chararray;

principalTitle= JOIN name by nconst, principalFinal by principalCast;
titleRating= JOIN ratings by tconst, title by tconst;
finalJoin = JOIN principalTitle by tconst, titleRating by ratings::tconst;
finalConst= FOREACH finalJoin GENERATE principalTitle::principalFinal::tconst, titleRating::title::originalTitle, titleRating::ratings::averageRating, principalTitle::name::deathYear, principalTitle::name::birthYear;
finalConst= Filter finalConst by (birthYear<1900) OR (deathYear>2015);
finalConst= Filter finalConst by averageRating==6;
finalConst= ORDER finalConst by originalTitle DESC;
limitedFinal= LIMIT finalConst 10;
STORE limitedFinal INTO '/home/cloudera/Desktop/Pig_HW/Query9';
