SELECT u.id, u.full_name, COUNT(b.id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.id = b.guest_id
GROUP BY u.id, u.full_name
ORDER BY total_bookings DESC;



SELECT p.id, p.title, COUNT(b.id) AS booking_count,
       RANK() OVER (ORDER BY COUNT(b.id) DESC) AS property_rank
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.title
ORDER BY property_rank;
