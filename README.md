
# 💲EU Bank Customer Churn Analysis For Credit Products.
## Overview
This project involves **exploratory data analysis (EDA)** on a dataset containing information about bank customers. The primary objective is to uncover insights related to customer churn, focusing on various factors like demographics, product holdings, and membership status. The analysis also includes the development of key performance indicators (KPIs) to help understand churn trends and customer behavior.

## Dataset
The dataset consists of the following features:

- _customer_id_: Unique identifier for each customer.
- _credit_score_: Credit score of the customer.
- _country_: Country of residence.
- _gender_: Gender of the customer.
- _age_: Age of the customer.
- _tenure_: Number of years the customer has been with the bank.
- _balance_: Current balance in the customer's account.
- _products_number_: Number of products the customer holds with the bank.
- _credit_card_: Whether the customer has a credit card (1: Yes, 0: No).
- _active_member_: Whether the customer is an active member (1: Yes, 0: No).
- _estimated_salary_: Estimated annual salary of the customer.
- _churn_: Whether the customer has churned (1: Yes, 0: No).

#### Dataset Link: [Click here to view on Kaggle.](https://www.kaggle.com/datasets/gauravtopre/bank-customer-churn-dataset/data)


## Project Goals
The primary goal of this project is to conduct an in-depth exploratory data analysis (EDA) to understand the factors influencing customer churn and to create actionable insights for the bank. The project involves several SQL queries, each addressing specific aspects of the analysis, where Q1 - Q4 are KPI's. :

1. **Overall Churn Rate**
Calculates the percentage of customers who have churned, providing a quick snapshot of the churn situation.

![Overall Churn Rate](https://github.com/user-attachments/assets/5c576479-7412-4a6e-860f-18b78205255b)

2. **Customer Lifetime Value (CLV) for Churned Customers**
Determines the average balance of churned customers, giving insights into the financial impact of churn.

![Customer Lifetime Value](https://github.com/user-attachments/assets/28394f3b-e958-4d1c-b369-2b15ef3ce695)

3. **Churn Rate by Product Holding**
Analyzes how the number of products held by customers affects their likelihood of churning.

![Churn Rate by Product Holding](https://github.com/user-attachments/assets/02d8073c-de3a-4e70-88a1-49e1088ac128)

4. **Active Member Retention Rate**
Measures the retention rate of customers who are active members, highlighting the effectiveness of membership in reducing churn.

![Active member retention rate](https://github.com/user-attachments/assets/ceeb2618-4aac-4d01-99e1-a6fde2619cb9)

5. **Customer Segmentation**
Identifies different segments of customers based on their demographic and transactional data, allowing for targeted marketing and retention strategies.

![Customer Segmentation](https://github.com/user-attachments/assets/cebc5a7b-0a50-45fb-b3e4-d65c2096782a)

6. **Active Membership Impact**
Explores how active membership status impacts churn rates across different demographic segments such as age, gender, and country.

![Active Membership Impact](https://github.com/user-attachments/assets/a4ff83f2-b48d-4120-a25a-c4915d06f96c)

7. **Churn Risk Prediction**
Builds a model to predict the likelihood of a customer churning based on various factors like account tenure, balance, and product holding.

![Churn Risk Prediction](https://github.com/user-attachments/assets/8a216959-803e-42c2-99ec-c40a156d0ce8)
...

8. **Customer Demographics Impact**
Assesses the impact of customer demographics (e.g., age, gender, geography) on churn rates to identify high-risk segments.

![Customer Demographics Impact](https://github.com/user-attachments/assets/0aadd735-bc61-4352-868f-e534e5bd9f1b)
...

9. **Product Holding Patterns**
Examines how the number of products a customer holds correlates with their likelihood of churning, offering insights for optimizing cross-selling and upselling strategies.

![Product Holding Patterns](https://github.com/user-attachments/assets/75a3e49e-7d70-409c-8caf-abebb19918c9)

## Methodology
The analysis is performed using SQL queries to extract, transform, and analyze the data. The queries are designed to answer key business questions related to customer churn, including overall churn rates, the impact of product holdings, and the effect of active membership.


_Contributions are welcome! Please fork the repository and submit a pull request for any improvements or new analyses._
