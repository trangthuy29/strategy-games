-- 1_data_quality.sql

-- check duplicate rows
SELECT
  COUNT(*) as total_rows,
  COUNT(DISTINCT ID) as distinct_ids,
  COUNT(*) - COUNT(DISTINCT ID) as duplicate_rows
FROM `game_analytics.strategy_games`;


-- số game không có rating count
SELECT
  COUNTIF(User_Rating_Count IS NULL) as missing_rating_count,
  ROUND(100 * COUNTIF(User_Rating_Count IS NULL) / COUNT(*), 1) as pct_missing_rating_count
FROM `game_analytics.strategy_games`;


-- bao nhiêu game miễn phí và game trả tiền
SELECT
  COUNTIF(Price IS NULL) as missing_price,
  COUNTIF(Price = 0) as free_games,
  COUNTIF(Price > 0) as non_free_games,
  ROUND(100 * COUNTIF(Price = 0) / COUNT(*), 1) as pct_free,
  ROUND(100 * COUNTIF(Price > 0) / COUNT(*), 1) as pct_not_free
FROM `game_analytics.strategy_games`;


-- tìm game có ngày cập nhật sớm hơn ngày phát hành
-- 03/08/2019: ngày cuối trong dataset
SELECT
  MIN(Original_Release_Date) as earliest_release,
  MAX(Original_Release_Date) as latest_release,
  COUNTIF(Original_Release_Date > '2019-08-03') as released_after_snapshot,
  COUNTIF(Current_Version_Release_Date < Original_Release_Date) as updated_before_release
FROM `game_analytics.strategy_games`;


-- bao nhiêu game có mua hàng trong game-iap
SELECT
  COUNTIF(In_app_Purchases IS NOT NULL)                            AS games_with_iap,
  ROUND(100 * COUNTIF(In_app_Purchases IS NOT NULL) / COUNT(*), 1) AS pct_with_iap
FROM `game_analytics.strategy_games`;