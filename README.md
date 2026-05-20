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
