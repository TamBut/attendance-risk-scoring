library(readr)
library(readxl)
library(dplyr)
library(writexl)
library(here)


eqi_file <- here("data_raw", "School-EQI-numbers-2023-2025.xlsx")
directory_file <- here("data_raw", "directory.csv")

# Load EQI data (skip 1 row to get headers)
eqi_df <- read_excel(eqi_file, skip = 1) %>%
  rename(
    School_ID = `School Number`,
    School_Name = `School Name`,
    EQI_2023 = `2023 - School Equity Index Number`,
    EQI_2024 = `2024 - School Equity Index Number`,
    EQI_2025 = `2025 - School Equity Index Number`
  ) %>%
  mutate(School_Name_clean = trimws(tolower(School_Name)))

# Load Directory data (skip 16 rows to get headers)
directory_df <- read_csv(directory_file, skip = 16) %>%
  mutate(
    School_Name_clean = trimws(tolower(`School Name`)),
    Education_Region = trimws(`Education Region`)
  )

# Define exact mapping from directory Education Region to aggregation region (lowercase, simplified)
region_map <- c(
  "Tai Tokerau" = "tai tokerau",
  "Tāmaki Herenga Tāngata" = "tamaki herenga tangata",
  "Tāmaki Herenga Manawa" = "tamaki herenga manawa",
  "Tāmaki Herenga Waka" = "tamaki herenga waka",
  "Bay of Plenty, Waiariki" = "bay of plenty, waiariki",
  "Canterbury, Chatham Islands" = "canterbury, chatham islands",
  "Waikato" = "waikato",
  "Wellington" = "wellington",
  "Hawke's Bay, Tairāwhiti" = "hawke's bay, tairawhiti",
  "Taranaki, Whanganui, Manawatū" = "taranaki, whanganui, manawatu",
  "Nelson, Marlborough, West Coast" = "nelson, marlborough, west coast",
  "Otago, Southland" = "otago, southland"
)

# Map Education Region to attendance_region
directory_df <- directory_df %>%
  mutate(attendance_region = region_map[Education_Region])

# Merge datasets on cleaned school names
merged_df <- eqi_df %>%
  inner_join(directory_df, by = "School_Name_clean") %>%
  select(School_Name, Education_Region, attendance_region, EQI_2023, EQI_2024, EQI_2025)

write_xlsx(merged_df, here("data_clean", "schools_eqi_regions.xlsx"))