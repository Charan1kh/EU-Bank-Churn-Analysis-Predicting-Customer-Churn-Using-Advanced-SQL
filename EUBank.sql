# 1. Identify different segments of customers based on their demographic and transactional data.
select *from customer_churn_data;

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
    
select Age_Group, country as Country, gender as Gender, avg(balance) as AvgBalance, count(products_number) as Num_of_products, active_member, churn 
from segmentedData
group by Age_Group, Country, Gender;
    
