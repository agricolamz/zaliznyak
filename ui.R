fluidPage(
  titlePanel("Обратный поиск в словаре А. А. Зализняка"),
  fluidRow(
    column(3, wellPanel(
      textInput("query", "", value = "паровоз"),
      # sliderInput("stress", "Ударный слог с конца слова:",
      #             min=1, max=5, value=1),
      sliderInput("l.dist", "РЛ фрагмента после опорного гласного:",
                  min=0, max=5, value=2),
      sliderInput("n.vowels", "номер опорного гласного (с начала слова)",
                  min=1, max=10, value=3),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

