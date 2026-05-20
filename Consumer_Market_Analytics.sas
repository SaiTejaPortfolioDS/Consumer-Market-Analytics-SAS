/*==============================================================================
  Consumer Market Analytics — SAS Statistical Programming
  Author : Mohan Venkata Pavan Sai Teja Kattiboyina
  Program: Consumer_Market_Analytics.sas
  Purpose: Probabilistic analysis, hypothesis testing, and price elasticity
           modeling on a 4-year $50B consumer market dataset
==============================================================================*/


/* ============================================================
   SECTION 1: DATA INGESTION & PREPARATION
   ============================================================ */

/* 1.1 Load raw market dataset */
proc import datafile="data/consumer_market_data.csv"
    out=market_raw
    dbms=csv
    replace;
    getnames=yes;
run;

/* 1.2 Data exploration */
proc contents data=market_raw; run;

proc means data=market_raw n nmiss mean std min max;
    var revenue units_sold price_per_unit promotion_spend
        competitor_price market_share;
run;

/* 1.3 Check for missing values */
proc freq data=market_raw;
    tables _character_ / missing;
run;

/* 1.4 Data cleaning and feature engineering */
data market_clean;
    set market_raw;

    /* Convert date string to SAS date */
    sale_date = input(date_str, yymmdd10.);
    format sale_date date9.;

    /* Derived variables */
    quarter        = qtr(sale_date);
    year           = year(sale_date);
    log_revenue    = log(revenue + 1);
    log_units      = log(units_sold + 1);
    log_price      = log(price_per_unit + 1);
    price_ratio    = price_per_unit / competitor_price;
    promo_flag     = (promotion_spend > 0);
    revenue_per_unit = revenue / units_sold;

    /* Seasonal indicator */
    if quarter in (3, 4) then peak_season = 1;
    else peak_season = 0;

    label
        log_revenue     = "Log-transformed Revenue"
        log_price       = "Log-transformed Price"
        price_ratio     = "Own Price / Competitor Price"
        promo_flag      = "Promotion Active (0/1)"
        peak_season     = "Peak Season Indicator (Q3/Q4)"
        revenue_per_unit= "Revenue per Unit Sold";
run;

proc print data=market_clean(obs=10); run;


/* ============================================================
   SECTION 2: EXPLORATORY DATA ANALYSIS
   ============================================================ */

/* 2.1 Annual revenue summary */
proc means data=market_clean n sum mean std;
    class year;
    var revenue units_sold;
    output out=annual_summary sum=total_revenue total_units
                              mean=avg_revenue avg_units;
run;

proc print data=annual_summary; run;

/* 2.2 Revenue distribution by product category */
proc tabulate data=market_clean;
    class product_category year;
    var revenue;
    table product_category * year,
          revenue * (sum mean std) / rts=30;
run;

/* 2.3 Normality check — Shapiro-Wilk on revenue */
proc univariate data=market_clean normal;
    var revenue log_revenue;
    histogram revenue    / normal kernel;
    histogram log_revenue / normal kernel;
    qqplot revenue     / normal(mu=est sigma=est);
    qqplot log_revenue / normal(mu=est sigma=est);
run;

/* 2.4 Correlation matrix */
proc corr data=market_clean pearson spearman;
    var revenue units_sold price_per_unit promotion_spend
        competitor_price market_share price_ratio;
run;


/* ============================================================
   SECTION 3: HYPOTHESIS TESTING (10+ EXPERIMENTS)
   ============================================================ */

/* Experiment 1: Do promoted products have significantly higher revenue?
   H0: mean revenue (promo) = mean revenue (no promo)
   H1: mean revenue (promo) > mean revenue (no promo)               */
proc ttest data=market_clean sides=U alpha=0.05;
    class promo_flag;
    var revenue;
    title "Exp 1: Promotional Lift — Two-Sample t-Test";
run;

/* Experiment 2: Does peak season drive higher unit sales?           */
proc ttest data=market_clean sides=U alpha=0.05;
    class peak_season;
    var units_sold;
    title "Exp 2: Peak Season Effect on Unit Sales";
run;

/* Experiment 3: ANOVA — Revenue differs across product categories   */
proc anova data=market_clean;
    class product_category;
    model revenue = product_category;
    means product_category / tukey;
    title "Exp 3: One-Way ANOVA — Revenue by Product Category";
run;

/* Experiment 4: ANOVA — Revenue differs across years                */
proc anova data=market_clean;
    class year;
    model revenue = year;
    means year / tukey;
    title "Exp 4: One-Way ANOVA — Revenue by Year";
run;

/* Experiment 5: Chi-square — Promo flag independent of peak season? */
proc freq data=market_clean;
    tables promo_flag * peak_season / chisq expected;
    title "Exp 5: Chi-Square Test — Promo vs. Peak Season";
run;

/* Experiment 6: Wilcoxon rank-sum — Non-parametric revenue comparison
   (use when normality assumption violated)                          */
proc npar1way data=market_clean wilcoxon;
    class promo_flag;
    var revenue;
    title "Exp 6: Wilcoxon Rank-Sum — Promo vs. No-Promo Revenue";
run;

/* Experiment 7: Paired t-test — Own price vs. competitor price
   (test whether own pricing is significantly above competition)     */
proc ttest data=market_clean;
    paired price_per_unit * competitor_price;
    title "Exp 7: Paired t-Test — Own Price vs. Competitor Price";
