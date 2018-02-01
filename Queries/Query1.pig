/*Movies details of 2 directors*/

title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);
crew = LOAD '/home/cloudera/Desktop/imdb data/title_crew.tsv' using PigStorage('\t') AS (tconst:chararray, directors:chararray, writers:chararray);
name= LOAD '/home/cloudera/Desktop/imdb data/name_basics.tsv' using PigStorage('\t') AS (nconst:chararray, primaryName:chararray,birthYear:int,deathYear:int,primaryProfession:chararray,knownForTitles:chararray);
crewLimited = LIMIT crew 3;
titleCrew = JOIN crewLimited by tconst, title by tconst;
titleCrewFlat= FOREACH titleCrew GENERATE *,flatten(TOKENIZE(crewLimited::directors)) AS directors, flatten(TOKENIZE(crewLimited::writers)) AS writers;
titleCrewOutput= JOIN titleCrewFlat BY directors, name by nconst;
titleCrewOutput= FOREACH titleCrewOutput GENERATE titleCrewFlat::title::originalTitle, titleCrewFlat::title::startYear, titleCrewFlat::title::runtimeMinutes, name::primaryName, name::birthYear, name::deathYear, name::primaryProfession;
STORE titleCrewOutput INTO '/home/cloudera/Desktop/Pig_HW/Query1';
