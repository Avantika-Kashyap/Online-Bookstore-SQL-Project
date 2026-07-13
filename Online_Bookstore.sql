DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
Customer_ID	SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),	
Country VARCHAR(150)
);
DROP TABLE IF EXISTS;
CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,	
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID	INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,	
Total_Amount NUMERIC(10,2)
);
SELECT*FROM Books;
SELECT*FROM Customers;
SELECT*FROM Orders;
COPY Books(Book_ID, Title, Author, Genre, Published_YEAR, Price, Stock)
FROM 'C:\Users\hp\Downloads\Books.csv'
CSV HEADER;
COPY Customer(Customer_ID, Name, Email,	Phone, City, Country)
FROM 'C:\Users\hp\Downloads\Customers.csv'
CSV HEADER;
COPY Orders(Order_ID, Customer_ID, Book_ID,	Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\hp\Downloads\Orders.csv'
CSV HEADER;
--QUERIES--
--Retrieves all books in the fiction genre--
SELECT*FROM Books
WHERE Genre='Fiction';
--Books Published after the year 1950--
SELECT*FROM Books
WHERE Published_YEAR>1950;
--List Customers from Canada--
SELECT*FROM Customers
WHERE Country='Canada';
--Orders placed in november 2023--
SELECT*FROM Orders
WHERE Order_date BETWEEN '2023-11-01'AND '2023-11-30'
--Retrieve the total stock of books available--
SELECT SUM(stock)AS Total_stock
FROM Books;
--details of the most expensive book--
SELECT*FROM Books ORDER BY price DESC
LIMIT 1;
--All customers who ordered more than 1 qantity of a book:
SELECT*FROM Orders
WHERE quantity>1;
--Retrives all orders where the totalamount exceeds $20:
SELECT*FROM Orders
WHERE total_amount>20;
--list all genes available in the books table:
SELECT DISTINCT genre FROM Books;
--book with lowest stock:
SELECT*FROM Books ORDER BY stock asc
LIMIT 1;
--Caculated the toal revenue generated fro all orders:
SELECT SUM(total_amount) AS Total_revenue
FROM Orders;
--ADVANCE QUERIES--
--retrieve the total no of books for each genre--
SELECT b.genre, SUM(o.quantity) AS Total_books_sold
FROM Orders o
JOIN Books b ON o.Book_id = b.Book_id
GROUP BY b.genre;
--average price of the books in fantasy genre--
SELECT  AVG(price)AS Fanstasy_avg_price FROM Books
WHERE genre = 'Fantasy';
--list customers who have placed atleast 2 orders--
SELECT customer_id, COUNT(Order_id) AS ORDER_COUNT
FROM Orders
GROUP BY customer_id
HAVING COUNT(Order_id)>=2;

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM Orders o
JOIN customer c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id)>=2;
--most frequently ordered book--
SELECT O.Book_id, b.Title, COUNT(o.order_id) AS ORDER_COUNT
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.Book_id, b.Title
ORDER BY ORDER_COUNT DESC
LIMIT 1;
--top 3 most expensive books--
SELECT*FROM Books ORDER BY price DESC
LIMIT 3;
--most expensive book from fantasy genre--
SELECT*FROM Books 
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;
--Total quantity of books sold by each author--
SELECT b.author, SUM(o.quantity) AS TOTAL_BOOKS_SOLD
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;
--the cities where customers who spent over $30 are located--
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30;
--customer who spent the most on orders--
SELECT c.customer_id, c.name, SUM(o.total_amount) AS TOTAL_SPENT
FROM Orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY TOTAL_SPENT DESC
LIMIT 1;
--Calculate the stock remaining after fulfilling all orders--
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS ORDER_QUANTITY, 
    b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;


























