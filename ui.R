fluidPage(
  fluidRow(
    column(3, wellPanel(
      textInput("query", "", value = "осёл"),
      submitButton("поиск")
    )),
    column(6,
           tableOutput("view")
    )
  )
)

