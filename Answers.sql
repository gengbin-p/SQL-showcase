-- Author: Gengbin
-- Date: 2025.10.07
-- Purpose: SQL scripts for questions of the Udemy course The Complete SQL masterclass

-- Question 1

SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost ASC;

-- Question 2
SELECT
COUNT(*),
CASE
WHEN replacement_cost >= 9.99 AND replacement_cost <= 19.99 THEN 'low'
WHEN replacement_cost >= 20.00 AND replacement_cost <= 24.99 THEN 'medium'
WHEN replacement_cost >= 25.00 AND replacement_cost <= 29.99 THEN 'high'
ELSE 'else'
END AS cost_category
FROM film
GROUP BY cost_category
ORDER BY count DESC;

-- Question 3
SELECT
title,
length,
c.name AS category_name
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
on fc.category_id = c.category_id
WHERE c.name = 'Drama' OR c.name = 'Sports'
ORDER BY f.length DESC;

-- Question 4
SELECT
COUNT(*),
c.name
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
on fc.category_id = c.category_id
GROUP BY c.name
ORDER BY COUNT(*) DESC;

-- Question 5
SELECT 
a.first_name, 
a.last_name,
COUNT (DISTINCT fa.film_id) AS movie_count
FROM film_actor AS fa
LEFT JOIN film AS f
on fa.film_id = f.film_id
LEFT JOIN actor AS a
ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY movie_count;
-- Note: the answer provided in the course is wrong due to duplicates.

-- Question 6
SELECT COUNT(*)
FROM address AS a
LEFT JOIN customer AS c
ON a.address_id = c.address_id
WHERE c.customer_id IS NULL;

-- Question 7
SELECT 
SUM(p.amount) as total_payment,
ci.city
FROM payment AS p
LEFT JOIN customer AS c
ON p.customer_id = c.customer_id
LEFT JOIN address AS a
ON c.address_id = a.address_id
LEFT JOIN city as ci
ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY total_payment DESC;

-- Question 8
SELECT 
SUM(p.amount) AS total_payment,
co.country ||', ' || ci.city AS location
FROM payment AS p
LEFT JOIN customer AS c
ON p.customer_id = c.customer_id
LEFT JOIN address AS a
ON c.address_id = a.address_id
LEFT JOIN city AS ci
ON a.city_id = ci.city_id
LEFT JOIN country AS co
ON ci.country_id = co.country_id
GROUP BY ci.city, co.country
ORDER BY total_payment ASC;

-- Question 9
SELECT 
ROUND(AVG(pay_per_staff), 2) AS average_payment,
staff_id
FROM(
	SELECT
	SUM(amount) AS pay_per_staff,
	staff_id,
	customer_id
	FROM payment
	GROUP BY staff_id, customer_id)
GROUP BY staff_id
ORDER BY average_payment DESC;

-- Question 10
SELECT ROUND(AVG(total_payment), 2) AS average_payment 
FROM(
	SELECT 
	SUM(amount) AS total_payment,
	date(payment_date)
	FROM payment
	GROUP BY(date(payment_date))
	HAVING EXTRACT(isodow FROM date(payment_date)) = 7);

-- Question 11
SELECT
*
FROM(
	SELECT
	title,
	length,
	replacement_cost,
	AVG(length) OVER (PARTITION BY replacement_cost) AS average_length
	FROM film)
WHERE length > average_length
ORDER BY length ASC;

-- Question 12
SELECT
ROUND(AVG(payment_per_person), 2) AS average_payment,
district
FROM(
	SELECT 
	p.customer_id,
	a.district,
	SUM(amount) AS payment_per_person
	FROM payment AS p
	LEFT JOIN customer AS c
	ON p.customer_id = c.customer_id
	LEFT JOIN address AS a
	ON c.address_id = a.address_id
	GROUP BY(p.customer_id, a.district))
GROUP BY(district)
ORDER BY average_payment DESC;

-- Question 13
SELECT
p.payment_id,
p.amount,
ca.name,
SUM(p.amount) OVER (PARTITION BY ca.name)
FROM payment AS p
LEFT JOIN rental AS r
ON p.rental_id = r.rental_id
LEFT JOIN inventory AS i
ON r.inventory_id = i.inventory_id
LEFT JOIN film AS f
ON i.film_id = f.film_id
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS ca
ON fc.category_id = ca.category_id
ORDER BY ca.name ASC, payment_id ASC;

-- Question 14
SELECT
title, name, total_revenue
FROM(
	SELECT
	f.title,
	ca.name,
	SUM(amount) as total_revenue,
	RANK() OVER (PARTITION BY ca.name ORDER BY SUM(amount) DESC) AS rnk
	FROM payment AS p
	LEFT JOIN rental AS r
	ON p.rental_id = r.rental_id
	LEFT JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	LEFT JOIN film AS f
	ON i.film_id = f.film_id
	LEFT JOIN film_category AS fc
	ON f.film_id = fc.film_id
	LEFT JOIN category AS ca
	ON fc.category_id = ca.category_id
	GROUP BY f.title, ca.name)
WHERE rnk = 1;

