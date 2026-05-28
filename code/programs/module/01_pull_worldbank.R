# =============================================================================
# 01_pull_worldbank.R
# Pull environmental and economic indicators from the World Bank via WDI
# =============================================================================

install.packages("WDI", repos = "https://cloud.r-project.org")
install.packages("tidyverse", repos = "https://cloud.r-project.org")

library(WDI)
library(tidyverse)

# -----------------------------------------------------------------------------
# Indicators
# -----------------------------------------------------------------------------

indicators <- c(
  life_expectancy = "SP.DYN.LE00.IN",   # Life expectancy at birth (years)
  forest_pct      = "AG.LND.FRST.ZS",   # Forest area (% of land)
  urban_pct       = "SP.URB.TOTL.IN.ZS" # Urban population (% of total)
)

# -----------------------------------------------------------------------------
# Pull most recent year only
# -----------------------------------------------------------------------------

df_raw <- WDI(
  country   = "all",
  indicator = indicators,
  start     = 2023,
  end       = 2023,
  extra     = FALSE
)

# -----------------------------------------------------------------------------
# Keep country name, year, and three variables only
# -----------------------------------------------------------------------------

df_raw <- df_raw |>
  select(iso2c, country, year, life_expectancy, forest_pct, urban_pct)

# -----------------------------------------------------------------------------
# Quick checks
# -----------------------------------------------------------------------------

cat("Rows pulled:   ", nrow(df_raw), "\n")
cat("Countries:     ", n_distinct(df_raw$country), "\n")
cat("Missing by column:\n")
df_raw |>
  summarise(across(c(life_expectancy, forest_pct, urban_pct), ~ sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "indicator", values_to = "n_missing") |>
  print(n = Inf)

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(df_raw, "data/documentation/worldbank_raw.csv")
cat("\nSaved to data/documentation/worldbank_raw.csv\n")
