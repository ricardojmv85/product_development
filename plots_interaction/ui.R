

library(shiny)

shinyUI(fluidPage(

   
    titlePanel("Interraciones de usuario con graficas"),
    tabsetPanel(
      tabPanel('plot', 
               h1('Graficas en shiny'),
               plotOutput('grafica_base_r'),
               plotOutput('grafica_ggplot')
               ),
      tabPanel('Clicks plots', 
                 fluidRow(
                   column(6, 
                          plotOutput('plot_click_options',
                                     click = 'clk', 
                                     dblclick = 'dclk',
                                     hover = 'mouse_hover',
                                     brush = 'mouse_brush'
                          ),
                          verbatimTextOutput("click_data"),
                   ),
                   column(6,
                          DT::dataTableOutput('mtcars_tbl')
                          )
                 )
               )
    )


))
