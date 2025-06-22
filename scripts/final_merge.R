library(readxl)
library(dplyr)
library(janitor)
library(here)

# Term-level attendance data
attendance_df <- read_excel(here("data_clean", "Regular-attendance-data-cleaned.xlsx")) %>%
  clean_names()

# EQI data by region
eqi_df <- read_excel(here("data_clean", "eqi_by_region.xlsx")) %>%
  clean_names()

# Volatility data by region
volatility_df <- read_excel(here("data_clean", "data_with_volatility.xlsx")) %>%
  clean_names()

# Step 1: Joining attendance data with EQI
merged_df <- attendance_df %>%
  left_join(eqi_df, by = "education_region")

# Step 2: Joining with volatility data
merged_df <- merged_df %>%
  left_join(volatility_df, by = "education_region")

# Check the structure
glimpse(merged_df)

# Just making sure year and percent are numeric
merged_df <- merged_df %>%
  mutate(
    year = as.numeric(year),
    term = as.numeric(term),
    percent = as.numeric(percent),
    avg_present = as.numeric(avg_present)
  )

library(writexl)
write_xlsx(merged_df, here("data_clean", "attendance_with_eqi_merged.xlsx"))