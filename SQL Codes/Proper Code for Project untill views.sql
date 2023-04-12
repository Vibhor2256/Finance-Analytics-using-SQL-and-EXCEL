-- Chapter:- SQL Advanced: Top Customers, Products, Markets

-- Include pre-invoice deductions in Croma detailed report
	explain analyze
	SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity, g.gross_price as gross_price_per_item,
           ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total, pre.pre_invoice_discount_pct
	FROM fact_sales_monthly s
	INNER JOIN dim_product p
	ON s.product_code=p.product_code
	INNER JOIN fact_gross_price g
	ON g.fiscal_year=get_fiscal_year(s.date)
    AND g.product_code=s.product_code
	INNER JOIN fact_pre_invoice_deductions as pre
            ON pre.customer_code = s.customer_code AND
            pre.fiscal_year=get_fiscal_year(s.date)
	WHERE s.customer_code=90002002 AND get_fiscal_year(s.date)=2021     
	LIMIT 1000000;

-- Same report but all the customers
	Explain Analyze
	SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity, g.gross_price as gross_price_per_item,
           ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total, pre.pre_invoice_discount_pct
	FROM fact_sales_monthly s
	INNER JOIN dim_product p
	ON s.product_code=p.product_code
	INNER JOIN fact_gross_price g
	ON g.fiscal_year=get_fiscal_year(s.date)
    AND g.product_code=s.product_code
	JOIN fact_pre_invoice_deductions as pre
    ON pre.customer_code = s.customer_code AND
    pre.fiscal_year=get_fiscal_year(s.date)
	WHERE get_fiscal_year(s.date)=2021     
	LIMIT 1000000;
    
-- The above queries are taking too much time to calculate and output the results, so we need performance improvement.
/* Performance Management, as we're going to do lot of mathematical calculations ,joins, etc tasks it is going to get too much time to 
execute the query on the data, and one of the most problem was that we were calculating 'fiscal year' for each and every date in 
'fact_sales_monthly' which is a repetitive process and is taking lot of time, so what we did is we just added one column named 
'fiscal_year' using the date_add()formula and it gives fiscal year for every date and in fututure we're going to use that fiscal_year 
column whenever needed. */
SELECT * FROM fact_sales_monthly;
explain analyze
SELECT s.date, s.customer_code, s.product_code, p.product, p.variant, s.sold_quantity, g.gross_price as gross_price_per_item,
		ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total, pre.pre_invoice_discount_pct
	FROM fact_sales_monthly s
	INNER JOIN dim_product p
	ON s.product_code=p.product_code
	INNER JOIN fact_gross_price g
	ON g.fiscal_year=s.fiscal_year
	AND g.product_code=s.product_code
	INNER JOIN fact_pre_invoice_deductions as pre
	ON pre.customer_code = s.customer_code AND
	pre.fiscal_year=s.fiscal_year
	WHERE s.fiscal_year=2021     
	LIMIT 1500000;
-- Yes it did improve the performance

-- Now, client need Report for Top Markets (rank, market, net_sales(in millions) or revenue)
/* Gross Price-PreInvoice deduction= Net Invoice Sales & Net Invoice Sales-Post_invoice deductions= Net Sales.
As we know that derived column name can't be used in the select statement so we create a view out of the whole query and then use it. */

-- Creating the view `sales_preinv_discount` and store all the data in like a virtual table
CREATE  VIEW `sales_preinv_discount` AS
SELECT s.date, s.fiscal_year, s.customer_code, c.market, s.product_code, p.product, p.variant, s.sold_quantity, 
	   g.gross_price as gross_price_per_item, ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total, pre.pre_invoice_discount_pct
	FROM fact_sales_monthly s
	INNER JOIN dim_customer c 
	ON s.customer_code = c.customer_code
	INNER JOIN dim_product p
	ON s.product_code=p.product_code
	INNER JOIN fact_gross_price g
	ON g.fiscal_year=s.fiscal_year
	AND g.product_code=s.product_code
	INNER JOIN fact_pre_invoice_deductions as pre
	ON pre.customer_code = s.customer_code AND
	pre.fiscal_year=s.fiscal_year;

-- Now generate net_invoice_sales using the above created view "sales_preinv_discount"
SELECT *, (gross_price_total-pre_invoice_discount_pct*gross_price_total) as net_invoice_sales
FROM sales_preinv_discount;

-- Create a view for post invoice deductions: `sales_postinv_discount`
CREATE VIEW `sales_postinv_discount` AS
SELECT s.date, s.fiscal_year, s.customer_code, s.market, s.product_code, s.product, s.variant, s.sold_quantity, s.gross_price_total,
	   s.pre_invoice_discount_pct, (s.gross_price_total-s.pre_invoice_discount_pct*s.gross_price_total) as net_invoice_sales,
	   (post.discounts_pct+post.other_deductions_pct) as post_invoice_discount_pct
	FROM sales_preinv_discount s
	INNER JOIN fact_post_invoice_deductions post
	ON post.customer_code = s.customer_code AND
	post.product_code = s.product_code AND
	post.date = s.date;

-- Create a report for net sales
SELECT *, net_invoice_sales*(1-post_invoice_discount_pct) as net_sales
FROM sales_postinv_discount;

-- Finally creating the view `net_sales` which inbuiltly use/include all the previous created view and gives the final result
CREATE VIEW `net_sales` AS
SELECT *, net_invoice_sales*(1-post_invoice_discount_pct) as net_sales
FROM sales_postinv_discount;

-- Task 1: Now that we have net sales, we write query for top-n Market, net sales for a given year
explain analyze
select market, round(sum(net_sales)/1000000,2) as net_sales_in_millions
from net_sales
where fiscal_year= 2021
group by market
order by net_sales_in_millions desc
limit 5;
-- Its better to create a stored procedure called 'get_top_n_markets_by_net_sales'

-- Task 2: Now that we have net sales, we write query for top-n Product, net sales for a given year, Use product name without a variant.
select Product, round(sum(net_sales)/1000000,2) as net_sales_in_millions
from net_sales
where fiscal_year= 2021
group by Product
order by net_sales_in_millions desc
limit 5;
-- Creating a stored procedure called 'get_top_n_products_by_net_sales'

-- Task 3: Now that we have net sales, we write query for top-n Customers, net sales for a given year. No customer name in our 
-- net_sales view so we need to join dim.customer table
select c.customer, round(sum(net_sales)/1000000,2) as net_sales_in_millions
from net_sales as n
inner join dim_customer as c on
c.customer_code= n.customer_code
where n.fiscal_year= 2021
group by c.customer
order by net_sales_in_millions desc
limit 5;
-- Creating a stored procedure called 'get_top_n_customers_by_net_sales_by_market'





-- Excercise question, Create a view for gross sales. It should have the following columns, date, fiscal_year, customer_code,
-- customer, market, product_code, product, variant, sold_quanity, gross_price_per_item, gross_price_total

select * from net_sales;
create view `gross_sales` as
select s.date, s.fiscal_year, s.customer_code, c.customer, c.market, s.product_code, p.product, p.variant, s.sold_quantity, 
g.gross_price as gross_price_per_item, s.sold_quantity*g.gross_price as gross_price_total 
from fact_sales_monthly as s
inner join dim_product as p on
p.product_code= s.product_code
inner join fact_gross_price as g on
g.product_code= s.product_code and g.fiscal_year=s.fiscal_year
inner join dim_customer as c on
c.customer_code= s.customer_code;









 

