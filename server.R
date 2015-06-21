
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

    # perform crimerate calculation
    my.crimerate <- reactive({nrow(my.crime())/nrow(violent.crimes)})
    
    my.map <- reactive({switch(input$mapType, 
                               "Roadmap" = "roadmap",
                               "Satellite" = "satellite",
                               "Terrain" = "terrain",
                               "Hybrid" = "hybrid")})
    
    # output map
    output$mapPlot <- renderPlot({
        
        # NOTE: cannot use qmap wrapper as it can't handle dynamic inputs to maptype
        # Use underlying ggmap instead
        
        HoustonMap <- ggmap(get_map(location = 'houston', zoom = 14, 
                                    color = 'bw', maptype = my.map()), fullpage = TRUE)
        HoustonMap <- HoustonMap + geom_point(aes(x = lon, y = lat), colour = "red",
                                    size = 4 , alpha = 0.3, data = my.crime())
        HoustonMap
        
    })
    
    # output text boxes
    
    output$text1 <- renderText({ 
        paste("Locations of", input$crimeSelect)})
    output$text2 <- renderText({ 
        paste0(round(my.crimerate()*100,1),"% of Violent Crimes")})
    })

