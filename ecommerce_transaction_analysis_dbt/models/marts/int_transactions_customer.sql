with customers as (
    Select 
        customerid::integer as customer_id,
        country
    From {{ ref('int_transactions')}}
)

    Select distinct
      *
    From customers