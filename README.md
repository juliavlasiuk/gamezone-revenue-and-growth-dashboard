# GameZone revenue and growth dashboard
Interactive Power BI dashboard analyzing revenue, orders and customer growth across regions, products and marketing channels, with YoY performance tracking.

Interactive Dashboard ➡️ [LINK](https://app.powerbi.com/links/upDtZ_A6lR?ctid=57c90c33-07df-4070-9672-cd2a8c9335ab&pbi_source=linkShare&bookmarkGuid=cec98cec-7fde-4961-9baf-73fa95acd299 )


## Project Overview
This project covers the full analytics workflow — from raw data cleaning in SQL to an interactive business dashboard in Power BI. The dataset contains transactional sales data from GameZone (fictional company), including orders, customers, products, marketing channels, regions and shipping times.
The dashboard is designed to answer key business questions:
- How is revenue trending over time and how does 2020 compare to 2019?
- Which products and regions drive the most revenue?
- Which marketing channels generate the highest order volume and revenue?
- How does customer and order growth look Year-over-Year?


## Key Insights1. Revenue more than doubled YoY — but growth is concentrated
**1.** Total revenue grew 159.7% YoY (from ~$1.4M to $3.63M). However, this growth is driven almost entirely by three products: 27in 4K Gaming Monitor, Sony PlayStation 5 Bundle and Nintendo Switch. The remaining five products contribute marginally.

**Recommendation:** Investigate whether the bottom products are worth keeping in the portfolio or whether resources should be reallocated to the top performers.

**2.** Direct channel carries the entire business
85% of total revenue ($3.09M) comes from the direct channel. Email accounts for 10%, while affiliate and social media together generate less than 5%.

**Recommendation:** The heavy reliance on a single channel is a business risk. It would be worth assessing whether email and affiliate programs are underfunded or simply underperforming — and whether there is potential to diversify.

**3.** North America dominates, but LATAM shows proportionally high growth
NA generates 52% of total revenue ($1.89M). LATAM, despite being the smallest region ($0.21M), recorded 184% YoY growth — the highest of all regions.

**Recommendation:** LATAM may be an emerging opportunity worth monitoring. A targeted regional strategy could accelerate growth in an otherwise underserved market.

**4.** Customers are spending more, not just buying more
AOV increased 31.5% YoY (from ~$232 to $305), while order volume grew 97.5%. This suggests a shift toward higher-value products — likely driven by the PS5 Bundle launch in 2020.

**Recommendation:** If the AOV increase is product-mix driven, the business should consider what happens to AOV once PS5 hype normalizes and plan accordingly.

**5.** Potential data quality issue flagged
Sony PlayStation 5 Bundle appears in 2019 data despite an official release in November 2020. This may indicate preorder records or a data entry error.

**Recommendation:** This should be validated with the source system before using 2019 product-level data in any business decisions.

## Dashboard pages
Page 1 — Revenue & Growth Analysis
High-level overview of business performance with YoY comparisons.
<img width="1087" height="607" alt="image" src="https://github.com/user-attachments/assets/2629eb7e-6d9a-4eaf-a5b2-32cbbd0c5208" />


Page 2 — Product Deep Dive
Granular view of product performance across marketing channels, platforms and time.
<img width="1312" height="740" alt="image" src="https://github.com/user-attachments/assets/e93d7868-2afa-4544-9f33-84b4b7bb410b" />

## Technical Details
**Tools used:** Excel · PostgreSQL (DBeaver) · Power BI Desktop · Power BI Online

**Data pipeline:**

- Raw data explored and cleaned in Excel — all issues logged in a structured issues tracker
- SQL view v_gamezone_final created in PostgreSQL — handling deduplication, column standardization, region join and data quality flagging
- View connected to Power BI — Calendar table built, DAX measures created for all KPIs and YoY calculations
- Two-page interactive report published to Power BI Online

 Full SQL script ➡️ [LINK](https://github.com/juliavlasiuk/gamezone-revenue-and-growth-dashboard/blob/main/sql/gamezone_orders_data_analysis.sql)


## Contact
Feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/juliavlasiuk/) if you have any questions about this project
