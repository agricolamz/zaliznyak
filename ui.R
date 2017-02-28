fluidPage(
  titlePanel("Обратный словарь А. А. Зализняка"),
  fluidRow(
    column(2, wellPanel(
      textInput("query", "", value = "загон"),
      sliderInput("l.dist", "Расстояние Левенштейна:",
                  min=0, max=3, value=0),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

