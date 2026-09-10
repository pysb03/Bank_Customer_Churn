# 🏦 Bank Customer Churn

Customer records for a European bank, containing demographic information, account characteristics, product usage, customer activity, and churn status.

---

## Project Objective

Analyze customer characteristics and account behavior to identify customer segments, churn patterns, and key factors associated with customer attrition.

---

## Recommended Analysis

- What attributes are more common among churned customers compared with non-churned customers?
- Which customer characteristics are associated with higher churn rates?
- How does customer churn differ across Germany, France, and Spain?
- How do customer activity, account balance, tenure, and number of products relate to churn?
- What types of customer segments can be identified based on customer characteristics and account behavior?
- Which customer segments have the highest churn risk and represent the greatest retention opportunities?

---

## Key Analysis

The analysis focuses on:

- Overall customer and churn performance
- Customer demographics and account characteristics
- Churn rate by customer activity, geography, gender, age, tenure, balance, and number of products
- Customer segmentation based on lifecycle, engagement, and account value
- Segment-level churn rate and customer distribution
- Segment profiling and retention opportunities

---

## Dataset

The dataset includes:

- Customer ID
- Surname
- Credit Score
- Geography
- Gender
- Age
- Tenure
- Account Balance
- Number of Products
- Credit Card Ownership (1 = Has , 0 = No has)
- Active Member Status (1 = Active , 0 = Inactive)
- Estimated Salary
- Exit or Churn Status (1 = Churner , 0 = Non-Churner)

---

## Tools

- **SQLite** — Data exploration, cleaning, aggregation, and SQL analysis
- **Microsoft Excel** — Data cleaning, transformation, PivotTables, segmentation, and dashboard development
- **Excel Dashboard** — Interactive dashboard and reporting

---

## Analysis Approach

### 1. Data Cleaning & Preparation

- Reviewed the dataset structure, data types, and key variables.
- Checked for blank, missing, or inconsistent values across customer and account attributes.
- Standardized numeric fields such as Balance, Estimated Salary, Credit Score, Age, and Tenure for analysis.
- Reviewed zero values in Balance and other fields to distinguish valid business values from missing or inconsistent data.
- Checked categorical fields such as Geography, Gender, and customer activity status for consistency.
- Verified key fields and customer records before creating the analysis dataset.

### 2. Data Transformation

Created an analysis-ready table by organizing customer demographic, account, engagement, and churn information into a single dataset.

Additional calculated fields and helper columns were created to support the analysis, including:
- Customer Activity Status
- Credit Card Status
- Churn Status
- Customer Value indicators
- Customer Lifecycle indicators
- Segment classification flags
- Final Customer Segment

### 3. Customer Segmentation

Customers were segmented based on a combination of customer lifecycle, engagement, and account value characteristics.

The segmentation framework includes:
- **High-Value Active** – customers with high account balances who are actively engaged with the bank.
- **High-Value Inactive** – high-value customers who are currently inactive and may represent a retention risk.
- **Low-Engagement** – customers showing lower engagement based on activity and account characteristics.
- **Young / Emerging** – younger customers with relatively lower account balances, representing potential for long-term relationship development.
- **Established Customers** – customers with longer relationships with the bank based on age and tenure.
- **Other** – customers who do not meet the criteria of the defined segments.

Helper flags were created for each segment before assigning a final segment to each customer. This approach allows overlapping segment criteria to be identified and controlled through a defined classification priority.

### 4. Churn Analysis

The analysis examined customer churn across different demographic, geographic, account, and engagement characteristics.

Key metrics included:
- Total Customers
- Churned Customers
- Non-Churned Customers
- Overall Churn Rate
- Churn Rate by Geography
- Churn Rate by Gender
- Churn Rate by Age Group
- Churn Rate by Customer Activity
- Churn Rate by Number of Products
- Churn Rate by Credit Card Ownership
- Churn Rate by Customer Segment

The analysis focuses on identifying characteristics and customer groups that are associated with higher or lower churn rates rather than assuming direct causation.

### 5. Dashboard Development

The analysis was organized into four dashboard sections to provide both an overall view and detailed customer insights:

**01 Overview**
- Overall customer base
- Churn vs. non-churn
- Customer demographics
- Key churn indicators

**02 Geography Analysis**
- Customer distribution by country
- Churn rate by country
- Account and customer behavior comparison across Germany, France, and Spain

**03 Segmentation Framework**
- Customer segmentation logic
- Segment criteria
- Business meaning of each customer segment

**04 Segment Analysis**
- Customer distribution by segment
- Churn rate by segment
- Segment-level customer profiles
- Key findings and retention opportunities

---

# Dashboard Preview

### Overview
<img width="1248" height="738" alt="Overview" src="https://github.com/user-attachments/assets/1b84d823-18f3-4f3e-8074-ce2499f6304a" />

### Geography Analysis
<img width="1242" height="738" alt="Geography" src="https://github.com/user-attachments/assets/3943409a-c9e8-49d3-a693-1763dc25655b" />

### Segmentation Meaning
<img width="1242" height="738" alt="Segment (Meaning)" src="https://github.com/user-attachments/assets/8172c6bb-31a8-4ebc-9c08-667021cce7e8" />

### Segment Analysis
<img width="1241" height="739" alt="Segment" src="https://github.com/user-attachments/assets/ea8865ec-2d1f-4a1e-986b-63495a049894" />

---

## Source

Dataset from **Maven Analytics Data Playground**:

https://mavenanalytics.io/data-playground/bank-customer-churn

