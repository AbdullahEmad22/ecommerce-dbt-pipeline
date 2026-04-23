{{ config(materialized='table') }}

SELECT
    transaction_id,
    customer_id,
    product_id,
    order_date,
    quantity * price AS sales_amount,
    quantity,
    price,
    order_status,
    payment_method
FROM {{ ref('ecommerce_sales_silver') }}