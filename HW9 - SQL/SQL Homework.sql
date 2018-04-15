use sakila;

# 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, 
# of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor 
where first_name 
like "Joe";

# 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name 
from actor 
where last_name 
like "%GEN%";

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows 
# by last name and first name, in that order:
select actor_id, first_name, last_name 
from actor 
where last_name 
like "%LI%"
order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country 
where country 
in ("Afghanistan", "Bangladesh", "China");

# 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
# Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD middle_name VARCHAR(45) 
AFTER first_name;

# 3b. You realize that some of these actors have tremendously long last names. 
# Change the data type of the middle_name column to blobs.
alter table actor 
modify middle_name blob;

# 3c. Now delete the middle_name column.
ALTER TABLE actor 
DROP COLUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) 
from actor 
group by last_name 
order by last_name;

# 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors
select last_name, count(last_name) as lname_count 
from actor 
group by last_name having lname_count > 1 
order by last_name;

# 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
# the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor set first_name = 'Harpo' where first_name = 'Groucho' and last_name = 'Williams';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
# as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
# (Hint: update the record using a unique identifier.)
select * from actor where first_name = "Harpo" and last_name = "Williams";

update actor
	set first_name = case when first_name = 'Harpo' then 'Groucho'
		when first_name <> 'Harpo' then 'Mucho Groucho'
        end
		where actor_id = 172;

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
# Use the tables staff and address:
select s.first_name, s.last_name, a.address, a.address2, a.district, c.city, a.postal_code
from staff s
left join address a
on (s.address_id = a.address_id)
left join city c
on (a.city_id = c.city_id);

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select amount, staff_id, payment_date from payment where payment_date like "2005-08-%" group by staff_id order by payment_date;

select s.staff_id, s.first_name, s.last_name, sum(p.amount) 
from payment p
left join staff s
on (p.staff_id = s.staff_id)
where p.payment_date like "2005-08-%"
group by s.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.film_id, title, count(*)
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by f.title;

# query statement to verify select.
select * from film_actor where film_id = 1;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(*) 
from inventory i
inner join film f
on i.film_id = f.film_id
where f.title = "Hunchback Impossible";

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
# List the customers alphabetically by last name:
select c.customer_id, c.first_name, c.last_name, sum(amount)
from customer c
left join payment p
on c.customer_id = p.customer_id
group by c.customer_id
order by last_name;

# for verification
SELECT 
    customer_id, amount
FROM
    payment
WHERE
    customer_id = 504;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
# Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title 
from film 
where language_id in 
	(select language_id 
    from language
    where name = 'English') 
    and (title like "K%" or title like "Q%");

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor fa
  WHERE film_id IN
  (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
  ) 
);
    
# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
# email addresses of all Canadian customers. Use joins to retrieve this information.
 select first_name, last_name, email 
 from customer cus
 left join address a
 on cus.address_id = a.address_id
 left join city c
 on a.city_id = c.city_id
 left join country 
 on c.country_id = country.country_id
 where country = "Canada"
 order by last_name;  
    
# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as famiy films.
select title 
from film 
where film_id in 
(
select film_id 
from film_category 
where category_id in 
	(
	select category_id 
	from category 
    where name = 'Family'
    )
);

# 7e. Display the most frequently rented movies in descending order.
select title, count(*) 
from rental r 
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id
group by title
order by count(*) desc;


# 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(amount) 
from payment p
left join inventory i
on p.customer_id = i.inventory_id
left join store s
on i.store_id = s.store_id
group by s.store_id;
      
      
# 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, k.country
from store s
left join address a
on (s.address_id = a.address_id)
left join city c
on (a.city_id = c.city_id)
join country as k
on (c.country_id = k.country_id)
group by c.city;


# 7h. List the top five genres in gross revenue in descending order. 
# (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;

select sum(amount), i.inventory_id, i.film_id, c.name 
from payment as p
left join rental as r
on p.rental_id = r.rental_id
left join inventory as i
on r.inventory_id = i.inventory_id
left join film_category as fc
on i.film_id = fc.film_id
left join category as c
on fc.category_id = c.category_id
group by c.name
order by sum(amount) desc;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view store_sales as
select s.store_id, sum(amount) 
from payment p
left join inventory i
on p.customer_id = i.inventory_id
left join store s
on i.store_id = s.store_id
group by s.store_id;

# 8b. How would you display the view that you created in 8a?
select * from store_sales;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view store_sales;











