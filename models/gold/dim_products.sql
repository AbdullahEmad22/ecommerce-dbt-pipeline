{{ config(materialized='table') }}

SELECT DISTINCT
    product_id,
    product_category
FROM {{ ref('ecommerce_sales_silver') }}