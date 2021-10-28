--1. Show all customers whose last names start with T. Order them by first name from A-Z.
SELECT *  --selected all columns from the customer table 
FROM customer  --customer table is selected 
WHERE last_name LIKE 'T%'  ---checking whose last name starts with T
ORDER BY first_name;    ---arranging the names column with first name

--2. Show all rentals returned from 5/28/2005 to 6/1/2005
SELECT *           ---Selected all columns 
FROM rental        ---From rental table
WHERE return_date BETWEEN '2005-5-28' AND '2005-6-1';  ---checking where return date according to the question

--3. How would you determine which movies are rented the most?
SELECT film.title AS title, count(rental.inventory_id) AS rental_rate  ---Selected all the titles that needs to show on our table
FROM rental                 -----took rental table
JOIN inventory              ----Joined inventory table to rental table
ON rental.inventory_id = inventory.inventory_id   ----Used inventory id as common columns for both tables 
JOIN film                ----joined film table for above combined tables 
ON film.film_id = inventory.inventory_id    -----used film id as common columns on both the tables 
GROUP BY film.title        ----grouped title 
ORDER BY rental_rate DESC;  ---sorted table according to rental tables 

--4.Show how much each customer spent on movies(based on this dataset).Order them from least to most.
SELECT film.title, count(payment.customer_id) AS customer_count    ---Selected all the titles that needs to show on our table
FROM payment        ------took payment table
JOIN rental         ----Joined rental table to rental table
ON payment.customer_id = rental.customer_id  -------Used customer id as common columns for both tables 
JOIN inventory        ----Joined inventory table to rental table
ON rental.inventory_id = inventory.inventory_id   ----Used inventory id as common columns for both tables
JOIN film  ------joined film table
ON film.film_id = inventory.inventory_id -----made film id is equal to inventory id
GROUP BY film.title   ----grouped film title 
ORDER BY customer_count; -----sorted using customer count 

--5.which actor was in the most movies in 2006(based on this dataset)?. Be sure to alias the actor name 
--and count as a more descriptive name.order the results from most to least.
SELECT first_name, last_name, count(film.release_year) AS release_count ---Selected all the titles that needs to show on our table
FROM film   ---took film table
JOIN film_actor   ----joined film actor table 
USING (film_id)   ---used film id as common column 
JOIN actor     ----joined actor table 
using (actor_id)    ---used actor id as common from both the tables 
GROUP BY first_name, last_name, film.release_year ----Griuped by first, lst and release year
HAVING release_year = '2006';  ---stated that release year should be 2006, so we will get the data for 2006 

--6. wrirte an explain plan for 4 and 5. show the queries and explain wht is happening in each one.
EXPLAIN SELECT film.title, count(payment.customer_id) AS customer_count    ---Selected all the titles that needs to show on our table
FROM payment        ------took payment table
JOIN rental         ----Joined rental table to rental table
ON payment.customer_id = rental.customer_id  -------Used customer id as common columns for both tables 
JOIN inventory        ----Joined inventory table to rental table
ON rental.inventory_id = inventory.inventory_id   ----Used inventory id as common columns for both tables
JOIN film  ------joined film table
ON film.film_id = inventory.inventory_id -----made film id is equal to inventory id
GROUP BY film.title   ----grouped film title 
ORDER BY customer_count; -----sorted using customer count 

EXPLAIN SELECT first_name, last_name, count(film.release_year) AS release_count ---Selected all the titles that needs to show on our table
FROM film   ---took film table
JOIN film_actor   ----joined film actor table 
USING (film_id)   ---used film id as common column 
JOIN actor     ----joined actor table 
using (actor_id)    ---used actor id as common from both the tables 
GROUP BY first_name, last_name, film.release_year ----Griuped by first, lst and release year
HAVING release_year = '2006';  ---stated that release year should be 2006, so we will get the data for 2006 

 ----EXPLAIN shows the data with in the tables in text format and it also shows the rows , columns we are grouping and the aggrgate for rows and columns etc
 

--7. What is the average rental rate per genre ?
SELECT category.name AS genre, AVG(rental_rate) AS avg_rental_rate  -----Selected the title for our table and taking avg for rental rate and giving alias
FROM category       ----taking category table 
JOIN film_category    ---joining film category table to category
ON category.category_id = film_category.category_id   ---used category id as common id from both the tables 
JOIN film     ---joining film to the above tables
ON film.film_id = film_category.film_id  ---using film id as common columns 
GROUP BY name, rental_rate; ---grouped rental rate 

--8. How many films were returned late?Early?on time?
SELECT 
COUNT(CASE WHEN rental_duration > date_part('day', return_date - rental_date) THEN 'Early' END) AS returned_early,
COUNT(CASE WHEN rental_duration < date_part('day', return_date - rental_date) THEN 'Late' END) AS returned_late,
COUNT(CASE WHEN rental_duration = date_part('day', return_date - rental_date) THEN 'On time' END) AS returned_ontime
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id

--9. What categories are the most rented and what are their total sales?

SELECT c.name AS Gener, COUNT(r.rental_id) AS num_of_rentals, SUM(p.amount) AS total_sales
FROM category AS c
JOIN film_category as fc
ON fc.category_id = c.category_id
JOIN film as f 
ON f.film_id = fc.film_id
JOIN inventory as i
ON i.film_id = f.film_id 
JOIN rental as r
ON r.inventory_id = i.inventory_id
JOIN payment as p 
ON p.rental_id = r.rental_id
GROUP BY gener
ORDER BY num_of_rentals DESC;

-----Most rented categories are sports which have total sales is 4892, animation and its total sales is 4245, 
   --action and its total sale is 3951, Sci-fi and its total sale is 4336 and Family has 3830 total sales.
   
---10, create a view for 8 and a view for 9. Be sure to name them appropriately.

CREATE VIEW question08 AS 
SELECT 
COUNT(CASE WHEN rental_duration > date_part('day', return_date - rental_date) THEN 'Early' END) AS returned_early,
COUNT(CASE WHEN rental_duration < date_part('day', return_date - rental_date) THEN 'Late' END) AS returned_late,
COUNT(CASE WHEN rental_duration = date_part('day', return_date - rental_date) THEN 'On time' END) AS returned_ontime
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id

CREATE VIEW question09 AS
SELECT c.name AS Gener, COUNT(r.rental_id) AS num_of_rentals, SUM(p.amount) AS total_sales
FROM category AS c
JOIN film_category as fc
ON fc.category_id = c.category_id
JOIN film as f 
ON f.film_id = fc.film_id
JOIN inventory as i
ON i.film_id = f.film_id 
JOIN rental as r
ON r.inventory_id = i.inventory_id
JOIN payment as p 
ON p.rental_id = r.rental_id
GROUP BY gener
ORDER BY num_of_rentals DESC;








