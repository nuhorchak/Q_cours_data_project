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

