-- Initial (naive) query: joins everything and returns duplicate rows when a booking has multiple payments
SELECT
  b.*,                      -- pulls all booking columns (heavier than needed)
  u.full_name, u.email,
  p.title, p.price_per_night,
  pay.id  AS payment_id, pay.status AS payment_status, pay.amount, pay.created_at AS payment_created_at
FROM bookings   b
JOIN users      u   ON u.id = b.guest_id
JOIN properties p   ON p.id = b.property_id
LEFT JOIN payments  pay ON pay.booking_id = b.id;

-- Analyze performance (run both before and after refactor)
EXPLAIN ANALYZE
SELECT
  b.*,
  u.full_name, u.email,
  p.title, p.price_per_night,
  pay.id, pay.status, pay.amount, pay.created_at
FROM bookings b
JOIN users u      ON u.id = b.guest_id
JOIN properties p ON p.id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.id;

-- Refactor 1: select only needed columns + avoid row blow-up from multiple payments
-- Pick the latest payment per booking using DISTINCT ON (PostgreSQL)
WITH latest_payment AS (
  SELECT DISTINCT ON (booking_id)
         id, booking_id, status, amount, created_at
  FROM payments
  ORDER BY booking_id, created_at DESC
)
SELECT
  b.id            AS booking_id,
  b.check_in, b.check_out, b.status AS booking_status,
  u.id            AS user_id, u.full_name, u.email,
  p.id            AS property_id, p.title, p.price_per_night,
  lp.id           AS payment_id, lp.status AS payment_status, lp.amount, lp.created_at AS payment_created_at
FROM bookings b
JOIN users u           ON u.id = b.guest_id
JOIN properties p      ON p.id = b.property_id
LEFT JOIN latest_payment lp ON lp.booking_id = b.id
ORDER BY b.created_at DESC;

-- (Optional) Refactor 2: if you frequently filter by recent bookings, pre-filter to shrink work
-- WITH recent_bookings AS (
--   SELECT * FROM bookings WHERE created_at >= NOW() - INTERVAL '90 days'
-- )
-- SELECT ... FROM recent_bookings rb ...
