USE sakila;

### 6a. 	Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT first_name, last_name, address
FROM staff s 
JOIN address a
ON s.address_id = a.address_id;

### 6b. 	Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff INNER JOIN payment 
ON staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%'; 

### 6c. 	List each film and the number of actors who are listed for that film. 
###     	Use tables `film_actor` and `film`. Use inner join.

SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS `Number of Actors`
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.title;

### 6d. 	How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id
) AS 'Number of Copies'
FROM film
WHERE title = "Hunchback Impossible";

### 6e. 	Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
### 		List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.last_name;