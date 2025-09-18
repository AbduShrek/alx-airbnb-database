-- USERS
-- Lookups by email (login), role filters, join on id
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users (role);

-- BOOKINGS
-- Frequent joins & filters
CREATE INDEX IF NOT EXISTS idx_bookings_guest_id ON bookings (guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings (property_id);
-- Common range/sort queries
CREATE INDEX IF NOT EXISTS idx_bookings_checkin ON bookings (check_in);
-- Helpful composite for guest history by time
CREATE INDEX IF NOT EXISTS idx_bookings_guest_created_at ON bookings (guest_id, created_at);

-- PROPERTIES
-- Join to host, price sorting/filtering, geo/city filters (adjust to your schema)
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties (host_id);
CREATE INDEX IF NOT EXISTS idx_properties_price ON properties (price_per_night);
-- If you have a city/location column, keep it indexed
-- CREATE INDEX IF NOT EXISTS idx_properties_city ON properties (city);

-- REVIEWS (optional but common)
-- Fetch reviews per property quickly
CREATE INDEX IF NOT EXISTS idx_reviews_property_id ON reviews (property_id);



-- 1) Bookings per user (should use idx_bookings_guest_id)
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM bookings b
WHERE b.guest_id = '<<some-user-uuid>>';

-- 2) Join bookings → users (should use idx_bookings_guest_id)
EXPLAIN ANALYZE
SELECT b.id, u.full_name
FROM bookings b
JOIN users u ON u.id = b.guest_id
WHERE b.check_in >= CURRENT_DATE - INTERVAL '90 days';

-- 3) Properties ordered by price (should use idx_properties_price)
EXPLAIN ANALYZE
SELECT p.id, p.title, p.price_per_night
FROM properties p
ORDER BY p.price_per_night
LIMIT 50;

-- 4) Reviews per property (should use idx_reviews_property_id)
EXPLAIN ANALYZE
SELECT r.*
FROM reviews r
WHERE r.property_id = '<<some-property-uuid>>';
