
CUSTOMER TRANSACTIONS DASHBOARD -SQL PROJECT

📌 Problem Statement  

This hypothetical Superstore is operating in a highly competitive retail environment but struggles to clearly identify   which customers, products, and regions drive profitability  .
Despite steady sales, the company faces challenges with:

    Unprofitable product categories  
    High discounts reducing margins  
    Rising shipping costs  
    Customer churn (loss of repeat buyers)  

Management seeks data-driven insights to guide decisions on targeting customer, product strategy, and regional expansion  .

🎯 Business Questions  

This project aims to answer the following:

1.   Revenue & Profitability  

     What are the overall sales and profit trends?
     Which categories and sub-categories are most/least profitable?

2.   Customer Segmentation & Retention  

     Who are the top 10 customers by total spending?
     Are there customers who have stopped purchasing (churn)?

3.   Regional Performance  

     Which regions, states, or cities generate the highest revenue?
     Are there markets where losses consistently occur?

4.   Operational Efficiency  

     How do shipping modes affect delivery times and profitability?
     Do discounts increase sales or simply reduce profit?



📊 Dataset  
	Source:   [Kaggle – Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
	Size:   9,994 rows, 21 columns
	Grain:   Each row = a unique product purchased in an order.
	
		Key Fields:
			Order Information:  Order ID, Order Date, Ship Date, Ship Mode
			Customer Information:  Customer ID, Customer Name, Segment, Region, City, State
     			Product Information:  Product ID, Category, Sub-Category, Product Name
     			Financials:  Sales, Quantity, Discount, Profit

About Dataset
Context
With growing demands and cut-throat competitions in the market, a Superstore Giant is seeking your knowledge in understanding what works best for them. They would like to understand which products, regions, categories and customer segments they should target or avoid.


Metadata
Row ID => Unique ID for each row.
Order ID => Unique Order ID for each Customer.
Order Date => Order Date of the product.
Ship Date => Shipping Date of the Product.
Ship Mode=> Shipping Mode specified by the Customer.
Customer ID => Unique ID to identify each Customer.
Customer Name => Name of the Customer.
Segment => The segment where the Customer belongs.
Country => Country of residence of the Customer.
City => City of residence of of the Customer.
State => State of residence of the Customer.
Postal Code => Postal Code of every Customer.
Region => Region where the Customer belong.
Product ID => Unique ID of the Product.
Category => Category of the product ordered.
Sub-Category => Sub-Category of the product ordered.
Product Name => Name of the Product
Sales => Sales of the Product.
Quantity => Quantity of the Product.
Discount => Discount provided.
Profit => Profit/Loss incurred.
 
🛠 Tools & Technologies  

	SQL (PostgreSQL):   querying and analysis
	pgAdmin 4:   database management
	GitHub:   portfolio hosting and documentation


📌 Project Deliverables  

	SQL scripts answering core business questions
	A structured database schema (customers, products, orders, sales fact table)
	Query outputs with insights (screenshots/tables)
	Final business recommendations for Superstore


 ✅ Expected Outcomes  

By the end of this project, in the analysis I will:

	Highlight high-value customers and churn risks
	Identify profitable vs unprofitable product lines
	Show revenue and profit trends by region and segment
	Recommend strategies to reduce losses from discounts and shipping

This project demonstrates my ability to transform raw transactional data into actionable business insights   using SQL alone.

