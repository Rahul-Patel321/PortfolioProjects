
--In this project we explore a sales dataset and generate various 
--analytics and insights from customers' past purchase behavior.


--Inspecting data
select *
from PortfolioProject..sales_data_sample

--checking unique values
select distinct STATUS
from sales_data_sample

select distinct YEAR_ID
from sales_data_sample

select distinct PRODUCTLINE
from sales_data_sample

select distinct COUNTRY
from sales_data_sample

select distinct DEALSIZE
from sales_data_sample

select distinct TERRITORY
from sales_data_sample


--ANALYSIS
---Grouping the sales by country 
select COUNTRY,
sum(SALES) as Total_sales
from sales_data_sample
group by COUNTRY
order by 2 desc


---Grouping the sales by Productline 
select PRODUCTLINE,
sum(SALES) as Total_sales
from sales_data_sample
group by PRODUCTLINE
order by 2 desc

---Grouping the sales by Year_id 
select YEAR_ID,
sum(SALES) as Total_sales
from sales_data_sample
group by YEAR_ID
order by 2 desc

---Grouping the sales by Territory 
select TERRITORY,
sum(SALES) as Total_sales
from sales_data_sample
group by TERRITORY
order by 2 desc

---Grouping the sales by Dealsize
select DEALSIZE,
sum(SALES) as Total_sales
from sales_data_sample
group by DEALSIZE
order by 2 desc

-- Looking at the distinct month id of each year 
select distinct MONTH_ID
from sales_data_sample
where YEAR_ID = '2003'

select distinct MONTH_ID
from sales_data_sample
where YEAR_ID = '2004'

select distinct MONTH_ID
from sales_data_sample
where YEAR_ID = '2005'

--By the above queries we got the information that in 2005 sales is lowest, 
--it may be beacause of they have operated only for 5 years in the year 2005  


--what was the best month for sale in the specific year,how much was earned that month?
select 
MONTH_ID,
COUNT(ORDERNUMBER) AS Total_orders,
SUM(SALES) as Total_Sales
from sales_data_sample
where YEAR_ID ='2003'
group by MONTH_ID
order by 2 desc

-- * In 2003 the best month for the sale is 11(November)


select 
MONTH_ID,
SUM(SALES) as Total_Sales
from sales_data_sample
where YEAR_ID ='2004'
group by MONTH_ID
order by 2 desc

-- * In 2004 the best month for the sale is 11(November)


select 
MONTH_ID,
SUM(SALES) as Total_Sales
from sales_data_sample
where YEAR_ID ='2005'
group by MONTH_ID
order by 2 desc

-- * In 2005 the best month for the sale is 5(May)


--November seems to be the month, what product do they sell in November
select 
PRODUCTCODE,
COUNT(PRODUCTCODE) AS Total_no_products_sold
from sales_data_sample
where YEAR_ID ='2003' and MONTH_ID = '11'
group by PRODUCTCODE
order by 2 desc


--Which product line they have used most 
select 
PRODUCTLINE,
COUNT(PRODUCTLINE) AS Total_no_productline
from sales_data_sample
where YEAR_ID ='2003' and MONTH_ID = '11'
group by PRODUCTLINE
order by 2 desc

--* From above we got the result that Classic Cars is the productline which they have used most of the time 


select *
from PortfolioProject..sales_data_sample



--Who is best customer ?
-- To calculate this we have to calculate the total sales of the individual customers and order it in 
-- decending order 

select CUSTOMERNAME,
COUNT(ORDERNUMBER) as Total_orders
from PortfolioProject..sales_data_sample
group by CUSTOMERNAME
order by COUNT(ORDERNUMBER) desc


select CUSTOMERNAME,
sum(SALES) as Total_sales_per_customer
from PortfolioProject..sales_data_sample
group by CUSTOMERNAME
order by COUNT(SALES) desc

-- Conc -> From the above queries we can see that Euro shopping channel is the best customer


-- Which city has the highest nummber of the sales in the specific country

select CITY,
sum(SALES) as Total_sales
from PortfolioProject..sales_data_sample
where COUNTRY = 'USA'-- by changing the country we can get the data for diffferent country
group by CITY
order by Total_sales desc


-- Which is the best product  in the United State 

select PRODUCTCODE,
COUNT(PRODUCTCODE) as Total_product_sold
from PortfolioProject..sales_data_sample
where COUNTRY = 'USA'
group by PRODUCTCODE
order by Total_product_sold desc

-- So, S18_3232 productcode is the best product in the USA









select *
from PortfolioProject..sales_data_sample

