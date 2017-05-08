library(shiny); library(stringr); library(stringdist); library(feather); library(dplyr)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  output$view <- renderTable({
    ru_reversed %>% 
      filter(stressed_s == input$stress) %>% 
      mutate(word_ = str_replace(word,  "́", "")) ->
      ru_reversed
    
    vowel <- nchar(input$query) - grep("[аеёиоуыэюя]", str_sub(tolower(input$query), 1:nchar(input$query), 1:nchar(input$query)))[input$stress]+1
    results <- ru_reversed[str_sub(ru_reversed$word_, -nchar(input$query), -vowel) == str_sub(input$query, -nchar(input$query), -vowel) &
                  stringdist(str_sub(ru_reversed$word_, -vowel, -1), str_sub(input$query, -vowel, -1)) <= input$l.dist, 1]
      })
}
