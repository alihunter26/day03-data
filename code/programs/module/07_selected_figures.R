# 07_selected_figures.R
# Three selected figures:
#   1. Scatterplot: Life Expectancy vs. Urban Population %
#   2. Choropleth: Forest Area by Country
#   3. Bar chart: Top 20 Countries by Life Expectancy

library(ggplot2)
library(maps)
library(dplyr)

# Install countrycode if needed (assigns continents to countries automatically)
install.packages("countrycode")
library(countrycode)

# ── Load data ─────────────────────────────────────────────────────────────────

df <- read.csv("data/clean/worldbank_clean.csv")
df <- df[complete.cases(df), ]


# ── Figure 1: Scatterplot — Life Expectancy vs. Urban Population % ────────────

fig1 <- ggplot(df, aes(x = urban_pct, y = life_expectancy)) +
  geom_point(color = "#0d6b65", alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", color = scales::alpha("black", 0.5), se = FALSE) +
  labs(
    title = "Life Expectancy vs. Urban Population Share",
    x = "Urban Population (% of total)",
    y = "Life Expectancy (years)"
  ) +
  theme_minimal()

ggsave("results/figures/selected_fig1_scatter_life_urban.png", fig1, width = 8, height = 6)


# ── Figure 2: Choropleth — Forest Area by Country ────────────────────────────

# Fix country name mismatches so countries show up on the map
name_fixes <- c(
  "Bahamas, The"                   = "Bahamas",
  "Brunei Darussalam"              = "Brunei",
  "Cabo Verde"                     = "Cape Verde",
  "Congo, Dem. Rep."               = "Democratic Republic of the Congo",
  "Congo, Rep."                    = "Republic of Congo",
  "Cote d'Ivoire"                  = "Ivory Coast",
  "Czechia"                        = "Czech Republic",
  "Egypt, Arab Rep."               = "Egypt",
  "Eswatini"                       = "Swaziland",
  "Gambia, The"                    = "Gambia",
  "Hong Kong SAR, China"           = "Hong Kong",
  "Iran, Islamic Rep."             = "Iran",
  "Korea, Dem. People's Rep."      = "North Korea",
  "Korea, Rep."                    = "South Korea",
  "Kyrgyz Republic"                = "Kyrgyzstan",
  "Lao PDR"                        = "Laos",
  "Macao SAR, China"               = "Macao",
  "Micronesia, Fed. Sts."          = "Micronesia",
  "Russian Federation"             = "Russia",
  "Slovak Republic"                = "Slovakia",
  "St. Kitts and Nevis"            = "Saint Kitts",
  "St. Lucia"                      = "Saint Lucia",
  "St. Vincent and the Grenadines" = "Saint Vincent",
  "Syrian Arab Republic"           = "Syria",
  "Trinidad and Tobago"            = "Trinidad",
  "Turkiye"                        = "Turkey",
  "United Kingdom"                 = "UK",
  "United States"                  = "USA",
  "Venezuela, RB"                  = "Venezuela",
  "Viet Nam"                       = "Vietnam",
  "West Bank and Gaza"             = "Palestine",
  "Yemen, Rep."                    = "Yemen"
)

df$country <- ifelse(df$country %in% names(name_fixes),
                     name_fixes[df$country],
                     df$country)

world_map <- map_data("world")
world_map <- world_map[world_map$region != "Antarctica", ]
map_df    <- left_join(world_map, df, by = c("region" = "country"))

fig2 <- ggplot(map_df, aes(x = long, y = lat, group = group, fill = forest_pct)) +
  geom_polygon(color = "white", linewidth = 0.1) +
  scale_fill_gradient(
    low = "#fffacd", high = "#0a6b1a",
    na.value = "lightgray",
    name = "Forest Coverage\n(% of land area)",
    breaks = c(0, 25, 50, 75, 100),
    labels = c("0%", "25%", "50%", "75%", "100%"),
    limits = c(0, 100),
    guide = guide_colorbar(
      barwidth  = 15,
      barheight = 0.8,
      title.position = "top",
      title.hjust = 0.5
    )
  ) +
  labs(
    title    = "Forest Coverage by Country",
    subtitle = "2023; data from World Bank" 
,
  
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    plot.title    = element_text(size = 15, face = "bold", hjust = 0.5, color = "black", margin = margin(t = 10, b = 5)),
    plot.subtitle = element_text(size = 9,  hjust = 0.5,  color = "black", margin = margin(b = 10)),
    plot.caption  = element_text(size = 8,  hjust = 1,    color = "black", margin = margin(t = 10)),
    legend.position = "bottom",
    legend.title  = element_text(size = 9,  face = "bold", color = "black"),
    legend.text   = element_text(size = 8,  color = "black")
  )

ggsave("results/figures/selected_fig2_choropleth_forest.png", fig2, width = 14, height = 8)


# ── Figure 3: Box Plot — Life Expectancy by Region ───────────────────────────
# Each box shows the median, spread, and outliers for countries in that region
# Individual country dots are overlaid so no data is hidden

# Assign continents to all countries, then remove any that couldn't be matched
df$continent <- countrycode(df$country, origin = "country.name", destination = "continent")
df <- df[!is.na(df$continent), ]

fig4 <- ggplot(df, aes(x = reorder(continent, life_expectancy, median),
                        y = life_expectancy,
                        fill = continent)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  geom_jitter(aes(color = continent), width = 0.2, size = 1.5, alpha = 0.5) +
  scale_fill_manual(values = c(
    "Africa"   = "#e8d44d",
    "Americas" = "#0a6b1a",
    "Asia"     = "#0d6b65",
    "Europe"   = "#2a7fbf",
    "Oceania"  = "#74c69d"
  )) +
  scale_color_manual(values = c(
    "Africa"   = "#e8d44d",
    "Americas" = "#0a6b1a",
    "Asia"     = "#0d6b65",
    "Europe"   = "#2a7fbf",
    "Oceania"  = "#74c69d"
  )) +
  labs(
    title = "Life Expectancy by Region",
    subtitle = "Each dot = one country; box shows median and spread",
    x = NULL,
    y = "Life Expectancy (years)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("results/figures/selected_fig3_boxplot_life_by_region.png", fig4, width = 9, height = 6)


message("Done! 3 figures saved to results/figures/")
