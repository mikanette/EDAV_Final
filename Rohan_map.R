library('tidyverse')
library('ggmap')

manhattan_map <- get_map("Manhattan, NY", source="google", maptype="toner-lite", zoom=12, color="bw")
liquor <- read.csv('Data/liquor_licenses/massaged_data.csv', header="TRUE")
manhattan <- liquor %>% filter(city.x == 'Manhattan')

liquor_class<-read.csv("Data/Liquor Licenses/liquor_classification.csv")
colnames(liquor_class)<-c("License.Type.Name","Classification")
liquor<-merge(liquor, liquor_class, by="License.Type.Name")

manhattan <- liquor %>% filter(Classification == 'WINE')

ggmap(manhattan_map) + geom_point(data=manhattan, aes(x=Longitude, y=Latitude, color = Classification))
