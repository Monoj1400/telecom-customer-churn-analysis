/*
===========================================================
PROJECT: TELECOM CUSTOMER CHURN & RETENTION ANALYSIS
DATABASE: MySQL
DATASET: IBM Telco Customer Churn
IMPORTED TABLE: telco-customer-churn

BUSINESS OBJECTIVE:
Analyze customer churn patterns and identify customer
segments that may benefit from targeted retention efforts.

ANALYSIS SCOPE:
7,032 imported customer records.

TOOLS:
MySQL, SQL aggregation, CASE expressions, CTEs.

IMPORTANT LIMITATION:
The source CSV contains 7,043 expected customer records,
but only 7,032 records were imported. Findings describe
the imported dataset and may not represent all source rows.

===========================================================
*/
-- Create a separate database for the telecom churn project
-- Create the project database if it does not already exist
CREATE DATABASE IF NOT EXISTS telecom_churn_analysis;

-- Select the project database
USE telecom_churn_analysis;

-- Select the database for subsequent work
USE telecom_churn_analysis;
-- Confirm the number of customer records available for analysis

    /* =========================================================
   SECTION 1: DATA VALIDATION AND QUALITY ASSESSMENT
   Purpose:
   - Verify imported record count
   - Check duplicate customer IDs
   - Check missing values in key fields
   - Understand the churn distribution
   ========================================================= */ --
SELECT COUNT(*) AS total_customers
FROM telecom_churn_analysis.`telco-customer-churn`;

-- Identify customer IDs that appear more than once
SELECT
    customerID,
    COUNT(*) AS record_count
FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY customerID
HAVING COUNT(*) > 1;

-- Assess missing values in key customer and billing fields
SELECT
    SUM(customerID IS NULL OR TRIM(customerID) = '') AS missing_customer_id,
    SUM(tenure IS NULL) AS missing_tenure,
    SUM(MonthlyCharges IS NULL) AS missing_monthly_charges,
    SUM(TotalCharges IS NULL) AS missing_total_charges,
    SUM(Churn IS NULL OR TRIM(Churn) = '') AS missing_churn
FROM telecom_churn_analysis.`telco-customer-churn`;

-- Count customers who churned versus customers who stayed
SELECT
    Churn,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM telecom_churn_analysis.`telco-customer-churn`),
        2
    ) AS percentage
FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY Churn
ORDER BY customer_count DESC;

-- Check for NULL values and empty strings in TotalCharges
SELECT
    SUM(TotalCharges IS NULL) AS null_total_charges,
    SUM(
        TotalCharges IS NOT NULL
        AND TRIM(TotalCharges) = ''
    ) AS blank_total_charges
FROM telecom_churn_analysis.`telco-customer-churn`;

-- Inspect distinct churn labels and check for unexpected values
SELECT
    Churn,
    COUNT(*) AS customer_count
FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY Churn;

-- Check whether tenure or monthly charges contain invalid ranges
SELECT
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure,
    MIN(MonthlyCharges) AS min_monthly_charges,
    MAX(MonthlyCharges) AS max_monthly_charges
FROM telecom_churn_analysis.`telco-customer-churn`;

           -- Business Analysis --
-- Analyze customer churn by contract type --
 /*Does customer churn differ significantly across contract types?*/
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Analyze churn by customer tenure group --
/*Does customer tenure relate to churn?
Business question: Are newer customers more likely to leave than customers who have stayed with the company for years?*/
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN '0-12 months' THEN 1
        WHEN '13-24 months' THEN 2
        WHEN '25-48 months' THEN 3
        ELSE 4
    END;
    
    
    -- Does monthly spending relate to churn? --
    -- Analyze customer churn across monthly charge bands
SELECT
    CASE
        WHEN MonthlyCharges < 35 THEN 'Under $35'
        WHEN MonthlyCharges < 65 THEN '$35-$64.99'
        WHEN MonthlyCharges < 90 THEN '$65-$89.99'
        ELSE '$90 and above'
    END AS monthly_charge_band,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY monthly_charge_band
ORDER BY
    CASE monthly_charge_band
        WHEN 'Under $35' THEN 1
        WHEN '$35-$64.99' THEN 2
        WHEN '$65-$89.99' THEN 3
        ELSE 4
    END;
    

    -- Compare customer churn rates by internet service type --
        -- Business question: Does churn vary between customers using Fiber optic, DSL, and customers without internet service? --
SELECT
    InternetService,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;

-- Analyze churn by technical support subscription --
-- Are customers without technical support more likely to churn than customers who have it? --
SELECT
    TechSupport,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY TechSupport
ORDER BY churn_rate_pct DESC;

-- Which combination of contract type and internet service has the highest churn rate? --
-- Compare churn across contract and internet service combinations
SELECT
    Contract,
    InternetService,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY
    Contract,
    InternetService
ORDER BY
    churn_rate_pct DESC,
    total_customers DESC;
    
    -- Rank customer segments by the number of churned customers --
    -- Finding the customer segments with the greatest churn impact --
-- Rank customer segments by the number of churned customers
SELECT
    Contract,
    InternetService,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY
    Contract,
    InternetService

ORDER BY
    churned_customers DESC;
    
    -- Calculate each contract and internet service segment's share of total churn --
    -- Calculate churned customers' share of total churn --
WITH segment_churn AS (
    SELECT
        Contract,
        InternetService,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
            AS churned_customers
    FROM telecom_churn_analysis.`telco-customer-churn`
    GROUP BY Contract, InternetService
),
total_churn AS (
    SELECT SUM(churned_customers) AS all_churned_customers
    FROM segment_churn
)
SELECT
    s.Contract,
    s.InternetService,
    s.total_customers,
    s.churned_customers,
    ROUND(
        100.0 * s.churned_customers
        / NULLIF(t.all_churned_customers, 0),
        2
    ) AS share_of_all_churn_pct
FROM segment_churn AS s
CROSS JOIN total_churn AS t
ORDER BY s.churned_customers DESC;

/* Business Question:
   Does customer churn vary by payment method?

   Purpose:
   Compare customer counts, churned customers, and
   within-group churn rates for each payment method.
*/
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

-- Analyze churn by paperless billing, Do customers enrolled in paperless billing have a different churn rate from those receiving paper bills? --
-- Analyze customer churn by paperless billing preference
SELECT
    PaperlessBilling,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM telecom_churn_analysis.`telco-customer-churn`
GROUP BY PaperlessBilling
ORDER BY churn_rate_pct DESC;

-- Consolidated overview of customer churn
SELECT
    COUNT(*) AS total_customers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,

    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END)
        AS retained_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate_pct,

    ROUND(AVG(tenure), 2) AS avg_tenure_months,

    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,

    ROUND(
        AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),
        2
    ) AS avg_churned_monthly_charges,

    ROUND(
        AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),
        2
    ) AS avg_retained_monthly_charges

FROM telecom_churn_analysis.`telco-customer-churn`
