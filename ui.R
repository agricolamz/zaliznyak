fluidPage(
  titlePanel("Обратный словарь А. А. Зализняка"),
  fluidRow(
    column(2, wellPanel(
      textInput("query", "", value = "осёл"),
      submitButton("поиск")
    )),
    column(3,
           tableOutput("view")
    )
  )
)

