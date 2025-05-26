-- 01 Find Book Titles
SELECT 
    title
FROM
    books
WHERE
    title LIKE 'The%'
ORDER BY id;

-- 02 Replace Titles
SELECT 
    CASE
        WHEN title LIKE 'The%' THEN CONCAT('***', SUBSTRING(title, 4))
        ELSE title
    END
FROM
    books
WHERE
    title LIKE 'The%'
ORDER BY id;

-- 03 Sum Cost of All Books
SELECT 
    ROUND(SUM(cost), 2) AS Sum
FROM
    books;
    
-- 04 Days Lived
SELECT 
    CONCAT(first_name, ' ', last_name) AS `Full Name`,
    DATEDIFF(died, born) AS `Days Lived`
FROM
    authors;

-- 05 Harry Potter Books
SELECT 
    title
FROM
    books
WHERE
    title LIKE 'Harry %'
ORDER BY id;