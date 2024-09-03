with cancelled_orders as (
      Select 
          a.*,
          b.stock_code,
          b.quantity,
          b.unit_price,
          b.description
      From {{ ref('int_transactions_invoice') }} a
      Left join {{ ref('int_transactions_invoice_items') }} b on a.invoice_no = b.invoice_no
      Where a.invoice_no like 'C%' -- remove cancelled orders with having invoice_no starting with C
  )
      Select 
        *,
        (quantity * unit_price) as cancelled_sales_amount
      From cancelled_orders 
      Group by 1,2,3,4,5,6,7,8