library(tidyverse)
library(readr)
library(readxl)
library(here)


df_clean <- read_excel(here("data_clean", "merged_attendance_eqi.xlsx"))


# Clean out NAs just in case
df_clean <- df_clean %>%
  drop_na(eqi_mean, volatility_present, avg_present)

# STEP 1: Standardise predictors
df_clean <- df_clean %>%
  mutate(
    eqi_std = scale(eqi_mean)[,1],
    vol_std = scale(volatility_present)[,1]
  )

# STEP 2: Weighted Risk Score based on variance explained
df_clean <- df_clean %>%
  mutate(
    risk_score = (0.63 * eqi_std) + (0.37 * vol_std)
  )

# STEP 3: Assign risk typologies (qualitative layer)
df_clean <- df_clean %>%
  mutate(
    risk_typology = case_when(
      eqi_std <= -0.5 & vol_std >= 0.5  ~ "High Risk (Structural + Instability)",
      eqi_std <= -0.5 & vol_std < 0.5   ~ "Structural Risk",
      eqi_std > -0.5 & vol_std >= 0.5   ~ "Instability Risk",
      eqi_std > -0.5 & vol_std < 0.5    ~ "Lower Risk"
    ),
  # Clean up NA for later summaries
    risk_typology = factor(risk_typology, levels = c("High Risk (Structural + Instability)", "Structural Risk", "Instability Risk", "Lower Risk"))
  )

# summary table
typology_summary <- df_clean %>%
  group_by(risk_typology) %>%
  summarise(
    mean_attendance = round(mean(avg_present), 1),
    count = n()
  )

print(typology_summary)

# Visualisation (with fixed labels)
ggplot(df_clean, aes(x = eqi_mean, y = volatility_present, color = risk_typology, label = education_region)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_text(size = 3, vjust = -1, check_overlap = TRUE, show.legend = FALSE) +  # <-- THIS IS THE FIX
  labs(
    title = "Regional Risk Typologies",
    x = "EQI (Mean)",
    y = "Volatility",
    color = "Risk Typology"
  ) +
  theme_minimal() +
  scale_color_brewer(palette = "Set2")
