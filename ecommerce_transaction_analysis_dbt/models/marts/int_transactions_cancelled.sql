with cancelled_orders as (
    Select 
        *
    From {{ref('int_transactions_invoice')}}
    Where invoice_no like 'C%'
)
    Select *
    From cancelled_orders