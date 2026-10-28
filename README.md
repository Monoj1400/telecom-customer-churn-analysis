# Telecom Customer Churn & Retention Analysis

## Project Overview

Customer churn is a major challenge for telecommunications companies because losing existing customers can affect recurring revenue and long-term customer relationships.

This project uses SQL to analyze customer churn patterns in the IBM Telco Customer Churn dataset. The objective is to identify customer segments with elevated churn rates, understand how churn varies across customer characteristics, and develop data-driven recommendations to support customer retention.

The analysis was conducted using MySQL, with a focus on data validation, aggregation, conditional logic, common table expressions (CTEs), and business-oriented SQL queries.

## Business Objectives

- Measure the overall customer churn and retention rates.
- Analyze churn across contract types, tenure groups, monthly charges, and internet service types.
- Investigate the relationship between technical support, payment methods, paperless billing, and churn.
- Identify customer segments contributing the largest share of total churn.
- Translate analytical findings into actionable retention recommendations.

## Dataset

**Dataset:** IBM Telco Customer Churn

The dataset contains customer-level information, including:

- Customer identifiers
- Tenure and contract type
- Internet service and technical support
- Monthly and total charges
- Payment method and paperless billing
- Customer churn status

**Analysis scope:** 7,032 successfully imported customer records.

**Data limitation:** The source dataset was expected to contain 7,043 customer records, but 7,032 records were imported into MySQL. The reason for the 11-record discrepancy has not been established. All reported findings apply to the imported records and may not represent the complete source dataset.

## Tools and Technical Skills

- **MySQL:** Data querying and analysis
- **MySQL Workbench:** SQL execution and database exploration
- **SQL aggregations:** `COUNT()`, `SUM()`, and `AVG()`
- **Conditional logic:** `CASE WHEN`
- **Common Table Expressions:** CTEs for structured segment analysis
- **Data quality assessment:** Duplicate checks, missing-value checks, category inspection, and numeric range validation
- **Business analysis:** Churn rates, customer segmentation, and contribution analysis

## Analytical Approach

### 1. Data Validation and Quality Assessment

Validated the imported dataset before conducting the business analysis.

Key checks included:
- Total record count
- Duplicate customer IDs
- Missing values in important fields
- Null and blank `TotalCharges` values
- Churn category consistency
- Numeric ranges for tenure and monthly charges

The analysis retains the 7,032 imported records and documents the unresolved source-record discrepancy.

### 2. Overall Churn and Retention

Established baseline customer metrics:

| Metric | Result |
|---|---:|
| Total customers analyzed | 7,032 |
| Churned customers | 1,869 |
| Retained customers | 5,163 |
| Overall churn rate | 26.58% |
| Average customer tenure | 32.42 months |
| Average monthly charges | $64.80 |

### 3. Churn by Customer Attributes

Analyzed churn rates across individual customer characteristics, including:

- Contract type
- Tenure groups
- Monthly charge bands
- Internet service
- Technical support
- Payment method
- Paperless billing

This analysis helped identify customer groups with substantially different observed churn rates.

### 4. Combined Segment Analysis

Combined contract type and internet service to investigate whether churn patterns differed across more specific customer segments.

The analysis examined both:
- **Segment churn rate:** The percentage of customers in a segment who churned.
- **Share of total churn:** The percentage of all churned customers represented by that segment.

A common table expression was used to calculate each segment's contribution to total churn.

## Key Findings

### 1. Contract Type Is Strongly Associated With Churn

| Contract type | Churn rate |
|---|---:|
| Month-to-month | 42.71% |
| One year | 11.28% |
| Two year | 2.85% |
<img width="636" height="200" alt="Screenshot 2026-10-28 210416" src="https://github.com/user-attachments/assets/2c356617-ed1f-4ed1-891f-26ca73cabf86" />
Month-to-month customers had the highest observed churn rate among the contract groups analyzed.

### 2. Newer Customers Show Higher Churn Rates

| Customer tenure | Churn rate |
|---|---:|
| 0–12 months | 47.68% |
| 13–24 months | 28.71% |
| 25–48 months | 20.39% |
| 49+ months | 9.51% |
<img width="408" height="107" alt="Screenshot 2026-10-28 210635" src="results/Screenshot 2026-10-28 210635.png" />
Customers in their first 12 months had the highest churn rate. This suggests that the early customer lifecycle deserves particular attention in retention planning.

