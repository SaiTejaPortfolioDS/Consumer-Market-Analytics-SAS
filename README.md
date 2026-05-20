# Consumer Market Analytics — SAS Statistical Programming

![SAS](https://img.shields.io/badge/SAS-Statistical%20Programming-0076A8)
![Domain](https://img.shields.io/badge/Domain-Consumer%20Market%20Analytics-orange)
![Experiments](https://img.shields.io/badge/Experiments-11%20Hypothesis%20Tests-green)
![Dataset](https://img.shields.io/badge/Dataset-4%20Year%20%2450B%20Market-lightgrey)

## Overview

A comprehensive SAS statistical programming project analyzing a 4-year, $50B consumer market dataset across **11 hypothesis testing experiments** and a suite of **price elasticity regression models**. The program covers the full analytical pipeline — from data ingestion and EDA through probabilistic analysis, multivariate regression, and time series trending.

This project mirrors real-world CPG (Consumer Packaged Goods) analytics workflows used by firms like Nielsen, IRI, and major retail chains.

---

## Analytical Sections

### 1. Data Ingestion & Feature Engineering
- PROC IMPORT for raw CSV ingestion
- Derived variables: log-transformed price/revenue, price ratio (own/competitor), promotional flag, peak season indicator, revenue per unit
- Date parsing and quarter/year extraction

### 2. Exploratory Data Analysis
- Annual revenue and unit sales summaries (PROC MEANS, PROC TABULATE)
- Normality testing — Shapiro-Wilk test on raw and log-transformed revenue (PROC UNIVARIATE)
- Histogram and Q-Q plots for distributional assessment
- Pearson and Spearman correlation matrix across 7 key variables

### 3. Hypothesis Testing — 11 Experiments

| # | Test | Question | Procedure |
|---|------|----------|-----------|
| 1 | Two-sample t-test (one-sided) | Do promoted products earn higher revenue? | PROC TTEST |
| 2 | Two-sample t-test (one-sided) | Does peak season drive higher unit sales? | PROC TTEST |
| 3 | One-way ANOVA + Tukey HSD | Revenue differs across product categories? | PROC ANOVA |
| 4 | One-way ANOVA + Tukey HSD | Revenue differs across years? | PROC ANOVA |
| 5 | Chi-square test | Promo flag independent of peak season? | PROC FREQ |
| 6 | Wilcoxon rank-sum (non-parametric) | Promo vs. no-promo revenue (non-normal) | PROC NPAR1WAY |
| 7 | Paired t-test | Own price vs. competitor price — significant gap? | PROC TTEST |
| 8 | Pearson correlation significance | Promotion spend vs. revenue relationship | PROC CORR |
| 9 | One-way ANOVA + Tukey HSD | Market share differs by quarter? | PROC ANOVA |
| 10 | Two-sample t-test | Market share: high vs. low price ratio | PROC TTEST |
| 11 | F-test | Revenue variance across product lines | PROC ANOVA |

### 4. Price Elasticity Modeling

Uses the **log-log regression** framework — the industry standard for constant elasticity estimation:

> ln(Units) = β₀ + β₁·ln(Price) + controls + ε
> **Interpretation:** β₁ = price elasticity of demand

| Model | Specification |
|-------|--------------|
| Simple elasticity | log_units ~ log_price |
| Full model | log_units ~ log_price + promotion_spend + price_ratio + peak_season + promo_flag |
| By-category | Separate regressions per product category |
| Cross-price elasticity | log_units ~ log_price + log(competitor_price) + controls |

Includes VIF diagnostics (multicollinearity), confidence intervals, and residual normality checks.

### 5. Logistic Regression — Promotion Response
Predicts whether a product achieves above-median market share using price, promotions, competition, and seasonality as predictors. Outputs odds ratios with Wald confidence intervals.

### 6. Time Series — Revenue Trend
Quarterly revenue aggregation, year-over-year growth calculation, and trend visualization via PROC SGPLOT and PROC EXPAND.

---

## Dataset

Sample data included in `data/consumer_market_data.csv` (500 records, 4-year span).

| Column | Description |
|--------|-------------|
| `date_str` | Transaction date (YYYY-MM-DD) |
| `product_category` | Beverages / Snacks / Dairy / Frozen Foods / Personal Care |
| `product_line` | Premium / Standard / Economy |
| `price_per_unit` | Own product price ($) |
| `competitor_price` | Nearest competitor price ($) |
| `units_sold` | Units sold in period |
| `revenue` | Total revenue ($) |
| `promotion_spend` | Promotional investment ($) |
| `market_share` | Share of category volume (0–1) |

---

## File Structure

```
Consumer-Market-Analytics-SAS/
├── Consumer_Market_Analytics.sas   ← Main SAS program (7 sections)
├── data/
│   └── consumer_market_data.csv    ← Sample dataset (500 records)
├── output/                         ← Export destination for results
└── README.md
```

---

## How to Run

**Option 1 — SAS Studio (free, browser-based):**
1. Go to [SAS Studio via SAS OnDemand](https://welcome.oda.sas.com/)
2. Upload `Consumer_Market_Analytics.sas` and the `data/` folder
3. Open the `.sas` file and click Run

**Option 2 — SAS University Edition / Base SAS:**
```sas
/* Update file paths at top of program if needed, then submit */
%include "Consumer_Market_Analytics.sas";
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| `PROC IMPORT` | CSV data ingestion |
| `PROC MEANS` / `PROC UNIVARIATE` | Descriptive statistics, normality tests |
| `PROC TTEST` | One- and two-sample t-tests, paired t-tests |
| `PROC ANOVA` | One-way ANOVA with Tukey HSD post-hoc |
| `PROC FREQ` | Chi-square tests, cross-tabulations |
| `PROC NPAR1WAY` | Non-parametric Wilcoxon rank-sum test |
| `PROC CORR` | Pearson/Spearman correlation with significance |
| `PROC REG` | OLS regression, elasticity modeling, VIF diagnostics |
| `PROC LOGISTIC` | Binary logistic regression, odds ratios |
| `PROC SGPLOT` | Time series and trend visualizations |
| `PROC EXPAND` | Lag computation for YoY growth |

---

## Author

**Mohan Venkata Pavan Sai Teja Kattiboyina**
MS Business Analytics & AI — University of Texas at Dallas

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://www.linkedin.com/in/saitejakmvp/)
[![Portfolio](https://img.shields.io/badge/Portfolio-saitejaportfolio.com-00897B)](https://saitejaportfolio.com)
