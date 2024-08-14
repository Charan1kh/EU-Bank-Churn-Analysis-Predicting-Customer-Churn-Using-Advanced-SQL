select * from customer_churn_data;

-- 1. Customer Segmentation:
-- Identify different segments of customers based on their demographic and transactional data. This should include using GROUP BY clauses to aggregate customer data and determine key metrics for each segment.
-- Suggestion: Create CTEs (Common Table Expressions) to temporarily segment customers into high-risk and low-risk groups based on specific criteria like account balance and credit score.

-- 2. Churn Risk Prediction:
-- Build a model to predict the likelihood of a customer churning based on various factors like account tenure, transaction frequency, and service usage.
-- Use subqueries to create calculated fields (e.g., average monthly balance, total transactions in the last 6 months) and correlate these fields with churn status.

-- 3. Retention Strategy Analysis:
-- Analyze which retention strategies (if data exists) have been most effective in reducing churn. This may involve joins between customer data and a hypothetical retention strategy table.
-- Implement advanced select statements to compare the effectiveness of multiple strategies, using CASE statements and subqueries to analyze customer responses.

-- 4. Profitability Analysis:
-- Determine the profitability of retaining a customer versus acquiring a new one. This should involve subqueries to calculate lifetime value (LTV) of customers, segmenting them by churn status.
-- Use window functions to rank customers by profitability and determine thresholds for intervention strategies.

-- 5. Customer Demographics Impact:
-- Assess the impact of customer demographics (e.g., age, gender, geography) on churn rates. This can involve creating advanced joins and using GROUP BY with multiple fields.
-- Suggest using CTEs or subqueries to calculate churn rates for different demographic groups and identify trends.

-- 6. Performance Dashboard:
-- Design queries to create a performance dashboard that tracks key metrics like churn rate, average customer lifetime value, and retention strategy effectiveness.
-- Include subqueries to calculate year-over-year changes and provide insights into customer trends over time.

# 1. Identify different segments of customers based on their demographic and transactional data.
# Customer Segmentation.
with segmentedData as (
	select 
		case when age between 18 and 25 then '18-25'
			 when age between 26 and 35 then '26-35'
			 when age between 36 and 45 then '36-45'
			 when age between 46 and 55 then '46-55'
			 when age between 56 and 65 then '56-65'
			 when age between 56 and 65 then '66-75'
			 when age between 56 and 65 then '76-85'
			 else '86-95'
		end as Age_Group, country, gender, balance, products_number, active_member, churn
	from customer_churn_data)
    
select Age_Group, country as Country, gender as Gender, round(avg(balance),0) as Avg_Balance, count(products_number) as Num_of_products, concat(round((sum(active_member)/count(active_member))*100,0),'%') as Active_members, concat(round((sum(churn)/count(churn))*100,0),'%') as Churn_rate
from segmentedData
group by Age_Group, Country, Gender
order by Age_Group, Country, Gender asc;
    
# 2. A model predicting the likelihood of a customer churning based on various factors like account tenure, transaction frequency, and service usage.
# Churn Risk Prediction.
select customer_id, 
	case when tenure < 6 then 25
		 when tenure between 7 and 36 then 15
         else 5
	end as Tenure_score,
    
    case when balance between 1 and 50000 then 25
		 when balance > 50001 then 15
         else 5
	end as Average_balance_score,
    
    case when products_number <= 1 then 20
		 when products_number between 2 and 3 then 10
         else 5
	end as Product_score, 
    
    case when active_member = 0 then 25
		 else 5
	end as Activity_score,
             
	case when credit_score between 000 and 579 then 'Poor'
		 when credit_score between 580 and 669 then 'Fair'
		 when credit_score between 670 and 739 then 'Good'
		 when credit_score between 740 and 799 then 'Very Good'
         else 'Exceptional'
	end as Service_usage_score,
    
    least(100, 50 + (case when tenure < 6 then 25
		 when tenure between 6 and 36 then 15
         else 5
	end) +
    
    (case when balance between 1 and 50000 then 25
		 when balance > 50001 then 15
         else 5
	end) +
    (case when products_number <= 1 then 20
		 when products_number between 2 and 3 then 10
         else 5 end) 
         +
    (case when active_member = 0 then 25
		 else 5
	end) +
    
    (case when credit_score between 000 and 579 then 25
		 when credit_score between 580 and 669 then 20
		 when credit_score between 670 and 739 then 15
		 when credit_score between 740 and 799 then 10
         else 5
	end)) as churn_likelihood
    
from customer_churn_data;

		
# 3. The impact of customer demographics (e.g., age, gender, geography) on churn rates.
# Customer Demographics Impact.

WITH agegrouped
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
                END AS Age_group,
                churn
         FROM   customer_churn_data),
     churnedratesbydemo
     AS (SELECT country                                   AS Country,
                gender                                    AS Gender,
                age_group,
                Count(*)                                  AS Total_customers,
                Sum(churn)                                AS Churned_customers,
                concat(Round(( Sum(churn) / Count(*) * 100 ), 1),'%') AS
                Churn_rate_percentage
         FROM   agegrouped
         GROUP  BY country,
                   gender,
                   age_group)
SELECT *
FROM   churnedratesbydemo
ORDER  BY country,
          gender,
          age_group ASC;


# 4.  Number of products a customer holds impacts their likelihood of churning
# Product Holding Patterns.

select 
	case when products_number = 1 then '1 Prouduct'
		 when products_number = 2 then '2 Products'
         else '3+ Products'
	end as Product_group, count(*) as Total_customers, sum(churn) as Churned_customers, round((sum(churn)/count(*))*100,1)as Churn_rate_percentage
    from customer_churn_data
    group by Product_group
    order by Product_group asc;

# 5. The impact of active membership status on churn rates across different gender and age segments.
# Active Membership Impact

select Age_group, gender as Gender, active_member as Active_status, count(*) as Total_customers, sum(churn) as Churned_customers, concat(round(((sum(churn)/count(*)))*100,1),'%') as Churn_rate_percentage
from (
select 
	case when age between 18 and 25 then '18-25'
		when age between 26 and 35 then '26-35'
		when age between 36 and 45 then '36-45'
		when age between 46 and 55 then '46-55'
		when age between 56 and 65 then '56-65'
		when age between 56 and 65 then '66-75'
		when age between 56 and 65 then '76-85'
		else '86-95'
	end as Age_group, gender,
    case when active_member = 1 then 'Active'
		 else 'Inactive'
	end as active_member, churn
from customer_churn_data) as SegmentedData
group by Age_group, Gender, Active_status
order by Age_group asc;
