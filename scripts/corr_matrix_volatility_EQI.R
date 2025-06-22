library(readxl)
merged_df <- read_excel(here("data_clean", "merged_attendance_eqi.xlsx"))

summary(merged_df)

# correlation matrix for key continuous variables
library(dplyr)

merged_df %>%
  select(eqi_mean, volatility_present, avg_present, coef_variation) %>%
  cor(use = "complete.obs")

library(GGally)

merged_df %>%
  select(eqi_mean, volatility_present, avg_present, coef_variation) %>%
  ggpairs()
