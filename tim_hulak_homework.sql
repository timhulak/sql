-- Use the Data Base
USE sakila
;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor
;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor
;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    actor.first_name = 'Joe'
;
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%'
;
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name
;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China')
;
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER table
	actor
ADD 
	description BLOB(50)
;
SELECT 
    *
FROM
    actor
;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER table
	actor
DROP 
	description
;
SELECT 
    *
FROM
    actor
;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2
;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
/*Find the actor_id for GROUCHO*/
SELECT 
    *
FROM
    actor;
/* actor_id for GROUCHO is 172 */
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    actor_id = 172
;
/* view table to make sure it worked */
SELECT 
    *
FROM
    actor;
/* It worked! */

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    actor_id = 172
;
/* view table to make sure it worked */
SELECT 
    *
FROM
    actor;
/* It worked! */
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    address
        JOIN
    staff ON staff.address_id = address.address_id
;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
    first_name,
    last_name,
    SUM(amount) AS 'Total Rung Up August 2005'
FROM
    payment p
        JOIN
    staff s ON p.staff_id = s.staff_id
WHERE
    p.payment_date LIKE '%2005-08%'
GROUP BY 1 , 2
;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
    f.title, COUNT(fa.actor_id) AS actors_count
FROM
    film_actor fa
        INNER JOIN
    film f USING (film_id)
GROUP BY f.title
ORDER BY actors_count DESC
;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Find the Film ID
SELECT 
    film_id
FROM
    film
WHERE
    title = 'Hunchback Impossible'
;
-- film_id for 'Hunchback Impossible' is 439

SELECT 
    store_id, COUNT(store_id) AS Hunchback_Impossible_copies
FROM
    inventory
WHERE
    film_id = 439
GROUP BY store_id
;
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    customer_id,
    first_name AS 'First',
    last_name AS 'Last',
    SUM(amount) AS 'Total Paid'
FROM
    payment p
        INNER JOIN
    customer c USING (customer_id)
GROUP BY customer_id , first_name , last_name
ORDER BY last_name ASC
;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT 
    *
FROM
    language;
-- ID is 1
SELECT 
    title
FROM
    film
WHERE
    (language_id = 1)
        AND (title LIKE 'K%' OR title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    film_id
FROM
    film
WHERE
    title = 'Alone Trip'
;
-- ID is 17

SELECT 
    first_name, last_name, title
FROM
    actor
        INNER JOIN
    (SELECT 
        title, actor_id
    FROM
        film_actor a
    INNER JOIN film b USING (film_id)) AS sub USING (actor_id)
WHERE
    title = 'Alone Trip'
;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
	first_name, last_name 
FROM
	customer c
    JOIN 
;

-- 7d. Sales have been lagging among young families,
-- and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

-- 7e. Display the most frequently rented movies in 
-- descending order.
SELECT 
    *
FROM
    inventory;
SELECT 
    *
FROM
    payment;
SELECT 
    *
FROM
    rental;

SELECT 
    title, COUNT(film_id) AS freq_rented
FROM
    inventory i
        INNER JOIN
    film f USING (film_id)
GROUP BY title , film_id
ORDER BY freq_rented DESC
;

-- 7f. Write a query to display how much business, in dollars,
-- each store brought in.
SELECT 
    staff_id AS store_num, SUM(amount)
FROM
    payment
GROUP BY staff_id
;

-- 7g. Write a query to display, for each store, its store ID, 
-- city, and country.
SELECT 
    store_id, address, city, country
FROM
    country c
        JOIN
    (SELECT 
        store_id, address, city, country_id
    FROM
        city cy
    INNER JOIN (SELECT 
        store_id, city_id, address_id, address
    FROM
        store s
    INNER JOIN address a USING (address_id)) AS aid USING (city_id)) AS cid USING (country_id);

-- 7h. List the top five genres in gross revenue in 
-- descending order. 
-- (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
SELECT 
    *
FROM
    category;
SELECT 
    *
FROM
    payment;
SELECT 
    *
FROM
    film_category;
SELECT 
    *
FROM
    rental;
SELECT 
    *
FROM
    inventory;

SELECT 
    inventory_id, film_id, category_id, name
FROM
    inventory i
        JOIN
    (SELECT 
        category_id, film_id, name
    FROM
        film_category fc
    INNER JOIN category c USING (category_id)) AS d USING (film_id);

SELECT 
    rental_id, amount, inventory_id
FROM
    payment p
        INNER JOIN
    rental r USING (rental_id)
;

SELECT 
    SUM(amount) AS total_sales_cat, name
FROM
    (SELECT 
        inventory_id, film_id, category_id, name
    FROM
        inventory i
    INNER JOIN (SELECT 
        category_id, film_id, name
    FROM
        film_category fc
    INNER JOIN category c USING (category_id)) AS d USING (film_id)) AS z
        INNER JOIN
    (SELECT 
        rental_id, amount, inventory_id
    FROM
        payment p
    INNER JOIN rental b USING (rental_id)) AS y USING (inventory_id)
GROUP BY name
ORDER BY total_sales_cat DESC;

-- 8a. In your new role as an executive, you would like to 
-- have an easy way of viewing the Top five genres by gross 
-- revenue. Use the solution from the problem above to create 
-- a view. If you haven't solved 7h, you can substitute 
-- another query to create a view.

SELECT 
    *
FROM
    category;
SELECT 
    *
FROM
    film_category;
SELECT 
    *
FROM
    inventory;
SELECT 
    *
FROM
    payment;
SELECT 
    *
FROM
    rental;

SELECT 
    *
FROM
    cat_film_id;

CREATE VIEW cat_film_id AS
    SELECT 
        inventory_id, film_id, category_id, name
    FROM
        inventory i
            INNER JOIN
        (SELECT 
            category_id, film_id, name
        FROM
            film_category fc
        INNER JOIN category c USING (category_id)) AS d USING (film_id);

SELECT 
    *
FROM
    inv_id_amount;

CREATE VIEW inv_id_amount AS
    SELECT 
        rental_id, amount, inventory_id
    FROM
        payment p
            INNER JOIN
        rental r USING (rental_id)
;

CREATE VIEW top_sales_by_category AS
    SELECT 
        SUM(amount) AS total_sales_category, name
    FROM
        inv_id_amount iid
            INNER JOIN
        cat_film_id cfid USING (inventory_id)
    GROUP BY name
    ORDER BY total_sales_category DESC;

SELECT 
    *
FROM
    top_sales_by_category;

-- 8b. How would you display the view that you created in 8a?
SELECT 
    *
FROM
    top_sales_by_category;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_sales_by_category;
