state_ui <- function(id) {
  ns <- NS(id)
  tagList(
    verbatimTextOutput(ns("state"))
  )
}

state_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    state <- reactive({
      state_param <- req(get_query_param("id"))
      weekly_df |> filter(.data$state == .env$state_param)
    })

    output$state <- renderPrint({ state() })
  })
}
