library(shiny); library(stringr); library(stringdist)

function(input, output) {
  load("ru_reversed.RData")
  output$view <- renderTable({
    vowel <- nchar(input$query) - max(grep("[аеёиоуыэюя]", str_sub(tolower(input$query), 1:nchar(input$query), 1:nchar(input$query))))+1
    ru_reversed[str_sub(ru_reversed$forms, -vowel, -1) == str_sub(input$query, -vowel, -1) &
                  stringdist(str_sub(ru_reversed$forms, -nchar(input$query), -vowel), str_sub(input$query, -nchar(input$query) -vowel)) <= input$l.dist+1, ]
      })
}
