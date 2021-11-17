

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

   
    titlePanel("Parametros Shiny"),
    sidebarLayout(
      sidebarPanel(
        sliderInput('bins',
                    'Numero de bins',
                    min=1,
                    max=50,
                    value=30),
        selectInput("set_col",
                    "Escoger el color:",
                    choices = c('aquamarine', 'blue', 'blueviolet', 'darkgray', 'chocolate'),
                    selected = 'darkgray'
                    ),
        textInput('url_param', "Marcador:", value="")
      ),
      mainPanel(
        plotOutput('distPlot')
      )
    )


))
