Select 
  MAKE_DATE(YEAR(invoice_date), 1, 1) as invoice_year, -- get year data
  sum(total_quantity) as annual_total_quantity, -- aggregate all quantities
  sum(total_sales_amount) as annual_total_amount -- aggregate sales amount
From {{ ref('fct_daily_total_sales') }} -- reference to daily sales
Group by 1