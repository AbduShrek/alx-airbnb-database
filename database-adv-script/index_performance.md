## Database Indexing

Created indexes on high-usage columns to speed up WHERE/JOIN/ORDER BY:
- Users: (email), (role)
- Bookings: (guest_id), (property_id), (check_in), (guest_id, created_at)
- Properties: (host_id), (price_per_night)
- Reviews: (property_id)

Performance check: run `EXPLAIN ANALYZE` on key queries before/after to confirm index usage and lower execution time. See `database_index.sql`.
