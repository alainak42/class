library(ggplot2)

weather <- read.csv("daytona_hourly_weather.csv")
weather$time <- as.POSIXct(
  weather$time,
  format = "%Y-%m-%dT%H:%M",
  tz = "America/New_York"
)
weather$month <- as.Date(format(weather$time, "%Y-%m-01"))

monthly_wind <- aggregate(
  wind_speed_10m ~ month,
  data = weather,
  FUN = \(x) mean(x, na.rm = TRUE)
)

monthly_precipitation <- aggregate(
  precipitation ~ month,
  data = weather,
  FUN = \(x) sum(x, na.rm = TRUE)
)

monthly_weather <- rbind(
  data.frame(
    month = monthly_wind$month,
    metric = "Average wind speed (mph)",
    value = monthly_wind$wind_speed_10m
  ),
  data.frame(
    month = monthly_precipitation$month,
    metric = "Monthly precipitation (inches)",
    value = monthly_precipitation$precipitation
  )
)

hurricanes <- data.frame(
  name = c("Irma", "Dorian", "Isaias", "Ian", "Nicole", "Milton"),
  date = as.Date(c(
    "2017-09-11", "2019-09-04", "2020-08-03",
    "2022-09-29", "2022-11-10", "2024-10-10"
  ))
)
hurricanes_wind <- hurricanes
hurricanes_wind$label_y <- max(monthly_wind$wind_speed_10m, na.rm = TRUE) * 1.12
hurricanes_wind$metric <- "Average wind speed (mph)"

hurricanes_precipitation <- hurricanes
hurricanes_precipitation$label_y <- max(monthly_precipitation$precipitation, na.rm = TRUE) * 1.12
hurricanes_precipitation$metric <- "Monthly precipitation (inches)"
hurricane_annotations <- rbind(hurricanes_wind, hurricanes_precipitation)

weather_plot <- ggplot(monthly_weather, aes(x = month, y = value, fill = metric)) +
  geom_segment(
    data = hurricane_annotations,
    aes(x = date, xend = date, y = -Inf, yend = Inf),
    color = "#A34E38",
    linetype = "dashed",
    linewidth = 0.6,
    inherit.aes = FALSE
  ) +
  geom_col(aes(color = metric), width = 25) +
  geom_label(
    data = hurricane_annotations,
    aes(x = date, y = label_y, label = name),
    inherit.aes = FALSE,
    angle = 90,
    size = 3,
    fill = "#F4E8D0",
    color = "#653D32",
    linewidth = 0
  ) +
  scale_fill_manual(values = c(
    "Average wind speed (mph)" = "#397C78",
    "Monthly precipitation (inches)" = "#C6533B"
  )) +
  scale_color_manual(values = c(
    "Average wind speed (mph)" = "#285B58",
    "Monthly precipitation (inches)" = "#8C392D"
  ), guide = "none") +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.3))) +
  facet_wrap(~metric, ncol = 1, scales = "free_y") +
  labs(
    title = "Daytona Beach, Florida",
    subtitle = paste(
      "Monthly wind and precipitation | dashed lines mark hurricane closest approaches in both panels",
      format(min(monthly_wind$month), "%b %Y"),
      "to",
      format(max(monthly_wind$month), "%b %Y")
    ),
    x = NULL,
    y = NULL,
    caption = paste(
      "Source: Open-Meteo Historical Forecast; NOAA HURDAT2 best tracks |",
      "hurricane labels shown in wind panel for storms passing within 100 miles"
    )
  ) +
  theme_minimal(base_size = 13, base_family = "serif") +
  theme(
    plot.background = element_rect(fill = "#F4E8D0", color = NA),
    panel.background = element_rect(fill = "#FBF5E9", color = NA),
    panel.grid.major = element_line(color = "#D8C9AE", linewidth = 0.4),
    panel.grid.minor = element_blank(),
    text = element_text(color = "#382D26"),
    axis.text = element_text(color = "#6D5948"),
    strip.background = element_rect(fill = "#E7D5B8", color = NA),
    strip.text = element_text(color = "#653D32", face = "bold"),
    plot.title = element_text(size = 26, face = "bold", color = "#285B58"),
    plot.subtitle = element_text(color = "#397C78"),
    plot.caption = element_text(color = "#806A56")
  )

ggsave(
  "daytona-weather.png",
  plot = weather_plot,
  width = 10,
  height = 10,
  dpi = 160,
  bg = "#F4E8D0"
)
