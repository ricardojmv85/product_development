

library(shiny)

shinyUI(fluidPage(

   
    titlePanel("Ejemplos UI dinamico"),
    tabsetPanel(tabPanel("Ejemplo 1", 
                         numericInput("min", "limite inferiror", value= 5),
                         numericInput("max", "limite superior", value= 10),
                         sliderInput('slider_eje1', 'seleccione intervalo', min=0, max=15, value=5)
                         ),
                tabPanel("Ejemplo 2", 
                         sliderInput('s1', 's1', value=0, min=-5, max=5),
                         sliderInput('s2', 's2', value=0, min=-5, max=5),
                         sliderInput('s3', 's3', value=0, min=-5, max=5),
                         sliderInput('s4', 's4', value=0, min=-5, max=5),
                         actionButton('clean', 'limpiar')
                         ),
                tabPanel("Ejemplo 3", 
                         numericInput('n', 'corridas', value=10),
                         actionButton('correr', 'correr')
                         ),
                tabPanel("Ejemplo 4", 
                         numericInput('nvalue', 'valor', value=0)),
                tabPanel("Ejemplo 5", 
                         numericInput('celcius', 'Temperature en celcius', value=NA, step=1),
                         numericInput('farenheith', 'Temperature en farenheith', value=NA, step=1)
                         ),
                tabPanel("Ejemplo 6",
                         selectInput('dist', 'Distribucion', choices=c('Normal', 'Uniforme', 'Exponencial')),
                         numericInput('nrandom', 'Tamano de la muestra', value=100, min=0),
                         tabsetPanel(id='params', type='hidden', 
                                     tabPanel('Normal',
                                              numericInput('media', 'media', value=0),
                                              numericInput('sd', 'sd', value=1)
                                              ),
                                     tabPanel('Uniforme',
                                              numericInput('uni_min', 'min', value=0),
                                              numericInput('uni_max', 'max', value=0)
                                              ),
                                     tabPanel('Exponencial',
                                              numericInput('razon', 'razon', value=1, min=0)
                                              )
                                     ),
                         plotOutput('plot_dist')
                         )
                )
                
    
    


))
