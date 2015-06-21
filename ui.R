
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
    title = "Shiny Crime Map",
    
  # Application title
  titlePanel("Downtown Houston Texas Violent Crimes"),
  
  p("This interactive map allows users 
    to view the locations of different types of violent crimes in the 
    Houston, Texas downtown area for January 2010 through August 2010."),
  
    # Sidebar with a input for controls
    sidebarLayout(
      sidebarPanel(
          
          h4("Instructions"),
          p("Select the Crime Type you would like to map from the drop down menu.
            Toggle the radio buttons to change Map Type. You may experience a
            short delay as the map loads."),
          
        selectInput("crimeSelect", label = h4("Crime Type"), 
                    choices = c("Robbery","Assault","Rape","Murder"),
                    selected = "Robbery"),
        
        radioButtons("mapType", label = h4("Map Type"),
                     #choices = c("Roadmap", "Satellite","Terrain", "Hybrid"),
                     choices = c("Roadmap" = "Roadmap",
                       "Satellite" = "Satellite",
                       "Terrain" = "Terrain",
                       "Hybrid" = "Hybrid"),
                     
                     selected = "Roadmap", inline = FALSE)
        
      ),
      # Show map and textboxes
      mainPanel(
    
          plotOutput("mapPlot"),
          h4(textOutput("text1"), align = "center"),
          h5(textOutput("text2"), align = "center")
      )  

  )
))
