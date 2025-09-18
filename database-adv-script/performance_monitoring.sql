-- Enable pg_stat_statements (one-time, requires superuser; else skip)
-- CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 1) Inspect top slow/most-called queries
-- SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 20;

-- 2) Frequently-used queries: measure plans & timing
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT COUNT(*) FROM bookings b WHERE b.guest_id = $1 AND b.start_date >= CURRENT_DATE - INTERVAL '180 days';

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT p.id, p.title, COUNT(b.id) AS booking_count
FROM properties p
LEFT JOIN bookings b ON b.property_id = p.id
GROUP BY p.id, p.title
ORDER BY booking_count DESC
LIMIT 50;

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT b.id, u.full_name, pr.title, pay.status
FROM bookings b
JOIN users u   ON u.id = b.guest_id
JOIN properties pr ON pr.id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.id
WHERE b.status = 'confirmed' AND pr.price_per_night > 50
ORDER BY b.start_date DESC
LIMIT 100;

-- 3) Keep stats fresh (run after large data changes)
ANALYZE bookings;
ANALYZE properties;
ANALYZE users;
ANALYZE payments;
