library(shiny); library(stringr); library(stringdist)

function(input, output) {
  load("ru_reversed.RData")
  output$view <- renderTable({
    ru_reversed[
      stringdist(
        str_sub(ru_reversed$forms, -nchar(input$query), -1),
        tolower(input$query),
        method = "lv") <= input$l.dist, ]
  })
}
