-- BEFORE: OFFSET pagination
SELECT id,user_id,status,created_at
FROM orders
WHERE status='paid'
ORDER BY created_at DESC, id DESC
LIMIT 50 OFFSET 50000;

-- AFTER: Keyset pagination (cursor from cursor.txt)
SELECT id,user_id,status,created_at
FROM orders
WHERE status='paid'
  AND (created_at < '2026-01-02 09:52:30.000000'
       OR (created_at='2026-01-02 09:52:30.000000' AND id < 121950))
ORDER BY created_at DESC, id DESC
LIMIT 50;