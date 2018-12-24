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
