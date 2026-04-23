{{ config(materialized='table') }}

WITH cleaning AS (
    SELECT 
        transaction_id,
        CAST(order_date AS DATE) AS order_date,
        customer_id,
        customer_name,
        CASE
            WHEN country NOT IN('US', 'UK', 'IN', 'DE', 'FR', 'CA', 'AU') THEN 'Unknown'
            ELSE country
        END AS country,
        product_id,
        product_category,
        CASE 
            WHEN quantity < 0 THEN 1
            ELSE quantity
        END AS quantity,
        CASE 
            WHEN price < 0 THEN 0
            ELSE price
        END AS price,
        payment_method,
        order_status
    FROM {{ ref('ecommerce_sales_bronze') }}
    WHERE customer_id IS NOT NULL 
        AND CAST(order_date AS DATE) <= CURRENT_DATE
),

deduplication AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY order_date DESC) AS flag_last
    FROM cleaning
)

SELECT *
FROM deduplication
WHERE flag_last = 1