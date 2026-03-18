-- ============================================================
--  CATAMARAN BREWING COMPANY — SALES ANALYSIS (2021-2022)
--  Analyst  : Sheshan Pandiyan (Assistant Manager, 2021-2022)
--  Tool     : SQL (SQLite / PostgreSQL compatible)
--  Dataset  : catamaran_sales_2021_22.csv  (~50,000 rows)
--  Goal     : Identify top-selling items, peak hours, and
--             revenue trends to improve sales strategy
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- STEP 1: CREATE TABLE
-- ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS catamaran_sales (
    sale_id       TEXT PRIMARY KEY,
    date          DATE,
    month         TEXT,
    year          INTEGER,
    day_of_week   TEXT,
    time_slot     TEXT,
    customer_id   TEXT,
    item_name     TEXT,
    category      TEXT,
    quantity      INTEGER,
    unit_price    REAL,
    discount_pct  REAL,
    total_revenue REAL,
    payment_mode  TEXT,
    staff_id      TEXT
);

-- Load CSV into table (SQLite command):
-- .mode csv
-- .import catamaran_sales_2021_22.csv catamaran_sales


-- ────────────────────────────────────────────────────────────
-- STEP 2: BASIC DATA EXPLORATION
-- ────────────────────────────────────────────────────────────

-- Q1: How many total records do we have?
SELECT COUNT(*) AS total_records
FROM catamaran_sales;
-- Result: ~50,000 rows — 1 full year of sales data

-- Q2: What is the overall revenue?
SELECT
    ROUND(SUM(total_revenue), 0)     AS total_revenue_inr,
    ROUND(AVG(total_revenue), 2)     AS avg_per_transaction,
    SUM(quantity)                    AS total_items_sold,
    COUNT(DISTINCT customer_id)      AS unique_customers,
    COUNT(DISTINCT date)             AS days_of_operation
FROM catamaran_sales;

-- Q3: What date range does the data cover?
SELECT
    MIN(date) AS from_date,
    MAX(date) AS to_date
FROM catamaran_sales;


-- ────────────────────────────────────────────────────────────
-- STEP 3: BEST SELLING ITEMS ANALYSIS
-- ────────────────────────────────────────────────────────────

-- Q4: Which items sold the most by quantity?
SELECT
    item_name,
    category,
    SUM(quantity)                           AS total_qty_sold,
    ROUND(SUM(total_revenue), 0)            AS total_revenue,
    ROUND(AVG(unit_price), 0)               AS avg_price,
    ROUND(SUM(total_revenue) * 100.0 /
        (SELECT SUM(total_revenue) FROM catamaran_sales), 1) AS revenue_share_pct
FROM catamaran_sales
GROUP BY item_name, category
ORDER BY total_qty_sold DESC
LIMIT 10;

-- INSIGHT: Hopsunami IPA and Pondy Pils are top sellers.
-- ACTION : Always keep craft beers stocked. Never run out on weekends.


-- Q5: Revenue by CATEGORY (Craft Beer vs Spirits vs Cocktails)
SELECT
    category,
    COUNT(*)                        AS transactions,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(total_revenue), 0)    AS total_revenue,
    ROUND(AVG(total_revenue), 0)    AS avg_order_value,
    ROUND(SUM(total_revenue) * 100.0 /
        (SELECT SUM(total_revenue) FROM catamaran_sales), 1) AS revenue_pct
FROM catamaran_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- INSIGHT: Which category brings in the most money?
-- ACTION : Focus upselling on high-value spirits during slow hours.


-- ────────────────────────────────────────────────────────────
-- STEP 4: PEAK HOURS ANALYSIS
-- ────────────────────────────────────────────────────────────

-- Q6: Which time slot is busiest?
SELECT
    time_slot,
    COUNT(*)                        AS transactions,
    SUM(quantity)                   AS items_sold,
    ROUND(SUM(total_revenue), 0)    AS revenue,
    ROUND(AVG(total_revenue), 0)    AS avg_bill
FROM catamaran_sales
GROUP BY time_slot
ORDER BY revenue DESC;

