-- Chinook Database (https://www.kaggle.com/datasets/ranasabrii/chinook?resource=download) is a relational database that represents a digital music store. It contains 11 tables including artists, 
--albums, playlists, music genre and also information about customers, invoices and employees.

-- The objective of this project is using SQL (Structured Query Language) to explore the database and answer questions related to the business. The main operations that will be applied are
--descriptive statistics, filters and conditions, join operations between tables, subqueries and window functions.

-- 1. Explore tables from database
SELECT * FROM Album LIMIT 10;
-- The table Album presents information about each album that can be found in the store, such as the ID number of the album, the title of the Album and the ID number of the artist.

SELECT * FROM Artist LIMIT 10;
-- The table Artist contains the name of the artist/band and the associated ID number.

SELECT * FROM Customer LIMIT 10;
-- The table Customer presents information about each customer of the digital store: name, company (if necessary), address, phone number, email address and SupportRepId.

SELECT * FROM Employee LIMIT 10;
-- The table Employee shows information about all employees of the store, including the address, role, birth date and hire date, name, phone number, email address and who they report to.
--This is a recursive relationship, because the column ReportsTo is foreign key that references EmployeeID in this table.

SELECT * FROM Genre LIMIT 10;
-- This table contains all genres of songs and the associdated ID.

SELECT * FROM Invoice LIMIT 10;
-- The table Invoice presents all the invoices associated to each customer and includes information such as invoice date, billing address, invoice total, the ID of the invoice and the ID
--of the customer who bought the products.

SELECT * FROM InvoiceLine LIMIT 10;
-- The table InvoiceLine presents all the products that have been bought in each invoice and the quantity of each product.

SELECT * FROM MediaType LIMIT 10;
-- In the table MediaType we can find in which digital format the track can be found and its ID number. 

SELECT * FROM Playlist LIMIT 10;
-- The table Playlist contains the name and ID of all playlists in the digital store.

SELECT * FROM PlaylistTrack LIMIT 10;
-- In the PlaylistTrack table there are two columns, the IDs of the playlist and of the track.

SELECT * FROM Track LIMIT 10;
-- The Track table presents more information about each song, such as the name, the album in which it is included, the song duration, the genre and the format of the song, as well as the
--price, the size of the song in bytes and a list of composers.

-- 2. Display the first and last names of customers from Germany.
SELECT FirstName, LastName from Customer where Country = 'Germany';

-- 3. Display the title and price (UnitPrice) of all tracks that cost more than 0.99.
SELECT Name, UnitPrice from Track where UnitPrice > 0.99;

-- 4. Display the 10 longest tracks in the database (Milliseconds column), ordered in descending order.
SELECT Name, Milliseconds from Track ORDER BY Milliseconds DESC LIMIT 10;

-- 5. Calculate the total number of customers per country, ordered in descending order by count.
SELECT COUNT(CustomerId), Country from Customer
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;

-- The most customers of this digital store, 13, come from USA. The next countries from where most customers are from are Canada, France and Brazil, with 8 from Canada, respectively 
--5 customers for France and Brazil. There are 2 customers from Czech Republic, India and Portugal, 3 from United Kingdom and 4 from Germany. There are also 15 countries that are
--represented by only 1 customer: Sweden, Spain, Poland and many more. Therefore, almost 36% of customers come from USA and Canada.

-- 6. Display the names of artists along with the titles of their albums.
SELECT Artist.Name, Album.Title FROM Artist
INNER JOIN Album
ON Artist.ArtistId = Album.ArtistId
ORDER BY Name ASC;

-- 7. Calculate the total amount spent by each customer, displaying their full name and total spent, ordered in descending order.
SELECT CONCAT(C.FirstName, " ", C.LastName) AS FullName, SUM(I.Total) AS TotalSpent FROM Customer C
INNER JOIN Invoice I
ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId
ORDER BY TotalSpent DESC, C.CustomerId ASC;

-- 8. Display track names, the album they belong to, and the artist, for all tracks in a chosen genre.
SELECT Artist.Name, Track.Name, Album.Title, Genre.Name FROM Track
INNER JOIN Album ON Track.AlbumId = Album.AlbumId
INNER JOIN Artist ON Album.ArtistId = Artist.ArtistId
INNER JOIN Genre on Track.GenreId = Genre.GenreId
WHERE Genre.Name = 'Alternative & Punk'
ORDER BY Artist.Name, Album.Title;

-- 9. Display customers who spent more than the average spending across all customers.
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS FullName, SUM(I.Total) AS TotalSpent
FROM Customer C
INNER JOIN Invoice I ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId
HAVING TotalSpent > (
    SELECT SUM(Total) / COUNT(DISTINCT CustomerId) FROM Invoice
)
ORDER BY TotalSpent DESC;

-- 22 out of 59 customers, almost 37%, spent more than the store-wide average of $39.47 per customer, with totals between $39.62 and $49.62.

-- 10. List all tracks that are longer than the average track length.
SELECT Name, Milliseconds FROM Track
WHERE Milliseconds > (
    SELECT AVG(Milliseconds) FROM Track
);

-- 11. List all albums that contain at least one track longer than 5 minutes.
SELECT DISTINCT A.Title FROM Album A
INNER JOIN Track T ON A.AlbumId = T.AlbumId
WHERE T.Milliseconds > 300000
ORDER BY A.Title ASC;

-- 12. List all tracks that have never been purchased.
SELECT T.Name FROM Track T
LEFT JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
WHERE IL.TrackId IS NULL;

-- This query shows that 1519 tracks have never been purchased by the customers.

-- 13. List the billing countries whose total sales are above the average total sales per country.
SELECT BillingCountry, SUM(Total) as TotalPerCountry FROM Invoice
GROUP BY BillingCountry
HAVING TotalPerCountry > (
    SELECT SUM(Total) / COUNT(DISTINCT BillingCountry) FROM Invoice
)
ORDER BY TotalPerCountry DESC;

-- Only 6 countries registered total sales greater than the average total sales: USA with $523.06, Canada, France, Brazil, Germany and UK with $112.86. The average is $97.03.

-- 14. List all tracks priced above the average price of tracks in their own genre.
SELECT T.Name, T.UnitPrice, G.Name FROM Track T
INNER JOIN Genre G ON T.GenreId = G.GenreId
WHERE T.UnitPrice > (
    SELECT AVG(T2.UnitPrice)
    FROM Track T2
    WHERE T2.GenreId = T.GenreId
)
ORDER BY T.UnitPrice DESC;

-- 214 tracks have a price greater than the average price per genre they are labeled on. Each track in the list has a price of $0.99.

-- 15. Display music genres that have more than 100 tracks in total.
SELECT G.Name, COUNT(T.TrackId) FROM Genre G
INNER JOIN Track T ON G.GenreId = T.GenreId
GROUP BY G.GenreId
HAVING COUNT(T.TrackId) > 100;

-- Out of 25 music genres the store has, 5 genres have more than 100 tracks. The most tracks are Rock, 1297, while the least tracks are Jazz, 130.

-- 16. For each customer, display their name, total amount spent, and their RANK based on how much they spent, in descending order.
SELECT CONCAT(C.FirstName, " ", C.LastName) AS FullName, SUM(I.Total) AS TotalSpent,
RANK() OVER(ORDER BY SUM(I.Total) DESC) AS Rank FROM Customer C
INNER JOIN Invoice I ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId
ORDER BY TotalSpent DESC;

-- This query creates a ranking of customers that spent the most money on products from the store. The client that spent the most money is Helena Holý, who paid $49.62 for her products, 
--while at the bottom of the list is Puja Srivastava, who spent $36.64. There are customers who spent the same amount. For example, Ladislav Kovács and Hugh O'Reilly are both on fourth
--place in this ranking, with $45.62, and Frank Ralston, Julia Barnett and Fynn Zimmermann are on the sixth place, each of them paying $43.62.

-- 17. Display the second longest track.
SELECT Name, Milliseconds FROM Track
ORDER BY Milliseconds DESC
LIMIT 1 OFFSET 1;

-- 18. Display the fifth highest distinct invoice total.
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS FullName, I.Total FROM Customer C
INNER JOIN Invoice I ON C.CustomerId = I.CustomerId
WHERE I.Total = (
    SELECT DISTINCT Total FROM Invoice
    ORDER BY Total DESC
    LIMIT 1 OFFSET 4
);

-- 19. Display the third youngest employee by birth date.
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, BirthDate FROM Employee
ORDER BY BirthDate DESC
LIMIT 1 OFFSET 2;

-- 20. Display the album with the sixth longest total duration.
SELECT A.Title, SUM(T.Milliseconds) FROM Album A
INNER JOIN Track T ON A.AlbumId = T.AlbumId
GROUP BY A.AlbumId
ORDER BY SUM(T.Milliseconds) DESC
LIMIT 1 OFFSET 5;
