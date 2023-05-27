.open restaurant.db

DROP TABLE menus;
DROP TABLE orders_details;
DROP TABLE customers ;
DROP TABLE cashier;
DROP TABLE crew;



.mode column
.header on
.mode box 
  -- เป็นตาราง


-- table 1 menus

  CREATE TABLE menus (
	menu_Id INT UNIQUE,   
	menu_Name TEXT,
  menu_time TEXT,
  price REAL
  ); 

insert into menus values
  (1, 'pad Thai','breakfast',50),
  (2, 'hotdog','dinner',100),
  (3,'fire Rice','lunch', 85),
  (4, 'water', "drink",15),
  (5, "sausages fried rice", "dinner",120),
  (6, "salmon steak", "dinner",150),
  (7, "fried chicken", "breakfast",35),
  (8, "rice and curry", "lunch",75),
  (9,"pizza","lunch",100),
  (10,"coke", "drink",12);



--select * 
--FROM menus; 

  
-- table 2 orders_details

CREATE TABLE orders_details (
	order_Id INT UNIQUE,   -- เลขที่บิล
	menu_Id INT,           -- เมนูไอดี
	order_Date DATE,       -- วันที่สั่งอาหาร
  quantity REAL,         -- จำนวน 
  cashier_Id INT,        -- จุดชำระ
  seat REAL);            -- จำนวนที่นั่ง

INSERT INTO orders_details VALUES
(1,2,"2023-01-17",8,1,5),
(2,1,"2023-01-05",9,1,7),
(3,3,"2023-01-10",10,2,10),
(4,7,"2023-01-10",8,3,4),
(5,6,"2023-01-09",28,3,20),
(6,5,"2023-01-11",6,3,3),
(7,4,"2023-01-06",8,2,4),
(8,8,"2023-01-03",2,1,2),
(9,9,"2023-01-04",1,2,1),
(10,3,"2023-01-02",5,1,3);

--select *
--from orders_details ; 


-- table 3 customers

CREATE TABLE customers (
  cust_Code INT UNIQUE,
  order_Id INT,
  cust_Name TEXT,
  cust_Provice TEXT,
  cust_DOB DATE );

INSERT INTO customers VALUES
(1,2,"Tom","Bangkok","1985-09-27"),
(2,4,"Jang","Rayong","1989-10-22"),
(3,8,"Pong","Phichit","2000-06-08"),
(4,3,"Piti","Uttaradit","1965-11-13"),
(5,7,"Bug","Phra Nakhon Si Ayutthaya","1989-04-09"),
(6,5,"Tong","Nakhon Ratchasima","1997-09-09"),
(7,4,"Benz","Bangkok","1999-06-19"),
(8,5,"Aof","Kalasin","1987-12-12"),
(9,6,"Oom","Nakhon Si Thammarat","1995-11-12"),
(10,10,"Gig","Bangkok","2000-20-02");


--select *
--from customers ;


--table 4 cashier

CREATE TABLE cashier (
cashier_Id INT UNIQUE,
cashier_name TEXT,
payment TEXRT);


INSERT INTO cashier VALUES
(1,"Arthur","credit crad"),
(2,"Brooke","internet banking"),
(3,"Braelyn","Cash"); 

--select * 
--FROM cashier; 


-- table 5 crew

CREATE TABLE crew (
  crew_id int unique,
  cashier_Id int,
  crew_name text,
  crew_commission int
  );

  insert into crew values 
  (1,1,"Bang",450),
  (2,2,"Toon",600),
  (3,3,"Tum",800),
  (4,1,"Sang",500),
  (5,3,"Dang",100),
  (6,2,"Soon",175);


--select *
--from crew;


--5 tables
--write 3-5 queries
--1x WITH
--1x SUBQUERY
--1x aggregate 


-- 1. หาประเภทอาหารที่ขาย และจัดกลุ่มตามมื้ออาหาร 


.print " TABLE : หาประเภทอาหารที่ขาย และจัดกลุ่มตามมื้ออาหาร "


  
select 
  menu_time as time, 
  sum(price) as price,
  count(menu_Name) as NumMenus
from menus
group by 1
order by price desc;


--2. แสดงรายชื่อของลูกค้า ที่เกิดหลัง ปี 1999 และจัดกลุ่มลูกค้าต่างจังหวัด
.print " TABLE : แสดงรายชื่อของลูกค้า ที่เกิดหลัง ปี 1999 และจัดกลุ่มลูกค้าต่างจังหวัด "
select 
  cust_code,
  cust_name,
  cust_provice,
  strftime('%Y',cust_DOB) AS year
from customers
where year > "1990"    --and cust_name like 'p%' 
order by year desc;


  
-- 3 ในใบเสร็จลูกค้าสั่งอะไรบ้างมาจากจังหวัดไหน และเป็นลูกค้ากลุ่มใดไหน 
.print "ในใบเสร็จลูกค้าสั่งอะไรบ้างมาจากจังหวัดไหน และเป็นลูกค้ากลุ่มใดไหน"
select 
  orders_details.order_id,
  customers.cust_name,
  orders_details.seat,
  menus.menu_Name,
  customers.cust_Provice as provice,
   case
      WHEN customers.cust_Provice = 'Bangkok' then 'centre'
      else 'other'
     end as 'segment' 
from orders_details 
join menus on orders_details.menu_Id = menus.menu_Id
join customers on orders_details.order_Id = customers.order_Id  
ORDER BY 1 ;


-- 4 aggregate order
.print "หา Insight เมนูประเภทต่างๆ ตามช่วงเวลา "
select
  menu_time,
  count(menu_name) as numproduct,
  sum(price) as total_price,
  max(price) as MAX,
  min(price) as MIN,
  round(avg(price), 2) as AVG_price
from menus
group by 1
order by 6,2,3,4,5  DESC ; 


-- 5 with

WITH aggregate as (
  select
  menu_time,
  count(menu_name) as numproduct,
  sum(price) as total_price,
  max(price) as MAX,
  min(price) as MIN,
  round(avg(price), 2) as AVG
from menus
group by 1
order by 6,2,3,4,5  DESC)

select *
from aggregate
where AVG > 45;


-- 6 sub Q    ใครรับลูกค้ามากสุดที่กี่ที่นั่ง/จ่ายตังที่ใคร/เป็นประเภทใด / ได้ค่าคอมเท่าไหร่
.print "ใครรับลูกค้ามากสุดที่กี่ที่นั่ง/จ่ายตังที่ใคร/เป็นประเภทใด / ได้ค่าคอมเท่าไหร่ "
select 

  crew_name,
  cashier_name,
  payment,
  sum(crew_commission) as total_comm,
  sum(seat) as total_cust
  from (
        select * 
          from menus
          join orders_details on menus.menu_id =                                         orders_details.menu_id 
          join customers on orders_details.order_id =                                    customers.order_id
          join cashier on orders_details.cashier_id =                                     cashier.cashier_id
          join crew on cashier.cashier_id  = crew.cashier_id
  
)
group by crew_name,cashier_name
order by total_comm,total_cust desc ;






  
  
