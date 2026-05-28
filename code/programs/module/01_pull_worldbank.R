# =============================================================================
# 01_pull_worldbank.R
# Pull environmental and economic indicators from the World Bank via WDI
# =============================================================================

library(WDI)
library(tidyverse)

# -----------------------------------------------------------------------------
# Indicators
# -----------------------------------------------------------------------------

indicators <- c(
  # Economic
  gdp_pc_usd        = "NY.GDP.PCAP.CD",      # GDP per capita (current USD)
  gdp_growth        = "NY.GDP.MKTP.KD.ZG",   # GDP growth (annual %)
  trade_pct_gdp     = "NE.TRD.GNFS.ZS",      # Trade (% of GDP)
  gni_pc            = "NY.GNP.PCAP.CD",       # GNI per capita (current USD)

  # Environmental
  co2_pc            = "EN.ATM.CO2E.PC",       # CO2 emissions per capita (metric tons)
  co2_kt            = "EN.ATM.CO2E.KT",       # CO2 emissions total (kt)
  renewable_pct     = "EG.FEC.RNEW.ZS",       # Renewable energy (% of total)
  energy_use_pc     = "EG.USE.PCAP.KG.OE",    # Energy use per capita (kg oil equiv)
  forest_pct        = "AG.LND.FRST.ZS",       # Forest area (% of land)
  pm25              = "EN.ATM.PM25.MC.M3",     # PM2.5 air pollution (mcg/m3)
  electricity_access= "EG.ELC.ACCS.ZS",       # Access to electricity (% of pop)

  # Demographic / control variables
  population        = "SP.POP.TOTL",          # Total population
  urban_pct         = "SP.URB.TOTL.IN.ZS"     # Urban population (% of total)
)

# -----------------------------------------------------------------------------
# Pull
# -----------------------------------------------------------------------------

df_raw <- WDI(
  country   = "all",
  indicator = indicators,
  start     = 2000,
  end       = 2023,
  extra     = TRUE    # appends region, income group, iso2/iso3 codes
)

# -----------------------------------------------------------------------------
# Quick checks
# -----------------------------------------------------------------------------

cat("Rows pulled:     ", nrow(df_raw), "\n")
cat("Countries:       ", n_distinct(df_raw$country), "\n")
cat("Years covered:   ", min(df_raw$year), "–", max(df_raw$year), "\n")
cat("Missing by column:\n")
df_raw |>
  select(all_of(names(indicators))) |>
  summarise(across(everything(), ~ sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "indicator", values_to = "n_missing") |>
  print(n = Inf)

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(df_raw, "data/documentation/worldbank_raw.csv")
cat("\nSaved to data/documentation/worldbank_raw.csv\n")
