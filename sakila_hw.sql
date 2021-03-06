/*1a. Display the first and last names of all actors from the table actor. */

use sakila;
SELECT DISTINCT
    first_name, last_name
FROM
    actor;


/*2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information?*/
use sakila;
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name LIKE '%joe';


/*2b. Find all actors whose last name contain the letters GEN:*/
use sakila;
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
	last_name LIKE '%gen';
    
/*2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:*/
use sakila;
SELECT 
    actor_id, last_name, first_name
FROM
    actor
WHERE
	last_name like '%{li}%'
order by last_name;




/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:*/
use sakila;
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    
/*3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.*/
USE sakila;
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(100) NULL AFTER `first_name`;

/*3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.*/

USE sakila;
ALTER TABLE `sakila`.`actor`
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

/*3c. Now delete the middle_name column.*/
USE sakila;
ALTER TABLE `sakila`.`actor`
DROP COLUMN `middle_name`;

/*4a. List the last names of actors, as well as how many actors have that last name.*/
USE sakila;
SELECT 
    last_name
FROM
    actor;
SELECT 
    COUNT(*)
FROM
    actor
WHERE
    last_name = 'NULL';

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/
use sakila;
SELECT 
    last_name, COUNT(*) AS CNT
FROM
    actor
GROUP BY last_name
HAVING COUNT(*) > 1;


/*4c.The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.*/
use sakila;
UPDATE actor 
SET first_name= 'HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

/**4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query,
if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
(Hint: update the record using a unique identifier.)*/
USE sakila;
UPDATE actor 
SET first_name= 'GRUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */
use sakila;
desc address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:*/
use sakila;
SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff s
        LEFT JOIN
    address a ON s.address_id = a.address_id;
    

/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. */
use sakila;
select * from payment;
SELECT 
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS 'total_amount'
FROM
    staff
        LEFT JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name , staff.last_name;

/*6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.*/
use sakila;
SELECT 
    f.film_id, f.title, COUNT(fa.actor_id) AS 'number_of_actor'
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id , f.title;


/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/
use sakila;
select * from inventory ;
SELECT 
    f.film_id, f.title, COUNT(inv.inventory_id) AS 'number_of_copy'
FROM
    film f
        INNER JOIN
    inventory inv ON f.film_id = inv.film_id
WHERE f.title like '% Hunchback'
GROUP BY f.film_id , f.title;


/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:*/

SELECT 
    c.first_name, c.last_name, SUM(p.amount) AS 'TOTAL'
FROM
    customer c
        LEFT JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name , c.last_name
ORDER BY c.last_name;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/
USE sakila;
SELECT 
    title
FROM
    film
WHERE
    (title LIKE 'K%' OR title LIKE 'Q%')
        AND language_id = (SELECT language_id FROM language WHERE name = 'English');
        
        
 /*7b. Use subqueries to display all actors who appear in the film Alone Trip.*/       
 
 USE sakila;
SELECT first_name as 'actor first name', last_name as 'actor last name'
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));

/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/

SELECT 
    first_name, last_name, country, email
FROM
    customer
        JOIN
    address ON (customer.address_id = address.address_id)
        JOIN
    city ON (address.city_id = city.city_id)
        JOIN
    country ON (city.country_id = country.country_id)
WHERE
    country = 'Canada';
    
/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.*/

/*7e. Display the most frequently rented movies in descending order.*/

USE sakila;
SELECT 
    title, COUNT(film.film_id) AS 'frequency_of_rental'
FROM
    film
        JOIN
    inventory ON (film.film_id = inventory.film_id)
        JOIN
    rental ON (inventory.inventory_id = rental.inventory_id)
GROUP BY title
ORDER BY frequency_of_rental desc ;

/*7f. Write a query to display how much business, in dollars, each store brought in.*/
Use sakila;
select * from staff;
SELECT 
    s.store_id, SUM(p.amount) as 'total_amount_dollars'
FROM
    payment p
        JOIN
    staff s ON (p.staff_id = s.staff_id)
GROUP BY store_id;

/*7g. Write a query to display for each store its store ID, city, and country.*/
USE sakila;
SELECT 
    store_id, city, country
FROM
    store
        JOIN
    address ON (store.address_id = address.address_id)
        JOIN
    city ON (address.city_id = city.city_id)
        JOIN
    country ON (city.country_id = country.country_id);
    
    
/*7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

SELECT 
    c.name AS 'Genres', SUM(p.amount) AS 'Gross_Amount'
FROM
    category c
        JOIN
    film_category fc ON (c.category_id = fc.category_id)
        JOIN
    inventory i ON (fc.film_id = i.film_id)
        JOIN
    rental r ON (i.inventory_id = r.inventory_id)
        JOIN
    payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross_Amount
LIMIT 5;

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/

CREATE VIEW VIEW_NAME AS
SELECT
   c.name AS 'Genres', SUM(p.amount) AS 'Gross_Amount'
FROM
   sakila.category c
       JOIN
   sakila.film_category fc ON (c.category_id = fc.category_id)
       JOIN
   sakila.inventory i ON (fc.film_id = i.film_id)
       JOIN
   sakila.rental r ON (i.inventory_id = r.inventory_id)
       JOIN
   sakila.payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY Gross_Amount
LIMIT 5;

/*8b. How would you display the view that you created in 8a?*/

SELECT* FROM view_name;


/*8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/

Drop View view_name;

