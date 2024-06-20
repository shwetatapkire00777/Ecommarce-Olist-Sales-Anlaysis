create database P2OLIST;
use P2OLIST;
SELECT @@secure_file_priv;

create table customers (
	customer_id varchar(250) NOT NULL,
    customer_unique_id varchar(250) NOT NULL,
    customer_zip_code_prefix int,
    customer_city varchar(250),
    customer_state varchar(20)
);

LOAD DATA INFILE 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_customers_dataset.csv' 
INTO TABLE  customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from customers;

create table geolocation(
	geolocation_zip_code_prefix int not null,
    geolocation_lat decimal(12,8)signed,
    geolocation_lng decimal(12,8)signed,
    geolocation_city varchar(250),
    geolocation_state varchar(20)
    
);

LOAD DATA INFILE 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_geolocation_dataset.csv' 
INTO TABLE  geolocation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from geolocation;

create table order_items(
	order_id varchar(250) not null,
    order_item_id int not null,
    product_id varchar(250) not null,
    seller_id varchar(250) not null,
    shipping_limit_date datetime,
    price decimal(10, 2),
    freight_value decimal(10, 2)
);

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_order_items_dataset.csv'
into table order_items
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from order_items;

create table order_payments (
	order_id varchar(250) not null,
    payment_sequential int,
    payment_type varchar(250) not null,
    payment_installments int,
    payment_value decimal (10, 2)
);

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_order_payments_dataset.csv'
into table order_payments
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from order_payments;

create table order_reviews (
	review_id varchar (50) not null,
    order_id varchar (50) not null,
    review_score smallint,
    review_creation_date varchar(50) ,
    review_answer_timestamp varchar(50) 
);
ALTER TABLE order_reviews
modify review_score INT(10);
drop table order_reviews;
 
load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_order_reviews_edit.csv'
into table order_reviews
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

 select * from order_reviews;
 
 create table orders (
	order_id varchar (250) not null,
    customer_id varchar (250) not null,
    order_status varchar (250),
    order_purchase_timestamp datetime not null,
    order_approved_at varchar (250) ,
    order_delivered_carrier_date varchar (250),
    order_delivered_customer_date varchar (250),
    order_estimated_delivery_date varchar (250)
);

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_orders_dataset.csv'
into table orders
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from orders;

create table products (
	product_id varchar (250) not null ,
    product_category_name varchar (250) ,
    product_name_lenght varchar (250),
    product_description_lenght varchar(250) ,
    product_photos_qty varchar(250) ,
    product_weight_g varchar(250) ,
    product_length_cm varchar (250),
    product_height_cm varchar (250),
    product_width_cm varchar (250)
);

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_products_dataset.csv'
into table products
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows ;


select * from products;

create table sellers (
	seller_id varchar (250) not null ,
    seller_zip_code_prefix int not null,
    seller_city varchar (250) not null,
    seller_state varchar (250) not null
);

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/olist_sellers_dataset.csv'
into table sellers
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows ;


select * from sellers ;

create table product_category_name_translation (
	product_category_name varchar (250) not null,
    product_category_name_english varchar (250)
) ;

load data infile 'C:/ExcelR/Project-23-02-24/Project-2-P469 - E-commerce Analytics-04-04-24/Received- E-commerce Analytics/product_category_name_translation.csv'
into table product_category_name_translation
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows ;

select * from product_category_name_translation ;

-- -------------------------------------1st KPI------------------------------------------
CREATE TABLE KPI1
SELECT
case
when DAYOFWEEK(order_purchase_timestamp) in (1, 7) then 'Weekend'
else 'Weekday'
end as DayType,
round(sum(op.payment_value),2) as Total_Payment
from orders o
join order_payments op on o.order_id = op.order_id
group by DayType
order by
daytype;
select * from KPI1;

-- ------------------------------------------KPI 2--------------------------------
select * from order_reviews;
select * from order_payments;
CREATE TABLE KPI2
select count(*) as Number_Of_Orders, review_score
from order_reviews o
join order_payments p ON o.order_id = p.order_id
WHERE o.review_score = 5
AND p.payment_type = 'credit_card';
select * from KPI2;
DROP TABLE KPI2;

-- ---------------------------------------KPI 3----------------------------------------------

select * from orders;
select * from products;
select* from order_items;
CREATE TABLE KPI3
(
	Average_no_of_days_for_pet_shop float4
    );
SELECT round(AVG(DATEDIFF(orders.order_delivered_customer_date, orders.order_purchase_timestamp)),2) AS Average_no_of_days_for_Pet_shop
FROM orders AS orders
JOIN order_items AS order_items ON orders.order_id = order_items.order_id
JOIN products AS products ON order_items.product_id = products.product_id
WHERE products.product_category_name = 'pet_shop';

select * from KPI3;
DROP TABLE KPI3;

-- ---------------------------------------------------KPI 4-------------------------------------------
select * from customers;
select * from order_payments;
select * from order_items;

SELECT
round(avg(order_items.price),2) as average_price,
round(avg(order_payments.payment_value),2) as average_payment_value

from order_items as order_items
join order_payments as order_payments
on order_items.order_id = order_payments.order_id
join orders as orders
on order_items.order_id = orders.order_id
join customers as customers
on orders.customer_id = customers.customer_id
where customers.customer_city = 'Sao Paulo';

-- ---------------------------------------------------KPI 5-------------------------------------------

select * from orders;
select * from order_reviews;

select
round(avg(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)),0) as avg_shipping_days,
round(avg (r.review_score)) as avg_review_score
from orders o
join order_reviews as r
on o.order_id = r.order_id
group by
r.review_score
order by 
r.review_score  ;

-- ---------------------------------------------------CUSOM KPI -------------------------------------------

-- top 5 product categories most ordered by customers
create table KPI8
WITH customer_products AS 
(
SELECT product_category_name_english,order_item_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation ps ON ps.product_category_name = p.product_category_name
)
SELECT product_category_name_english, SUM(order_item_id) AS units
FROM customer_products
GROUP BY product_category_name_english
ORDER BY units DESC
LIMIT 5;

SELECT * FROM KPI8;

-- top 5 product categories based on ratings

create table KPI9
WITH cust_products AS 
(
SELECT product_category_name_english,
review_score,
o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
JOIN order_reviews cc ON cc.order_id= oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation ps ON ps.product_category_name = p.product_category_name
)
SELECT product_category_name_english,
round(avg(review_score),2) as rating
FROM cust_products
GROUP BY 1
ORDER BY rating DESC
LIMIT 5;

SELECT * FROM KPI9;

-- bottom 5 product categories least ordered by customers

create table KPI10
WITH customer_products AS 
(
SELECT product_category_name_english,order_item_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation ps ON ps.product_category_name = p.product_category_name
)
SELECT product_category_name_english, SUM(order_item_id) AS units
FROM customer_products
GROUP BY product_category_name_english
ORDER BY units
LIMIT 5;
SELECT * FROM KPI10;

-- bottom 5 product categories based on ratings

create table KPI11

WITH cust_products AS 
(
SELECT product_category_name_english,
review_score,
o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
JOIN order_reviews cc ON cc.order_id= oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation ps ON ps.product_category_name = p.product_category_name
)
SELECT product_category_name_english,
round(avg(review_score),2) as rating
FROM cust_products
GROUP BY 1
ORDER BY rating
LIMIT 5;
SELECT * FROM KPI11;
