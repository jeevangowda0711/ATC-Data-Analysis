# Data Warehousing Exercises

This repository contains my submissions for the data warehousing exercises as part of my data analysis training at ATC. There are 4 exercises focusing on SQL querying, ETL pipelines, schema design, and more. Each exercise is in its own folder with relevant files and documentation.

## Exercise 1: SQL Query Drill
- **Tool**: MySQL Workbench (or SQL Fiddle as an alternative).
- **Dataset**: Sakila sample database [](https://dev.mysql.com/doc/sakila/en/sakila-introduction.html).
- **Tasks**:
  - Calculate total revenue by store.
  - Find average order value (AOV) by customer segment (Bronze/Silver/Gold based on spend).
  - Identify top 10 products (films) by profit margin (using ROI %).
  - Bonus: Customers who spent > $1,000 in 2024 (adapted for Sakila data to lifetime spend > $200).
- **Goal**: Practice GROUP BY, aggregations, and JOINs.
- **Files**:
  - [exercise1.sql](./exercise1_sql_drill/exercise1.sql): SQL queries.
  - [ATC_Data_Analysis_Exercise_1.pdf](./exercise1_sql_drill/ATC_Data_Analysis_Exercise_1.pdf): PDF with query screenshots and results.

Example query output (from PDF screenshots):
- Total revenue by store: Store 1 (Canada) - $33,000+ revenue.
- AOV by segment: Gold (~$150+), Silver (~$120), Bronze (~$80).
- Top 10 films: High ROI films like "Film X" with 500%+ return.

## Exercise 2: ETL Workflow
- **Tool**: Jupyter Notebook (with pandas, sqlite3, country_converter).
- **Dataset**: Kaggle's "10000 Sales Records" CSV [](https://www.kaggle.com/datasets/omaradel99/10000-sales-records).
- **Tasks**:
  - **Extract**: Download/load CSV (using kagglehub if needed).
  - **Transform**: Clean data (remove nulls), standardize country names (using country_converter), compute profit margin.
  - **Load**: Write cleaned data to SQLite database.
- **Goal**: Build a complete ETL pipeline.
- **Files**:
  - [etl_workflow.ipynb](./exercise2_etl_workflow/etl_workflow.ipynb): Full ETL code and execution.
  - [10000_sales_records.csv](./exercise2_etl_workflow/10000_sales_records.csv): Source data.
  - etl_output.db: Generated SQLite DB (table: sales_cleaned with columns like Region, Country_std, Profit_Margin).

Setup: Install dependencies with `pip install pandas sqlalchemy kagglehub country-converter`.

Preview of transformed data (from notebook):
| Region | Country | Item Type | ... | Profit_Margin |
|--------|---------|-----------|-----|---------------|
| Sub-Saharan Africa | Chad | Office Supplies | ... | 0.193870 |

## Exercise 3: Schema Design
- **Tool**: Draw.io (or Lucidchart).
- **Task**: Design a star schema for a movie theater data warehouse.
  - **Fact Table**: Fact_TicketSales (sale_id PK, price FLOAT, quantity INT, total_amount FLOAT, date_key INT FK, movie_key INT FK, customer_key INT FK, theater_key INT FK).
  - **Dimension Tables**:
    - Dim_Date (date_key PK, full_date DATE, day INT, month INT, quarter INT, year INT, day_of_week VARCHAR, is_weekend BOOLEAN).
    - Dim_Movie (movie_key PK, movie_title VARCHAR, genre VARCHAR, language VARCHAR, release_date DATE, duration_minutes INT, rating VARCHAR).
    - Dim_Customer (customer_key PK, first_name VARCHAR, last_name VARCHAR, gender VARCHAR, age_group VARCHAR, loyalty_status VARCHAR, city VARCHAR, state VARCHAR).
    - Dim_Theater (theater_key PK, theater_name VARCHAR, city VARCHAR, state VARCHAR, number_of_screens INT, seating_capacity INT).
- **Goal**: Practice dimensional modeling (star schema).
- **Files**:
  - [Movie_Theater_Data_Warehouse.drawio.png](./exercise3_schema_design/Movie_Theater_Data_Warehouse.drawio.png): ER diagram image.

![ER Diagram](./exercise3_schema_design/Movie_Theater_Data_Warehouse.drawio.png)

## How to Run
- Exercise 1: Load Sakila DB in MySQL Workbench and run the .sql file.
- Exercise 2: Open etl_workflow.ipynb in Jupyter/VS Code and run all cells (ensure CSV is in the same folder).
- Exercise 3: Open the .drawio.png in Draw.io for editing.

## License
MIT License - Feel free to use or adapt these exercises.