# WINDOW Function practice-:

-- To see what %, the specific customer shares in total sales
select sum(amount) from expenses; #65800

select *, amount*100/sum(amount) over() as pct
from expenses
order by category;

-- To see what %, the specific customer shares category wise
select sum(amount) from expenses where category='Food'; # 11800

select *, amount*100/sum(amount) over(partition by category) as pct
from expenses
order by category;

-- Suppose client want to see the cumulative sum of amount, means like how much was the expense for each given date
select *, sum(amount) over(partition by category order by date) as expense_on_date
from expenses
order by category,date;

# WINDOW Function uses in our ATLIQ project
-- Task4
with cte1 as (
select c.customer, round(sum(net_sales)/1000000,2) as net_sales_in_millions
	from net_sales as n
	inner join dim_customer as c on
	c.customer_code= n.customer_code
	where n.fiscal_year= 2021
	group by c.customer
	)
select *, net_sales_in_millions*100/sum(net_sales_in_millions) over() as pct_net_sales
from cte1
order by net_sales_in_millions desc ;
-- It gave us the report which we exported and saved as a excel and further went on to create a bar plot.

-- Task5
with cte2 as (
select c.customer, c.region, round(sum(net_sales)/1000000,2) as net_sales_in_millions
	from net_sales as n
	inner join dim_customer as c on
	c.customer_code= n.customer_code
	where n.fiscal_year= 2021 # and c.region='APAC'
	group by c.customer, c.region )
    
select customer, region, net_sales_in_millions*100/sum(net_sales_in_millions) over( partition by region) as pct_net_sales
from cte2
order by region, pct_net_sales desc;

-- or second way is to give where n.fiscal_year=2021 and c.region='APAC' and in place of over(partition by region) only over() and keep on
-- changing the regions manually
select customer, region, net_sales_in_millions*100/sum(net_sales_in_millions) over() as pct_net_sales
from cte2
order by pct_net_sales desc;
-- It gave us the report which we exported and saved as a excel and further went on to create a Pie Chart. Also created
-- stored procedure called 'get_%_net_sales_of_customers_per_region'


-- Using row_number(), rank(), dense_rank() in our 'random_tables' database
select *, row_number() over(partition by category order by amount) as rn, -- give different rank according to order by statment, 
--        even for same values
		  rank() over(partition by category order by amount) as rnk, -- give same rank for same values but skips next rank
          dense_rank() over(partition by category order by amount) as drnk -- gives same rank for same values and do not skip ranks
from expenses;

select *, row_number() over (order by marks) as rn,
		rank() over(order by marks) as rnk,
		dense_rank() over(order by marks) as drnk
from student_marks;


-- Using these in our gdb041 database, 
-- Task6
with cte1 as (
	select p.division, p.product, sum(s.sold_quantity) as total_quantity 
	from dim_product as p
	inner join fact_sales_monthly as s on
	p.product_code= s.product_code
    where s.fiscal_year=2021
	group by p.division, p.product),
    
    cte2 as (
		select *, dense_rank() over(partition by division order by total_quantity desc) as rn
		from cte1
    )
    
select * from cte2 
where rn<=3;
-- Got the required output, also created stored procedure called 'get_top_n_products_per_division_by_qty_sold'

-- Task7
with cte1 as (
		select c.market, c.region, sum(gross_price_total)/1000000 as gross_sales_mln
        from gross_sales as g
        inner join dim_customer as c on
        g.customer_code=c.customer_code
        where g.fiscal_year=2021
        group by c.market, c.region
        order by gross_sales_mln desc
        ),
cte2 as (
	select *, dense_rank() over(partition by region order by gross_sales_mln desc) as rnk
	from cte1 )
    
select * from cte2
where rnk<=2;





