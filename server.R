library(shiny)
library(stringr)
library(stringdist)
library(feather)
library(DT)
library(dplyr)

function(input, output) {
  ru_reversed <- read_feather("ru_reversed.feather")
  stress <- "́"
  output$view <- DT::renderDataTable({
    str_vowel <- rev(str_extract_all(input$query, "[аеёиоуыэюяАЕЁИОУЫЭЮЯ]")[[1]])[input$stress]
    str_vowel_id <- rev(str_locate_all(input$query, "[аеёиоуыэюяАЕЁИОУЫЭЮЯ]")[[1]][,"start"])[input$stress]
    query_f_fragment <- str_sub(input$query, str_vowel_id+1, str_vowel_id+input$l_symbol_after)
    query_f_fragment_adjusted <- str_sub(input$query, str_vowel_id+1+input$l_symbol_after, nchar(input$query))
    query_p_fragment <- str_sub(input$query, 1, str_vowel_id-1)
    ru_reversed %>%
      filter(stressed_s == input$stress,
             str_detect(word, paste0(str_vowel, stress))) %>%
      mutate(stressed_n = str_locate(word, paste0(str_vowel, stress))[1:n()] + 2,
             fol_fragment = str_sub(word, stressed_n, stressed_n + input$l_symbol_after-1),
             fol_fragment_adjusted = str_sub(word, stressed_n+input$l_symbol_after, stressed_n + nchar(input$query)),
             prev_fragment = str_sub(word, stressed_n - nchar(query_p_fragment) - 2, stressed_n-3),
             dist = stringdist(fol_fragment_adjusted, query_f_fragment_adjusted)) %>%
      filter(prev_fragment == query_p_fragment,
             fol_fragment == query_f_fragment,
             dist <= input$l.dist) ->
      results
    if (input$n_vowels_before > 0) {
      results %>%
        mutate(fragment = str_sub(word, 1, stressed_n - 3),
               vowels_before = str_count(fragment, "[аеёиоуыэюяАЕЁИОУЫЭЮЯ]")) %>%
        filter(vowels_before == input$n_vowels_before) ->
        results
    }
    results %>% select(word) %>% distinct()
  },
  options = list(pageLength = 36, dom = 'ftip'))
  
  output$fullview <- DT::renderDataTable({
    ru_reversed %>%
      mutate(new_word = str_replace_all(word, stress, "")) %>%
      filter(str_detect(new_word, input$fullquery)) ->
      full_result
    if (input$n_vowels_before2 > 0){
      full_result %>% 
        mutate(b = str_locate(new_word, input$fullquery)[1:n()]-1,
               n_vowels = str_count(str_sub(new_word, 1, b), "[аеёиоуыэюяАЕЁИОУЫЭЮЯ]")) %>%
        filter(n_vowels == input$n_vowels_before2) ->
        full_result
    }
    full_result[,1] %>% distinct()
  },
  options = list(pageLength = 40, dom = 'ftip'))
  output$simview <- DT::renderDataTable({
    ru_reversed %>%
      mutate(sim = stringsim(input$simquery, word)) %>%
      arrange(desc(sim)) %>%
      slice(1:input$n_best) %>%
      select(word) %>% 
      distinct()
  },
  options = list(pageLength = 50, dom = 'ftip'))

output$syllable <- DT::renderDataTable({
  ru_reversed %>%
    filter(stressed_s == input$syll_stress) %>% 
    mutate(n_syl = str_count(word, "[аеёиоуыэюяАЕЁИОУЫЭЮЯ]")) %>% 
    filter(n_syl == input$syll_number) %>% 
    select("word")
  },
options = list(pageLength = 50, dom = 'ftip'))
}