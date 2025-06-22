# EQI-only model
model_eqi <- lm(avg_present ~ eqi_mean, data = df_clean)

# Add volatility
model_eqi_vol <- lm(avg_present ~ eqi_mean + volatility_present, data = df_clean)

# add interaction
model_interaction <- lm(avg_present ~ eqi_mean * volatility_present, data = df_clean)

# compare models via ANOVA
anova(model_eqi, model_eqi_vol, model_interaction)
summary(model_eqi)$r.squared
summary(model_eqi_vol)$r.squared
summary(model_interaction)$r.squared
library(ggplot2)

ggplot(df_clean, aes(x = volatility_present, y = avg_present, color = eqi_bin)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Attendance vs Volatility across EQI bins",
       x = "Volatility", y = "Average Attendance") +
  theme_minimal()
library(broom)

# tidied outputs
eqi_only_tidy <- tidy(model_eqi)
eqi_vol_tidy <- tidy(model_eqi_vol)
interaction_tidy <- tidy(model_interaction)



