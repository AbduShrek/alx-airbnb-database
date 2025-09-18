## Query Performance Refactor
- Initial query joined users, properties, and payments, causing duplicates when multiple payments exist and fetching unnecessary columns.
- Refactor uses a CTE (`latest_payment`) with `DISTINCT ON (booking_id)` to pick the most recent payment and selects only required columns.
- Measure with `EXPLAIN ANALYZE` before/after; expect fewer rows scanned/returned and better plan (fewer joins/less width).
