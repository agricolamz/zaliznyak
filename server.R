library(shiny); library(stringr); library(stringdist); library(feather); library(DT)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  output$fullview <- DT::renderDataTable({
    data.frame(result = str_subset(ru_reversed$word, input$fullquery))
  },
  options = list(pageLength = 36, dom = 'ftip'))
  output$view <- DT::renderDataTable({
    data <- ru_reversed[ru_reversed$stressed_s == input$stress,]
    stressed_vowel <- str_locate_all(input$query, "[аеёиоуыэюя]")
    stressed_vowel <- rev(data.frame(stressed_vowel)$start)[input$stress]
    pattern <- str_sub(input$query, -nchar(input$query), -stressed_vowel-1)
    ends <- str_sub(str_replace_all(data$word, "́", ""), -nchar(input$query), -1)
    data <- data[str_sub(ends,  -nchar(input$query), -stressed_vowel-1) == pattern,]
    ends <- ends[str_sub(ends,  -nchar(input$query), -stressed_vowel-1) == pattern]
    result <- data[stringdist(ends, input$query) <= input$l.dist, 1]
    if(input$n_vowels_before == 0){result} else{
      result$n_vowels_before <- str_count(result$word, "[аеёиоуыэюя]") - input$stress
      result[result$n_vowels_before == input$n_vowels_before, 1]
      }},
    options = list(pageLength = 36, dom = 'ftip'))
}