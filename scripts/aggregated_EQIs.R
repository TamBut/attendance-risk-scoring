library(dplyr)
library(readxl)
library(writexl)
library(here)

# Load merged data
merged_df <- read_excel(here("data_clean", "school_region_EQI.xlsx"))

# Group and aggregate by education_region
eqi_region <- merged_df %>%
  group_by(education_region) %>%
  summarise(
    schools_in_region = n(),
    
    EQI_2023_mean = mean(EQI_2023, na.rm = TRUE),
    EQI_2023_median = median(EQI_2023, na.rm = TRUE),
    
    EQI_2024_mean = mean(EQI_2024, na.rm = TRUE),
    EQI_2024_median = median(EQI_2024, na.rm = TRUE),
    
    EQI_2025_mean = mean(EQI_2025, na.rm = TRUE),
    EQI_2025_median = median(EQI_2025, na.rm = TRUE)
  ) %>%
  arrange(education_region)

# Write the aggregated table to Excel
write_xlsx(eqi_region, here("data_clean", "eqi_region_summary.xlsx"))
