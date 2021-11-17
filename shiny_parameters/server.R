
library(shiny)

shinyServer(function(input, output, session) {

  observe({
    query <- parseQueryString(session$clientData$url_search)
    bins <- query[["bins"]]
    bar_col <- query[["color"]]
    if(!is.null(bins)){
      updateSliderInput(session, 'bins', value=as.numeric(bins))
    }
    
    if(!is.null(bar_col)){
      updateSelectInput(session, 'set_col', selected=bar_col)
    }
  })
  
  observe({
    bins <- input$bins
    color <- input$set_col
    
    host <- session$clientData$url_hostname
    protocol <- session$clientData$url_protocol
    port <- session$clientData$url_port
    query <- paste('?', 'bins=', bins,'&','color=', color, sep='')
    url <- paste(protocol, '//', host, ':', port, '/', query, sep="")
    updateTextInput(session, 'url_param', value=url)
    
    
  })
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    hist(x, breaks=input$bins, col=input$set_col, border='white')
  })
  
  
  
  
})
