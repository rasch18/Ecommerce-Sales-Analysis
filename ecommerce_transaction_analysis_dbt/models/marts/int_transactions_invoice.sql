with invoices as (
    Select 
        invoiceno as invoice_no, 
        invoicedate as invoice_date,
        customerid::integer as customer_id
    From {{ ref('int_transactions')}}
)

    Select distinct 
      *
    From invoices