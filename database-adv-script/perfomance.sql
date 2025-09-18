-- Initial (naive) query: retrieves all bookings with joins
-- Adds a WHERE with AND to simulate a common filter
SELECT
  b.*,
  u.full_name, u.email,
  p.title, p.price_per_night,
  pay.id  AS payment_id, pay.status AS payment_status, pay.amount, pay.created_at AS payment_created_at
FROM bookings   b
JOIN users      u   ON u.id = b.guest_id
JOIN properties p   ON p.id = b.property_id
LEFT JOIN payments  pay ON pay.booking_id = b.id
WHERE b.status = 'confirmed'
  AND p.price_per_night > 50;

-- Analyze performance (before/after refactor)
EXPLAIN ANALYZE
SELECT
  b.*,
  u.full_name, u.email,
  p.title, p.price_per_night,
  pay.id, pay.status, pay.amount, pay.created_at
FROM bookings b
JOIN users u      ON u.id = b.guest_id
JOIN properties p ON p.id = b.property_id
LEFT JOIN payments pay ON pay.booking_id = b.id
WHERE b.status = 'confirmed'
  AND p.price_per_night > 50;

-- Refactored query: trim columns + get latest payment only
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
WHERE b.status = 'confirmed'
  AND p.price_per_night > 50
ORDER BY b.created_at DESC;
