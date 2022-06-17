overview_ui <- function(id) {
  ns <- NS(id)

  tagList(
    selectInput(ns("states"), "States",
      setNames(names(states), unlist(states)),
      multiple = TRUE),
    uiOutput(ns("grid"))
  )
}

overview_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    active_states <- reactive({
      if (is.null(input$states)) {
        sort(unique(df$state))
      } else {
        input$states
      }
    })

    output$grid <- renderUI({
      card_grid(card_width = 225, fixed_width = FALSE, heights_equal = "row",
        lapply(active_states(), state_card, id = session$ns(NULL))
      )
    })

    xrange <- range(weekly_df$submission_date)
    yrange <- c(max(weekly_df$new_case) * -0.1, max(weekly_df$new_case) * 1.1)

    lapply(sort(unique(df$state)), function(state) {
      output[[paste0("plotly_", state)]] <- renderPlotly({
        info <- getCurrentOutputInfo()

        weekly_df |>
          filter(.data$state == .env$state) |>
          plot_ly(x = ~submission_date, y = ~new_case, color = I(info$fg())) |>
          add_lines() |>
          layout(yaxis = list(range = yrange)) |>
          plotly_minimal_layout()

      }) |> bindCache(state)
    })
  })
}

state_card <- function(state, id) {
  ns <- NS(id)

  worst_week <- weekly_df |>
    filter(.data$state == .env$state) |>
    arrange(desc(new_case)) |>
    head(1)

  card(
    card_body(padding = NULL,
      class = if (state %in% danger_states)
        "bg-danger"
      else if (state %in% warning_states)
        "bg-warning"
      else
        "bg-light",
      plotlyOutput(ns(paste0("plotly_", state)), height = 125)
    ),
    h6(states[[state]]),
    p("Peak of ",
      prettyNum(worst_week$new_case, big.mark = ","),
      " cases/week ocurred on ",
      worst_week$submission_date
    ),
    card_footer(
      tags$a(class = "btn btn-primary", href = route_link(paste0("state?id=", state)),
        "Details"
      )
    )
  )
}

plotly_minimal_layout <- function(p) {
  info <- getCurrentOutputInfo()

  p |>
    layout(
      dragmode = FALSE,
      font = list(color = info$fg(), family = info$font()$families[[1]]),
      xaxis = list(visible = FALSE),
      yaxis = list(visible = FALSE),
      paper_bgcolor = info$bg(),
      plot_bgcolor = info$bg(),
      margin = list(t = 0, r = 0, b = 0, l = 0)
    ) |>
    config(displayModeBar = F)
}
