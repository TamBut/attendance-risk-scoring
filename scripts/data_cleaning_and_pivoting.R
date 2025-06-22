library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)
library(writexl)
library(stringi)  # some regions have macrons that need removing

# Load and skip extra header rows
df_raw <- read_excel(
  here("data_raw", "Regular-attendance-data-2011-2024-T4-v2_original.xlsx"),
  sheet = "Education Region",
  skip = 4
)

# Clean column names: replace newlines, remove parentheses, replace % and spaces, lowercase
names(df_raw) <- names(df_raw) %>%
  gsub("\\n", " ", .) %>%
  gsub("\\(|\\)", "", .) %>%
  gsub("%", "percent", .) %>%
  gsub(" ", "_", .) %>%
  tolower()

df_raw <- df_raw %>% clean_names()

# filling down missing year and term values
df_raw <- df_raw %>%
  tidyr::fill(year, term)

# remove macrons from education_region and trimming whitespace to standardise region names (this is because Manawatu was spelled with and without a macron in diff datasets)
df_raw <- df_raw %>%
  mutate(
    education_region = stri_trans_general(education_region, "Latin-ASCII") %>%
      str_trim()
  )

# Filter out rows with missing education_region or year/term
df_raw <- df_raw %>%
  filter(!is.na(education_region) & !is.na(year) & !is.na(term))

# Pivot longer to tidy format
df_long <- df_raw %>%
  pivot_longer(
    cols = -c(year, term, education_region),
    names_to = "metric",
    values_to = "value"
  )

df_long <- df_long %>%
  mutate(
    type = case_when(
      str_ends(metric, "_n") ~ "count",
      str_ends(metric, "percent") ~ "percent",
      TRUE ~ "other"
    ),
    category = metric %>%
      str_remove("_n$|_percent$") %>%
      str_replace_all("_", " ")
  ) %>%
  select(year, term, education_region, category, type, value)

# Pivot wider to get counts and percents as columns
df_clean <- df_long %>%
  pivot_wider(
    names_from = type,
    values_from = value
  )

# Clean numeric columns (remove commas)
df_clean <- df_clean %>%
  mutate(
    count = as.numeric(gsub(",", "", count)),
    percent = as.numeric(gsub(",", "", percent))
  )

# Saving cleaned Excel file
write_xlsx(df_clean, here("data_clean", "Regular-attendance-data-cleaned.xlsx"))