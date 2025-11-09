📘 Nigerian Retail Coupon Usage Dashboard
Interactive Business Intelligence Report for Campaign Optimization and Customer Engagement

🧩 Business Problem
In Nigeria’s competitive retail and e-commerce landscape, brands run aggressive coupon campaigns to boost sales, attract new customers, and retain loyal ones. However, many campaigns fail to deliver ROI due to poor targeting, ineffective channels, and low redemption rates.

As a data analyst, I set out to answer: Which campaigns, channels, and discount types actually drive customer engagement and redemption? This dashboard helps marketing teams optimize future campaigns using data-driven insights.

📊 Project Overview
Industry: Retail & E-Commerce (Nigeria)

Dataset: Coupon and Discount Usage Data (200,000 rows, 10 columns)

Tools: Python, Excel (Power Query), MySQL, Power BI, GitHub

Analytics Type: Descriptive, Diagnostic, Exploratory (Predictive modeling planned in next phase)

📁 Dataset Source & Structure
Source: Electric Sheep Africa on Hugging Face

License: GPL (safe for public use)

Format: CSV & Parquet

Schema:

coupon_id, customer_id, coupon_code, discounttype, discount_value, usage_date, order_id, campaignname, channel, redemption_status

🧪 Data Preparation Workflow
🔹 Step 1: Load with Python
python
from datasets import load_dataset
import pandas as pd

dataset = load_dataset("electricsheepafrica/nigerian_retail_and_ecommerce_coupon_and_discount_usage_data")
df = dataset['train'].to_pandas()
df.to_csv("C:/Users/User/Documents/coupon_data/coupon_usage.csv", index=False)
✅ Saved 200,000 rows to coupon_usage.csv

🔹 Step 2: Clean in Excel (Power Query)
Opened CSV in Excel using Power Query

Formatted usageDate to proper date type

Renamed column headers using camelCase

Removed duplicates and invalid rows

Created statusFlag column:

powerquery
if [redemption_status] = "redeemed" then 1 else 0
Saved as coupon_usage_clean_fixed.csv

🔹 Step 3: Import into MySQL
sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coupon_usage_clean_fixed.csv'
INTO TABLE coupons
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(couponId, customerId, couponCode, discountType, discountValue, usageDate, orderId, campaignName, channel, redemptionStatus, statusFlag);
🔹 Step 4: SQL EDA & Indexing
Created indexes on: couponId, customerId, campaignName, usageDate

Ran queries for campaign, channel, discount, and customer analysis

📊 Exploratory Data Analysis (SQL)
✅ Redemption Summary
sql
SELECT COUNT(*) AS totalCouponsSent, SUM(statusFlag) AS totalCouponsRedeemed,
ROUND(SUM(statusFlag)/COUNT(*)*100, 2) AS redemptionRatePercent FROM coupons;
✅ Campaign Performance
sql
SELECT campaignName, COUNT(*) AS totalSent, SUM(statusFlag) AS totalRedeemed,
ROUND(SUM(statusFlag)/COUNT(*)*100, 2) AS redemptionRatePercent
FROM coupons GROUP BY campaignName ORDER BY redemptionRatePercent DESC;
✅ Channel Effectiveness
sql
SELECT channel, COUNT(*) AS totalSent, SUM(statusFlag) AS totalRedeemed,
ROUND(SUM(statusFlag)/COUNT(*)*100, 2) AS redemptionRatePercent
FROM coupons GROUP BY channel ORDER BY totalRedeemed DESC;
✅ Daily Redemption Trend
sql
SELECT DATE(usageDate) AS usageDay, COUNT(*) AS totalCoupons, SUM(statusFlag) AS redeemedCount
FROM coupons GROUP BY usageDay ORDER BY usageDay;
✅ Discount Type Analysis
sql
SELECT discountType, COUNT(*) AS totalSent, SUM(statusFlag) AS totalRedeemed,
ROUND(SUM(statusFlag)/COUNT(*)*100, 2) AS redemptionRatePercent,
ROUND(AVG(discountValue), 2) AS avgDiscountValue
FROM coupons GROUP BY discountType ORDER BY redemptionRatePercent DESC;
✅ Top Redeemed Coupons
sql
SELECT couponCode, discountType, discountValue, campaignName, channel
FROM coupons WHERE statusFlag = 1 ORDER BY discountValue DESC LIMIT 10;
✅ Customer Engagement
sql
SELECT customerId, COUNT(*) AS totalCoupons, SUM(statusFlag) AS redeemedCoupons,
ROUND(SUM(statusFlag)/COUNT(*)*100, 2) AS redemptionRatePercent
FROM coupons GROUP BY customerId HAVING COUNT(*) > 5 ORDER BY redeemedCoupons DESC LIMIT 10;
✅ Campaign Discount Value
sql
SELECT campaignName, ROUND(SUM(discountValue * statusFlag), 2) AS totalDiscountRedeemed
FROM coupons GROUP BY campaignName ORDER BY totalDiscountRedeemed DESC;
📈 Key Insights
SMS and email channels had highest redemption

Fixed amount discounts outperformed percentage-based ones

Some campaigns had redemption rates above 70%

A small group of customers redeemed a large number of coupons

Redemption rate varied widely across campaigns (20–32%)

Higher discount tiers (50–60%) drove stronger engagement

Repeat and loyalty campaigns outperformed awareness campaigns

📊 Power BI Dashboard
🔹 Visuals & Business Value
Visual	What It Shows	Why It Matters
KPI Cards	Total Sent, Redeemed, Redemption Rate	Quick performance snapshot
Campaign Performance (Bar)	Redemption rate by campaign	Identifies top-performing campaigns
Channel Share (Pie)	Redemption by channel	Reveals most effective communication
Daily Trend (Line)	Redemption over time	Detects seasonal or campaign spikes
Discount Analysis (Bar)	Redemption by discount type	Optimizes pricing strategy
Customer Engagement (Table)	Top customers by redemption rate	Targets loyal and high-value customers
🔹 Filters & Interactivity
Campaign Filter: Compare performance across campaigns

Channel Filter: Isolate SMS, email, push notifications

Date Range Filter: Analyze trends over time

🔮 Next Steps: Predictive Modeling
To showcase my transition into data science:

✅ Python Models (Planned)
Logistic Regression: Predict redemption likelihood

Decision Trees: Segment customers by behavior

✅ Power BI AI Visuals (Free Account)
Key Influencers: Identify top drivers of redemption

Decomposition Tree: Drill into campaign/channel impact

🚀 How to Use This Project
Clone this repo

Open Coupon_Usage_Analysis.pbix in Power BI Desktop

Explore the dashboard interactively

Use filters to drill into campaigns, channels, and time periods

Review SQL scripts and data for reproducibility

📣 Citation
Electric Sheep Africa (2025). Coupon And Discount Usage Data. Hugging Face. https://huggingface.co/datasets/electricsheepafrica/nigerian-retail-coupon-and-discount-usage-data