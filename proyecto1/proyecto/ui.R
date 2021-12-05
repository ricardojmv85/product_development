

library(shiny)
library(DT)
library(colourpicker)
library(plotly)

shinyUI(fluidPage(
  fluidPage( tabsetPanel(id = "inTabset",
    tabPanel("Bitcoin", value='bitcoin',
             titlePanel("Bitcoin Analysis"),
             sidebarLayout(
               sidebarPanel(
                 h2('Date and type visualization'),
                 dateRangeInput('date_window1', 
                                'Please select a date window',
                                start='2021-01-01',
                                end = '2021-03-31',
                                max = '2021-07-06',
                                min = '2013-04-29'),
                 radioButtons('pricess_bulltet1',
                              'Please select price condition',
                              c('Open', 'Close','High', 'Low'),
                              selected='High'),
                 h2('Control chart parameters'),
                 checkboxGroupInput('limits1',
                                    'Please select the sigma limits to visualize',
                                    choiceNames=c('1 Sigma', '2 Sigma', '3 Sigma'),
                                    choiceValues=c(1, 2, 3)),
                 colourInput('limit_color1', 'Please select the color of the limits', value='red', showColour='background',palette = "limited"),
                 numericInput('moving_window1',
                              'Please select the moving window range',
                              3,
                              min=1),
                 h2('Export'),
                 textInput('graph_name1', 'Name for the graph', 'Bitcoin Graph Name'),
                 downloadButton("download_graph1", "Download graph"),
                 textInput('file_name1', 'Name for the file', 'Bitcoin File Name'),
                 downloadButton("download_file1", "Download file"),
                 h2('Share view'),
                 verbatimTextOutput('report1')
               ),
               mainPanel(
                 h1(textOutput('graph_title1')),
                 plotlyOutput("candle_graph1"),
                 h2("Data source table"),
                 DT::DTOutput('output_table1')
               ) 
             )),
    tabPanel("Ethereum", value='ethereum',
             titlePanel("Ethereum Analysis"),
             sidebarLayout(
               sidebarPanel(
                 h2('Date and type visualization'),
                 dateRangeInput('date_window2', 
                                'Please select a date window',
                                start='2021-01-01',
                                end = '2021-03-31',
                                max = '2021-07-06',
                                min = '2013-04-29'),
                 radioButtons('pricess_bulltet2',
                              'Please select price condition',
                              c('Open', 'Close','High', 'Low'),
                              selected='High'),
                 h2('Control chart parameters'),
                 checkboxGroupInput('limits2',
                                    'Please select the sigma limits to visualize',
                                    choiceNames=c('1 Sigma', '2 Sigma', '3 Sigma'),
                                    choiceValues=c(1, 2, 3)),
                 colourInput('limit_color2', 'Please select the color of the limits', value='red', showColour='background',palette = "limited"),
                 numericInput('moving_window2',
                              'Please select the moving window range',
                              3,
                              min=1),
                 h2('Export'),
                 textInput('graph_name2', 'Name for the graph', 'Ethereum Graph Name'),
                 downloadButton("download_graph2", "Download graph"),
                 textInput('file_name2', 'Name for the file', 'Ethereum File Name'),
                 downloadButton("download_file2", "Download file"),
                 h2('Share view'),
                 verbatimTextOutput('report2')
               ),
               mainPanel(
                 h1(textOutput('graph_title2')),
                 plotlyOutput("candle_graph2"),
                 h2("Data source table"),
                 DT::DTOutput('output_table2')
               ) 
             ))
    ))))
