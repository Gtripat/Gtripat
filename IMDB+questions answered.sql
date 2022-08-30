USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS total_rows
FROM
    director_mapping;
    
-- 3867

SELECT 
    COUNT(*) AS total_rows
FROM
    genre;
    
-- 14662

SELECT 
    COUNT(*) AS total_rows
FROM
    movie;

-- 7997
    
SELECT
	COUNT(*) AS total_rows
FROM
	names;

-- 25735

SELECT
	COUNT(*) AS total_rows
FROM
	ratings;

-- 7997

SELECT
	COUNT(*) AS total_rows
FROM
	role_mapping;

-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	id IS NULL;

-- id column contains no null

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	title IS NULL;

-- title column contains no null

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	year IS NULL;

-- year column contains no null

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	date_published IS NULL;
    
-- date_published column contains no null

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	duration IS NULL;
    
-- duration column contains no null

SELECT 
    COUNT(*) AS null_count
FROM
    movie
WHERE
    country IS NULL;
    
-- country column contains 20 nulls

SELECT 
    COUNT(*) AS null_count
FROM
    movie
WHERE
    worlwide_gross_income IS NULL;
    
-- worlwide_gross_income column contains 3724 nulls

SELECT
	COUNT(*) AS null_count
FROM
	movie
WHERE
	languages IS NULL;
    
-- languages column contains 194 nulls

SELECT 
    COUNT(*) AS null_count
FROM
    movie
WHERE
    production_company IS NULL;
    
-- production_company column contains 528 nulls

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total no. of the movies release each year

SELECT 
    year AS Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;

-- Total no. of the movies month wise

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY number_of_movies DESC;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(*) AS movies_by_US_IN_2019
FROM
    movie
WHERE
    (country LIKE '%USA%'
        OR country LIKE '%India%')
        AND year = 2019;

-- There were 1059 movies produced in the USA or India in 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT
	genre
FROM
	genre
GROUP BY genre;

-- OR

SELECT DISTINCT
    genre
FROM
    genre;

-- There are 13 unique genres present


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(movie_id) AS number_of_movies
FROM
    genre
GROUP BY genre
ORDER BY number_of_movies DESC;

-- Drama genre have the highest no. of movies

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH 
movies_with_one_genre
AS
(
SELECT 
    m.title
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY m.title
HAVING COUNT(g.genre) = 1)
SELECT COUNT(*) movies_with_one_genre FROM movies_with_one_genre;

-- 3245 movies with one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	g.genre, COUNT(m.id) movie_count, RANK() OVER (ORDER BY COUNT(m.id) DESC) genre_rank
FROM
	movie m
		INNER JOIN genre g ON g.movie_id = m.id
GROUP BY g.genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top10_movies_by_avgRating
AS
(
SELECT
	m.title, avg_rating, dense_rank() over (order by avg_rating desc) movie_rank
FROM
	movie m
		INNER JOIN ratings r ON r.movie_id = m.id
)
SELECT * FROM top10_movies_by_avgRating WHERE movie_rank <= 10;

-- dense_rank is used as there are many movies with same ratings



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    r.median_rating, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
GROUP BY r.median_rating
ORDER BY movie_count DESC;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.production_company, COUNT(m.id) AS movie_count, dense_rank() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY m.production_company;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    g.genre, COUNT(m.id) movie_count
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
        AND m.country LIKE '%USA%'
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE m.title like 'The%' and r.avg_rating > 8
ORDER BY r.avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    COUNT(m.id) num_median_rating
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8;

-- 361 movies with median rating of 8 that were released between 1 Apr 2018 and 1 Apr 2019.




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH German_movies_votes
AS
(
SELECT
 SUM(r.total_votes) AS German_movies_votes
FROM
	movie m
    INNER JOIN ratings r ON r.movie_id = m.id
WHERE
	m.languages like '%German%'),
Italian_movies_votes
AS
(
SELECT
 SUM(r.total_votes) AS Italian_movies_votes
FROM
	movie m
    INNER JOIN ratings r ON r.movie_id = m.id
WHERE
	m.languages like '%Italian%')
SELECT 
	German_movies_votes, Italian_movies_votes, 
	CASE WHEN German_movies_votes >  Italian_movies_votes THEN 'Yes' Else 'No' END AS German_greater_Italian
FROM 
	German_movies_votes, Italian_movies_votes;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH
top3_genres_by_movies
AS
(
SELECT
	g.genre, COUNT(m.id) movie_count, r.avg_rating
FROM movie m
	INNER JOIN genre g ON g.movie_id = m.id
	INNER JOIN ratings r ON r.movie_id = m.id
WHERE r.avg_rating > 8.0
GROUP BY g.genre
ORDER BY movie_count desc
LIMIT 3),
directors_by_movies_genres
AS
(
SELECT
	n.name AS director_name, COUNT(m.id) AS movie_count, g.genre, DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) director_rank
FROM
	movie m
    INNER JOIN genre g ON g.movie_id = m.id
    INNER JOIN director_mapping dm on dm.movie_id = m.id
    INNER JOIN names n ON n.id = dm.name_id
    INNER JOIN ratings r ON r.movie_id = m.id
