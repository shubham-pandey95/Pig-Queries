/*Movies having 5 primary cast members born before 1950*/

principals= LOAD '/home/cloudera/Desktop/imdb data/title_principals.tsv' using PigStorage('\t') AS (tconst:chararray,principalCast:chararray);
name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
principalFinal = FOREACH principals GENERATE tconst, FLATTEN(TOKENIZE(principalCast,',')) as principalCast:chararray;
principalBirth = FILTER name BY birthYear<1950;
principalBirth=  JOIN principalFinal by principalCast, principalBirth by nconst; 
principalGroup = GROUP principalBirth BY tconst;
principalGroup = FOREACH principalGroup GENERATE group as tconst, COUNT(principalBirth) as cnt:long;
principalGroup = FILTER principalGroup by cnt>5;
principalBirth = JOIN principalGroup by tconst, title by tconst;
principalBirth = FOREACH principalBirth GENERATE principalGroup::tconst, primaryTitle, titleType, cnt;
principalBirth = ORDER principalBirth by cnt ASC;
STORE principalBirth INTO '/home/cloudera/Desktop/Pig_HW/Query5';