run;

/* Experiment 8: Correlation significance — Promo spend vs. revenue  */
proc corr data=market_clean;
    var promotion_spend revenue;
    title "Exp 8: Pearson Correlation — Promotion Spend vs. Revenue";
run;

/* Experiment 9: ANOVA — Market share differs by quarter             */
proc anova data=market_clean;
    class quarter;
    model market_share = quarter;
    means quarter / tukey;
    title "Exp 9: One-Way ANOVA — Market Share by Quarter";
run;

/* Experiment 10: Two-sample t-test — Market share above/below median price ratio */
data market_clean;
    set market_clean;
    high_price_ratio = (price_ratio > 1.0);
run;

proc ttest data=market_clean;
    class high_price_ratio;
    var market_share;
    title "Exp 10: Market Share — High vs. Low Price Ratio";
run;

/* Experiment 11: F-test — Variance equality across product lines    */
proc anova data=market_clean;
    class product_line;
    model revenue = product_line;
    title "Exp 11: F-Test — Revenue Variance Across Product Lines";
run;


/* ============================================================
   SECTION 4: PRICE ELASTICITY MODELING
   ============================================================ */

/* 4.1 Simple log-log regression (constant elasticity model)
   ln(Q) = b0 + b1*ln(P) + e
   Interpretation: b1 = price elasticity of demand               */
proc reg data=market_clean;
    model log_units = log_price / clb vif;
    output out=elasticity_simple predicted=yhat_simple residual=resid_simple;
    title "4.1 Log-Log Regression — Price Elasticity (Simple)";
run;

/* 4.2 Multiple regression — Control for promotions, competition, season */
proc reg data=market_clean;
    model log_units = log_price promotion_spend price_ratio
                      peak_season promo_flag / clb vif;
    output out=elasticity_multi predicted=yhat_multi residual=resid_multi;
    title "4.2 Log-Log Regression — Price Elasticity (Full Model)";
run;

/* 4.3 Elasticity by product category (separate regressions) */
proc sort data=market_clean; by product_category; run;

proc reg data=market_clean;
    by product_category;
    model log_units = log_price promotion_spend peak_season / clb;
    title "4.3 Price Elasticity by Product Category";
run;

/* 4.4 Cross-price elasticity — Effect of competitor price on own units */
proc reg data=market_clean;
    model log_units = log_price log(competitor_price + 1)
                      promotion_spend peak_season / clb vif;
    title "4.4 Cross-Price Elasticity Model";
run;

/* 4.5 Residual diagnostics */
proc univariate data=elasticity_multi normal;
    var resid_multi;
    histogram resid_multi / normal;
    qqplot resid_multi / normal(mu=est sigma=est);
    title "4.5 Residual Diagnostics — Full Elasticity Model";
run;


/* ============================================================
   SECTION 5: LOGISTIC REGRESSION — PROMOTION RESPONSE
   ============================================================ */

/* Predict whether a product achieves above-median market share */
data market_clean;
    set market_clean;
    median_ms    = 0.15;  /* example median — update after proc means */
    high_share   = (market_share > median_ms);
run;

proc logistic data=market_clean descending;
    class product_category peak_season / param=ref;
    model high_share = log_price promotion_spend price_ratio
                       peak_season product_category / clodds=wald;
    output out=logit_out predicted=prob_high_share;
    title "5. Logistic Regression — High Market Share Predictor";
run;


/* ============================================================
   SECTION 6: TIME SERIES — REVENUE TREND
   ============================================================ */

/* 6.1 Aggregate monthly revenue */
proc means data=market_clean noprint;
    class year quarter;
    var revenue units_sold;
    output out=quarterly_ts(where=(_type_=3))
           sum=total_revenue total_units;
run;

proc sort data=quarterly_ts; by year quarter; run;

/* 6.2 Plot quarterly revenue trend */
proc sgplot data=quarterly_ts;
    series x=quarter y=total_revenue / group=year markers;
    xaxis label="Quarter";
    yaxis label="Total Revenue ($)";
    title "6. Quarterly Revenue Trend by Year";
run;

/* 6.3 Year-over-year growth */
proc expand data=quarterly_ts out=yoy_growth method=none;
    id quarter;
    convert total_revenue = revenue_lag4 / transformout=(lag 4);
run;

data yoy_growth;
    set yoy_growth;
    yoy_pct = ((total_revenue - revenue_lag4) / revenue_lag4) * 100;
run;

proc print data=yoy_growth; var year quarter total_revenue revenue_lag4 yoy_pct; run;


/* ============================================================
   SECTION 7: RESULTS SUMMARY & EXPORT
   ============================================================ */

/* 7.1 Elasticity summary table */
ods output ParameterEstimates=elasticity_params;
proc reg data=market_clean;
    model log_units = log_price promotion_spend price_ratio peak_season;
run;
ods output close;

proc print data=elasticity_params;
    title "7. Price Elasticity Model — Parameter Estimates";
run;

/* 7.2 Export final feature dataset */
proc export data=market_clean
    outfile="output/market_analysis_output.csv"
    dbms=csv replace;
run;

/* 7.3 Final summary statistics */
proc means data=market_clean mean std min max;
    var revenue units_sold price_per_unit market_share;
    title "7. Final Summary Statistics — Market Dataset";
run;

/*==============================================================================
   END OF PROGRAM
==============================================================================*/
