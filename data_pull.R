library(tidyverse)
library(lubdata_pull %>% 
  filter(port_name == 'Calexico') %>%
  filter(date <= '2004-01-01' & date >= '2003-01-01') %>% 
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))ridate)
library(forecast)
library(RSocrata)

# data_pull <- read.socrata("https://data.bts.gov/resource/keg4-3bc2.json")
# data_pull <- data_pull %>% mutate(., value = as.numeric(value))
# data_pull <- data_pull %>% mutate(., measure = as.factor(measure))
load('border_crossings.rda')




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

# forecasting

data_pull %>% 
  filter(port_name == 'Brownsville') %>% 
  filter(measure == 'Pedestrians') %>% 
  filter(date >= '2020-06-01') %>% 
  ggplot(., aes(date, value, color=measure, linetype=measure)) + geom_line() +
  theme(axis.text.x = element_text(angle = 90))

brownsville_pedestrians <- data_pull %>% 
  filter(port_name == 'Brownsville') %>% 
  filter(measure == 'Pedestrians') %>% 
  filter(date <= '2020-06-01') %>% 
  select(value) %>% ts(., start= c(2020,6), end = c(2021,3), frequency = 12)

fit_HW <- HoltWinters((brownsville_pedestrians), beta=FALSE, gamma=FALSE)
plot(fit_HW)
forecast_HW <- forecast(fit_HW, 3)
plot(forecast_HW)







