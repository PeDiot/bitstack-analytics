# Bitstack Portfolio Analysis

Personal project to track the weekly performance of my Bitstack portfolio using dbt and BigQuery.

## Metrics

To understand the calculations in the `bitstack.analytics` table, let us define the following variables for a given period consisting of $T$ transactions:

* $t$: The index of the week or transaction ($t \in \{1, \dots, T\}$).
* $i_t$: The amount invested in Euros during week $t$ (out-of-pocket cost).
* $q_t$: The quantity of Bitcoin (in Satoshis) purchased during week $t$.
* $p_t$: The market price of Bitcoin (EUR/BTC) at the time of transaction $t$.

---

### 1. Total Investment ($I_{total}$)
The cumulative amount of capital injected into the portfolio.
$$I_{total} = \sum_{t=1}^{T} i_t$$

### 2. Total Quantity ($Q_{total}$)
The total volume of Bitcoin accumulated, including rewards/gifts where $i_t = 0$.
$$Q_{total} = \sum_{t=1}^{T} q_t$$

### 3. Current Price ($P_{current}$)
The market value of Bitcoin at the most recent entry in the dataset.
$$P_{current} = p_T$$

### 4. Average Price / Break-even ($PRU$)
The volume-weighted average cost of the portfolio. This represents the price at which the portfolio enters profit.
$$PRU = \frac{\sum_{t=1}^{T} i_t}{\sum_{t=1}^{T} q_t} = \frac{I_{total}}{Q_{total}}$$

### 5. Total Value ($V_{total}$)
The current fiat value of the entire Bitcoin balance.
$$V_{total} = Q_{total} \times P_{current}$$

### 6. Cumulative Performance ($Perf_{cum}$)
The percentage of gain or loss relative to the total invested capital.
$$Perf_{cum} = \frac{V_{total} - I_{total}}{I_{total}} = \frac{P_{current} - PRU}{PRU}$$

## Technical Stack
* **Storage:** Google BigQuery (`Bronze` and `Gold` layers).
* **Transformation:** dbt (Data Build Tool) Cloud.
* **Orchestration:** Medallion Architecture (Raw $\rightarrow$ Analytics).
* **Visualization:** Looker.