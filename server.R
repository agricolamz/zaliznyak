library(shiny); library(stringr)

function(input, output) {
  load("ru_reversed.RData")
  output$view <- renderTable({
    ru_reversed[str_sub(ru_reversed$forms, -nchar(input$query), -1) == tolower(input$query),]
  })
}
