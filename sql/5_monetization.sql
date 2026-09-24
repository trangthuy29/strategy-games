-- 5_monetization.sql

-- model chiếm bao nhiêu % trong nhóm top 10%
SELECT
  model,
  COUNT(*) as games,
  ROUND(100 * COUNT(*)
        / (SELECT COUNT(*) FROM `game_analytics.games_clean`), 1) as pct_games,
  COUNTIF(tier = 'top_10pct') as top_games,
  ROUND(100 * COUNTIF(tier = 'top_10pct')
        / (SELECT COUNTIF(tier = 'top_10pct') 
           FROM `game_analytics.games_clean`), 1) as pct_of_top10,
  ROUND(100 * COUNTIF(tier = 'top_10pct') / COUNT(*), 1) as hit_rate,
  ROUND(100 * COUNTIF(tier = 'no_rating') / COUNT(*), 1) as pct_no_rating
FROM `game_analytics.games_clean`
GROUP BY model
ORDER BY hit_rate DESC;


-- mỗi model chiếm bao nhiêu % tổng rating count
SELECT
  model,
  SUM(rating_count) as ratings,
  ROUND(100 * SUM(rating_count)
        / (SELECT SUM(rating_count) FROM `game_analytics.games_clean`), 1) as pct_ratings,
  ROUND(AVG(avg_rating), 2) as avg_rating_in_model
FROM `game_analytics.games_clean`
GROUP BY model
ORDER BY ratings DESC;


-- số game trả phí vẫn có IAP
SELECT
  COUNT(*) as paid_games,
  COUNTIF(have_iap) as paid_with_iap,
  ROUND(100 * COUNTIF(have_iap) / COUNT(*), 1) as pct_paid_with_iap
FROM `game_analytics.games_clean`
WHERE model = 'paid';