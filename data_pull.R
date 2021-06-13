library(tidyverse)
library(forecast)
library(RSocrata)

data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
data_pull <- data_pull %>% mutate(., year = year(date)) %>% mutate(., month = month(date))

# data_pull %>% select(-port_code) %>% 
#   filter(measure == 'Trucks') %>%
#   filter(border=="US-Canada Border") %>% 
#   group_by(state, date, value, port_name) %>% 
#   summarise() %>% filter(state=='Alaska') %>% 
#   ggplot(., aes(month, value, color=port_name, linetype=port_name)) + geom_line() +
#   theme(axis.text.x = element_text(angle = 90))
