--bai 1
with job_count_table as
(select 
company_id, 
title,
description,
count(job_id) as job_count
from job_listings
group by company_id, title, description)

select COUNT(DISTINCT(company_id)) from job_count_table
where job_count >1

--bai2: bài này em mới ra kết quả của tất cả các sản phẩm và category có total_spend cao nhất thôi chứ chưa limit được mỗi category 2 cái total_spend cao nhất ạ
-- identify the two top highest-grossing product within each category in 2022
with fiter_table as
(SELECT category,
product,
sum(spend) as total_spend
from product_spend
where extract(year from transaction_date)=2022
group by category, product) 


select DISTINCT(a.category), a.product,
MAX(b.total_spend)
from product_spend as a 
JOIN fiter_table as b on a.category=b.category
GROUP BY DISTINCT(a.category), a.product

--bai3

with count_table as
(select policy_holder_id,
COUNT(case_id) as count_call
FROM callers
group by policy_holder_id)

select count(policy_holder_id) from count_table
WHERE count_call>=3

--bai4
With filter_table as
(SELECT a.page_id, a.page_name, liked_date
from pages as a
LEFT JOIN page_likes as b
on a.page_id=b.page_id)

select page_id
from filter_table
where liked_date is NULL
group by page_id

hoac 

SELECT a.page_id FROM pages as a 
LEFT JOIN page_likes as b
on a.page_id=b.page_id
where b.liked_date is NULL
order by a.page_id

--bai 5
SELECT 
EXTRACT(MONTH FROM a.event_date) as mth,
COUNT(DISTINCT a.user_id) as monthly_active_users
from user_actions as a    
WHERE EXISTS
(SELECT b.user_id
from user_actions as b
WHERE b.user_id=a.user_id
AND EXTRACT(MONTH FROM b.event_date) = EXTRACT(MONTH FROM a.event_date - interval '1month')
)
AND EXTRACT(MONTH FROM a.event_date) = 7
AND EXTRACT(YEAR FROM a.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM a.event_date);

--bai6 
select left(trans_date,7) as month,
country,
count(amount) as trans_count,
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from Transactions
group by month,country;


-bai7: 

SELECT 
product_id, 
year as first_year,
quantity,
price
  FROM sales 
where 
 (product_id, year) in 
   (SELECT 
    product_id, min(year)
    from sales 
    group by product_id)

--bai 8: 
WITH filter_table as
(SELECT a.customer_id,
b.product_key from Customer as a 
RIGHT JOIN Product as b on a.product_key=b.product_key)
select DISTINCT customer_id from filter_table
group by customer_id
having COUNT(DISTINCT product_key) = (select count(product_key) from product)

--bai 9 
WITH filter_table as
(SELECT 
employee_id,
name,
manager_id,
salary from employees
where salary<30000)

SELECT 
employee_id
from filter_table
where manager_id not in (select distinct employee_id from employees)
order by employee_id

--bai10
With filter as 
(SELECT
 count(job_id) as trung_lap, 
 company_id,
 title,
 description 
 from job_listings
 group by company_id,title,description)
 
SELECT COUNT(company_id) from filter
where trung_lap >= 2

--bai11: 

WITH filter_table as
(SELECT 
c.name,
COUNT(rating) AS rating_fromuser
from movies as a 
JOIN MovieRating as b on a.movie_id=b.movie_id
JOIN Users as c on c.user_id=b.user_id
group by c.name
ORDER BY COUNT(rating) DESC, c.name
LIMIT 1),

filter2 as 
(SELECT 
a.title,
AVG(b.rating) AS rating_movie
from movies as a 
JOIN MovieRating as b on a.movie_id=b.movie_id
JOIN Users as c on c.user_id=b.user_id
where b.created_at  between '2020-02-01' and '2020-02-29'
GROUP BY a.title
ORDER BY AVG(b.rating) DESC, a.title
LIMIT 1)

SELECT name as results from filter_table
UNION ALL
SELECT title from filter2

--bai12
with 
filter1 as
(select requester_id as id,
count(*) as num from RequestAccepted
group by requester_id),

filter2 as 
(select accepter_id as id,
count(*) as num from RequestAccepted
group by accepter_id), 

filter3 as 
(select id, num from filter1
UNION ALL
select id, num from filter2)

SELECT id, SUM(num) as num
from filter3
group by id
order by num DESC
LIMIT 1;

