SELECT b.id AS booking_id, b.check_in, b.check_out, u.id AS user_id, u.full_name, u.email
FROM bookings b
INNER JOIN users u ON b.guest_id = u.id;



SELECT p.id AS property_id, p.title, r.id AS review_id, r.rating, r.comment
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id;



SELECT u.id AS user_id, u.full_name, b.id AS booking_id, b.check_in, b.check_out
FROM users u
FULL OUTER JOIN bookings b ON u.id = b.guest_id;
