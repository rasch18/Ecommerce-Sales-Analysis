with cancelled_orders as (
      Select 
          a.*,
          b.stock_code,
          b.quantity,
          c.unit_price
      From {{ ref('int_transactions_invoice') }} a
      Left join {{ ref('int_transactions_invoice_items') }} b on a.invoice_no = b.invoice_no
      Left join {{ ref('int_transactions_products') }} c on b.stock_code = c.stock_code
      Where a.invoice_no like 'C%'
  )
      Select 
        *,
        (quantity * unit_price) as cancelled_sales_amount
      From cancelled_orders 
      Group by 1,2,3,4,5,6