with transaction_table as ( -- get country details
  Select 
    a.invoice_no,
    a.stock_code,
    a.description,
    a.unit_price,
    a.quantity,
    c.country
  From int_transactions_invoice_items a
  Left join int_transactions_invoice b on a.invoice_no = b.invoice_no
  Left join int_transactions_customer c on b.customer_id = c.customer_id
  Where a.invoice_no not in (Select invoice_no from int_transactions_cancelled)
  Order by 1 desc

-- Aggregates total sales for each item in each country, filtering out canceled transactions
), cte_sales as ( -- calculate sum per itemn stock code, and country
  Select 
    country,
    stock_code,
    description,
    sum(quantity * unit_price) as total_sales 
  From transaction_table
  Where country is not null
  Group by 1,2,3

-- Ranks items within each country based on their total sales
)
  Select 
    country,
    stock_code,
    description,
    total_sales,
    row_number() over(partition by country order by total_sales desc) as item_ranking
  From cte_sales
  Qualify item_ranking = 1 -- get only the highest selling item based on sales
  Order by 1 asc