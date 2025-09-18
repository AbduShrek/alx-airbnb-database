-- NOTE: If your column is named `check_in`, replace `start_date` below with `check_in`.

-- 1) Create a partitioned bookings table by RANGE on start_date
CREATE TABLE IF NOT EXISTS bookings_p (
  id UUID PRIMARY KEY,
  property_id UUID NOT NULL,
  guest_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date   DATE NOT NULL,
  status     TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (start_date);

-- 2) Yearly partitions (adjust ranges to your data horizon)
CREATE TABLE IF NOT EXISTS bookings_2024 PARTITION OF bookings_p
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE IF NOT EXISTS bookings_2025 PARTITION OF bookings_p
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Optional default partition to catch out-of-range data
CREATE TABLE IF NOT EXISTS bookings_default PARTITION OF bookings_p
  DEFAULT;

-- 3) Helpful indexes (created on each partition)
CREATE INDEX IF NOT EXISTS idx_bookings_2024_guest ON bookings_2024 (guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_2025_guest ON bookings_2025 (guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_def_guest  ON bookings_default (guest_id);

CREATE INDEX IF NOT EXISTS idx_bookings_2024_prop  ON bookings_2024 (property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_2025_prop  ON bookings_2025 (property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_def_prop   ON bookings_default (property_id);

CREATE INDEX IF NOT EXISTS idx_bookings_2024_start ON bookings_2024 (start_date);
CREATE INDEX IF NOT EXISTS idx_bookings_2025_start ON bookings_2025 (start_date);
CREATE INDEX IF NOT EXISTS idx_bookings_def_start  ON bookings_default (start_date);

-- 4) (If migrating) Move data from existing table `bookings` → `bookings_p`
--    Run this only once, then swap names if desired.
-- INSERT INTO bookings_p (id, property_id, guest_id, start_date, end_date, status, created_at)
-- SELECT id, property_id, guest_id, start_date, end_date, status, created_at
-- FROM bookings;

-- 5) Sample queries to evaluate pruning and performance
-- BEFORE/AFTER compare with EXPLAIN ANALYZE:

-- Range query (should prune to a single partition)
EXPLAIN ANALYZE
SELECT id, property_id, guest_id, start_date, status
FROM bookings_p
WHERE start_date >= DATE '2025-06-01'
  AND start_date <  DATE '2025-07-01';

-- Join query (still benefits from pruning + indexes)
EXPLAIN ANALYZE
SELECT b.id, u.full_name, p.title
FROM bookings_p b
JOIN users u      ON u.id = b.guest_id
JOIN properties p ON p.id = b.property_id
WHERE b.start_date BETWEEN DATE '2025-01-01' AND DATE '2025-12-31';

-- Guest history in a period
EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM bookings_p 
WHERE guest_id = '00000000-0000-0000-0000-000000000000'
  AND start_date >= CURRENT_DATE - INTERVAL '180 days';
