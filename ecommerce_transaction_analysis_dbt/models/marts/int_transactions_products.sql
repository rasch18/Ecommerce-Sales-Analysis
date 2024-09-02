with products as (
    Select 
        stockcode as stock_code,
        REGEXP_REPLACE(a.description, '[^a-zA-Z0-9]', '') AS description, -- remove any unnneccessary characters
        unitprice as unit_price
    From {{ ref('int_transactions')}}
)
    Select *
    From products