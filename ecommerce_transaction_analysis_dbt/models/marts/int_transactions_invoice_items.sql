with invoice_items as (
    Select 
        invoiceno as invoice_no,
        stockcode as stock_code,
        REGEXP_REPLACE(description, '[^a-zA-Z0-9 ]', '') AS description, -- remove any unnneccessary characters
        unitprice::float as unit_price,
        quantity::integer as quantity
    From {{ ref('int_transactions')}}
)

    Select distinct *
    From invoice_items