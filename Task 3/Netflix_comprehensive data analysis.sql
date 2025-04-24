Use netflix;

-- Trend of Content over years ( how Netflix's content volume has changed over time.)
SELECT release_year, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- Top 10 most frequent Directors
SELECT director, COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;

-- most common genres ( from listed in)
SELECT listed_in, COUNT(*) AS genre_count
FROM netflix_titles
GROUP BY listed_in
ORDER BY genre_count DESC
LIMIT 10;

-- Longest title duration per country

SELECT country, MAX(duration) AS max_duration
FROM netflix_titles
WHERE duration LIKE '%min%'
GROUP BY country
ORDER BY max_duration DESC;

-- Most frequent Actor/Actress

SELECT actor, COUNT(*) AS appearances
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS actor
    FROM netflix_titles
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM 
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
             UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
             UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    ) n
    WHERE n.n <= 1 + LENGTH(cast) - LENGTH(REPLACE(cast, ',', ''))
) AS cast_list
WHERE actor IS NOT NULL AND actor != ''
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;

-- contents availability by month (Seasonal trends of netflix uploads)

SELECT MONTH(STR_TO_DATE(date_added, '%M %d, %Y')) AS month_added,
       COUNT(*) AS total_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY month_added
ORDER BY month_added;

-- Content Type Percentage Breakdown (How much is TV vs Movie)

SELECT type, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles) AS percentage
FROM netflix_titles
GROUP BY type;
