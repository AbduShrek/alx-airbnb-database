## SQL Joins

- **INNER JOIN:** Retrieve all bookings with their respective users.  
- **LEFT JOIN:** Retrieve all properties with their reviews, including those without reviews.  
- **FULL OUTER JOIN:** Retrieve all users and all bookings, even if some are unmatched.  



## SQL Subqueries

- **Non-Correlated Subquery:** Find properties with average rating > 4.0.  
- **Correlated Subquery:** Find users with more than 3 bookings.  

👉 Queries are available in [`subqueries.sql`](.database-adv-script
/subqueries.sql).



## SQL Aggregation & Window Functions

- **Aggregation:** Count total bookings made by each user.  
- **Window Function:** Rank properties by number of bookings using RANK().  

👉 Queries are available in [`aggregations_and_window_functions.sql`](.database-adv-script/aggregations_and_window_functions.sql).
