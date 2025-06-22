# Attendance and Volatility in Aotearoa

This project analyzes 13 years of regional attendance data (2011-2024) to identify patterns of attendance instability that can be combined with traditional equity-based metrics. The resulting framework provides education policymakers with a data-driven approach to prioritise intervention resources and identify emerging risks before they become critical.

> **Problem**: Focusing intervention strategies on socioeconomic disadvantage risks potentially overlooking at-risk regions with different risk profiles.

> **Solution**: I developed a composite risk scoring model that combines socioeconomic factors with attendance volatility patterns to improve prediction accuracy from 63% to 94%.

> **Impact**: Enables early identification of attendance instability and more strategic allocation of intervention resources.


## Key Discovery

**Attendance volatility explains 31% additional variance beyond socioeconomic factors alone** - increasing model performance from 63% to 94% R².

Regional risk classification combining Equity Index (EQI) and attendance volatility

## Key Findings

- **Volatility matters**: Beyond average attendance rates, instability accounts for ~37% of variation in the risk model
- **Long-term challenges persist**: Most regions haven't returned to pre-pandemic attendance levels
- **Targeted interventions possible**: Risk typologies enable precise, evidence-based policy targeting
- **Regional differences**: Post-COVID volatility varies across regions

## Quick Start

### Dependencies

```r
install.packages(c(
  "dplyr", "ggplot2", "readxl", "broom", 
  "patchwork", "tidyr", "janitor", "here", "stringi", "stringr", "rrepel", "tidyverse"
))
```

## Run Analysis
Follow the markdown files in order to reproduce the complete analysis:

- **01_cleaning_and_ETL.Rmd** - Data import, cleaning, and transformation
- **02_EDA.Rmd** - Exploratory data analysis and key relationships
- **03_modeling_risk_factors.Rmd** - Statistical modeling of attendance predictors
- **04_risk_scoring_typology.Rmd** - Risk classification and regional typologies


## Analysis pipeline 

| Step | File | Description |
|------|------|-------------|
| 1 | Cleaning & ETL | Raw MoE data → tidy format, volatility calculation, EQI integration |
| 2 | EDA | Exploratory analysis, trend identification, regional patterns |
| 3 | Modeling | Predictive models testing EQI + volatility interactions |
| 4 | Risk Scoring | Regional classification for intervention targeting |

## Risk modeling

| Model | R² | Improvement |
|-------|----|-----------:|
| EQI only | 0.63 | Baseline |
| EQI + Volatility | 0.94 | +31 points |
| With interaction | 0.95 | +1 point |

**Translation**: While socioeconomic disadvantage (EQI) strongly predicts attendance, regions with identical EQI scores can have different outcomes based on attendance stability.


## Project structure

```
attendance-risk-scoring/
├── data_raw/           # Original MoE datasets
├── data_clean/         # Processed datasets  
├── notebooks/          # R notebooks
├── scripts/            # R scripts
├── plots/              # ggplot2 plots
└── reports/            # Final analysis outputs
```
## Data Sources

- **Attendance Data: Ministry of Education (2011-2024)**
- **Equity Index: Education Counts - School EQI scores**
- **School Directory: NZ Schools Directory for regional mapping**

## Policy Implications
This analysis enables precision targeting of attendance interventions by identifying regions facing both structural disadvantage AND attendance instability - allowing for more effective resource allocation. The volatility metric would be particularly useful with more granular data, e.g., school-level attendance. Analysing volatility at the school level increases statistical power to detect meaningful variation, allows for attributing local shocks accurately, and enables precise, equity-focused intervention. More granular volatility would also allow for more reliable predictive modelling, since we could account for other relevant school-level variables, interventions, and exogenous shocks. 
>Volatility could be an early alarm for struggling schools, before structural variables like EQI show issues, and before attendance drops significantly.
