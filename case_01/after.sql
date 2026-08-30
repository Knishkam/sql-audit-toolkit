EXPLAIN
SELECT id, user_id, status, created_at, total_amount
FROM orders
WHERE user_id = 1234 AND status = 'paid'
ORDER BY created_at DESC
LIMIT 50;

-- Rollback:
-- DROP INDEX idx_user_status_created ON orders;
