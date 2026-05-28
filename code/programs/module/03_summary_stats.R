# =============================================================================
# 03_summary_stats.R
# Summary statistics table for all indicators
# =============================================================================

library(tidyverse)
library(knitr)

# -----------------------------------------------------------------------------
# Load
# -----------------------------------------------------------------------------

df <- read_csv("data/clean/worldbank_clean.csv", show_col_types = FALSE)

# -----------------------------------------------------------------------------
# Five-number summary per indicator
# -----------------------------------------------------------------------------

summary_stats <- df |>
  summarise(
    n_countries = n_distinct(country),
    year        = unique(year),

    # Life expectancy
    le_min    = min(life_expectancy, na.rm = TRUE),
    le_q1     = quantile(life_expectancy, 0.25, na.rm = TRUE),
    le_median = median(life_expectancy, na.rm = TRUE),
    le_q3     = quantile(life_expectancy, 0.75, na.rm = TRUE),
    le_max    = max(life_expectancy, na.rm = TRUE),

    # Forest area
    forest_min    = min(forest_pct, na.rm = TRUE),
    forest_q1     = quantile(forest_pct, 0.25, na.rm = TRUE),
    forest_median = median(forest_pct, na.rm = TRUE),
    forest_q3     = quantile(forest_pct, 0.75, na.rm = TRUE),
    forest_max    = max(forest_pct, na.rm = TRUE),

    # Urban population
    urban_min    = min(urban_pct, na.rm = TRUE),
    urban_q1     = quantile(urban_pct, 0.25, na.rm = TRUE),
    urban_median = median(urban_pct, na.rm = TRUE),
    urban_q3     = quantile(urban_pct, 0.75, na.rm = TRUE),
    urban_max    = max(urban_pct, na.rm = TRUE),

    # Correlations with life expectancy
    cor_forest_le = cor(forest_pct, life_expectancy, use = "complete.obs"),
    cor_urban_le  = cor(urban_pct,  life_expectancy, use = "complete.obs")
  )

# -----------------------------------------------------------------------------
# Build summary table
# -----------------------------------------------------------------------------

stats_table <- tibble(
  Indicator = c("Life Expectancy (years)", "Forest Area (% of land)", "Urban Population (% of total)"),
  Min       = round(c(summary_stats$le_min,    summary_stats$forest_min,    summary_stats$urban_min),    1),
  Q1        = round(c(summary_stats$le_q1,     summary_stats$forest_q1,     summary_stats$urban_q1),     1),
  Median    = round(c(summary_stats$le_median, summary_stats$forest_median, summary_stats$urban_median), 1),
  Q3        = round(c(summary_stats$le_q3,     summary_stats$forest_q3,     summary_stats$urban_q3),     1),
  Max       = round(c(summary_stats$le_max,    summary_stats$forest_max,    summary_stats$urban_max),    1)
)

cor_table <- tibble(
  Comparison  = c("Forest Area vs Life Expectancy", "Urban Population vs Life Expectancy"),
  Correlation = round(c(summary_stats$cor_forest_le, summary_stats$cor_urban_le), 3)
)

# -----------------------------------------------------------------------------
# Print tables
# -----------------------------------------------------------------------------

cat("Year:", summary_stats$year, "  |  N countries:", summary_stats$n_countries, "\n\n")

cat("=== Five-Number Summary ===\n")
print(kable(stats_table, format = "simple"))

cat("\n=== Correlations with Life Expectancy ===\n")
print(kable(cor_table, format = "simple"))

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(stats_table, "results/statistics/summary_stats.csv")
write_csv(cor_table,   "results/statistics/correlations.csv")
cat("\nSaved to results/statistics/\n")
