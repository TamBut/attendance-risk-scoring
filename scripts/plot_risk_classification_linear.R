
library(tidyverse)
library(readxl)
library(ggrepel)
library(here)
library(writexl)

# Load data (adjust path as needed)
df_clean <- read_excel(here("data_clean", "merged_attendance_eqi.xlsx"))

# Standardising predictors
df_clean <- df_clean %>%
  mutate(
    eqi_std = scale(eqi_mean),
    vol_std = scale(volatility_present)
  )

# Calculate weighted risk score (weights from variance explained)
df_clean <- df_clean %>%
  mutate(
    risk_score = (0.63 * eqi_std) + (0.37 * vol_std)
  )

# Assign risk categories, reversing so higher risk = higher score
df_clean <- df_clean %>%
  mutate(
    risk_quantile = ntile(-risk_score, 4),
    risk_label = case_when(
      risk_quantile == 1 ~ "Very High Risk",
      risk_quantile == 2 ~ "High Risk",
      risk_quantile == 3 ~ "Moderate Risk",
      risk_quantile == 4 ~ "Low Risk"
    ),
    risk_label = factor(risk_label, levels = c("Very High Risk", "High Risk", "Moderate Risk", "Low Risk"))
  )

# Remove rows with NA risk_label
df_clean_cleaned <- df_clean %>%
  filter(!is.na(risk_label))

# Summary stats by risk group
df_clean_cleaned %>%
  group_by(risk_label) %>%
  summarise(
    mean_eqi = round(mean(eqi_mean), 1),
    mean_volatility = round(mean(volatility_present), 2),
    mean_attendance = round(mean(avg_present), 1),
    count = n()
  ) %>%
  arrange(risk_label) %>%
  print()

# Plot
ggplot(df_clean_cleaned, aes(x = eqi_mean, y = volatility_present, color = risk_label, label = education_region)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_text_repel(size = 3, show.legend = FALSE, max.overlaps = 20) +
  labs(title = "Regional Attendance Risk Categorisation",
       subtitle = "Based on combined EQI and Attendance Volatility",
       x = "EQI (Mean)",
       y = "Attendance Volatility") +
  scale_color_manual(values = c(
    "Very High Risk" = "#D73027",  # deep red
    "High Risk" = "#FC8D59",       # warm orange
    "Moderate Risk" = "#4575B4",   # calm blue
    "Low Risk" = "#66BD63"          # fresh green
  )) +
  theme_minimal()


write_xlsx(df_clean_cleaned, here("data_clean", "merged_attendance_risk_categorized.xlsx"))