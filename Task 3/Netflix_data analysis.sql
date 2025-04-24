CREATE DATABASE NETFLIX;
use NETFLIX;

SELECT *
FROM netflix_titles;

-- List all movies released in 2020, ordered by title
SELECT title, release_year
FROM netflix_titles
WHERE type = 'Movie' AND release_year = 2020
ORDER BY title;

-- Count of shows per country
SELECT country, COUNT(*) AS show_count
FROM netflix_titles
GROUP BY country
ORDER BY show_count DESC;

-- ratings(show_id, average_rating) by using JOINS
-- dummy table of ratings
CREATE TABLE ratings (
    show_id VARCHAR(50),
    average_rating DECIMAL(3,1)
);

-- Step 2: Insert sample data (matching some known show_ids if available)
INSERT INTO ratings (show_id, average_rating)
VALUES 
('s1', 7.5),
('s2', 8.2),
('s3', 6.9);  -- Make sure these match real show_ids in netflix_titles if possible

-- Step 3: Join netflix_titles with ratings
SELECT n.title, r.average_rating
FROM netflix_titles n
INNER JOIN ratings r ON n.show_id = r.show_id;


-- show with the longest duration

SELECT title, duration
FROM netflix_titles
WHERE duration = (
    SELECT MAX(duration)
    FROM netflix_titles
    WHERE type = 'Movie'
);

-- Average number of shows per country
SELECT AVG(country_total) AS avg_shows_per_country
FROM (
    SELECT country, COUNT(*) AS country_total
    FROM netflix_titles
    GROUP BY country
) AS sub;

-- View: TV Shows added in 2021
CREATE VIEW tv_shows_2021 AS
SELECT *
FROM netflix_titles
WHERE type = 'TV Show' AND date_added LIKE '%2021%';

-- Improve query performance on common filters
CREATE INDEX idx_country ON netflix_titles(country(100));
CREATE INDEX idx_type_year ON netflix_titles(type, release_year);


