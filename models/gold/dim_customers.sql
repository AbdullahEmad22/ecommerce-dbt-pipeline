{{ config(materialized='table') }}

SELECT DISTINCT
    customer_id,
    customer_name,
    country
FROM {{ ref('ecommerce_sales_silver') }}