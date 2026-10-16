weather_url <- paste0(
  "https://api.open-meteo.com/v1/forecast?",
  "latitude=27.3364&longitude=-82.5307",
  "&hourly=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m",
  "&past_days=7&forecast_days=0",
  "&timezone=America%2FNew_York&format=csv"
)

hourly_weather <- read.csv(weather_url, skip = 2)[, 1:5]
names(hourly_weather) <- c(
  "time",
  "temperature_2m",
  "relative_humidity_2m",
  "precipitation",
  "wind_speed_10m"
)
write.csv(hourly_weather, "sarasota_hourly_weather.csv", row.names = FALSE)
