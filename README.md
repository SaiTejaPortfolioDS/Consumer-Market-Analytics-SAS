# Conagra Brands — Meat Substitute Market Analysis

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/SaiTejaPortfolioDS/Conagra-Brands-Meat-Substitute-Analysis/blob/main/Conagra_Meat_Substitute_Sales_Analysis.ipynb)
![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python)
![scikit-learn](https://img.shields.io/badge/scikit--learn-1.3-orange?logo=scikit-learn)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?logo=jupyter)

## Business Problem

Conagra competes in the fast-growing meat substitute category (projected **$15B globally by 2027**). The goal of this analysis is to answer two commercial questions:

1. **Which product attributes and promotional levers drive the most unit sales?**
2. **Where does the Gardein brand have untapped competitive whitespace?**

Answering these with statistical rigor — rather than intuition alone — gives category managers a prioritized, defensible action list.

## Approach

```
Raw Retail Data
    │
    ▼
Exploratory Analysis ──► Brand share · Flavor gaps · Season × Promo patterns
    │
    ▼
Feature Engineering ──► One-hot encoding · % Merch lift · Flavor × Season interactions
    │
    ▼
Regularized Regression ──► ElasticNet CV  ┐
                            Lasso CV      ┘ ─► Ranked feature coefficients
    │
    ▼
Business Recommendations
```

## Key Findings

| Driver | Direction | Business Implication |
|--------|-----------|----------------------|
| Feature & Display co-activation | ↑ Positive | Highest promo ROI — prioritize joint campaigns |
| Flavor × Season interactions | ↑ Positive | Align assortment to peak flavor-season combos |
| Pack size (`total_ounces`) | ↑ Positive | Multi-pack SKUs capture volume-buying occasions |
| Gardein flavor whitespace (BEEF, CHICKEN) | Opportunity | SKU expansion into top-performing flavors |

## Methodology

| Step | Details |
|------|---------|
| **EDA** | Brand share (pie), flavor ranking, Gardein gap analysis, season × promo heatmap |
| **Preprocessing** | `StandardScaler` fit exclusively on training data — prevents leakage |
| **Encoding** | `pd.get_dummies` on `season`, `category`, `sub_category`, `flavor`, `form` |
| **Interactions** | Flavor × season and season × promo cross-features |
| **Models** | `ElasticNetCV` (L1 + L2) and `LassoCV` (L1), both with 5-fold CV alpha selection |
| **Evaluation** | Train R², Test R², Adjusted R² on 80/20 hold-out |
| **Interpretability** | Coefficient ranking — non-zero Lasso coefficients = minimal sufficient feature set |

## Tech Stack

| Library | Version | Purpose |
|---------|---------|---------|
| `pandas` | ≥ 2.0 | Data manipulation |
| `numpy` | ≥ 1.24 | Numerical operations |
| `scikit-learn` | ≥ 1.3 | Pipelines, scaling, Lasso/ElasticNet |
| `matplotlib` | ≥ 3.7 | Visualizations |
| `seaborn` | ≥ 0.12 | Statistical plots |
| `openpyxl` | ≥ 3.1 | Reading Excel source files |
| `jupyter` | ≥ 1.0 | Interactive notebook environment |

## Project Structure

```
Conagra-Brands-Meat-Substitute-Analysis/
├── Conagra_Meat_Substitute_Sales_Analysis.ipynb   ← main analysis notebook
├── data/                                           ← place input files here (not tracked)
│   ├── Top_5_Meat_Substitute_With_Category_Info.xlsx
│   ├── One_Hot_Encoded_File.csv
│   └── Final Data.csv
├── requirements.txt
└── README.md
```

## Setup & Reproduction

```bash
# 1. Clone
git clone https://github.com/SaiTejaPortfolioDS/Conagra-Brands-Meat-Substitute-Analysis.git
cd Conagra-Brands-Meat-Substitute-Analysis

# 2. Create & activate virtual environment
python -m venv .venv
source .venv/bin/activate        # macOS / Linux
# .venv\Scripts\activate         # Windows

# 3. Install dependencies
pip install -r requirements.txt

# 4. Add data files to ./data/  (see Project Structure above)

# 5. Launch notebook
jupyter notebook Conagra_Meat_Substitute_Sales_Analysis.ipynb
```

**Alternative — run instantly in the cloud:** click the "Open In Colab" badge above.

## Data

The analysis uses proprietary retail scanner data covering the top 5 meat substitute SKUs across Conagra's portfolio. Due to confidentiality the raw files are not included in this repository. The notebook documents every transformation step so the pipeline can be applied to any similarly structured retail dataset.

| File | Description |
|------|-------------|
| `Top_5_Meat_Substitute_With_Category_Info.xlsx` | Source data: product attributes, brand, season, promotional channel volumes |
| `One_Hot_Encoded_File.csv` | Intermediate: one-hot encoded categorical features |
| `Final Data.csv` | Modeling-ready table including derived `% Change in Sales due to merch` column |

## Author

**Sai Teja KMVP**
Master's in Business Analytics & AI — University of Texas at Dallas

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://www.linkedin.com/in/saitejakmvp/)
[![GitHub](https://img.shields.io/badge/GitHub-SaiTejaPortfolioDS-181717?logo=github)](https://github.com/SaiTejaPortfolioDS)
