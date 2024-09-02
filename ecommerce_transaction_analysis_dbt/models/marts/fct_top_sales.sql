with quantities as (Select
        a.invoice_no,
        a.customer_id,
        a.invoice_date,
        b.stock_code,
        c.description, 
        c.unit_price,
        b.quantity
    From {{ ref('int_transactions_invoice') }} a
    Left join {{ ref('int_transactions_invoice_items') }} b on a.invoice_no = b.invoice_no
    Left join {{ ref('int_transactions_products') }} c on b.stock_code = c.stock_code
    Where a.invoice_no not in (Select invoice_no from int_transactions_cancelled) -- make sure to not include cancelled items
    )
        Select 
            invoice_no,
            customer_id,
            invoice_date,
            stock_code,
            description, 
            unit_price,
            quantity,
            (quantity * unit_price) as total_sales_amount
        From quantities
        Group by 1,2,3,4,5,6,7
        Order by total_sales_amount desc