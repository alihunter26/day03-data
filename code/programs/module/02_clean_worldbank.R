# =============================================================================
# 02_clean_worldbank.R
# Clean raw World Bank data
# =============================================================================

library(tidyverse)

# -----------------------------------------------------------------------------
# Load
# -----------------------------------------------------------------------------

df_raw <- read_csv("/Users/alihunter/Documents/EIL Summer/Group-Data-Brief_Day05/data/raw/wdi_raw.csv", show_col_types = FALSE)

# -----------------------------------------------------------------------------
# Rename WDI indicator codes to readable names
# -----------------------------------------------------------------------------

df_raw <- df_raw |>
  rename(
    gdp_per_capita    = NY.GDP.PCAP.CD,
    electricity_access = EG.ELC.ACCS.ZS,
    renewable_elec    = EG.ELC.RNWX.ZS,
    life_expectancy   = SP.DYN.LE00.IN,
    forest_pct        = AG.LND.FRST.ZS,
    urban_pct         = SP.URB.TOTL.IN.ZS,
    pm25_pollution    = EN.ATM.PM25.MC.M3,
    co2_per_gdp       = EN.GHG.CO2.RT.GDP.PP.KD,
    maternal_mortality = SH.STA.MMRT,
    energy_per_capita = EG.USE.PCAP.KG.OE
  )

# -----------------------------------------------------------------------------
# Drop rows where all variables are missing
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

analysis_vars <- c(
  "gdp_per_capita", "electricity_access", "renewable_elec",
  "life_expectancy", "forest_pct", "urban_pct",
  "pm25_pollution", "co2_per_gdp", "maternal_mortality", "energy_per_capita"
)

df_clean <- df_raw |>
  filter(!is.na(iso2c), nchar(iso2c) == 2) |>
  filter(!country %in% aggregates) |>
  select(-iso2c) |>
  filter(if_any(all_of(analysis_vars), ~ !is.na(.)))

# -----------------------------------------------------------------------------
# Quick checks
# -----------------------------------------------------------------------------

cat("Countries after cleaning: ", n_distinct(df_clean$country), "\n")
cat("Years:                    ", paste(range(df_clean$year), collapse = " - "), "\n")
cat("Rows:                     ", nrow(df_clean), "\n")
cat("\nMissingness by variable:\n")
df_clean |>
  summarise(across(all_of(analysis_vars), ~ mean(is.na(.)) * 100)) |>
  pivot_longer(everything(), names_to = "variable", values_to = "pct_missing") |>
  mutate(pct_missing = round(pct_missing, 1)) |>
  print(n = Inf)

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(df_clean, "data/clean/worldbank_clean.csv")
cat("\nSaved to data/clean/worldbank_clean.csv\n")
