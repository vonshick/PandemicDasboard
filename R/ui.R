#'@import shiny

ui <- fluidPage(
  titlePanel("Coronavirus dashboard"),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      selectInput(inputId = "country_select", label = "Country", choices = c("Poland"))
    ),

    mainPanel(
      width = 8,
      fluidRow(
        align = "center",
        height = 4,
        plotly::plotlyOutput(outputId = "total_cases_plot")
      ),
      fluidRow(height = 4, br()),
      fluidRow(
        align = "center",
        height = 4,
        plotly::plotlyOutput(outputId = "daily_cases_plot")
      )
    )
  )
)
