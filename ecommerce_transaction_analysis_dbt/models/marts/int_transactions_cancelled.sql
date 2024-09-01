with cancelled_orders as (
    Select 
        *
    From {{ref('int_transactions_products')}}
    Where stock_code like 'C%'
)
    Select *
    From cancelled_orders