library(ggplot2)
library(dplyr)
library(bslib)
library(plotly)
library(shiny)
library(shiny.router)

shinyOptions(cache = cachem::cache_disk("./cache"))
thematic::thematic_shiny()

source("global.R")

router <- make_router(
  route("/", overview_ui("overview"), \() overview_server("overview")),
  route("state", state_ui("state"), \() state_server("state"))
)

ui <- page_fluid(
  theme = bs_theme(5),
  router$ui
)

server <- function(input, output, session) {
  router$server(input, output, session)
}

shinyApp(ui, server)
