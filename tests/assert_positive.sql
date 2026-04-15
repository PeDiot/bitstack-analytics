SELECT *
FROM {{ ref('analytics') }}
WHERE investment_eur < 0
   OR quantity_sats < 0
   OR total_investment_eur < 0
   OR total_quantity_sats < 0
   OR total_value < 0
   OR current_price < 0
   OR average_price < 0