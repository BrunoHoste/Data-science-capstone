library(shiny)

source("predfunct.R")

server <- function(input, output) {
    
    output$predfunct_result <- renderText({
        predfunct(input$predfunct_input)
    })
    
}
