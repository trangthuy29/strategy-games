-- 3_prepare.sql


-- tạo bảng game_base với dòng bị trùng, đặt null=0
CREATE OR REPLACE TABLE `game_analytics.games_base` AS
SELECT DISTINCT
  ID,
  Name,
  Developer,
  IFNULL(Price, 0) as price,
  IFNULL(User_Rating_Count, 0) as rating_count,
  Average_User_Rating as avg_rating,
  In_app_Purchases IS NOT NULL as have_iap,
  ARRAY_LENGTH(SPLIT(Languages, ', ')) as n_languages,
  Genres,
  EXTRACT(YEAR FROM Original_Release_Date) as release_year,
  CASE
    WHEN Price > 0                    THEN 'paid'
    WHEN In_app_Purchases IS NOT NULL THEN 'free_iap'
    ELSE 'free_no_iap'
  END as model --kiểu kiếm tiền
FROM `game_analytics.strategy_games`;


-- xác định p90_threhold
SELECT APPROX_QUANTILES(rating_count, 100)[OFFSET(90)] as p90_threhold
FROM `game_analytics.games_base`;


-- tạo bảng games_clean, p90_threhold=405
CREATE OR REPLACE TABLE `game_analytics.games_clean` AS
SELECT
  *,
  CASE
    WHEN rating_count = 0 THEN 'no_rating'
    WHEN rating_count >= 405 THEN 'top_10pct'
    ELSE 'rated'
  END AS tier
FROM `game_analytics.games_base`;

SELECT * FROM game_analytics.games_clean;