### 3. Fiber Optic Customers Have Higher Observed Churn

| Internet service | Churn rate |
|---|---:|
| Fiber optic | 41.89% |
| DSL | 19.00% |
| No internet service | 7.43% |
<img width="417" height="75" alt="Screenshot 2026-10-28 210758" src="https://github.com/user-attachments/assets/3cd15cd4-6374-4216-b7b3-3dffee0d1b75" />
Fiber optic customers had a substantially higher churn rate than customers in the other internet service categories. Further investigation would be needed to understand the reasons behind this difference.

### 4. Technical Support Is Associated With Lower Churn

| Technical support | Churn rate |
|---|---:|
| No | 41.65% |
| Yes | 15.20% |
| No internet service | 7.43% |
<img width="433" height="78" alt="Screenshot 2026-10-28 210841" src="results/Screenshot 2026-10-28 210841.png" />
Customers without technical support had a higher observed churn rate than customers with technical support. This is an association and does not establish that technical support alone causes lower churn.

### 5. A High-Risk Combined Segment Emerged

The month-to-month contract and fiber optic segment had:

- **2,128** customers
- **1,162** churned customers
- **54.61%** churn rate
- **62.17%** of all churned customers
<img width="504" height="176" alt="image" src="results/Screenshot 2026-10-28 210947.png" />
This segment contributed the largest number of churned customers among the contract and internet service combinations analyzed.
The month-to-month fiber optic and month-to-month DSL segments together accounted for **83.25% of all churned customers** in the imported dataset.

### 6. Electronic Check Users Have Higher Observed Churn

| Payment method | Churn rate |
|---|---:|
| Electronic check | 45.29% |
| Mailed check | 19.20% |
| Bank transfer (automatic) | 16.73% |
| Credit card (automatic) | 15.25% |
<img width="470" height="100" alt="Screenshot 2026-10-28 211231" src="https://github.com/user-attachments/assets/7461189c-9350-47b8-85cd-085a6c3a9c98" />
Electronic check users had the highest churn rate among the payment methods analyzed. Additional investigation could examine whether payment experience, customer preferences, or other customer characteristics are associated with this pattern.

### 7. Churned Customers Have Higher Average Monthly Charges

| Customer group | Average monthly charges |
|---|---:|
| Churned customers | $74.44 |
| Retained customers | $61.31 |
<img width="1024" height="42" alt="Screenshot 2026-10-28 211425" src="https://github.com/user-attachments/assets/776260b1-7894-4591-81d4-b6a33171ad74" />
Churned customers paid approximately $13.13 more per month on average than retained customers in the analyzed dataset.

This difference may help guide further investigation into pricing, service bundles, and perceived value.

## Business Recommendations

Based on the observed patterns, the following actions merit further investigation:

1. **Prioritize early-life retention:** Review onboarding, first-year customer experience, and proactive support for newer customers.
2. **Investigate month-to-month churn:** Evaluate whether suitable longer-term plans or retention offers could improve customer continuity.
3. **Examine fiber optic customer experience:** Investigate service satisfaction, pricing, reliability, and support issues before deciding on interventions.
4. **Review technical support accessibility:** Assess whether customers who need assistance can access effective and timely support.
5. **Investigate electronic check churn:** Explore whether payment experience or other characteristics help explain the elevated churn rate.
6. **Evaluate value perception:** Study pricing and service bundles among higher-paying customers who leave.

These are recommendations for further investigation and testing, not claims that the suggested interventions will necessarily reduce churn.

## Limitations

- Only 7,032 of the 7,043 expected source records were imported.
- The reason for the record discrepancy has not been confirmed.
- The analysis is descriptive and identifies associations rather than causal relationships.
- The analysis does not establish the effectiveness of any retention intervention.
- Findings are limited to the imported dataset and should be validated before being generalized to other telecom customer populations.

## Project Outcome

This project demonstrates how SQL can be used to move from raw customer data to structured business insights. It combines data validation, customer segmentation, churn-rate calculations, CTE-based analysis, and business recommendations to support data-driven retention planning.

## Repository Contents

- `README.md` — Project documentation
- SQL analysis script — Data validation and business analysis queries

## Author

**Manoj Kumar B. K.**

Aspiring Data Analyst | SQL | Python | Excel | Power BI | Tableau

