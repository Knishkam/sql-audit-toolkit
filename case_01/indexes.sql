-- Apply optimization (fix)
CREATE INDEX idx_user_status_created ON orders(user_id, status, created_at);

-- Make baseline index invisible so the optimizer chooses the composite index (safe validation technique)
ALTER TABLE orders ALTER INDEX idx_status INVISIBLE;

ANALYZE TABLE orders;
