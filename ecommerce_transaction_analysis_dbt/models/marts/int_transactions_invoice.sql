with invoices as (
    Select 
        invoiceno as invoice_no, 
        customerid as customer_id, 
        invoicedate as invoice_date
    From {{ ref('int_transactions')}}
)

    Select invoices
    From invoices