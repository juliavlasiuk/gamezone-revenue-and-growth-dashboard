-- data check
select count(*)
from gamezone_orders_data 
limit 10;


-- created view to replace UPPER column names and select only needed columns for analysis
create or replace view v_gamezone_final AS
with ranked_orders as( -- row number here later is used to remove duplicates I found in order_id column
select  
    o."USER_ID" AS user_id,
    o."ORDER_ID" AS order_id,
    o."PURCHASE_TS_CLEANED" AS purchase_date,
    CAST(o."PURCHASE_YEAR" AS TEXT) AS purchase_year, 
    o."PURCHASE_MONTH" AS purchase_month,
    o."PRODUCT_NAME_CLEANED" AS product_name,
    o."USD_PRICE_CLEANED" AS price,
    o."PURCHASE_PLATFORM" as purchase_platform,
    o."MKT_CHANNEL_CLEANED" AS mkt_channel,
    r.region_cleaned AS region,
    o."TIME_TO_SHIP" AS time_to_ship,
    case 
        when "DATE_CHECK" = TRUE then 'OK'
        else 'Date error'
    end as data_quality_status,
    ROW_NUMBER() over(partition by o."ORDER_ID" order by o."USER_ID") as rn
from gamezone_orders_data o
join regions r on o."COUNTRY_CODE" = r.country)
select *
from ranked_orders
where rn = 1 AND data_quality_status = 'OK';


-- join check - if every country got the region
SELECT count(*)
FROM v_gamezone_final
WHERE region is null;


--null values check
SELECT 
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_users,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_orders,
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE purchase_date IS NULL) AS null_dates,
    COUNT(*) FILTER (WHERE region IS NULL) AS null_regions
FROM v_gamezone_final;




--duplicates check 
SELECT count(*)
FROM v_gamezone_final vgf;


-- checked what order_id duplicate values got left
SELECT order_id, COUNT(*)
FROM v_gamezone_final
GROUP BY order_id
HAVING COUNT(*) > 1
LIMIT 10;

-- verified one order_id from result from above -> shows different user_id which could be data incosistency/system error
-- to have a correct revenue calculations later one of the duplicates has to be removed (check VIEW scrypt)
SELECT *
FROM v_gamezone_final 
WHERE order_id = 'e9e88f519b773427';

SELECT *
FROM v_gamezone_final
LIMIT 10;


--  Revenue by year & month and amount of orders
SELECT 
	purchase_year
	,purchase_month
	,COUNT(order_id) AS orders_amount
	,ROUND(SUM(price),2) as total_revenue
FROM v_gamezone_final 
WHERE data_quality_status = 'OK'
GROUP BY  purchase_year, purchase_month
ORDER BY purchase_year, purchase_month; 

-- QUICK INSIGHTS
-- Noticable spike of revenue in 2020 -> might be caused by COVID or internal company changes? Not much info on that
-- Usual seasonal decrease of orders in dec every year - jan/feb next year 
-- Highest revenue in Dec 2020 - most probably caused by holiday season, but it would be worth checking MKT campaign made at that time



-- Revenue distribution based on the product - 2020
SELECT
	product_name
	,COUNT(*) AS amount_sold
	,ROUND(SUM(price),2) AS total_rev_per_product
FROM v_gamezone_final
WHERE purchase_year = '2020' AND data_quality_status = 'OK'
GROUP BY product_name
ORDER BY total_rev_per_product DESC;
-- QUICK INSIGHTS
-- Razer Pro Gaming Headset has significantly lower revenue then other products - what is the reason for that (data error or just low sales)



-- Revenue distribution based on the product - 2019
SELECT
	product_name
	,COUNT(*) AS amount_sold
	,ROUND(SUM(price),2) AS total_rev_per_product
FROM v_gamezone_final
WHERE purchase_year = '2019' AND data_quality_status = 'OK'
GROUP BY product_name
ORDER BY total_rev_per_product DESC;

-- QUICK INSIGHTS
-- there were less products available in 2019 and overall less sold items (in 2020 revenue increased around 2 times!)
-- nevertheless gaming monitor is product with the highest revenue in both 2019 and 2020 years
-- Sony Playstation 5 bundle was released in 2020 so why we have them mentioned in 2019 - check if those are preorders or some data error


-- Summary table:
SELECT 
	purchase_year
	,product_name
	,ROUND(SUM(price),2) AS total_rev_per_product
FROM v_gamezone_final
WHERE data_quality_status = 'OK'
GROUP BY purchase_year, product_name
ORDER BY purchase_year, total_rev_per_product DESC;



-- Revenue distribution by region
SELECT 
	region
	,ROUND(SUM(price),2) AS revenue_by_region
	,ROUND(((SUM(price)/SUM(SUM(price)) OVER())*100),2) AS revenue_by_rgn_pct_test
FROM v_gamezone_final vgf 
WHERE data_quality_status = 'OK'
GROUP BY region
ORDER BY revenue_by_region DESC;

-- AVG time to ship 
SELECT
	AVG(time_to_ship)
FROM v_gamezone_final
WHERE data_quality_status = 'OK';


--Number of users per marketing channel
SELECT 
	count(*) AS users_number
	,mkt_channel
FROM v_gamezone_final vgf 
WHERE data_quality_status = 'OK'
GROUP BY mkt_channel
ORDER BY users_number DESC;


-- Revenue distribution per marketing channel
SELECT 
	mkt_channel
	,COUNT(*) AS orders_count
	,SUM(price) AS revenue
	,ROUND(AVG(price),2) AS avg_price
	,ROUND(100.0 * SUM(price) / SUM(SUM(price)) OVER (), 1) AS revenue_share_pct
FROM v_gamezone_final vgf 
WHERE data_quality_status = 'OK'
GROUP BY mkt_channel
ORDER BY revenue DESC;


SELECT sum(vgf.price )
FROM v_gamezone_final vgf 
WHERE vgf.purchase_year = '2019' AND  data_quality_status = 'OK';






