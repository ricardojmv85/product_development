
library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {

  selected_points <- reactiveVal(rep(FALSE, nrow(mtcars)))
  
  
  observeEvent(input$mouse_brush, {
    selected <- brushedPoints(mtcars, input$mouse_brush, allRows=TRUE)['selected_']
    selected_points(selected | selected_points())
  })
  
  observeEvent(input$clk, {
    selected <- nearPoints(mtcars, input$clk, xvar="wt", yvar="mpg", allRows=TRUE)['selected_']
    selected_points(selected | selected_points())
  })
  
  observeEvent(input$mouse_hover, {
    selected <- nearPoints(mtcars, input$mouse_hover, xvar="wt", yvar="mpg", allRows=TRUE)['selected_']
    selected_points(selected_points() & xor(selected_points(), selected))
  })
  
  observeEvent(input$dclk, {
    selected_points(rep(FALSE, nrow(mtcars)))
  })

  
  output$plot <- renderPlot({
    mtcars$selected <- selected_points()
    ggplot(mtcars, aes(wt, mpg)) + 
      geom_point(aes(colour = selected)) +
      scale_color_manual(values=c("TRUE"="green","FALSE"="gray")) +
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white",
                                         colour = "black"),
          legend.position = "none")
    
  }, res = 150)
  
  
  output$mtcars_tbl <- DT::renderDataTable({
    df <- mtcars
    if(any(selected_points())){ 
      df$selected <- selected_points()
      df <- df %>% 
              filter(selected == TRUE) %>%
              select(-selected)
    } 
    df
  })
  

})
