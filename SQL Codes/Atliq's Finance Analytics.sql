-- Month
-- Product
-- Variant
-- Sold Quality
-- Gross Price Per Item
-- Gross Price Total

-- Fiscal Year and Month (We created function called 'get_fiscal_year' assuming
-- fiscal year starts from 01/Sep) Below we are just filtering the data by giving diff Quarter

-- Below query gives Month and Sold Quanity
select * from fact_sales_monthly 
where
	customer_code=90002002 and 
    get_fiscal_year(date) = 2021-01-01 and
    get_fiscal_quarter(date)= "Q4"
order by date desc;
-- 9,10,11-> Q1
-- 12,1,2-> Q2
-- 3,4,5-> Q3
-- 6,7,8-> Q4

-- Below query gives Product & Variant
select s.date, s.product_code, p.product, p.variant, s.sold_quantity
from fact_sales_monthly as s
inner join dim_product as p
on p.product_code= s.product_code;

-- Below query gives Gross Price Per Item
select s.date, s.product_code, p.product, p.variant, s.sold_quantity, g.gross_price
from fact_sales_monthly as s
inner join dim_product as p
on p.product_code= s.product_code
inner join fact_gross_price as g
on g.product_code= s.product_code and g.fiscal_year= get_fiscal_year(s.date)
where
	customer_code=90002002 and 
    get_fiscal_year(date) = 2021
order by date desc;

-- Below query gives Gross Price Total
select s.date, s.product_code, p.product, p.variant, s.sold_quantity, g.gross_price, 
round(s.sold_quantity*g.gross_price,2) as gross_price_total
from fact_sales_monthly as s
inner join dim_product as p
on p.product_code= s.product_code
inner join fact_gross_price as g
on g.product_code= s.product_code and g.fiscal_year= get_fiscal_year(s.date)
where
	customer_code=90002002 and 
    get_fiscal_year(date) = 2021
order by date desc;

-- Month, Total gross sales amount to Croma India in this month
select s.date, sum(g.gross_price*s.sold_quantity) as gross_price_total  
from fact_sales_monthly as s
inner join fact_gross_price g on
g.product_code=s.product_code and g.fiscal_year= get_fiscal_year(s.date)
where customer_code= 90002002
group by s.date
order by s.date asc;

-- Yearly Report for Croma India with :- Fiscal Year, Total Gross Sales amount In that year from Croma
select get_fiscal_year(s.date) as Fiscal_Year, sum(s.sold_quantity*g.gross_price) as total_gross_sales
from fact_sales_monthly as s
inner join fact_gross_price as g on
s.product_code= g.product_code and g.fiscal_year= get_fiscal_year(s.date)
where s.customer_code= 90002002
group by get_fiscal_year(s.date)
order by get_fiscal_year(s.date);