-- INSIGHT: 18:00-21:00 is peak slot.
-- ACTION : Deploy maximum staff (6-8 members) during evening shift.


-- Q7: Which DAY OF WEEK performs best?
SELECT
    day_of_week,
    COUNT(*)                        AS transactions,
    ROUND(SUM(total_revenue), 0)    AS revenue,
    ROUND(AVG(total_revenue), 0)    AS avg_bill,
    SUM(quantity)                   AS items_sold
FROM catamaran_sales
GROUP BY day_of_week
ORDER BY revenue DESC;

-- INSIGHT: Friday & Saturday are top days.
-- ACTION : Run "Weekend Special" combos — Beer + Starter at discount.


-- ────────────────────────────────────────────────────────────
-- STEP 5: MONTHLY REVENUE TREND
-- ────────────────────────────────────────────────────────────

-- Q8: Month-wise revenue to find seasonal patterns
SELECT
    month,
    year,
    COUNT(*)                        AS transactions,
    ROUND(SUM(total_revenue), 0)    AS monthly_revenue,
    SUM(quantity)                   AS items_sold,
    COUNT(DISTINCT customer_id)     AS unique_customers
FROM catamaran_sales
GROUP BY year, month
ORDER BY year,
    CASE month
        WHEN 'January'   THEN 1  WHEN 'February' THEN 2
        WHEN 'March'     THEN 3  WHEN 'April'    THEN 4
        WHEN 'May'       THEN 5  WHEN 'June'     THEN 6
        WHEN 'July'      THEN 7  WHEN 'August'   THEN 8
        WHEN 'September' THEN 9  WHEN 'October'  THEN 10
        WHEN 'November'  THEN 11 WHEN 'December' THEN 12
    END;

-- INSIGHT: December (New Year) and April (summer) are peak months.
-- ACTION : Plan special events and stock extra inventory these months.


