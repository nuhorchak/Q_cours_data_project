library(tidyverse)
library(lubridate)
library(forecast)
library(RSocrata)

data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
data_pull <- data_pull %>% mutate(., value = as.numeric(value))
data_pull <- data_pull %>% mutate(., measure = as.factor(measure))

data_pull %>% 
  filter(port_name == 'Brownsville') %>%
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))


plot_port_city <- function(data, city = 'Brownsville', ...){
  data %>% 
    filter(port_name == city) %>%
    ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
    theme(axis.text.x = element_text(angle = 90))
}

# forecasting


brownsville_pedestrians <- data_pull %>% 
  filter(port_name == 'Brownsville') %>% 
  filter(measure == 'Pedestrians') %>% 
  filter(date <= '2019-12-01') %>% 
  select(value) %>% ts(., start= c(1996,1), end = c(2019,12), frequency = 12)

fit_HW <- HoltWinters(brownsville_pedestrians, beta=FALSE, gamma=FALSE)
# fit_auto_ARIMA <- auto.arima(brownsville_pedestrians)
# fit_arima <- Arima(brownsville_pedestrians, order =c(2,1,1), seasonal = c(0,0,2))
plot(fit_HW)
forecast_HW <- forecast(fit_HW, 3)
plot(forecast_HW)
