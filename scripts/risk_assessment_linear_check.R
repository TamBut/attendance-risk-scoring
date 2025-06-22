
library(tidyverse)
library(readxl)
library(here)


df_clean <- read_excel(here("data_clean", "merged_attendance_eqi.xlsx"))

glimpse(df_clean)

# STEP 1: Standardise predictors
df_clean <- df_clean %>%
  mutate(
    eqi_std = as.numeric(scale(eqi_mean)),           # Standardize EQI
    vol_std = as.numeric(scale(volatility_present))  # Standardize volatility
  )

# STEP 2: Assign weights based on model variance explained
# ~63% EQI, ~37% volatility (from earlier models)

df_clean <- df_clean %>%
  mutate(
    risk_score = (0.63 * eqi_std) + (0.37 * vol_std)
  )

# STEP 3: Quick check of risk score distribution
summary(df_clean$risk_score)

# STEP 4: Validate association between risk score and attendance
model_lin <- lm(avg_present ~ risk_score, data = df_clean)
summary(model_lin)

# STEP 5: Visualise relationship
ggplot(df_clean, aes(x = risk_score, y = avg_present)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Attendance vs Weighted Risk Score",
       x = "Weighted Risk Score",
       y = "Average Attendance") +
  theme_minimal()


model_lin <- lm(avg_present ~ risk_score, data = df_clean)
summary(model_lin)