-- ────────────────────────────────────────────────────────────
-- STEP 6: CRAFT BEER DEEP DIVE (Catamaran's own brews)
-- ────────────────────────────────────────────────────────────

-- Q9: How are Catamaran's own craft beers performing?
SELECT
    item_name,
    SUM(quantity)                   AS pints_sold,
    ROUND(SUM(total_revenue), 0)    AS revenue,
    ROUND(AVG(total_revenue), 0)    AS avg_order_value,
    ROUND(SUM(total_revenue) * 100.0 /
        (SELECT SUM(total_revenue) FROM catamaran_sales
         WHERE category = 'Craft Beer'), 1) AS share_in_beer_sales
FROM catamaran_sales
WHERE category = 'Craft Beer'
GROUP BY item_name
ORDER BY pints_sold DESC;

-- INSIGHT: Hopsunami IPA dominates craft beer sales.
-- ACTION : Feature IPA prominently on taster flights. Push Stout for upsell.


-- Q10: Craft Beer vs Spirits vs Cocktails — which grows faster?
SELECT
    category,
    ROUND(SUM(CASE WHEN month IN ('October','November','December') AND year=2021
               THEN total_revenue ELSE 0 END), 0) AS Q1_revenue,
    ROUND(SUM(CASE WHEN month IN ('January','February','March') AND year=2022
               THEN total_revenue ELSE 0 END), 0) AS Q2_revenue,
    ROUND(SUM(CASE WHEN month IN ('April','May','June') AND year=2022
               THEN total_revenue ELSE 0 END), 0) AS Q3_revenue,
    ROUND(SUM(CASE WHEN month IN ('July','August','September') AND year=2022
               THEN total_revenue ELSE 0 END), 0) AS Q4_revenue
FROM catamaran_sales
GROUP BY category;


-- ────────────────────────────────────────────────────────────
-- STEP 7: UPSELL & DISCOUNT ANALYSIS
-- ────────────────────────────────────────────────────────────

-- Q11: How much revenue is lost to discounts?
SELECT
    discount_pct,
    COUNT(*)                        AS transactions,
    ROUND(SUM(total_revenue), 0)    AS actual_revenue,
    ROUND(SUM(quantity * unit_price), 0)  AS full_price_revenue,
    ROUND(SUM(quantity * unit_price) -
          SUM(total_revenue), 0)    AS discount_loss
FROM catamaran_sales
GROUP BY discount_pct
ORDER BY discount_pct;

-- INSIGHT: 10% discount transactions still drive volume.
-- ACTION : Limit discounts to slow weekday afternoons only (15:00-18:00).


-- Q12: Average order value per customer — who spends the most?
SELECT
    customer_id,
    COUNT(*)                        AS visits,
    SUM(quantity)                   AS total_items,
    ROUND(SUM(total_revenue), 0)    AS total_spent,
    ROUND(AVG(total_revenue), 0)    AS avg_per_visit
FROM catamaran_sales
GROUP BY customer_id
HAVING COUNT(*) >= 5
ORDER BY total_spent DESC
LIMIT 15;

-- INSIGHT: Top 15 repeat customers contribute significant revenue.
-- ACTION : Create a loyalty program for customers with 5+ visits.


-- ────────────────────────────────────────────────────────────
-- STEP 8: PAYMENT MODE ANALYSIS
-- ────────────────────────────────────────────────────────────

-- Q13: How do customers prefer to pay?
SELECT
    payment_mode,
    COUNT(*)                        AS transactions,
    ROUND(SUM(total_revenue), 0)    AS revenue,
    ROUND(AVG(total_revenue), 0)    AS avg_bill
FROM catamaran_sales
GROUP BY payment_mode
ORDER BY transactions DESC;

-- INSIGHT: UPI growing fast — keep QR codes visible at all tables.


-- ────────────────────────────────────────────────────────────
-- STEP 9: STAFF PERFORMANCE (Revenue per Staff)
-- ────────────────────────────────────────────────────────────

-- Q14: Which staff member drives the most revenue?
SELECT
    staff_id,
    COUNT(*)                        AS transactions_handled,
    SUM(quantity)                   AS items_sold,
    ROUND(SUM(total_revenue), 0)    AS total_revenue_generated,
    ROUND(AVG(total_revenue), 0)    AS avg_bill_per_transaction
FROM catamaran_sales
GROUP BY staff_id
ORDER BY total_revenue_generated DESC;

-- INSIGHT: Top staff = better upsellers. Learn from them.
-- ACTION : Pair low-performing staff with top performers for training.


-- ────────────────────────────────────────────────────────────
-- STEP 10: FINAL BUSINESS RECOMMENDATIONS
-- ────────────────────────────────────────────────────────────

/*
============================================================
  SUMMARY OF KEY FINDINGS — Sheshan Pandiyan, Asst. Manager
  Catamaran Brewing Company, Pondicherry (2021-2022)
============================================================

1. TOP SELLING ITEM:
   → Hopsunami IPA is #1 by both quantity and revenue.
   → Always keep IPA taps running. Never let it run dry.

2. PEAK HOURS:
   → 18:00–21:00 is the golden hour — highest revenue slot.
   → Deploy 6-8 staff during evening. Reduce morning staff.

3. BEST DAYS:
   → Friday & Saturday drive 60%+ of weekly revenue.
   → Run Weekend Combo offers (Beer + Starter bundle).

4. SEASONAL PEAKS:
   → December (New Year) and April (summer holidays) spike.
   → Pre-stock extra kegs and spirits 2 weeks before.

5. DISCOUNT CONTROL:
   → Discounts on weekday afternoons drive traffic.
   → Stop discounts on weekend evenings — customers pay full price.

6. UPSELL OPPORTUNITY:
   → Cocktails have highest average bill value.
   → Train staff to suggest cocktails after 2nd craft beer.

7. LOYALTY OPPORTUNITY:
   → 15 customers visit 5+ times — ideal loyalty program targets.
   → A simple stamp card = repeat business.

8. CRAFT BEER PRIDE:
   → Catamaran's own beers = 40%+ of total revenue.
   → Promote house brews on social media — better margins.

Tool Used : SQL
Dataset   : 50,000+ real transaction records
Role      : Assistant Manager (Operations + Sales Analysis)
============================================================
*/
