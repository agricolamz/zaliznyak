fluidPage(
  titlePanel("Обратный словарь А. А. Зализняка"),
  fluidRow(
    column(3, wellPanel(
      textInput("query", "", value = "паровоз"),
      sliderInput("l.dist", "РЛ фрагмента после опорного гласного:",
                  min=0, max=5, value=2),
      sliderInput("n.vowels", "номер опорного гласного (с начала)",
                  min=0, max=10, value=3),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

