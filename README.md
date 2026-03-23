# Bitstack Portfolio Analysis

Personal project to track the weekly performance of my Bitstack portfolio using dbt and BigQuery.

## Metrics

To understand the calculations in the `bitstack.analytics` table, let us define the following variables for a given period consisting of $T$ transactions:

* $t$: The index of the week or transaction ($t \in \{1, \dots, T\}$).
* $i_t$: The amount invested in Euros during week $t$ (out-of-pocket cost).
* $q_t$: The quantity of Bitcoin (in Satoshis) purchased during week $t$.
* $p_t$: The market price of Bitcoin (EUR/BTC) at the time of transaction $t$.

#### Total Investment
The cumulative amount of capital injected into the portfolio.

$$I_{\text{total}} = \sum_{t=1}^{T} i_t$$

#### Total Quantity
The total volume of Bitcoin accumulated, including rewards/gifts where $i_t = 0$.

$$Q_{\text{total}} = \sum_{t=1}^{T} q_t$$

#### Current Price
The market value of Bitcoin at the most recent entry in the dataset.

$$P_{\text{current}} = p_T$$

#### Average Price
The volume-weighted average cost of the portfolio. This is a proxy for the price at which the portfolio was purchased. It takes the different purchase entries into account.

$$P_RU = \frac{\sum_{t=1}^{T} i_t}{\sum_{t=1}^{T} q_t} = \frac{I_{\text{total}}}{Q_{\text{total}}}$$

#### Total Value
The current fiat value of the entire Bitcoin balance.

$$V_{\text{total}} = Q_{\text{total}} \times P_{\text{current}}$$

#### Cumulative Performance
The percentage of gain or loss relative based on average purchase price and current price

$$r = \frac{P_{\text{current}} - P_{\text{average}}}{P_{\text{average}}}$$

## Technical Stack
* **Storage:** Google BigQuery
* **Transformation:** dbt Cloud
* **Visualization:** Looker
