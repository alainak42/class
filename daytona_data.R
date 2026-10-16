end_date <- Sys.Date() - 5
start_date <- as.Date(sprintf(
  "%d-%s",
  as.integer(format(end_date, "%Y")) - 10,
  format(end_date, "%m-%d")
))

weather_url <- paste0(
  "https://historical-forecast-api.open-meteo.com/v1/forecast?",
  "latitude=29.2108&longitude=-81.0228",
  "&hourly=temperature_2m,uv_index,precipitation,wind_speed_10m",
  "&temperature_unit=fahrenheit",
  "&precipitation_unit=inch",
  "&wind_speed_unit=mph",
  "&start_date=", start_date,
  "&end_date=", end_date,
  "&timezone=America%2FNew_York&format=csv"
)

hourly_weather <- read.csv(weather_url, skip = 2)[, 1:5]
names(hourly_weather) <- c(
  "time", "temperature_2m", "uv_index", "precipitation", "wind_speed_10m"
)

if (nrow(hourly_weather) == 0 || all(is.na(hourly_weather$temperature_2m))) {
  stop("No historical weather data were returned for Daytona Beach.")
}

write.csv(hourly_weather, "daytona_hourly_weather.csv", row.names = FALSE)
