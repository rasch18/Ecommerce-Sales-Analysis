with products as (
    Select 
        stockcode as stock_code,
        description,
        unitprice as unit_price
    From {{ ref('int_transactions')}}
)
    Select *
    From products