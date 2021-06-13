library(tidyverse)
library(lubridate)
library(forecast)
library(RSocrata)

data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
data_pull <- data_pull %>% mutate(., value = as.numeric(value))

data_pull %>% 
  filter(port_name == 'Brownsville') %>%
  filter(measure == ) %>% 
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))


plot_port_city <- function(data, city = 'Brownsville', travel_method = , ...){
  data %>% 
    filter(port_name == city) %>%
    filter(measure==travel_method) %>% 
    ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
    theme(axis.text.x = element_text(angle = 90))
}

