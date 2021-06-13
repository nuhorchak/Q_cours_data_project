library(tidyverse)
library(lubridate)
library(forecast)
library(RSocrata)

data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
data_pull <- data_pull %>% mutate(., value = as.numeric(value))

data_pull %>% select(-port_code) %>%
  filter(port_name == 'Alcan') %>%
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))

