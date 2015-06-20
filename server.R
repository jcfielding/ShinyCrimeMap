
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(dplyr)
require(maps)
require(ggmap)

# violent_crimes <- subset(crime, offense != "auto theft" & offense != 
#                              "theft" & offense != "burglary")

violent.crimes <- filter(crime, offense != "auto theft" & offense != 
           "theft" & offense != "burglary")

# rank violent crimes
violent.crimes$offense <- factor(violent.crimes$offense, levels =
                                c("robbery", "aggravated assault", "rape", "murder"))

# restrict to downtown
# violent.crimes <- subset(violent.crimes, -95.39681 <= lon & lon <= 
#                              -95.34188 & 29.73631 <= lat & lat <= 29.784)
 violent.crimes <- filter(violent.crimes, -95.39681 <= lon & lon <= 
                              -95.34188 & 29.73631 <= lat & lat <= 29.784)

shinyServer(function(input, output) {

    output$mapPlot <- renderPlot({

        mydata <- switch(input$crimeSelect, 
                       "Robbery" = filter(violent.crimes, offense == "robbery"),
                       "Assault" = filter(violent.crimes, offense == "aggravated assault"),
                       "Rape" = filter(violent.crimes, offense == "rape"),
                       "Murder" = filter(violent.crimes, offense == "murder"))
        
        # HoustonMap <- qmap('houston', zoom = 14, color = 'bw', legend = 'topleft')
        HoustonMap <- qmap('houston', zoom = 14, color = 'bw')
        
        HoustonMap <- HoustonMap + 
            geom_point(aes(x = lon, y = lat), colour = "red",
                       size = 4 , alpha = 0.3, data = mydata)
#             geom_point(aes(x = lon, y = lat, size = offense,
#                            colour = offense), data = violent_crimes)      
        HoustonMap
        
    })
    
    
#   output$distPlot <- renderPlot({
# 
#       # generate bins based on input$bins from ui.R
#       x    <- faithful[, 2]
#       bins <- seq(min(x), max(x), length.out = input$bins + 1)
#       
#       # draw the histogram with the specified number of bins
#       hist(x, breaks = bins, col = 'darkgray', border = 'white')
#       
#   })

})
