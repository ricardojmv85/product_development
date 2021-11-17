
library(shiny)

shinyServer(function(input, output, session) {
  
  observeEvent(input$min, {
    updateSliderInput(session, "slider_eje1", min=input$min)
  })
  observeEvent(input$max, {
    updateSliderInput(session, "slider_eje1", max=input$max)
  })
  
  observeEvent(input$clean, {
    updateSliderInput(session, 's1', value=0)
    updateSliderInput(session, 's2', value=0)
    updateSliderInput(session, 's3', value=0)
    updateSliderInput(session, 's4', value=0)
  })
  
  observeEvent(input$n, {
    
    if(is.na(input$n)){
      
    label <- paste0('correr')
    }
    else if(input$n > 1){
    label <- paste0('correr ', input$n, ' veces')
      
    } else if(input$n ==1){
    label <- paste0('correr ', input$n, ' vez')
    } else {
    label <- paste0('correr')
      
    }
    updateActionButton(session, 'correr', label=label)
  })
  
  observeEvent(input$nvalue, {
    updateNumericInput(session, 'nvalue', value=input$nvalue+1 )
  })
  
  observeEvent(input$celcius, {
    f <- round(input$celcius*(9/5)+32)
    updateNumericInput(session, 'farenheith', value=f)
  })

  observeEvent(input$farenheith, {
    f <- round((input$farenheith-32)*(5/9))
    updateNumericInput(session, 'celcius', value=f)
  })
  
  observeEvent(input$dist, {
    updateTabsetPanel(session, 'params', selected=input$dist)
  })
  
  sample_dist <- reactive({
    switch (input$dist,
      'Normal' = rnorm(n = input$nrandom, mean=input$media, sd=input$sd),
      'Uniforme' = runif(input$nrandom, input$uni_min, input$uni_max),
      'Exponencial' = rexp(input$nrandom, rate=input$razon)
    )
  })
  
  output$plot_dist <- renderPlot({
    hist(sample_dist())
  })
  
  
})
