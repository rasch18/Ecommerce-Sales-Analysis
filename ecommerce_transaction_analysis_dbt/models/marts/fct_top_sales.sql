with quantities as (Select
        a.stock_code,
        a.description,
        a.unit_price,
        b.invoice_no,
        b.quantity
    From int_transactions_products a
    Left join int_transactions_invoice_items b on a.stock_code = b.stock_code
    Where b.invoice_no not in (Select invoice_no from int_transactions_cancelled) -- make sure to not include cancelled items
    )
        Select 
            stock_code,
            description,
            unit_price,
            invoice_no, 
            sum(quantity) as total_quantity -- aggregate total quantity
        From quantities
        Group by 1,2,3,4
        Order by total_quantity desc