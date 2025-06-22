library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)
library(writexl)
library(here)

regional <- read_excel(here("data_clean", "Regular-attendance-data-cleaned.xlsx"))

# 2. calculate regional volatility on present half days with average, count, and coefficient of variation
data_with_volatility <- regional %>%
  filter(category == "present half days") %>%
  group_by(education_region) %>%
  summarise(
    volatility_present = sd(percent, na.rm = TRUE),
    avg_present = mean(percent, na.rm = TRUE),
    n_obs = n(),
    coef_variation = volatility_present / avg_present
  )

# 3. saving the data frame
write_xlsx(data_with_volatility, here("data_clean", "data_with_volatility.xlsx"))

print(data_with_volatility)
