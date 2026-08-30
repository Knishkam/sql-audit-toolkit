SET SESSION cte_max_recursion_depth = 250000;

WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 200000
)
INSERT INTO orders (user_id, status, created_at, total_amount, notes)
SELECT
  (n % 5000) + 1 AS user_id,
  CASE
    WHEN n % 10 = 0 THEN 'cancelled'
    WHEN n % 5 = 0 THEN 'pending'
    ELSE 'paid'
  END AS status,
  NOW() - INTERVAL (n % 365) DAY AS created_at,
  (n % 10000) / 10.0 AS total_amount,
  CONCAT('note-', n)
FROM seq;
