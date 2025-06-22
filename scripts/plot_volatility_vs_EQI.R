library(ggplot2)
library(dplyr)
library(ggrepel)
library(readxl)

merged_df <- read_excel("/Users/tamarabutigan/Desktop/attendance-risk-scoring/data_clean/merged_attendance_eqi.xlsx")

# Identify two example regions with similar EQI but different avg_present
region_pairs <- merged_df %>%
  arrange(eqi_mean) %>%
  mutate(
    eqi_diff = abs(eqi_mean - lag(eqi_mean, 1)),
    attendance_diff = abs(avg_present - lag(avg_present, 1))
  ) %>%
  filter(!is.na(eqi_diff)) %>%
  arrange(eqi_diff, desc(attendance_diff)) %>%
  slice(1:2)

# Create the scatter plot
ggplot(merged_df, aes(x = eqi_mean, y = avg_present)) +
  geom_point(aes(color = volatility_present, size = coef_variation), alpha = 0.7) +
  scale_color_gradient(low = "blue", high = "red", name = "Volatility Present") +
  scale_size_continuous(name = "Coefficient of Variation") +
  geom_text_repel(aes(label = education_region),
                  size = 3,
                  box.padding = 0.3,
                  point.padding = 0.5,
                  max.overlaps = Inf) +
  coord_cartesian(ylim = c(min(merged_df$avg_present) - 0.2, 
                           max(merged_df$avg_present) + 0.2)) +
  labs(
    title = "Attendance vs Socioeconomic Index by Region",
    subtitle = "Highlighting similar EQI regions with contrasting attendance outcomes",
    x = "EQI Mean (Socioeconomic Index)",
    y = "Average Attendance",
    caption = "Point color: Volatility; Size: Attendance variation"
  ) +
  theme_minimal()

