USE sakila;

### 1a. Display the first and last names of all actors from the table `actor`. 

SELECT first_name, last_name
FROM actor;

### 1b. 	Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

### 2a.  	You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
### 		What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

### 2b.  	Find all actors whose last name contain the letters `GEN`

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';

### 2c. 	Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;


### 2d. 	Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China

SELECT country_id, country
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

### 3a. 	Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: 
### 		you will need to specify the data type.

ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;

### 3b. 	You realize that some of these actors have tremendously long middle names. Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

### 3c. 	Now delete the `middle_name` column.

ALTER TABLE actor
DROP COLUMN middle_name;

### 4a. 	List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name) AS "Count of Last Name"
FROM actor GROUP BY last_name;

### 4b. 	List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(last_name) AS "Count of Last Name"
FROM actor GROUP BY last_name HAVING count(last_name) >=2;

### 4c. 	Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
### 		the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

UPDATE actor 
SET first_name = 'HARPO'
WHERE First_name = "GROUCHO" AND last_name = "WILLIAMS";

### 4d. 	Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all!
###     	In a single query, if the first name of the actor is currently  `HARPO`, change it to `GROUCHO`. Otherwise, change the first
###     	name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST
###     	NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor
 SET first_name = 
 CASE 
 WHEN first_name = 'HARPO' 
 THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
 END
 WHERE actor_id = 172;

### 5a. 	You cannot locate the schema of the `address` table. Which query would you use to re-create it?

DESCRIBE sakila.address;

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

### 7a. 	The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
### 		films starting with the letters `K` and `Q` have also soared in popularity. 
### 		Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");


### 7b. 	Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

### 7c. 	You want to run an email marketing campaign in Canada, for which you  will need the names and email addresses of all Canadian customers. 
### 		Use joins to retrieve this information.

SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';


###  7d. 	Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
### 		Identify all movies categorized as famiy films.

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

### 7e. 	Display the most frequently rented movies in descending order.

SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;


### 7f. 	Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

### 7g. 	Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);


###  7h. 	List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category,
###      	film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;


USE sakila;

###  8a. 	In your new role as an executive, you would like to have an easy  way of viewing the Top five genres by gross revenue. 
###  		Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
  	
###  8b. 	How would you display the view that you created in 8a?

SELECT * FROM genre_revenue;

###  8c. 	You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW genre_revenue;
