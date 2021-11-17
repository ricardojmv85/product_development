

library(shiny)
library(lubridate)

shinyUI(fluidPage(

   
    titlePanel("Cargar Archivos a Shiny"),
    sidebarLayout(
      sidebarPanel(
        fileInput("cargar_archivo", "Cargar archivo", buttonLabel = "Seleccionar", placeholder = "No hay archivo seleccionado"),
        dateRangeInput('fechas', "Seleccione fechas",
                       start= ymd("1990-01-05"), end = ymd("2007-09-30"), min=ymd("1900-01-05"), max=ymd("2007-09-30")),
        downloadButton("download_dataframe", "Descargar Arhivo")
      ),
      mainPanel(
        DT::dataTableOutput("contenido_archivo")
      )
    )


))
