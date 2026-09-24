-- 2_exploration.sql

-- số lượng game theo rating count
SELECT
  CASE
    WHEN User_Rating_Count IS NULL THEN '0. no rating'
    WHEN User_Rating_Count < 100   THEN '1. 5-99'
    WHEN User_Rating_Count < 1000  THEN '2. 100-999'
    ELSE '3. 1000+'
  END as rating_count_group,
  COUNT(*) as games,
  ROUND(AVG(Average_User_Rating), 2) as avg_rating_group
FROM `game_analytics.strategy_games`
GROUP BY rating_count_group
ORDER BY rating_count_group;


-- Phân bố game theo avg rating (1-5)
SELECT
  Average_User_Rating,
  COUNT(*) as games
FROM `game_analytics.strategy_games`
WHERE Average_User_Rating IS NOT NULL
GROUP BY Average_User_Rating
ORDER BY Average_User_Rating;


-- mỗi game hỗ trợ bao nhiêu ngôn ngữ?
SELECT
  ARRAY_LENGTH(SPLIT(Languages, ', ')) as n_languages,
  COUNT(*) as games
FROM `game_analytics.strategy_games`
GROUP BY n_languages
ORDER BY n_languages;


-- thể loại phổ biến nhất
SELECT
  genre,
  COUNT(*) AS games
FROM `game_analytics.strategy_games`,
UNNEST(SPLIT(Genres, ', ')) AS genre
WHERE genre NOT IN ('Games', 'Strategy')
GROUP BY genre
ORDER BY games DESC
LIMIT 15;


-- free game có nhiều rating count nhất
SELECT DISTINCT Name, User_Rating_Count, Average_User_Rating
FROM `game_analytics.strategy_games`
WHERE Price = 0
ORDER BY User_Rating_Count DESC
LIMIT 10;


-- paid game có nhiều rating count nhất
SELECT DISTINCT Name, Price, User_Rating_Count, Average_User_Rating
FROM `game_analytics.strategy_games`
WHERE Price > 0
ORDER BY User_Rating_Count DESC
LIMIT 10;


-- mức price phổ biến của paid game
SELECT
  Price,
  COUNT(*) AS games
FROM `game_analytics.strategy_games`
WHERE Price > 0
GROUP BY Price
ORDER BY games DESC
LIMIT 10;


-- top 10 developers có nhiều game nhất
SELECT
  Developer,
  COUNT(*)                AS games,
  SUM(User_Rating_Count)  AS total_ratings
FROM `game_analytics.strategy_games`
GROUP BY Developer
ORDER BY games DESC
LIMIT 10;


-- mỗi năm có bao nhiêu game phát hành
SELECT
  EXTRACT(YEAR FROM Original_Release_Date) AS release_year,
  COUNT(*) AS games
FROM `game_analytics.strategy_games`
GROUP BY release_year
ORDER BY release_year;


-- số lượng game updated/not updated
SELECT
  CASE
    WHEN Current_Version_Release_Date = Original_Release_Date THEN 'never updated'
    WHEN Current_Version_Release_Date >= '2019-02-03' THEN 'within 6 months'
    WHEN Current_Version_Release_Date >= '2018-08-03' THEN '6-12 months'
    WHEN Current_Version_Release_Date >= '2017-08-03' THEN '1-2 years'
    ELSE 'over 2 years'
  END as last_update,
  COUNT(*) as games
FROM `game_analytics.strategy_games`
GROUP BY last_update
ORDER BY last_update;