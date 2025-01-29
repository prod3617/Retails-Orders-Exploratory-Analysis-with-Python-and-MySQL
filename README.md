# Exploratory Data Analysis Using Pandas and MySQL

## Retail Order Analysis

### Table of Contents
- [Project Description](#project-description)
- [Data Source](#data-source)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Tools](#tools)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results/Findings](#resultsfindings)
  

### Project Description
The project aims to do an exploratory analysis of retail orders using Pandas and MySQL. We analyzed the data to determine the top products sold in each region, how much the month-to-month sales and profit are changing, and what is the overall sales in the last two years.

![Exploratory Analysis Image](Exploratory%20Analysis.png)

### Data Source
- Retail Order Data: The data is taken from the Kaggle website using the Kaggle library and directly hitting the Kaggle api to download and extract the data from the zip folder in the Jupyter Notebook.

### Tools
- Python Pandas - For data cleaning and Preparation.
- MySQL - To perform exploratory analysis.

### Data Cleaning and Preparation
Data is loaded in the Juypter Notebook using the pandas's library and read_csv function. We have replaced some of the data as 'nan' from the ship mode column. We have also renamed each of the columns. We have calculated the  sale price, discount, and profit and added the data in the new column respectively. We have deleted the unwanted columns. We have used the sqlachemy library and pymysql to append the data in MySql. We have created the table structure in MySQL and pulled the data in the table using this Python library.

### Exploratory Data Analysis
Performed some exploratory data analysis to find some information about key questions like
- Which are the top 10 products sold?
- Find the top 5 highest-selling products in each region.
- Find a month-over-month comparison of the sales.
- For each category which month has the highest sales

### Data Analysis
To find the key answer to the question, we have written code in Python and MySQL as
``` Python Pandas
# Derive new columns like a discount, sell price, and profit.
data['discount'] = data['list_price'] * data['discount_percent']/100
data['sale_price'] = data['list_price'] - data['discount']
data['profit'] = data['sale_price'] - data['cost_price']
data.head()
```
``` MySQL
-- For each category which month has the highest sales;
with high_sale as (select category, DATE_FORMAT(order_date, '%Y-%m') AS order_year_month, sum(sale_price) as sales from orders
group by category, DATE_FORMAT(order_date, '%Y-%m')),
rank_high_sale as (select *, row_number()over(partition by category order by sales desc) as rn from high_sale)
select * from rank_high_sale where rn = 1;
```

### Results/Findings
- 'TEC-CO-10004722' is the most sold product.
- 'TEC-CO-10004722' is the most sold product in the East, West, and Central regions. 'TEC-MA-10002412' is the most sold product in the South region.
- Sales growth is maximum in the Feb month from the previous year. Sales declined the most in June as compared to the previous year.
- The furniture category has the maximum sales in 'October-2022', Office supplies in 'February-2023', and Technology in 'October-2023'.
