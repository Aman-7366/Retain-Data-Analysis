#  Retail Data Analysis Project

This project is an end-to-end retail data analysis case study aimed at understanding sales, profit, and customer behavior across multiple dimensions—Category, Product, Store, and Order. The analysis is performed using SQL for data preparation and Power BI for data visualization.

##  Project Overview

The objective of this project is to derive business insights for a retail company by analyzing their sales and customer behavior across regions, stores, and product categories.

- **Tools Used:** SQL Server, Power BI
- **Domain:** Retail
- **Key Areas:** Data Cleaning, Data Modeling, Sales Analysis, RFM Segmentation, Dashboarding

---

##  Project Structure

### 1.  Data Collection

The raw data was sourced from a mock retail database comprising multiple tables including:
- Transactions
- Products
- Stores
- Customers

### 2.  Data Cleaning
Performed using the script: [`data_cleaning.sql`](./data_cleaning.sql)

Key steps:
- Handled nulls and inconsistent formats
- Standardized date formats and text fields
- Removed duplicates and outliers

### 3. Data Analysis
Performed using: [`data_analysis_final.sql`](./data_analysis_final.sql)

Key areas analyzed:
- Product-level performance
- Category-wise sales and orders
- Time-based sales patterns (month, week, day)
- Channel preference (Online, Instore, Phone Delivery)

### 4.  RFM Analysis
Performed using: [`rfm_analysis.sql`](./rfm_analysis.sql)

We calculated:
- Recency
- Frequency
- Monetary value

Used RFM scores to segment customers into buckets for retention strategies.

### 5.  360 Customer Table
Built using: [`360Tables.sql`](./360Tables.sql)

This included:
- Total orders
- Total revenue
- Discount usage
- Profit contribution
- Channel preference
- Gender and regional behavior

---

##  Power BI Dashboards

Power BI was used to create insightful and interactive dashboards.

### 1. Product & Category Level Dashboard

Highlights:
- Top and bottom categories
- Revenue and order comparison
- Product segmentation

### 2. Order Level Dashboard

Highlights:
- Sales trend by month
- Channel-wise order distribution
- Weekday vs Weekend sales

### 3. Store-Level Dashboard

Highlights:
- Store performance
- Sales and quantity per store
- State-wise filtering

 Power BI App Link: [View Interactive Dashboard](https://app.powerbi.com/links/-EJ1DFWrFi?ctid=2aecfc40-188c-4595-89d3-9c49e23fbd10&pbi_source=linkShare&bookmarkGuid=4562f244-b097-4596-8c78-797d1a9215ee)

---

##  Key Insights

- **Toys & Gifts** was the top-performing category with the highest revenue and orders.
- Most sales occurred via **Online Channel**, indicating a shift in consumer buying habits.
- **Store ST103** is the top-performing outlet, suggesting potential for similar store models.
- Weekdays recorded **79%** of total orders—important for planning campaigns.

---

##  Contributions

- **Data Analyst:** Aman Kumar
- Tools Used: SQL, Power BI

---

##  Files

- `data_cleaning.sql` – SQL scripts to clean and preprocess data
- `data_analysis_final.sql` – SQL queries for exploratory analysis
- `rfm_analysis.sql` – RFM model query
- `360Tables.sql` – Combined customer 360-degree view
- `Power BI App link.txt` – Contains app sharing link

---

##  Contact

For any queries or collaboration:  
📧 ak701474@gmail.com  
📍 [LinkedIn Profile](https://www.linkedin.com/in/aman-kumar-24aab6316/)

---


