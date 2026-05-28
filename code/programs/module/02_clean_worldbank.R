# =============================================================================
# 02_clean_worldbank.R
# Clean raw World Bank data
# =============================================================================

library(tidyverse)

# -----------------------------------------------------------------------------
# Load
# -----------------------------------------------------------------------------

df_raw <- read_csv("data/documentation/worldbank_raw.csv", show_col_types = FALSE)

# -----------------------------------------------------------------------------
# Drop rows where all three variables are missing
# -----------------------------------------------------------------------------

df_clean <- df_raw |>
  filter(rowSums(!is.na(select(., life_expectancy, forest_pct, urban_pct))) > 0)

# -----------------------------------------------------------------------------
# Quick checks
# -----------------------------------------------------------------------------

cat("Countries after cleaning: ", n_distinct(df_clean$country), "\n")
cat("Year:                     ", unique(df_clean$year), "\n")
cat("Rows:                     ", nrow(df_clean), "\n")

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(df_clean, "data/clean/worldbank_clean.csv")
cat("\nSaved to data/clean/worldbank_clean.csv\n")
