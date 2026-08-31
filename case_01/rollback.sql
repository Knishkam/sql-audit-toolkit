ALTER TABLE orders ALTER INDEX idx_status VISIBLE;
DROP INDEX idx_user_status_created ON orders;
ANALYZE TABLE orders;
