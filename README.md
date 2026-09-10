# Business Performance Analytics

## Project Overview

This project simulates an end-to-end Data Analyst workflow for an international retail/e-commerce business.

The main objective is to investigate sales performance, profitability, customer behavior and data quality issues using real-world-style transactional data.

The project focuses on transforming raw data into reliable analysis and actionable business insights.

**Project status:** In progress

---

## Business Questions

The analysis aims to answer questions such as:

- How reliable is the raw data?
- Are there missing, duplicated or inconsistent records?
- What is the company's revenue and profitability?
- Which product categories generate the most revenue and profit?
- Which categories have the highest and lowest profit margins?
- Which products perform best in terms of revenue and profit?
- How do discounts affect selling price and profitability?
- Which customers generate the highest revenue?
- Which customers have the highest Average Order Value (AOV)?
- How does revenue evolve over time?
- What potential business issues require further investigation?

---

## Dataset

The project uses five related datasets:

- `customers.csv` — customer information
- `orders.csv` — order-level information
- `order_items.csv` — products and quantities included in orders
- `products.csv` — product, category, price and cost information
- `returns.csv` — return-related information

The datasets contain intentionally introduced data quality issues in order to simulate a realistic business analytics environment.

---

## Data Quality Analysis

The initial analysis identified several data quality issues, including:

- Duplicate customer records
- Missing customer information
- Orders with missing `Customer_ID`
- Invalid order dates
- Duplicate order item records
- Negative quantities
- Missing selling prices
- Unmatched product records
- Return records without matching orders

These issues were investigated before drawing business conclusions from the data.

A key finding was that some negative quantities were associated with completed orders, meaning that negative quantity cannot automatically be interpreted as a return or cancellation.

This highlights the importance of validating business rules before cleaning or transforming data.

---

## SQL Analysis

SQL was used to explore the relational structure of the data and answer business questions.

The analysis included:

- Data exploration and record counts
- Order status analysis
- Identifying missing customer relationships
- Revenue calculation
- Revenue by product category
- Profit by product category
- Profit margin analysis
- Top products by revenue
- Top products by profit
- Product-level margin analysis
- Discount analysis
- Customer order frequency
- Customer revenue
- Average Order Value (AOV)
- Customer segmentation based on business criteria

SQLite was used for the SQL analysis.

---

## Python / Pandas Analysis

Python and Pandas were used for data cleaning, validation, transformation and exploratory analysis.

The analysis included:

- Loading and inspecting raw datasets
- Missing-value analysis
- Duplicate detection
- Data type conversion
- Date parsing and validation
- Dataset merging
- Negative quantity investigation
- Identification of unmatched product records
- Revenue calculation
- Profit calculation
- Profit margin analysis
- Category-level analysis
- Customer analysis
- Monthly revenue analysis
- Data visualization using Matplotlib

The main Python analysis is available in:

`audit.ipynb`

---

## Key Findings

### Data Quality

The datasets contain several inconsistencies that can affect reporting and analysis.

For example:

- 120 orders have a missing `Customer_ID`.
- 35 orders contain invalid order dates.
- 150 order items contain negative quantities.
- Duplicate order item records were identified.
- Product `P9999` does not have a matching product record.

These findings demonstrate why data validation is an important part of the analyst workflow.

### Profitability

The analysis showed differences between revenue performance and profitability.

The Beauty category generates substantial revenue but has the lowest profit margin among the analyzed categories.

This suggests that revenue alone should not be used to evaluate category performance.

Further product-level investigation is required to understand whether cost structure, pricing or promotional activity is responsible.

### Discounts

Some products have significantly higher average discounts than others.

The analysis suggests that discount strategy should be evaluated at product level rather than applying the same approach across an entire category.

### Customers

Customer analysis showed that high revenue and high Average Order Value do not necessarily mean the same thing.

Some customers have very high AOV based on only one or a few orders, so order frequency should be considered alongside revenue.

### Revenue Trend

Monthly revenue remained relatively stable overall, fluctuating approximately between €23M and €27M during the analyzed period.

The highest monthly revenue occurred in December 2025, while the lowest occurred in February 2026.

---

## Tools & Technologies

- **SQL / SQLite** — data querying and business analysis
- **Python** — data analysis
- **Pandas** — data cleaning and transformation
- **Matplotlib** — data visualization
- **Excel** — data quality checks and analysis
- **Jupyter Notebook** — Python analysis environment
- **GitHub** — project versioning and portfolio

---

## Project Structure

```text
business-performance-analytics/
│
├── customers.csv
├── orders.csv
├── order_items.csv
├── products.csv
├── returns.csv
│
├── audit.ipynb
│
└── README.md
