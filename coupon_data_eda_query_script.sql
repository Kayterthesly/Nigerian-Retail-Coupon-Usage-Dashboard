-- ✅ Step 1: Create the database if not already created
CREATE DATABASE IF NOT EXISTS coupon_analytics;
USE coupon_analytics;

-- ✅ Step 2: Create the table with correct column types
DROP TABLE IF EXISTS coupons;

CREATE TABLE coupons (
  couponId TEXT,
  customerId TEXT,
  couponCode TEXT,
  discountType TEXT,
  discountValue DOUBLE,
  usageDate DATETIME,
  orderId TEXT,
  campaignName TEXT,
  channel TEXT,
  redemptionStatus TEXT,
  statusFlag INT
);

-- find local path allowed for dataset 
SHOW VARIABLES LIKE "secure_file_priv";

-- ✅ Step 3: Load data from CSV file
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coupon_usage_clean_fixed.csv'
INTO TABLE coupons
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(couponId, customerId, couponCode, discountType, discountValue, usageDate, orderId, campaignName, channel, redemptionStatus, statusFlag);

-- Verify Import
SELECT COUNT(*) FROM coupons;

--  Change column types to VARCHAR(100)
ALTER TABLE coupons
MODIFY campaignName VARCHAR(100),
MODIFY channel VARCHAR(100),
MODIFY customerId VARCHAR(100);

-- view table
SELECT * FROM coupons;

-- EDA Goals, We’ll explore: Overall coupon performance, Redemption behavior, Campaign and channel effectiveness, Discount value insights, Customer engagement.
-- Indexes to speed up filtering and grouping
CREATE INDEX idx_usageDate ON coupons(usageDate);
CREATE INDEX idx_campaignName ON coupons(campaignName);
CREATE INDEX idx_channel ON coupons(channel);
CREATE INDEX idx_customerId ON coupons(customerId);

-- 1. Overall Coupon Summary
-- Total coupons sent, redeemed, and redemption rate
SELECT 
  COUNT(*) AS totalCouponsSent,
  SUM(statusFlag) AS totalCouponsRedeemed,
  ROUND(SUM(statusFlag) / COUNT(*) * 100, 2) AS redemptionRatePercent
FROM coupons;

-- 2. Redemption Rate by Campaign
-- Redemption performance across campaigns
SELECT 
  campaignName,
  COUNT(*) AS totalSent,
  SUM(statusFlag) AS totalRedeemed,
  ROUND(SUM(statusFlag) / COUNT(*) * 100, 2) AS redemptionRatePercent
FROM coupons
GROUP BY campaignName
ORDER BY redemptionRatePercent DESC;

-- 3. Channel Effectiveness
-- Which channels drive the most redemptions?
SELECT 
  channel,
  COUNT(*) AS totalSent,
  SUM(statusFlag) AS totalRedeemed,
  ROUND(SUM(statusFlag) / COUNT(*) * 100, 2) AS redemptionRatePercent
FROM coupons
GROUP BY channel
ORDER BY totalRedeemed DESC;

-- 4. Daily Redemption Trend
-- Redemption activity over time
SELECT 
  DATE(usageDate) AS usageDay,
  COUNT(*) AS totalCoupons,
  SUM(statusFlag) AS redeemedCount
FROM coupons
GROUP BY usageDay
ORDER BY usageDay;

-- 5. Redemption by Discount Type
-- Which discount types perform best?
SELECT 
  discountType,
  COUNT(*) AS totalSent,
  SUM(statusFlag) AS totalRedeemed,
  ROUND(SUM(statusFlag) / COUNT(*) * 100, 2) AS redemptionRatePercent,
  ROUND(AVG(discountValue), 2) AS avgDiscountValue
FROM coupons
GROUP BY discountType
ORDER BY redemptionRatePercent DESC;

-- 6. High-Value Redeemed Coupons
-- Top 10 most expensive redeemed coupons
SELECT 
  couponCode,
  discountType,
  discountValue,
  campaignName,
  channel
FROM coupons
WHERE statusFlag = 1
ORDER BY discountValue DESC
LIMIT 10;

-- 7. Customer Redemption Behavior
-- Most engaged customers
SELECT 
  customerId,
  COUNT(*) AS totalCoupons,
  SUM(statusFlag) AS redeemedCoupons,
  ROUND(SUM(statusFlag) / COUNT(*) * 100, 2) AS redemptionRatePercent
FROM coupons
GROUP BY customerId
HAVING COUNT(*) > 5
ORDER BY redeemedCoupons DESC
LIMIT 10;

-- 8. Redemption Value by Campaign
-- Total discount value redeemed per campaign
SELECT 
  campaignName,
  ROUND(SUM(discountValue * statusFlag), 2) AS totalDiscountRedeemed
FROM coupons
GROUP BY campaignName
ORDER BY totalDiscountRedeemed DESC;
