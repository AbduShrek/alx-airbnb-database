## Table Partitioning (Bookings)

- Implemented **RANGE partitioning** on `bookings` by `start_date` into yearly partitions (2024, 2025 + default).
- Added indexes per partition on `(guest_id)`, `(property_id)`, `(start_date)`.
- Tested with `EXPLAIN ANALYZE` on date-range and join queries to confirm **partition pruning** and fewer scanned rows.

**Observed (example):**
- Range query: planner prunes to 1 partition; total cost/time reduced.
- Joins on partitioned subset: fewer rows scanned; improved latency.
