# Case_02 — OFFSET → Keyset Pagination (MySQL)

## BEFORE (OFFSET)
key: idx_status
Extra: Using index condition; Using filesort

## AFTER-1 (Composite index)
key: idx_status_created_id
Extra: Using where; Backward index scan

## Cursor used for keyset
created_at: 2026-01-02 09:52:30.000000
id: 121950

## AFTER-2 (Keyset)
key: idx_status_created_id
Extra: Using index condition; Backward index scan

## Rollback
DROP INDEX idx_status_created_id ON orders;