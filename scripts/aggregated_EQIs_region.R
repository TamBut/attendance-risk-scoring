library(readr)
library(dplyr)
library(writexl)

merged_df <- read_csv(here("data_clean", "eqi_with_regions.csv"))

# group by attendance_region and calculate summary stats
eqi_region <- merged_df %>%
  group_by(attendance_region) %>%
  summarise(
    eqi_mean_2023 = mean(EQI_2023, na.rm = TRUE),
    eqi_mean_2024 = mean(EQI_2024, na.rm = TRUE),
    eqi_mean_2025 = mean(EQI_2025, na.rm = TRUE),
    schools_in_region = n()
  ) %>%
  arrange(attendance_region)

# saving result to Excel
write_xlsx(eqi_region, here("data_clean", "eqi_by_region.xlsx"))