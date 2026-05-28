# =============================================================================
# 03_summary_stats.R
# Summary statistics table for all indicators
# =============================================================================

library(tidyverse)

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
# Print
# -----------------------------------------------------------------------------

cat("=== Summary Statistics ===\n\n")
cat("Year:        ", summary_stats$year, "\n")
cat("N countries: ", summary_stats$n_countries, "\n\n")

cat("Life Expectancy (years):\n")
cat("  Min:", round(summary_stats$le_min, 1),
    " Q1:", round(summary_stats$le_q1, 1),
    " Median:", round(summary_stats$le_median, 1),
    " Q3:", round(summary_stats$le_q3, 1),
    " Max:", round(summary_stats$le_max, 1), "\n\n")

cat("Forest Area (% of land):\n")
cat("  Min:", round(summary_stats$forest_min, 1),
    " Q1:", round(summary_stats$forest_q1, 1),
    " Median:", round(summary_stats$forest_median, 1),
    " Q3:", round(summary_stats$forest_q3, 1),
    " Max:", round(summary_stats$forest_max, 1), "\n\n")

cat("Urban Population (% of total):\n")
cat("  Min:", round(summary_stats$urban_min, 1),
    " Q1:", round(summary_stats$urban_q1, 1),
    " Median:", round(summary_stats$urban_median, 1),
    " Q3:", round(summary_stats$urban_q3, 1),
    " Max:", round(summary_stats$urban_max, 1), "\n\n")

cat("Correlations with Life Expectancy:\n")
cat("  Forest area: ", round(summary_stats$cor_forest_le, 3), "\n")
cat("  Urban pop:   ", round(summary_stats$cor_urban_le, 3), "\n")

# -----------------------------------------------------------------------------
# Save
# -----------------------------------------------------------------------------

write_csv(summary_stats, "results/statistics/summary_stats.csv")
cat("\nSaved to results/statistics/summary_stats.csv\n")
