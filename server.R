library(shiny); library(stringr); library(stringdist); library(feather); library(DT); library(dplyr)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  output$simview <- DT::renderDataTable({
    ru_reversed %>% 
      mutate(sim = stringsim(input$simquery, word)) %>% 
      arrange(desc(sim)) %>% 
      slice(1:input$n_best) %>% 
      select(word)
  },
  options = list(pageLength = 50, dom = 'ftip'))
  
  output$fullview <- DT::renderDataTable({
    ru_reversed %>% 
      mutate(new_word = str_replace_all(word, "́", "")) %>% 
      mutate(dist = stringdist(input$fullquery, new_word)) %>% 
      filter(dist == input$l.dist_full) %>% 
      select(word)
    },
  options = list(pageLength = 40, dom = 'ftip'))
  
  output$view <- DT::renderDataTable({
    data <- ru_reversed[ru_reversed$stressed_s == input$stress,]
    stressed_vowel <- str_locate_all(input$query, "[аеёиоуыэюя]")
    stressed_vowel <- rev(data.frame(stressed_vowel)$start)[input$stress]
    pattern <- str_sub(input$query, -nchar(input$query), -stressed_vowel-1)
    ends <- str_sub(str_replace_all(data$word, "́", ""), -nchar(input$query), -1)
    data <- data[str_sub(ends, -nchar(input$query), -stressed_vowel-1) == pattern,]
    ends <- ends[str_sub(ends, -nchar(input$query), -stressed_vowel-1) == pattern]
    result <- data[stringdist(ends, input$query) <= input$l.dist, 1]
    if(input$n_vowels_before == 0){result} else{
      result$n_vowels_before <- str_count(result$word, "[аеёиоуыэюя]") - input$stress
      result[result$n_vowels_before == input$n_vowels_before, 1]
      }},
    options = list(pageLength = 36, dom = 'ftip'))
}