WHERE r.avg_rating > 8.0 AND g.genre in (SELECT genre FROM top3_genres_by_movies)
GROUP BY n.name)
SELECT director_name, movie_count FROM directors_by_movies_genres WHERE director_rank <= 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    n.name AS actor_name, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    role_mapping rm ON rm.movie_id = m.id
        INNER JOIN
    names n ON n.id = rm.name_id AND category = 'Actor'
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    r.median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH
top3_prod_comp_by_votes 
AS
(
SELECT
	m.production_company, SUM(r.total_votes) AS vote_count, DENSE_RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM
	movie m
		INNER JOIN
	ratings r ON r.movie_id = m.id
GROUP BY m.production_company)
SELECT * FROM top3_prod_comp_by_votes WHERE prod_comp_rank <= 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH
top1_IndianActors_avgRating
AS
(
SELECT 
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) AS actor_avg_rating,
	RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) DESC, SUM(r.total_votes) DESC) AS actor_rank
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
        INNER JOIN
    role_mapping rm ON rm.movie_id = m.id
        INNER JOIN
    names n ON n.id = rm.name_id
        AND rm.category = 'actor'
WHERE
    m.country LIKE '%India%'
GROUP BY n.name
HAVING movie_count >= 5)
SELECT * FROM top1_IndianActors_avgRating WHERE actor_rank=1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH
top1_IndianActors_avgRating
AS
(
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) AS actress_avg_rating,
	RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
        INNER JOIN
    role_mapping rm ON rm.movie_id = m.id
        INNER JOIN
    names n ON n.id = rm.name_id
        AND rm.category = 'actress'
WHERE
    m.country LIKE '%India%' and m.languages LIKE '%Hindi%'
GROUP BY n.name
HAVING movie_count >= 3)
SELECT * FROM top1_IndianActors_avgRating WHERE actress_rank<=5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT 
    m.title,
    r.avg_rating,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_category
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    g.genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	g.genre,
    ROUND(AVG(m.duration)) avg_duration,
    ROUND(SUM(AVG(m.duration)) OVER (ORDER BY g.genre),2) AS running_total_duration,
    ROUND(AVG(AVG(m.duration)) OVER (ORDER BY g.genre),2) AS moving_avg_duration
FROM
	movie m
		INNER JOIN
	genre g On g.movie_id = m.id
GROUP BY g.genre
ORDER BY g.genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH
top3_genres_by_movies
AS
(
SELECT
	g.genre, 
    COUNT(m.id) movie_count
FROM 
	movie m
		INNER JOIN 
	genre g ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3),
high_gross_movies
AS
(
SELECT 
	g.genre, 
    m.year, 
    m.title as movie_name,
    -- converting INR gross income to $
    CASE 
		WHEN m.worlwide_gross_income LIKE 'INR%' THEN concat('$ ', substr(m.worlwide_gross_income,4,15)/80) 
        ELSE m.worlwide_gross_income 
        END AS worlwide_gross_income, 
    DENSE_RANK() OVER (PARTITION BY m.year ORDER BY 
			CAST(CASE 
				WHEN m.worlwide_gross_income LIKE 'INR%' THEN substr(m.worlwide_gross_income,4,15)/80 
                ELSE substr(m.worlwide_gross_income,3,15) 
                END AS DECIMAL(15,0)) DESC) AS movie_rank 
FROM
	movie m
		INNER JOIN
	genre g ON g.movie_id = m.id
		INNER JOIN
	top3_genres_by_movies tg ON tg.genre = g.genre
)
SELECT * FROM high_gross_movies WHERE movie_rank <= 5;

-- Movies with worldwide gross income in INR is converted to $ so that the top 5 movies with highest gross income


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH top2_prod_company
AS
(
SELECT
	m.production_company, 
    COUNT(m.id) movie_count, 
    dense_rank() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM
	movie m
		INNER JOIN
	ratings r ON r.movie_id = m.id
WHERE r.median_rating >= 8  AND POSITION(',' IN m.languages) > 0 AND m.production_company IS NOT NULL
GROUP BY m.production_company
)
SELECT * FROM top2_prod_company WHERE prod_comp_rank <= 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top3_actress_by_rating
AS
(
SELECT
	n.name AS actress_name, 
    SUM(r.total_votes) AS total_votes, 
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
    DENSE_RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC) AS actress_rank
FROM
	movie m
		INNER JOIN
	genre g ON g.movie_id = m.id
		INNER JOIN
	ratings r ON r.movie_id = m.id
		INNER JOIN
	role_mapping rm ON rm.movie_id = m.id and rm.category = 'actress'
		INNER JOIN names n ON n.id = rm.name_id
WHERE g.genre = 'Drama' AND r.avg_rating > 8
GROUP BY n.name
)
SELECT * FROM top3_actress_by_rating WHERE actress_rank <=3 ;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH
dir_diff_days_bet_movies
AS
(
SELECT n.id AS director_id, n.name, m.title, m.date_published, 
	LAG(m.date_published) OVER (PARTITION BY n.name ORDER BY m.date_published) AS prev_movie_published_date,
	DATEDIFF(m.date_published, LAG(m.date_published) OVER (PARTITION BY n.name ORDER BY m.date_published)) AS days_difference
FROM
    movie m
        INNER JOIN
    director_mapping dm ON dm.movie_id = m.id
        INNER JOIN
    names n ON n.id = dm.name_id
ORDER BY n.name),
dir_days_diff
AS
(
SELECT
	director_id, ROUND(avg(days_difference)) avg_inter_movie_days 
FROM 
	dir_diff_days_bet_movies 
GROUP BY director_id
)
SELECT
    dm.name_id AS director_id,
    n.name AS director_name,
    COUNT(m.id) AS number_of_movies,
    dif.avg_inter_movie_days,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM
    movie m
        INNER JOIN
    director_mapping dm ON dm.movie_id = m.id
        INNER JOIN
    names n ON n.id = dm.name_id
        INNER JOIN
    ratings r ON r.movie_id = m.id
		INNER JOIN
	dir_days_diff dif ON dif.director_id = dm.name_id
GROUP BY dm.name_id
ORDER BY number_of_movies DESC
LIMIT 9;