-- Books Table
drop table if exists Books;
create table if not exists Books(
Book_ID	SERIAL PRIMARY KEY,
Title	VARCHAR(100),
Author	VARCHAR(100),
Genre	VARCHAR(50),
Published_Year	INT,
Price	NUMERIC(10,2),
Stock	INT
)
-- Customers table
drop table if exists Customers;
create table if not exists Customers(
Customer_ID	SERIAL PRIMARY KEY,
Name	VARCHAR(100)	,
Email	VARCHAR(100)	,
Phone	VARCHAR(15)	,
City	VARCHAR(150),	
Country	VARCHAR(150)	

)

-- Orders table
drop table if exists Orders;
create table if not exists Orders(

Order_ID	SERIAL PRIMARY KEY,
Customer_ID	INT REFERENCES Customers(Customer_ID),
Book_ID	INT REFERENCES Books(Book_Id),
Order_Date	DATE,
Quantity	INT,
Total_Amount	NUMERIC(10,2)
)



-- import data of books
 copy Books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price,	Stock)
from 'C:\Users\javed\OneDrive\Desktop\Online Book Store\Books.csv'
csv header;

-- import data of Customers
copy Customers(Customer_ID,	Name,	Email,	Phone,	City,	Country)
from 'C:\Users\javed\OneDrive\Desktop\Online Book Store\Customers.csv'
csv header

-- import data of Orders
copy Orders(Order_ID,	Customer_ID	,Book_ID,	Order_Date,	Quantity,	Total_Amount
)
from 'C:\Users\javed\OneDrive\Desktop\Online Book Store\Orders.csv'
csv header;

-- data of three tables
SELECT * FROM BOOKS;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1 retrive all books in "fiction " genre
select * from Books
where genre ='Fiction';

-- 2 find books published after the year 1950
select * from Books
where published_year>1950
order by published_year desc;

-- 3 list of all cutomers form the canada
select customer_id, name,city, country from Customers
where country ='Canada';

-- 4 show order placed in nov 2023
select * from Orders
where order_date between '2023-11-01' and '2023-11-30';


--5 retrive the total stock of books available
select sum(stock) as total_stock from Books;

-- 6 Find the detials of the most expensive books
select * from books
order by price desc
limit 5;

-- 7 show all customers who ordered more than 1 quantity of books
select * from Customers as c
join Orders as o on c.Customer_id=o.Customer_id
where quantity>1;

--  8 retrive all orders where the total count exceeds $20;
select * from orders 
where total_amount>20
order by total_amount desc;


-- 9 list all genres available in the books tables

select distinct genre from books;

-- 10 find the book with the lowest stock
select * from books
where stock<10;
-- or
select * from books
order by stock
limit 10;

-- 11 calcualted the total revenue generated from all orders
select sum(total_amount) as revenue from orders;

-- second periods of queries 

SELECT * FROM BOOKS;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Retrive the total number of books sold for each genre...
select b.genre,sum(quantity)as sold from Books as b
join Orders as o on b.book_id=o.book_id
group by b.genre
order by sold ;


-- average price of the books of "fantast " genre
select genre, avg(price)as avg_price_of_fantasy
from Books
where genre = 'Fantasy'
group by genre;

-- list customers who have placed at least two orders
select c.customer_id,c.name ,count(o.order_id)  from customers as c
join orders as o on c.customer_id=o.customer_id
group by c.customer_id
having  count(o.order_id)>=2;


-- find the most frequently orders books;
select o.book_id,b.title, count(o.order_id) as frequently from books as b
join orders as o on b.book_id=o.book_id
group by o.book_id,b.title
order by frequently desc
limit 10 ;

-- show the top 3 most expensive books of "fantasy" Genre?
SELECT title, author, price
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- retrieve the total quantity of books sold by each author
select b.author,sum(quantity)as sold from Books as b
join Orders as o on b.book_id=o.book_id
group by b.author
order by sold desc;

-- 
SELECT * FROM BOOKS;
SELECT * FROM Customers;
SELECT * FROM Orders;
-- 
-- list the cities where customers who spent over $30 are located
select  distinct c.city,sum(o.total_amount) as spent from customers as c
join orders as o on c.customer_id=o.customer_id
group by  c.city
having sum(o.total_amount)> 460 ;

-- find the customers who spent the most on orders
select  c.customer_id, c.name, sum(o.total_amount) as spent from customers as c
join orders as o on c.customer_id=o.customer_id
group by c.customer_id, c.name
order by spent desc
limit 5;

-- calculate the stock remaining after fulfilling all orders;


select b.book_id, b.title, b.stock, coalesce( sum(o.quantity),0) as sold_quantity,
b.stock-coalesce( sum(o.quantity),0) as remaining_stock
from books as b
left join orders as o on b.book_id=o.book_id
group by b.book_id;