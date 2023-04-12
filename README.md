# Finance-Analytics-using-SQL-and-EXCEL

# [Finance Analytics using SQL and EXCEL Portfolio](https://github.com/Vibhor2256/Finance-Analytics-using-SQL-and-EXCEL)

This repository/portfolio is for a project which was created for a computer hardware producing organisation. To help the organization, better its yearly performance by getting enough insights from its database to make quick, smart data-informed decisions.
<br><br> 

The situation in the project is that there is a computer hardware-producing organization, and we have its finance-related database. The database consists of details about the product, customers, cost of products, all the rebate offers, sales information with date of purchase, sold quantity, etc. <br><br>

The task involves SQL queries to answer ad-hoc requests for which the business needs insights. The task also focuses on improving the performance of large queries using different measures. Apart from that, it also expects certain insights in the form of proper charts and tables.<br><br>

Report-generating actions were taken using SQL for retrieving various details per business requirement. The tables were extracted in the form of comma-separated-values(CSV) files and for visualization of these insights, EXCEL charts were used. User-defined functions, stored procedures, etc were taken advantage of so that the same SQL queries can be used as a reusable asset for any past/future financial years.<br><br>


Finally, a lot of the conclusions were made after the insights were drawn, some of them are listed below such as: <br>

1- Amazon has the highest global market share percentage, it is the biggest customer/asset for our organization. <br><br>
2- Nova pvt. ltd, Notebillig, etc have the lowest market share, and there is a need to improve the business strategy for such customers.<br><br>
3- India is the best-selling country with the largest percentage of product sales. <br><br>
4- South American countries like Chile, Brazil, and Columbia have very little business done by our organization. So, a better and more personalized marketing strategy would be necessary to attract these markets. <br><br>
5- Region wise net sales percentage was drawn out of the data for APAC, EU, LATAM, and NA regions. Also, top n and bottom n products in these regions were extracted to know customer behavior better. <br><br><br>

Below are some of the tasks involved in the project, snapshots of the queries and the generated reports:-<br>
### Task1 <br>
- The product owner want to have a report of individual product sales (aggregated on a monthly basis at the product level) for its customer Croma India for FY 2021.The 
report must have these details:- Month of Purchase, Product name, Variant, Sold quantity, Gross Price per item, Gross Price Total. Assumption: Financial Year starts on 01/Sep. <br><br> 

Before writing the query to retrieve information, we first wrote a user defined function called 'get_fiscal_year' which takes any date as input and give out 'financial year' for that particular date as per the assumed financial year start date. <br><br>
![image](https://user-images.githubusercontent.com/61342727/231563721-98bb409b-3809-44cb-b632-6f9515033082.png)

<br><br>
Now, below is the query to retrieve the required information:<br><br>
![image](https://user-images.githubusercontent.com/61342727/231561994-89e3f0a2-7cb5-4773-ab9a-1bb94747cdc2.png) <br> <br>
It gives us the following report: <br><br>
![image](https://user-images.githubusercontent.com/61342727/231562654-c8da7dae-1d13-4b1b-843f-8fe2d2442e3a.png) <br><br>


### Task2 <br>
- Give reports to the product owner about top n products, top n customers and top n markets.<br>
Below are the queries and their generated reports simultaneously:-<br><br>
**Challenge#1** 
<br>While writing query to retrieve information, we encountered that the queries are taking too much time to calculate and output the results, so we needed performance improvement.<br>
![image](https://user-images.githubusercontent.com/61342727/231565715-6cc11ad2-ce50-4258-8a91-7d1139977e0e.png)
<br>
As we're going to do lot of mathematical calculations ,joins, etc tasks it is going to get too much time to  execute the query on the data, and one of the most problem was that we were calculating 'fiscal year' for each and every date in 'fact_sales_monthly' which is a repetitive process and is taking lot of time, so what we did is we just added one column named 'fiscal_year' using the date_add()formula and it gives fiscal year for every date and in fututure we're going to use that fiscal_year 
column whenever needed. <br>
It enhanced the performance quite much as shown below:-<br>
![image](https://user-images.githubusercontent.com/61342727/231566601-c051b057-1486-4755-b3ef-7b5048636744.png)<br>

After the performance improvments and added column the below queries were used to generate reports:-<br>
![image](https://user-images.githubusercontent.com/61342727/231567319-08538337-3aa1-4c1b-8ebd-fd60bfafca98.png)<br>
![image](https://user-images.githubusercontent.com/61342727/231567594-1b128045-34e7-4aad-8d48-0c6cf541ea2f.png)<br><br>


### Task3 <br>
- Give a chart of top 10 markets by their net sales % to the product owner.<br>
Below are the queries and their generated reports simultaneously:-<br><br>
![image](https://user-images.githubusercontent.com/61342727/231570225-dd496e81-8618-4520-b9d3-6b93cfafc512.png)<br>
![image](https://user-images.githubusercontent.com/61342727/231570584-cb8ae4f2-56ed-45ad-846c-0ad6275bfbcf.png)<br>
![image](https://user-images.githubusercontent.com/61342727/231570968-0e3903d1-a6be-484a-8374-3cfe65a7dad7.png)<br><br>


### Task4 <br>
- Give a region wise % net sales report broken down by customers in that respective region for FY 2021.<br>
Below are the queries and their generated reports simultaneously:-<br><br>
![image](https://user-images.githubusercontent.com/61342727/231571920-60f5ed39-bd4f-4089-96a2-c9c60d30e531.png)<br><br>
![image](https://user-images.githubusercontent.com/61342727/231573026-99e50f4c-f275-4c34-9909-54edc3037fb2.png)<br><br>

It gave us the report which we exported and saved as a excel and further went on to create a Pie Chart for each region as shown below:- <br><br>
![image](https://user-images.githubusercontent.com/61342727/231575999-fdc65908-5add-44a3-9d12-2d1c13f1b6cb.png)<br><br>
![image](https://user-images.githubusercontent.com/61342727/231576071-2543b52a-11fa-4362-9565-bb93095cfdeb.png)<br><br>

**Challenge#2** <br>
Also created stored procedure called 'get_%_net_sales_of_customers_per_region' as a **reusable asset** for any combination of inputs. Below is the code and working snapshots of the stored procedure:-<br><br>
![image](https://user-images.githubusercontent.com/61342727/231572651-66871955-8058-451d-84a4-a09f651923e5.png)<br><br>
![image](https://user-images.githubusercontent.com/61342727/231574976-24cb323f-42ce-4446-bd3a-2cfbd7eaa353.png)<br><br>



### Task5 <br>
- Give a report which give top n products in each division of the product category by their quantity sold for FY 2021.<br>
Below are the queries and their generated reports simultaneously:-<br><br>
![image](https://user-images.githubusercontent.com/61342727/231573922-011df305-7cfc-487a-9637-4308ba3ddc22.png)<br><br>
![image](https://user-images.githubusercontent.com/61342727/231574121-10ccb241-42b8-4713-b336-8d5b74c9ebd6.png)<br><br>


### Task6<br>
- Give a report that showcases top 2 markets in every region by their gross sales for FY 2021 <br>
Below are the queries and their generated reports simultaneously:-<br><br>
![image](https://user-images.githubusercontent.com/61342727/231574693-4b47b5fb-f9b1-4f54-b308-935c875af8ec.png)<br><br>
![image](https://user-images.githubusercontent.com/61342727/231574797-5873210b-24c8-4b2e-8731-6131b1953d3a.png)


[Click here to go to Top](https://vibhor2256.github.io/Finance-Analytics-using-SQL-and-EXCEL/)



















