library(ggplot2)

weather <- read.csv("sarasota_hourly_weather.csv")
weather$time <- as.POSIXct(
  weather$time,
  format = "%Y-%m-%dT%H:%M",
  tz = "America/New_York"
)

extremes <- weather[c(which.min(weather$temperature_2m), which.max(weather$temperature_2m)), ]
extremes$label <- c("Coolest", "Warmest")

weather_plot <- ggplot(weather, aes(x = time, y = temperature_2m)) +
  geom_line(color = "#54D6C5", linewidth = 1.2) +
  geom_point(
    data = extremes,
    color = "#FFB86C",
    size = 3
  ) +
  geom_label(
    data = extremes,
    aes(label = paste0(label, ": ", temperature_2m, "°C")),
    nudge_y = c(-1.2, 1.2),
    fill = "#17334A",
    color = "#F4FAFF",
    linewidth = 0,
    size = 3.5
  ) +
  scale_x_datetime(date_labels = "%a\n%b %d", date_breaks = "1 day") +
  labs(
    title = "Sarasota, Florida",
    subtitle = "A week of hourly temperatures",
    x = NULL,
    y = "Temperature (°C)",
    caption = "Source: Open-Meteo | Local time"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.background = element_rect(fill = "#0B1E2D", color = NA),
    panel.background = element_rect(fill = "#0B1E2D", color = NA),
    panel.grid.major = element_line(color = "#254158"),
    panel.grid.minor = element_blank(),
    text = element_text(color = "#F4FAFF"),
    axis.text = element_text(color = "#B7C9D8"),
    plot.title = element_text(size = 24, face = "bold"),
    plot.subtitle = element_text(color = "#54D6C5"),
    plot.caption = element_text(color = "#B7C9D8")
  )

ggsave(
  "sarasota-weather.png",
  plot = weather_plot,
  width = 10,
  height = 6,
  dpi = 160,
  bg = "#0B1E2D"
)
