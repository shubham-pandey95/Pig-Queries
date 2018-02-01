/*Top 15 artist of most voted Adult movies*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
principals= LOAD '/home/cloudera/Desktop/imdb data/title_principals.tsv' using PigStorage('\t') AS (tconst:chararray,principalCast:chararray);
name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
ratings= LOAD '/home/cloudera/Desktop/imdb data/title_ratings.tsv' using PigStorage('\t') AS (tconst:chararray, averageRating:double,numVotes:int);

principalFinal = FOREACH principals GENERATE tconst, FLATTEN(TOKENIZE(principalCast,',')) as principalCast:chararray;
adultTitle = FILTER title by isAdult==1;
principalAdult = JOIN adultTitle by tconst, principalFinal by tconst;
principalAdult= JOIN principalAdult by adultTitle::tconst, ratings by tconst;
principalAdult = FOREACH principalAdult GENERATE adultTitle::tconst, primaryTitle,startYear,endYear,principalCast, ratings::numVotes;
namePrincipalAdult = JOIN name by nconst, principalAdult by principalCast;
namePrincipalAdult = FOREACH namePrincipalAdult GENERATE adultTitle::tconst, adultTitle::primaryTitle, adultTitle::startYear, adultTitle::endYear, ratings::numVotes;
namePrincipalAdult= ORDER namePrincipalAdult by numVotes DESC;
namePrincipalAdult= limit namePrincipalAdult 15;
STORE namePrincipalAdult INTO '/home/cloudera/Desktop/Pig_HW/Query3';
