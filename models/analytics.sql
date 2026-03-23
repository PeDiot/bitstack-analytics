{{ config(materialized="table") }}

{% set eur_cts = 100.0 %}
{% set btc_sats = 99982320.0 %}

with
    daily_data as (
        select
            date,
            coalesce(investment_cts, 0) as investment_eur_cts,
            quantity_sats,
            coalesce(price_cts, investment_cts) as fiat_value_cts
        from {{ source("bitstack", "raw") }}
    ),

    cumulative_data as (
        select
            date,
            investment_eur_cts,
            quantity_sats,
            fiat_value_cts,
            sum(investment_eur_cts) over (
                order by date asc rows between unbounded preceding and current row
            ) as total_investment_cts,
            sum(quantity_sats) over (
                order by date asc rows between unbounded preceding and current row
            ) as total_quantity_sats
        from daily_data
    ),

    calculated_metrics as (
        select
            date,
            investment_eur_cts,
            quantity_sats,
            total_investment_cts,
            total_quantity_sats,

            (cast(fiat_value_cts as float64) / {{ eur_cts }})
            / (nullif(quantity_sats, 0) / {{ btc_sats }}) as current_price,
            (cast(total_investment_cts as float64) / {{ eur_cts }})
            / (nullif(total_quantity_sats, 0) / {{ btc_sats }}) as average_price

        from cumulative_data
    )

select
    date,
    round(investment_eur_cts / {{ eur_cts }}, 2) as investment_eur,
    quantity_sats,

    round(total_investment_cts / {{ eur_cts }}, 2) as total_investment,
    total_quantity_sats as total_quantity,

    round(current_price * (total_quantity_sats / {{ btc_sats }}), 2) as total_value,

    round(current_price, 2) as current_price,
    round(average_price, 2) as average_price,

    round(
        (current_price - average_price) / nullif(average_price, 0), 4
    ) as cumulative_performance

from calculated_metrics
order by date desc
