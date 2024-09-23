
select * from fact
SELECT COUNT(DISTINCT(month(Transaction_Date))) AS distinct_transaction_dates
FROM fact;
--BUOC 1: tinh thang mua hang dau tien cua CustomerID
with raw1 as(
select CustomerID, min(month(Transaction_Date)) as fist_month from fact
where year(Transaction_Date) = 2019
group by CustomerID),
--BUOC 2: join lay thong tin month(Transaction_Date) va fist_month theo customerID
raw2 as(
select CustomerID, month(Transaction_Date) as order_month from fact
where year(Transaction_Date) = 2019),
final_table as(
select distinct a.CustomerID, fist_month, order_month, order_month - fist_month as month_diff from raw1 a
left join raw2 b 
on a.CustomerID = b.CustomerID),
--select * from final_table
--order by CustomerID
--BUOC 3:tao bang cohort so retained customer theo month
retained_table as(
select fist_month, count(distinct CustomerID) as number_of_user,
COUNT(CASE WHEN month_diff = 0 then CustomerID END) month_0,
COUNT(CASE WHEN month_diff = 1 then CustomerID END) month_1,
COUNT(CASE WHEN month_diff = 2 then CustomerID END) month_2,
COUNT(CASE WHEN month_diff = 3 then CustomerID END) month_3,
COUNT(CASE WHEN month_diff = 4 then CustomerID END) month_4,
COUNT(CASE WHEN month_diff = 5 then CustomerID END) month_5,
COUNT(CASE WHEN month_diff = 6 then CustomerID END) month_6,
COUNT(CASE WHEN month_diff = 7 then CustomerID END) month_7,
COUNT(CASE WHEN month_diff = 8 then CustomerID END) month_8,
COUNT(CASE WHEN month_diff = 9 then CustomerID END) month_9,
COUNT(CASE WHEN month_diff = 10 then CustomerID END) month_10,
COUNT(CASE WHEN month_diff = 11 then CustomerID END) month_11
from final_table
group by fist_month)
--order by fist_month

--BUOC 4: tinh bang % retaied customer theo month previous_month
select fist_month,
cast(month_0 as float)/month_0 as month_0,
round(CASE WHEN month_0 <> 0 then cast(month_1 as float)/month_0 END,2) as month_1,
round(CASE WHEN month_1 <> 0 then cast(month_2 as float)/month_1 END,2) as month_2,
round(CASE WHEN month_2 <> 0 then cast(month_3 as float)/month_2 END,2) as month_3,
round(CASE WHEN month_3 <> 0 then cast(month_4 as float)/month_3 END,2) as month_4,
round(CASE WHEN month_4 <> 0 then cast(month_5 as float)/month_4 END,2) as month_5,
round(CASE WHEN month_5 <> 0 then cast(month_6 as float)/month_5 END,2) as month_6,
round(CASE WHEN month_6 <> 0 then cast(month_7 as float)/month_6 END,2) as month_7,
round(CASE WHEN month_7 <> 0 then cast(month_8 as float)/month_7 END,2) as month_8,
round(CASE WHEN month_8 <> 0 then cast(month_9 as float)/month_8 END,2) as month_9,
round(CASE WHEN month_9 <> 0 then cast(month_10 as float)/month_9 END,2) as month_10,
round(CASE WHEN month_10 <> 0 then cast(month_11 as float)/month_10 END,2) as month_11
from retained_table
order by fist_month
