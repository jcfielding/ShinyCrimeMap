
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Downtown Houston Texas Violent Crimes"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        
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
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("mapPlot"),
        h4(textOutput("text1"), align = "center"),
        h5(textOutput("text2"), align = "center"),
        h5(textOutput("text3"), align = "center")
      )  

  )
))
