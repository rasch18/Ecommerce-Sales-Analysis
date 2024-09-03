with transaction_table as ( -- get country details
  Select 
    a.stock_code,
    a.description,
    a.unit_price,
    a.quantity,
    b.country
  From {{ ref('int_transactions_invoice_items') }} a
  Left join {{ ref('int_transactions_invoice') }} b on a.invoice_no = b.invoice_no
  Where a.invoice_no not in (Select invoice_no from {{ ref('int_transactions_cancelled') }}) --, exclude canceled transactions
  Order by 1 desc

-- Aggregate total quantity in each unit price of an item
), cte_aggregate_quantity_per_country as ( -- calculate sum per itemn stock code, and country
  Select 
    country,
    stock_code,
    description,
    unit_price,
    sum(quantity) as total_product_quantity
  From transaction_table
  Group by 1,2,3,4

-- Aggregate sales amount for each unit price per item
), cte_aggregate_total_sales_amount_per_unit_price as (
  Select 
    country,
    stock_code,
    description,
    unit_price,
    sum(total_product_quantity * unit_price) as total_sales_amount
  From cte_aggregate_quantity_per_country
  Group by 1,2,3,4

-- Aggregate sales amount for each item in each country
), cte_top_item_per_country as ( 
  Select
    country,
    description,
    sum(total_sales_amount) as total_country_sales_amount,
    -- Ranks items within each country based on their total sales
    row_number() over(partition by country order by total_country_sales_amount desc) as item_ranking
  From cte_aggregate_total_sales_amount_per_unit_price
  Group by 1,2
  Qualify item_ranking = 1 -- get only the highest selling item based on sales
  Order by 1 asc

)
  Select * exclude(item_ranking)
  From cte_top_item_per_country