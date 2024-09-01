with invoice_items as (
    Select 
        invoiceno as invoice_no,
        stockcode as stock_code,
        quantity
    From {{ ref('int_transactions')}}
)

    Select *
    From invoice_items