with transactions_table as (
    Select
        a.invoice_date,
        a.invoice_no,
        a.customer_id,
        b.description, 
        b.stock_code,
        b.unit_price,
        b.quantity
    From {{ ref('int_transactions_invoice') }} a
    Left join {{ ref('int_transactions_invoice_items') }} b on a.invoice_no = b.invoice_no
    Where a.invoice_no not in (Select invoice_no from {{ ref('int_transactions_cancelled') }}) -- make sure to not include cancelled items
    -- Get total sum of quantities per item
    ), quantities as ( 
        Select 
            stock_code,
            description, 
            unit_price,
            sum(quantity) as per_item_quantity
        From transactions_table
        Where description is not null
        Group by 1,2,3

    ), item_sales_amount as ( -- same stock codes with different unit prices
      Select 
        stock_code,
        description,
        unit_price,
        per_item_quantity,
        (per_item_quantity * unit_price) as per_item_sales_amount
      From quantities
      Group by 1,2,3,4

    ) 
      Select 
        stock_code,
        description,
        sum(per_item_quantity) as total_quantity,
        sum(per_item_sales_amount) as total_sales_amount
      From item_sales_amount
      Group by 1,2
      Order by total_sales_amount desc