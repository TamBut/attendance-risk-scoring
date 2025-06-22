library(readr)
library(readxl)
library(dplyr)
library(writexl)
library(here)

# File paths
eqi_file <- here("data_raw", "School-EQI-numbers-2023-2025.xlsx")
school_directory_file <- here("data_raw", "directory.csv")

# Load EQI data (skip 1 row to get actual headers)
eqi_df <- read_excel(eqi_file, skip = 1)

# Load Directory data (skip 16 rows to get actual headers)
directory_df <- read_csv(school_directory_file, skip = 16)

# Rename columns for consistency, keep all years
eqi_df <- eqi_df %>%
  rename(
    School_ID = `School Number`,
    School_Name = `School Name`,
    EQI_2023 = `2023 - School Equity Index Number`,
    EQI_2024 = `2024 - School Equity Index Number`,
    EQI_2025 = `2025 - School Equity Index Number`
  )

# Clean school names in both datasets: lowercase, trim whitespace
eqi_df <- eqi_df %>%
  mutate(School_Name_clean = trimws(tolower(School_Name)))

directory_df <- directory_df %>%
  mutate(School_Name_clean = trimws(tolower(`School Name`)))

# Define mapping from directory_region to attendance_region, hardcoding here
region_map <- c(
  "Northland Region" = "Tai Tokerau",
  "Auckland Region" = "Tāmaki Makaurau",
  "Bay of Plenty Region" = "Bay of Plenty, Waiariki",
  "Waikato Region" = "Waikato",
  "Manawatū-Whanganui Region" = "Taranaki, Whanganui, Manawatū",
  "Hawke's Bay Region" = "Hawke's Bay, Tairāwhiti",
  "Taranaki Region" = "Taranaki, Whanganui, Manawatū",
  "Whanganui Region" = "Taranaki, Whanganui, Manawatū",
  "Canterbury Region" = "Canterbury, Chatham Islands",
  "Chatham Islands" = "Canterbury, Chatham Islands",
  "Otago Region" = "Otago, Southland",
  "Southland Region" = "Otago, Southland",
  "Gisborne Region" = "Hawke's Bay, Tairāwhiti",
  "Marlborough Region" = "Nelson, Marlborough, West Coast",
  "Tasman Region" = "Nelson, Marlborough, West Coast",
  "Nelson Region" = "Nelson, Marlborough, West Coast",
  "West Coast Region" = "Nelson, Marlborough, West Coast",
  "Wellington Region" = "Wellington"
)

# Map directory_region to education_region
directory_df <- directory_df %>%
  mutate(education_region = region_map[`Regional Council`])

# Merge EQI data with Directory using cleaned school names
merged_df <- eqi_df %>%
  inner_join(directory_df, by = "School_Name_clean") %>%
  select(School_ID, School_Name, education_region, EQI_2023, EQI_2024, EQI_2025)

# Writing the full school-region-EQI table to Excel
write_xlsx(merged_df, here("data_clean", "school_region_EQI.xlsx"))