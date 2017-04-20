library(shiny)
library(ggmap)

queens_names<-read.csv("../Data/QU_Locations.csv",strip.white=TRUE)
brooklyn_names<-read.csv("../Data/BK_Locations.csv",strip.white=TRUE)
manhattan_names<-read.csv("../Data/MA_Locations.csv",strip.white=TRUE)
bronx_names<-read.csv("../Data/BX_Locations.csv",strip.white=TRUE)
empty_names<-read.csv("../Data/Empty_Locations.csv")

sidewalks_manhattan<-read.csv("../Data/Sidewalk Cafes/sidewalks_manhattan.csv")
sidewalks_brooklyn<-read.csv("../Data/Sidewalk Cafes/sidewalks_brooklyn.csv")
sidewalks_queens<-read.csv("../Data/Sidewalk Cafes/sidewalks_queens.csv")
sidewalks_bronx<-read.csv("../Data/Sidewalk Cafes/sidewalks_bronx.csv")
sidewalks_nbh<-read.csv("../Data/Sidewalk Cafes/sidewalks_nbh.csv")



shinyServer(function(input,output) {
  
  selectedMap <-reactive({
    
    if(input$borough=="All Boroughs"){
      if(!exists("all_map")){
        all_map <- get_map( location = c(-73.9485424, 40.7454513),  source = "google", zoom = 11, maptype="roadmap", color="bw") 
      }
      all_map
    }
    
    else if(input$borough=="Manhattan"){
      if(!exists(manhattan_map)){
        manhattan_map <- get_map("Manhattan, NY", source="google", maptype="roadmap", zoom=12, color="bw")
      }
      manhattan_map
    }
    else if(input$borough=="Brooklyn"){
      if(!exists(brooklyn_map)){
        brooklyn_map <- get_map("Brooklyn, NY",  source = "google", zoom = 12, maptype="roadmap", color="bw") 
      }
      brooklyn_map
    }
    else if(input$borough == "Queens"){
      if(!exists(queens_map)){
        queens_map <- get_map("Astoria, NY",  source = "google", zoom = 12, maptype="roadmap", color="bw")
      }
      queens_map
    }
    else{
      if(!exists(bronx_map)){
        bronx_map <- get_map("Bronx, NY",  source = "google", zoom = 12, maptype="roadmap", color="bw") 
      }
      bronx_map
    } }) 
  
  
  selectedData <- reactive({
    if(input$borough=="All Boroughs"){
      sidewalks_nbh
    }
    else if(input$borough=="Manhattan"){
      sidewalks_manhattan
    }
    else if(input$borough=="Brooklyn"){
      sidewalks_brooklyn
    }
    else if(input$borough == "Queens"){
      sidewalks_queens
    }
    else{
      sidewalks_bronx
    } })
  
  selectedNames <- reactive({
    if(input$borough=="All Boroughs"){
      empty_names
    }
    else if(input$borough=="Manhattan"){
      manhattan_names
    }
    else if(input$borough=="Brooklyn"){
      brooklyn_names
    }
    else if(input$borough == "Queens"){
      queens_names
    }
    else{
      bronx_names
    } })
  
  output$map <- renderPlot({
    selectedMap()
    if(input$type=="Dot Plot"){
      ggmap(selectedMap())+geom_point(aes(x=LONGITUDE,y=LATITUDE), color="purple", size=3,data=selectedData()%>%filter(SUBMIT_YEAR==input$year), alpha=0.3)+geom_text_repel(data=selectedNames(), aes(mean_lon, mean_lat, label=Neighborhood),fontface="bold", size=3)+xlab("") + ylab("")+theme(axis.text.x=element_blank(),axis.text.y=element_blank(),axis.ticks.x=element_blank(),axis.ticks.y=element_blank(),axis.line = element_line(color = NA))
    }
    else{
      ggmap(selectedMap())+stat_density2d(aes(x=LONGITUDE,y=LATITUDE, fill=..level..),data=selectedData()%>%filter(SUBMIT_YEAR==input$year), geom="polygon", alpha=0.3)+scale_fill_gradient(low="yellow",high="red")+geom_text_repel(data=selectedNames(), aes(mean_lon, mean_lat, label=Neighborhood),fontface="bold", size=3)+xlab("") + ylab("")+theme(axis.text.x=element_blank(),axis.text.y=element_blank(),axis.ticks.x=element_blank(),axis.ticks.y=element_blank(),axis.line = element_line(color = NA))+ guides(fill=FALSE)
    }
     
    
    },width=800,height=800)
  
})