library(shiny); library(stringr); library(stringdist); library(feather); library(DT)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  output$fullview <- DT::renderDataTable({
    ru_reversed[grepl(input$fullquery, ru_reversed$word),]
  },
  options = list(pageLength = 36, dom = 'ftip'))
  output$view <- DT::renderDataTable({
    vowel <- nchar(input$query) - grep("[аеёиоуыэюя]", str_sub(tolower(input$query), 1:nchar(input$query), 1:nchar(input$query)))[input$n.vowels]+1
    results <- ru_reversed[str_sub(ru_reversed$word, -nchar(input$query), -vowel) == str_sub(input$query, -nchar(input$query), -vowel) &
                  stringdist(str_sub(ru_reversed$word, -vowel, -1), str_sub(input$query, -vowel, -1)) <= input$l.dist, ]
    results[is.na(results$stressed_s)|(results$stressed_s == input$stress), ]},
    options = list(pageLength = 36, dom = 'ftip'))
}
