library(shiny); library(stringr); library(stringdist); library(feather)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  output$view <- renderTable({
    vowel <- nchar(input$query) - grep("[аеёиоуыэюя]", str_sub(tolower(input$query), 1:nchar(input$query), 1:nchar(input$query)))[input$n.vowels]+1
    results <- ru_reversed[str_sub(ru_reversed$forms, -nchar(input$query), -vowel) == str_sub(input$query, -nchar(input$query), -vowel) &
                  stringdist(str_sub(ru_reversed$forms, -vowel, -1), str_sub(input$query, -vowel, -1)) <= input$l.dist, ]
    results[is.na(results$stressed_end)|(results$stressed_end == input$stress) , ]
      })
}
