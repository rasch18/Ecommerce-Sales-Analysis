with quantities as (Select
        a.stock_code,
        a.description, -- remove any unnneccessary characters
        a.unit_price,
        b.quantity
    From int_transactions_products a
    Left join int_transactions_invoice_items b on a.stock_code = b.stock_code
    Where b.invoice_no not in (Select invoice_no from int_transactions_cancelled) -- make sure to not include cancelled items
    )
        Select 
            stock_code,
            description,
            unit_price,
            total_quantity -- aggregate total quantity
        From quantities
        Group by 1,2,3
        Order by total_quantity desc