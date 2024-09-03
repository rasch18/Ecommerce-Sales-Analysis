with total_quantity_no as (
  Select 
    b.invoice_date::date as invoice_date, -- convert date values from timestamp to record all quantities sold per day
    a.stock_code,
    a.description,
    a.unit_price, -- though some items are under the same stock code, they have each price amount
    sum(a.quantity) as total_quantity -- sum number of quantities
  From {{ ref('int_transactions_invoice_items') }} a
  Left join {{ ref('int_transactions_invoice') }} b on a.invoice_no = b.invoice_no -- incoporate date field
  Where a.invoice_no not in (Select invoice_no from {{ ref('int_transactions_cancelled') }})
  Group by 1,2,3,4

)
  Select 
    invoice_date,
    stock_code,
    description,
    total_quantity,
    unit_price,
    SUM(total_quantity * unit_price) AS total_sales_amount  -- calculate the total sales per item
  From total_quantity_no
  Group by 1,2,3,4,5