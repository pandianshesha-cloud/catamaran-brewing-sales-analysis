# 🍺 Catamaran Brewing Company — Sales Analysis (2021–2022)

**Analyst:** Sheshan Pandiyan | Assistant Manager (2021–2022)  
**Tool:** SQL (SQLite compatible)  
**Dataset:** ~50,000 sales transactions | 1 full year  
**Location:** Pondicherry, India  

---

## 📌 About This Project

I worked as **Assistant Manager at Catamaran Brewing Company**, Pondicherry from 2021 to 2022. During my time there, I handled guest queries, managed high-pressure situations, and observed sales patterns daily.

This project uses **SQL** to analyze 1 year of sales data (50,000+ rows) to answer real business questions I faced on the floor — *Which beers sell the most? When is it busiest? How can we upsell better?*

---

## 🍻 About Catamaran Brewing Company

Catamaran Brewing Company is **Pondicherry's first craft brewery**, located at 117, Anna Salai. They brew their own craft beers on-site including:

| Beer Name | Style |
|---|---|
| Hopsunami IPA | Indian Pale Ale |
| Pondy Pils | Pilsner |
| Indian Summer | Belgian Witbier |
| Vox Populi | Dark Lager |
| Yuri G's | Oatmeal Stout |
| Chingari Cider | Apple Cider |
| Smoky Santa | Porter |
| Dive In Blues | Hard Seltzer |

---

## ❓ Business Questions Answered

| # | Question | SQL Concept Used |
|---|---|---|
| 1 | What is total revenue and unique customers? | `SUM`, `COUNT DISTINCT` |
| 2 | Which items sell the most? | `GROUP BY`, `ORDER BY` |
| 3 | Which category earns the most? | `GROUP BY`, percentage calc |
| 4 | Which time slot is the busiest? | `GROUP BY` time_slot |
| 5 | Which day of week performs best? | `GROUP BY` day_of_week |
| 6 | Monthly revenue trend? | `CASE WHEN`, seasonal analysis |
| 7 | How are house craft beers performing? | `WHERE category`, `GROUP BY` |
| 8 | How much revenue lost to discounts? | Revenue vs full price calc |
| 9 | Who are top repeat customers? | `HAVING`, loyalty analysis |
| 10 | Which staff drives most revenue? | Staff performance ranking |

---

## 💡 Key Findings

- 🏆 **Hopsunami IPA** is the #1 selling item — always keep taps running
- ⏰ **18:00–21:00** is peak hour — needs maximum staff deployment
- 📅 **Friday & Saturday** drive 60%+ of weekly revenue
- 🎄 **December** is the highest revenue month (New Year rush)
- 💰 **Cocktails** have the highest average bill value — best upsell target
- 🔁 Top 15 repeat customers = ideal loyalty program candidates

---

## 📁 Files in This Repository

```
catamaran-sales-analysis/
│
├── catamaran_sales_analysis.sql      ← All 14 SQL queries with insights
├── catamaran_sales_2021_22.csv       ← Dataset (50,196 rows)
└── README.md                         ← This file
```

---

## 🛠️ How to Run

**Option 1 — SQLite (Free, simple):**
```bash
# Install SQLite (free)
# Open terminal and type:
sqlite3 catamaran.db
.mode csv
.import catamaran_sales_2021_22.csv catamaran_sales
.read catamaran_sales_analysis.sql
```

**Option 2 — DB Browser for SQLite (Visual tool, no coding needed):**
1. Download free from: https://sqlitebrowser.org
2. Open → Import CSV file
3. Copy paste any query → Run

---

## 📊 Dataset Details

| Column | Description |
|---|---|
| sale_id | Unique transaction ID |
| date | Sale date (Oct 2021 – Sep 2022) |
| day_of_week | Monday to Sunday |
| time_slot | 4 slots: 12-15, 15-18, 18-21, 21-23 |
| item_name | Beer / Spirit / Cocktail name |
| category | Craft Beer / Whiskey / Vodka / Cocktail etc |
| quantity | Number of glasses/bottles |
| unit_price | Price per item (₹) |
| discount_pct | 0%, 5%, or 10% |
| total_revenue | Final amount after discount |
| payment_mode | Cash / Card / UPI |
| staff_id | Staff member who handled the table |

---

## 🛠️ Skills Demonstrated

- SQL `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `HAVING`
- Aggregate functions: `SUM`, `AVG`, `COUNT`, `ROUND`
- `CASE WHEN` for quarterly breakdown
- Subqueries for percentage calculations
- Business thinking from real hospitality experience

---

## 👤 About Me

**Sheshan Pandiyan** — Hospitality professional transitioning to Data Analytics.  
4+ years managing restaurant and bar operations across Tamil Nadu & Pondicherry.  
Now applying data skills to the same industry problems I solved manually on the floor.

📧 pandianshesha@gmail.com | 📍 Vellore, Tamil Nadu
