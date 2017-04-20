library('tidyverse')
library('ggmap')

manhattan_map <- get_map("Manhattan, NY", source="google", maptype="toner-lite", zoom=12, color="bw")
liquor <- read.csv('Data/liquor_licenses/massaged_data.csv')
manhattan <- liquor %>% filter(city.x == 'Manhattan')
ggmap(manhattan_map) + geom_point(data=manhattan, aes(x=Longitude, y=Latitude,color = nbh))
