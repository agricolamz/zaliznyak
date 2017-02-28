fluidPage(
  titlePanel("Обратный словарь А. А. Зализняка"),
  fluidRow(
    column(4, wellPanel(
      textInput("query", "", value = "загон"),
      sliderInput("l.dist", "РЛ перед последним гласным:",
                  min=0, max=5, value=0),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

