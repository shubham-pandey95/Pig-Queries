/*List of all the Episodes of FRIENDS season-wise*/

episode= LOAD '/home/cloudera/Desktop/imdb data/title_episode.tsv' using PigStorage('\t') AS (tconst:chararray, parentTconst:chararray,seasonNumber:int,episodeNumber:int);
title=  LOAD '/home/cloudera/Desktop/imdb data/title_basics.tsv' using PigStorage('\t') AS (tconst:chararray,titleType:chararray,primaryTitle:chararray,originalTitle:chararray,isAdult:int,startYear:int,endYear:int,runtimeMinutes:double,genres:chararray);

filterEpisode = FILTER episode BY parentTconst=='tt0108778';
episodeTitle = JOIN filterEpisode by tconst, title by tconst;
episodeTitle = FOREACH episodeTitle GENERATE title::tconst, seasonNumber, episodeNumber, originalTitle, startYear, endYear;
episodeTitle = ORDER episodeTitle by seasonNumber ASC, episodeNumber ASC;
STORE episodeTitle INTO '/home/cloudera/Desktop/Pig_HW/Query6';
