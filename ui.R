fluidPage(
  titlePanel("Обратный словарь А. А. Зализняка"),
  fluidRow(
    column(3, wellPanel(
      textInput("query", "", value = "паровоз"),
      sliderInput("l.dist", "РЛ фрагмента после последнего гласного:",
                  min=0, max=5, value=2),
      sliderInput("n.vowels", "номер гласного",
                  min=0, max=10, value=2),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

