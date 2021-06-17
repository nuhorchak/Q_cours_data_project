library(tidyverse)
library(lubridate)
library(forecast)
library(RSocrata)
library(scales)

# data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
# data_pull <- data_pull %>% mutate(., value = as.numeric(value))
# data_pull <- data_pull %>% mutate(., measure = as.factor(measure))
load('border_crossings.rda')

data_pull <- data_pull %>% mutate(year = format(date, format="%Y"))


data_pull %>% 
  filter(port_name == 'Calexico') %>%
  filter(date <= '2004-01-01' & date >= '2003-01-01') %>% 
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))

data_pull %>% 
  filter(measure == 'Personal Vehicle Passengers') %>% 
  filter(date >= '2010-01-01') %>% 
  filter(border == 'US-Canada Border') %>% 
  ggplot(., aes(year, value, color=port_name)) + geom_point() +
  facet_wrap(~ year) +
  theme(axis.text.x = element_text(angle = 90))

data_pull %>% 
  filter(measure == 'Personal Vehicle Passengers') %>% 
  filter(date >= '2010-01-01') %>% 
  filter(border == 'US-Canada Border') %>% select(value) %>% max()

plot_port_city <- function(data, city = 'Brownsville', ...){
  data %>% 
    filter(port_name == city) %>%
    ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
    theme(axis.text.x = element_text(angle = 90)) +
    ggtitle(label = city)
}

for (name in unique(data_pull$port_name)) {
  
  ggsave(filename = paste0("plot_", name, ".png"),
         plot_port_city(data_pull, city = name),
         width = 11,
         height = 7)
}

#### forecasting

# data_pull %>% 
#   filter(port_name == 'Brownsville') %>% 
#   filter(measure == 'Pedestrians') %>% 
#   filter(date >= '2020-06-01') %>% 
#   ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
#   theme(axis.text.x = element_text(angle = 90))

del_rio_PPV <- data_pull %>% 
  filter(port_name == 'Del Rio') %>% 
  filter(measure == 'Personal Vehicle Passengers') %>% 
  arrange(date) %>% 
  select(value) %>% ts(., start= c(1996,1), end = c(2020,1), frequency = 12)

# fit_HW <- HoltWinters((del_rio_PPV), beta=FALSE, gamma=FALSE)
# plot(fit_HW)
# forecast_HW <- forecast(fit_HW, 12)
# plot(forecast_HW)

fit_arima <- auto.arima(del_rio_PPV)
plot(fit_arima)
forecast_arima <- forecast(fit_arima, 14)
plot(forecast_arima)


del_rio_data_PPV <- data_pull %>% 
  filter(port_name == 'Del Rio') %>% 
  filter(measure == 'Personal Vehicle Passengers') %>% 
  select(date, value) %>% arrange(date)

forecast_del_rio <- del_rio_data_PPV %>% 
  filter(date >= '2020-02-01') %>% 
  select(-value) %>% arrange(date) %>% 
  cbind(., forecast_arima$mean)
colnames(forecast_del_rio)[2] <- "forecast"


ggplot() + geom_line(data = del_rio_data_PPV, 
                     aes(date, value, color =  'blue')) +
  geom_line(data = forecast_del_rio, aes(date, forecast, color = 'red')) +
  scale_colour_hue('Values', labels=c('Actual', 'Forecast')) +
  ggtitle("Del Rio, TX Personal Vehicle Passengers") +
  xlab('Date') + ylab('Monthly Total') +
  scale_y_continuous(
    labels = scales::number_format(accuracy = 1,
                                   decimal.mark = ','))

