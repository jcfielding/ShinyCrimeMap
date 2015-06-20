
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(dplyr)
require(ggplot2)
require(maps)
require(ggmap)

load("data/crime.Rda")

# removed unused columns and subset for violent crimes
crime %>%
    select(offense, lon , lat) %>%
    filter(offense != "auto theft" & offense != 
               "theft" & offense != "burglary") -> violent.crimes

# factor violent crimes
violent.crimes$offense <- factor(violent.crimes$offense, levels =
                                     c("robbery", "aggravated assault", "rape", "murder"))
    
# restrict to downtown Houston and complete cases
violent.crimes %>% 
    filter(-95.39681 <= lon & lon <= 
                             -95.34188 & 29.73631 <= lat & lat <= 29.784) %>%  
    filter(complete.cases(.)) -> violent.crimes


shinyServer(function(input, output) {
    
    my.crime <- reactive({switch(input$crimeSelect, 
                                 "Robbery" = filter(violent.crimes, offense == "robbery"),
                                 "Assault" = filter(violent.crimes, offense == "aggravated assault"),
                                 "Rape" = filter(violent.crimes, offense == "rape"),
                                 "Murder" = filter(violent.crimes, offense == "murder"))})
    
    my.crimerate <- reactive({nrow(my.crime())/nrow(violent.crimes)})
    
    my.map <- reactive({switch(input$mapType, 
                               "Roadmap" = "roadmap",
                               "Satellite" = "satellite",
                               "Terrain" = "terrain",
                               "Hybrid" = "hybrid")})

    output$mapPlot <- renderPlot({
        
        #HoustonMap <- qmap('houston', zoom = 14, color = 'bw', maptype = input$mapType)
        
        HoustonMap <- ggmap(get_map(location = 'houston', zoom = 14, 
                                    color = 'bw', maptype = my.map()))
        HoustonMap <- HoustonMap + geom_point(aes(x = lon, y = lat), colour = "red",
                                    size = 4 , alpha = 0.3, data = my.crime())
        HoustonMap
        
    })
    
    output$text1 <- renderText({ 
        paste("Incidents of", input$crimeSelect)})
    output$text2 <- renderText({ 
        paste0(round(my.crimerate()*100,1),"% of Violent Crimes")})
    output$text3 <- renderText({ 
        paste("January 2010 to August 2010")})
    })

