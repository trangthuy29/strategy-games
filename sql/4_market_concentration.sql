-- 4_market_concentration.sql


-- tỷ lệ games và rating count dựa theo tier
SELECT
  tier,
  COUNT(*) as games,
  SUM(rating_count) as ratings,
  ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM `game_analytics.games_clean`), 1) as pct_games,
  ROUND(100 * SUM(rating_count)
        / (SELECT SUM(rating_count) FROM `game_analytics.games_clean`), 1) as pct_ratings
FROM `game_analytics.games_clean`
GROUP BY tier
ORDER BY tier;


-- game nhiều rating count nhất chiếm tỷ lệ bao nhiêu
SELECT
  Name,
  model,
  rating_count,
  ROUND(100 * rating_count
        / (SELECT SUM(rating_count) FROM `game_analytics.games_clean`), 1) as pct_all_ratings
FROM `game_analytics.games_clean`
ORDER BY rating_count DESC
LIMIT 10;


-- số game phát hành theo năm và số game trong đó lọt nhóm top 10%
SELECT
  release_year,
  COUNT(*) as games,
  COUNTIF(tier = 'top_10pct') as top_games,
  ROUND(100 * COUNTIF(tier = 'top_10pct') / COUNT(*), 1) as hit_rate
FROM `game_analytics.games_clean`
GROUP BY release_year
ORDER BY release_year;

-- số game và hit rate của từng sub-genre
SELECT
  genre,
  COUNT(*) as games,
  COUNTIF(tier = 'top_10pct') as top_games,
  ROUND(100 * COUNTIF(tier = 'top_10pct')/COUNT(*), 1) as hit_rate,
FROM `game_analytics.games_clean`,
UNNEST(SPLIT(Genres, ', ')) AS genre
WHERE genre NOT IN ('Games', 'Strategy')
GROUP BY genre
HAVING COUNT(*) >= 100
ORDER BY hit_rate DESC;

-- Top 10 nhà phát triển chiếm bao nhiêu % tổng rating count
SELECT
  Developer,
  COUNT(*) as games,
  SUM(rating_count) as ratings,
  ROUND(100 * SUM(rating_count)
        / (SELECT SUM(rating_count) FROM `game_analytics.games_clean`), 1) as pct_all_ratings
FROM `game_analytics.games_clean`
GROUP BY Developer
ORDER BY ratings DESC
LIMIT 10;