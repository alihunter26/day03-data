# README for day03-data

**Author:** Ali Hunter
**Date:** May 2026
**Contact:** [email]

---

## Overview

This repository contains the data and replication code for [project title]. The analysis uses 2023 World Bank data to examine the relationship between life expectancy, forest cover, and urbanization across countries. All data are drawn from the World Development Indicators (WDI) API and processed entirely in R.

---

## Data Sources and Provenance

| Variable | Indicator Code | Source | Access Date | License |
|----------|---------------|--------|-------------|---------|
| Life expectancy at birth (years) | `SP.DYN.LE00.IN` | World Bank WDI | May 2026 | CC BY 4.0 |
| Forest area (% of land area) | `AG.LND.FRST.ZS` | World Bank WDI | May 2026 | CC BY 4.0 |
| Urban population (% of total) | `SP.URB.TOTL.IN.ZS` | World Bank WDI | May 2026 | CC BY 4.0 |

All data are publicly available at https://data.worldbank.org under the [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

---

## Software and Package Requirements

- **R** (version 4.4 or higher)
- **R packages:**
  - `WDI` — World Bank API access
  - `tidyverse` — data cleaning and manipulation
  - `knitr` — table formatting

To install all packages, run:
```r
install.packages(c("WDI", "tidyverse", "knitr"), repos = "https://cloud.r-project.org")
```

---

## Code

Run scripts in the following order from the project root directory:

| Order | Script | Description | Output |
|-------|--------|-------------|--------|
| 1 | `code/programs/module/01_pull_worldbank.R` | Pulls raw data from World Bank API for all countries, 2023 | `data/documentation/worldbank_raw.csv` |
| 2 | `code/programs/module/02_clean_worldbank.R` | Removes regional and income-group aggregates, retains country-level observations only | `data/clean/worldbank_clean.csv` |
| 3 | `code/programs/module/03_summary_stats.R` | Produces five-number summary per indicator and correlations with life expectancy | `results/statistics/summary_stats.csv`, `results/statistics/correlations.csv` |
