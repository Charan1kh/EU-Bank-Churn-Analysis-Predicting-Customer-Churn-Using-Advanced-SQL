

-- 1. KPI's
# Overall Churn Rate.
SELECT Concat(Round((Sum(churn) / Count(*)) * 100, 1),'%') AS Overall_churn_rate
FROM customer_churn_data;

# Customer Lifetime Value.
SELECT Round(Avg(balance),1) AS Average_CLV_of_churned_customers
FROM customer_churn_data
WHERE churn =1;

# Churn Rate by Product Holding
SELECT products_number, Concat(Round((Sum(churn)/Count(*)) * 100, 1),'%') AS Churn_rate
FROM customer_churn_data
GROUP BY products_number;

#Active member retention rate.
SELECT active_member, round((1 - sum(churn) / count(*)) * 100, 2) AS retention_rate
FROM customer_churn_data
GROUP BY active_member;

-- 1. Identify different segments of customers based on their demographic and transactional data.
# Customer Segmentation.with segmenteddata AS (
  SELECT
    CASE 
	   WHEN age BETWEEN 18 AND 25 THEN '18-25'
       WHEN age BETWEEN 26 AND 35 THEN '26-35'
       WHEN age BETWEEN 36 AND 45 THEN '36-45'
       WHEN age BETWEEN 46 AND 55 THEN '46-55'
       WHEN age BETWEEN 56 AND 65 THEN '56-65'
       WHEN age BETWEEN 56 AND 65 THEN '66-75'
       WHEN age BETWEEN 56 AND 65 THEN '76-85'
       ELSE '86-95'
    end AS age_group, country, gender, balance, products_number, active_member, churn
  FROM customer_churn_data)
    
SELECT age_group, country AS country, gender AS gender, round(avg(balance),0) AS avg_balance, count(products_number) AS num_of_products, concat(round((sum(active_member)/count(active_member))*100,0),'%') AS active_members, concat(round((sum(churn)/count(churn))*100,0),'%') AS churn_rate
FROM segmenteddata
GROUP BY age_group, country, gender
ORDER BY age_group, country, gender ASC;

-- 2. The impact of active membership status on churn rates across different gender and age segments.
# Active Membership ImpactSELECT age_group, gender AS Gender, active_member AS Active_status, Count(*) AS Total_customers, Sum(churn) AS Churned_customers, Concat(Round(((Sum(churn)/Count(*)))*100,1),'%') AS Churn_rate_percentage
FROM (
SELECT
  CASE
	WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 55 THEN '46-55'
    WHEN age BETWEEN 56 AND 65 THEN '56-65'
    WHEN age BETWEEN 56 AND 65 THEN '66-75'
    WHEN age BETWEEN 56 AND 65 THEN '76-85'
    ELSE '86-95'
  end AS Age_group, gender,
    CASE WHEN active_member = 1 THEN 'Active'
     ELSE 'Inactive'
  end AS active_member, churn
FROM customer_churn_data) AS SegmentedData
GROUP BY age_group, gender, active_status
ORDER BY age_group ASC;


-- 3. A model predicting the likelihood of a customer churning based on various factors like account tenure, transaction frequency, and service usage.
# Churn Risk Prediction.
SELECT customer_id,
  CASE 
	 WHEN tenure < 6 THEN 25
     WHEN tenure BETWEEN 7 AND 36 THEN 15
         ELSE 5
  end AS Tenure_score,
    
    CASE 
     WHEN balance BETWEEN 1 AND 50000 THEN 25
     WHEN balance > 50001 THEN 15
         ELSE 5
  end AS Average_balance_score,
    
    CASE 
     WHEN products_number <= 1 THEN 20
     WHEN products_number BETWEEN 2 AND 3 THEN 10
         ELSE 5
  end AS Product_score,
    
    CASE 
     WHEN active_member = 0 THEN 25
     ELSE 5
  end AS Activity_score,
             
  CASE 
     WHEN credit_score BETWEEN 000 AND 579 THEN 'Poor'
     WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
     WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
     WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
         ELSE 'Exceptional'
  end AS Service_usage_score,
    
    Least(100, 50 + (CASE WHEN tenure < 6 THEN 25 WHEN tenure BETWEEN 6 AND 36 THEN 15 ELSE 5 end) +
    
    (CASE 
     WHEN balance BETWEEN 1 AND 50000 THEN 25
     WHEN balance > 50001 THEN 15
         ELSE 5
  end) +
    (CASE 
     WHEN products_number <= 1 THEN 20
     WHEN products_number BETWEEN 2 AND 3 THEN 10
         ELSE 5 end)
         +
    (CASE 
     WHEN active_member = 0 THEN 25
     ELSE 5
  end) +
    
    (CASE 
     WHEN credit_score BETWEEN 000 AND 579 THEN 25
     WHEN credit_score BETWEEN 580 AND 669 THEN 20
     WHEN credit_score BETWEEN 670 AND 739 THEN 15
     WHEN credit_score BETWEEN 740 AND 799 THEN 10
         ELSE 5
  end)) AS churn_likelihood
    
FROM customer_churn_data;

    
-- 4. The impact of customer demographics (e.g., age, gender, geography) on churn rates.
# Customer Demographics Impact.WITH agegrouped
     AS (SELECT customer_id,
                country,
                gender,
                CASE
                  WHEN age BETWEEN 18 AND 25 THEN '18-25'
                  WHEN age BETWEEN 26 AND 35 THEN '26-35'
                  WHEN age BETWEEN 36 AND 45 THEN '36-45'
                  WHEN age BETWEEN 46 AND 55 THEN '46-55'
                  WHEN age BETWEEN 56 AND 65 THEN '56-65'
                  WHEN age BETWEEN 56 AND 65 THEN '66-75'
                  WHEN age BETWEEN 56 AND 65 THEN '76-85'
                  ELSE '86-95'
                end AS age_group,
                churn
         FROM   customer_churn_data),
     churnedratesbydemo
     AS (SELECT country AS country,
                gender AS gender,
                age_group,
                count(*) AS total_customers,
                sum(churn) AS churned_customers,
                concat(round(( sum(churn) / count(*) * 100 ), 1),'%') AS
                churn_rate_percentage
         FROM   agegrouped
         GROUP  BY country, gender, age_group)
SELECT *
FROM   churnedratesbydemo
ORDER  BY country, gender, age_group ASC;


-- 5.  Number of products a customer holds impacts their likelihood of churning
# Product Holding Patterns.
SELECT
  CASE 
     WHEN products_number = 1 THEN '1 Prouduct'
     WHEN products_number = 2 THEN '2 Products'
	 ELSE '3+ Products' end AS Product_group, Count(*) AS Total_customers, Sum(churn) AS Churned_customers, Round((Sum(churn)/Count(*))*100,1)AS Churn_rate_percentage
    FROM customer_churn_data
    GROUP BY product_group
    ORDER BY product_group ASC;