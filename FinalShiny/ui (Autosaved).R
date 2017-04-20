library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Sidewalk Cafe License Applications"),
inputPanel(
  align = "center",
  selectInput(inputId="borough",label="Choose Borough:",choices=c("All Boroughs","Manhattan","Brooklyn", "Queens", "Bronx")),
  sliderInput(inputId="year",label="Choose Year:",value=2015, min=2015, max=2017,sep=""),
  radioButtons(inputId="type",label="Map Type:",choices=c("Dot Plot", "HeatMap"), inline=TRUE)
  radioButtons(inputId="Wealth", label="Income Data:", choices=c("True", "False"), inline=TRUE)
),
mainPanel(
  align = "center",
  plotOutput("map")
)
))