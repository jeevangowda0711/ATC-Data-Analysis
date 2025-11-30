SHOW DATABASES;
USE sakila;

# 1. Total revenue by store
SELECT 
    s.store_id,
    CONCAT(ci.city, ', ', co.country) AS store_location,
    SUM(p.amount) AS total_revenue,
    COUNT(p.payment_id) AS total_transactions
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY s.store_id, store_location
ORDER BY total_revenue DESC;

# 2. Average order value (AOV) by customer segment
# (We’ll segment customers into Bronze / Silver / Gold based on total spend)
WITH customer_spend AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_spent,
        COUNT(p.payment_id) AS transaction_count,
        CASE 
            WHEN SUM(p.amount) >= 150 THEN 'Gold'
            WHEN SUM(p.amount) >= 100 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_segment
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT 
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(total_spent), 2) AS avg_total_spent,
    ROUND(AVG(total_spent / transaction_count), 2) AS avg_order_value
FROM customer_spend
GROUP BY customer_segment
ORDER BY avg_order_value DESC;

# 3. Top 10 films by profit margin
# (Profit margin = (rental_rate - replacement_cost) is not meaningful → better:
# Revenue generated vs replacement cost → Return on Inventory %)
SELECT 
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost,
    COUNT(r.rental_id) AS times_rented,
    SUM(p.amount) AS total_revenue,
    ROUND((SUM(p.amount) - f.replacement_cost) / f.replacement_cost * 100, 2) AS ROI_percent
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, f.rating, f.rental_rate, f.replacement_cost
HAVING times_rented >= 10  -- only films rented at least 10 times
ORDER BY ROI_percent DESC
LIMIT 10;

# 4. Bonus: Customers who spent > $1,000 in 2024
# (Note: Sakila data only goes up to 2006, so we’ll use total lifetime spend > $200 as equivalent — very common tweak)
-- Real version for 2024 data (use this in real jobs)
-- SELECT 
--     c.customer_id,
--     CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
--     c.email,
--     SUM(p.amount) AS total_spent_2024
-- FROM customer c
-- JOIN payment p ON c.customer_id = p.customer_id
-- WHERE YEAR(p.payment_date) = 2024
-- GROUP BY c.customer_id, customer_name, c.email
-- HAVING total_spent_2024 > 1000
-- ORDER BY total_spent_2024 DESC;

-- Sakila version (lifetime spend > $200 = top VIPs)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    SUM(p.amount) AS lifetime_spend,
    COUNT(p.payment_id) AS transactions
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name, c.email
HAVING lifetime_spend > 200
ORDER BY lifetime_spend DESC
LIMIT 20;