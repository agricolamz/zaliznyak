library(rmarkdown)

navbarPage("",
           tabPanel("Обратный поиск",
  titlePanel("Обратный поиск в словаре А. А. Зализняка"),
  fluidRow(
    column(3, wellPanel(
      textInput("query", "", value = "нога"),
      sliderInput("stress", "Ударный слог с конца слова:",
                  min=1, max=5, value=1),
      sliderInput("l.dist", "РЛ фрагмента после ударного гласного:",
                  min=0, max=5, value=0),
      sliderInput("n_vowels_before", "Количество слогов перед ударением (не учитывается, если значение — ноль)",
                  min=0, max=6, value=0),
      submitButton("поиск")
    )),
    column(3,
           DT::dataTableOutput("view")
    )
  )),
  tabPanel("Точный поиск по словарю",
           titlePanel("Точный поиск по словарю"),
           "Можно использовать регулярные выражения, например, 'нога.м' или 'нога.*м'",
           fluidRow(
             column(3, wellPanel(
               textInput("fullquery", "", value = "нога")),
               sliderInput("n_vowels_before2", "Количество слогов перед ударением (не учитывается, если значение — ноль)",
                           min=0, max=6, value=0),
               submitButton("поиск")),
             column(3,
                    DT::dataTableOutput("fullview")
             ))),
tabPanel("Поиск ближайших слов",
         titlePanel("Поиск ближайших слов по словарю"),
         fluidRow(
          column(3, wellPanel(
             textInput("simquery", "", value = "нога")),
             sliderInput("n_best", "Количество слов в выдаче",
                         min=10, max=50, value=50),
             submitButton("поиск")),
         column(3,
                DT::dataTableOutput("simview")
         ))))

