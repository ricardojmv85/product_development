
library(shiny)
library(dplyr)
library(DT)
library(plotly)
library(ggplot2)
library(scales)
library(zoo)
library(roll)
library(comprehenr)

shinyServer(function(input, output, session) {
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    from_date <- query[["from_date"]]
    to_date <- query[["to_date"]]
    cripto <- query[['cripto']]
    li_color <- URLdecode(query[['color']])
    limits <- query[['limits']]
    window <- query[['window']]
    price_type <- query[['price_type']]
    windowtab <- 1
    
    if(!is.null(cripto)){
      updateTabsetPanel(session, "inTabset", selected = cripto)
      windowtab <- switch (cripto,
              'bitcoin' = 1,
              'ethereum' = 2
      )
    }
    if(!is.null(from_date)){
      updateDateRangeInput(session, paste('date_window', windowtab, sep=''), start=from_date)
    }
    if(!is.null(to_date)){
      updateDateRangeInput(session, paste('date_window', windowtab, sep=''), end=to_date)
    }
    if(!is.null(li_color)){
      updateColourInput(session, paste('limit_color', windowtab, sep=''), value=li_color)
    }
    if(!is.null(price_type)){
      updateRadioButtons(session, paste('pricess_bulltet', windowtab, sep=''), selected=price_type)
    }
    if(!is.null(limits)){
      temp_list <- as.list(strsplit(limits, ",")[[1]])
      updateCheckboxGroupInput(session, paste('limits', windowtab, sep=''), selected=temp_list)
    }
    if(!is.null(window)){
      updateNumericInput(session, paste('moving_window', windowtab, sep=''), value=window)
    }
    
  })
  
  observe({
    cripto <- input$inTabset
    windowtab <- switch (cripto, 'bitcoin' = 1, 'ethereum' = 2)
    eval(parse(text=paste('from_date <- input$date_window', windowtab, '[1]', sep='')))
    eval(parse(text=paste('to_date <- input$date_window', windowtab, '[2]', sep='')))
    eval(parse(text=paste('li_color <- input$limit_color', windowtab, sep='')))
    eval(parse(text=paste('limits <- input$limits', windowtab, sep='')))
    eval(parse(text=paste('price_type <- input$pricess_bulltet', windowtab, sep='')))
    eval(parse(text=paste('window <- input$moving_window', windowtab, sep='')))

    host <- session$clientData$url_hostname
    protocol <- session$clientData$url_protocol
    port <- session$clientData$url_port
    
    
    
    if(!is.null(limits)){
      query <- paste('?', 'from_date=', from_date,
                     '&','to_date=', to_date,
                     '&','cripto=', cripto,
                     '&','color=', URLencode(li_color, reserved = TRUE),
                     '&','price_type=', price_type,
                     '&','window=', window,
                     '&','limits=', paste(limits, collapse = ",")
                     , sep='')
    } else {
      query <- paste('?', 'from_date=', from_date,
                     '&','to_date=', to_date,
                     '&','cripto=', cripto,
                     '&','color=', URLencode(li_color, reserved = TRUE),
                     '&','price_type=', price_type,
                     '&','window=', window
                     , sep='')
    }
    url <- paste(protocol, '//', host, '/Proyecto1/', query, sep="")
    # url <- paste(protocol, '//', host, ':', port, '/', query, sep="")
    print(paste('output$report',windowtab, ' <- renderText({url})', sep=''))
    output$report1 <- renderText({url})
    eval(parse(text=(paste('output$report',windowtab, ' <- renderText({url})', sep=''))))
  })
  
  dataset1 <- readr::read_csv('bitcoin.csv') %>%
    select(Date, High, Low, Open, Close) %>%
    mutate(across(2:5, round, 2)) %>%
    mutate(Date = as.Date(Date, format = '%y-%m-%d'))
  
  observeEvent(input$pricess_bulltet1, {
    output$graph_title1 <- renderText(paste(input$pricess_bulltet1, 'Price Graph', sep=' '))
  })
  
  observeEvent(input$date_window1, {
    updateNumericInput(session, 'moving_window1', max=as.numeric(input$date_window1[2] - input$date_window1[1]))
  })

  output$output_table1 <- DT::renderDataTable({
    get_data_to_plot() %>%
      DT::datatable() %>%
      formatCurrency(columns = c(input$pricess_bulltet1), currency='$')
  })
  
  get_data_to_plot <- function(){
    data_to_plot <- dataset1 %>% select(Date, !!as.symbol(input$pricess_bulltet1))
    if(!is.null(input$limits1)){
      data_to_plot <- data_to_plot %>% 
        filter(Date >= input$date_window1[1] & Date <= input$date_window1[2])
      if('1' %in% input$limits1){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet1), k = input$moving_window1, fill = NA)) %>%
          mutate(InfLimit1Sigma = Average + roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1)) %>%
          mutate(SupLimit1Sigma = Average - roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1))
      }
      if('2' %in% input$limits1){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet1), k = input$moving_window1, fill = NA)) %>%
          mutate(InfLimit2Sigma = Average + (2 * roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1))) %>%
          mutate(SupLimit2Sigma = Average - (2 * roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1)))
      }
      if('3' %in% input$limits1){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet1), k = input$moving_window1, fill = NA)) %>%
          mutate(InfLimit3Sigma = Average + (3 * roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1))) %>%
          mutate(SupLimit3Sigma = Average - (3 * roll_sd(!!as.symbol(input$pricess_bulltet1), width = input$moving_window1)))
      }
    }
    return(data_to_plot)
  }
  
  get_plot <- function(){
    plot <- plot <- ggplot(dataset1 %>% filter(Date >= input$date_window1[1] & Date <= input$date_window1[2]), 
                           aes(Date)) +
      geom_line(aes_string(y = input$pricess_bulltet1)) +
      geom_point(aes_string(y = input$pricess_bulltet1)) +
      scale_y_continuous(labels=scales::dollar_format()) +
      scale_x_date(labels = date_format("%Y-%m-%d")) + 
      theme(plot.background = element_rect(fill = "lightblue", colour = "lightblue"),
            panel.background = element_rect(fill = "lightblue", colour = "lightblue"),
            panel.grid.major.x = element_blank(),
            panel.grid.major.y = element_line( size=.1, color="white" ),
            panel.grid.minor = element_blank(),
            axis.text=element_text(size=14),
            axis.text.x=element_text(angle=30, hjust=1),
            legend.position = "none")
    
    data_to_plot <- get_data_to_plot()
    
    if(!is.null(input$limits1)){
      if('1' %in% input$limits1){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit1Sigma), colour=input$limit_color1)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit1Sigma), colour=input$limit_color1)
      }
      if('2' %in% input$limits1){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit2Sigma), colour=input$limit_color1)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit2Sigma), colour=input$limit_color1)
      }
      if('3' %in% input$limits1){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit3Sigma), colour=input$limit_color1)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit3Sigma), colour=input$limit_color1)
      }
    }
    return(plot)
  }

  
  
  
  output$download_file1 <- downloadHandler(
    filename = function(){
      paste(input$file_name1, ".csv", sep="")
    },
    content = function(file){
      write.csv(get_data_to_plot(), file, row.names = FALSE)
    }
  )
  
  output$download_graph1 <- downloadHandler(
    filename = function(){
      paste(input$graph_name1,'.png', sep='')
    },
    content = function(file){
      ggsave(file, plot=get_plot(), width=20)
    }
  )
  
  output$candle_graph1 <- renderPlotly({get_plot()})
  
  ##################################################################################
  
  dataset2 <- readr::read_csv('ethereum.csv') %>%
    select(Date, High, Low, Open, Close) %>%
    mutate(across(2:5, round, 2)) %>%
    mutate(Date = as.Date(Date, format = '%y-%m-%d'))
  
  observeEvent(input$pricess_bulltet2, {
    output$graph_title2 <- renderText(paste(input$pricess_bulltet2, 'Price Graph', sep=' '))
  })

  observeEvent(input$date_window2, {
    updateNumericInput(session, 'moving_window2', max=as.numeric(input$date_window2[2] - input$date_window2[1]))
  })

  output$output_table2 <- DT::renderDataTable({
    get_data_to_plot2() %>%
      DT::datatable() %>%
      formatCurrency(columns = c(input$pricess_bulltet2), currency='$')
  })

  get_data_to_plot2 <- function(){
    data_to_plot <- dataset2 %>% select(Date, !!as.symbol(input$pricess_bulltet2))
    if(!is.null(input$limits2)){
      data_to_plot <- data_to_plot %>%
        filter(Date >= input$date_window2[1] & Date <= input$date_window2[2])
      if('1' %in% input$limits2){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet2), k = input$moving_window2, fill = NA)) %>%
          mutate(InfLimit1Sigma = Average + roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2)) %>%
          mutate(SupLimit1Sigma = Average - roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2))
      }
      if('2' %in% input$limits2){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet2), k = input$moving_window2, fill = NA)) %>%
          mutate(InfLimit2Sigma = Average + (2 * roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2))) %>%
          mutate(SupLimit2Sigma = Average - (2 * roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2)))
      }
      if('3' %in% input$limits2){
        data_to_plot <- data_to_plot %>%
          mutate(Average = zoo::rollmean(!!as.symbol(input$pricess_bulltet2), k = input$moving_window2, fill = NA)) %>%
          mutate(InfLimit3Sigma = Average + (3 * roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2))) %>%
          mutate(SupLimit3Sigma = Average - (3 * roll_sd(!!as.symbol(input$pricess_bulltet2), width = input$moving_window2)))
      }
    }
    return(data_to_plot)
  }

  get_plot2 <- function(){
    plot <- plot <- ggplot(dataset2 %>% filter(Date >= input$date_window2[1] & Date <= input$date_window2[2]),
                           aes(Date)) +
      geom_line(aes_string(y = input$pricess_bulltet1)) +
      geom_point(aes_string(y = input$pricess_bulltet1)) +
      scale_y_continuous(labels=scales::dollar_format()) +
      scale_x_date(labels = date_format("%Y-%m-%d")) +
      theme(plot.background = element_rect(fill = "lightblue", colour = "lightblue"),
            panel.background = element_rect(fill = "lightblue", colour = "lightblue"),
            panel.grid.major.x = element_blank(),
            panel.grid.major.y = element_line( size=.1, color="white" ),
            panel.grid.minor = element_blank(),
            axis.text=element_text(size=14),
            axis.text.x=element_text(angle=30, hjust=1),
            legend.position = "none")

    data_to_plot <- get_data_to_plot2()

    if(!is.null(input$limits2)){
      if('1' %in% input$limits2){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit1Sigma), colour=input$limit_color2)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit1Sigma), colour=input$limit_color2)
      }
      if('2' %in% input$limits2){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit2Sigma), colour=input$limit_color2)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit2Sigma), colour=input$limit_color2)
      }
      if('3' %in% input$limits2){
        plot <-  plot + geom_line(aes(y = data_to_plot$InfLimit3Sigma), colour=input$limit_color2)
        plot <-  plot + geom_line(aes(y = data_to_plot$SupLimit3Sigma), colour=input$limit_color2)
      }
    }
    return(plot)
  }




  output$download_file2 <- downloadHandler(
    filename = function(){
      paste(input$file_name2, ".csv", sep="")
    },
    content = function(file){
      write.csv(get_data_to_plot2(), file, row.names = FALSE)
    }
  )

  output$download_graph2 <- downloadHandler(
    filename = function(){
      paste(input$graph_name2,'.png', sep='')
    },
    content = function(file){
      ggsave(file, plot=get_plot2(), width=20)
    }
  )

  output$candle_graph2 <- renderPlotly({get_plot2()})

})
