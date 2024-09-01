with customers as (
    Select 
        customerid as customer_id,
        country
    From {{ ref('int_transactions')}}
)

    Select *
    From customers