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

aggregates <- c(
  # Regional groupings
  "Africa Eastern and Southern", "Africa Western and Central",
  "Arab World", "East Asia & Pacific",
  "East Asia & Pacific (IDA & IBRD countries)",
  "East Asia & Pacific (excluding high income)",
  "Europe & Central Asia",
  "Europe & Central Asia (IDA & IBRD countries)",
  "Europe & Central Asia (excluding high income)",
  "European Union", "Euro area",
  "Latin America & Caribbean",
  "Latin America & Caribbean (excluding high income)",
  "Latin America & the Caribbean (IDA & IBRD countries)",
  "Middle East & North Africa",
  "Middle East & North Africa (excluding high income)",
  "Middle East & North Africa (IDA & IBRD countries)",
  "North America", "South Asia", "South Asia (IDA & IBRD)",
  "Sub-Saharan Africa",
  "Sub-Saharan Africa (IDA & IBRD countries)",
  "Sub-Saharan Africa (excluding high income)",
  "Central Europe and the Baltics",
  # Income groupings
  "High income", "Low income", "Low & middle income",
  "Lower middle income", "Middle income", "Upper middle income",
  "Not classified",
  # World Bank lending categories
  "IBRD only", "IDA & IBRD total", "IDA blend",
  "IDA only", "IDA total",
  # Demographic groupings
  "Early-demographic dividend", "Late-demographic dividend",
  "Post-demographic dividend", "Pre-demographic dividend",
  # Other groupings
  "Caribbean small states", "Fragile and conflict affected situations",
  "Heavily indebted poor countries (HIPC)",
  "Least developed countries: UN classification",
  "OECD members", "Other small states", "Pacific island small states",
  "Small states", "World"
)

df_clean <- df_raw |>
  filter(!is.na(iso2c), nchar(iso2c) == 2) |>
  filter(!country %in% aggregates) |>
  select(-iso2c) |>
  filter(if_any(c(life_expectancy, forest_pct, urban_pct), ~ !is.na(.)))

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
