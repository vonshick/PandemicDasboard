#'@import shinydashboard

pandash_ui <- function() {
  header <- dashboardHeader(title = "Pandemic dashboard")

  body <- dashboardBody(
    fluidPage(
      # titlePanel("Pandemic dashboard"),
      sidebarLayout(
        sidebarPanel(
          width = 4,
          selectInput(
            inputId = "country_select",
            label = "Country",
            choices = c("Poland", "Japan", "Italy", "Spain", "Germany", "China")
          ),
          dateRangeInput(inputId = "date_range", label = "Date range")
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
  )

  dashboardPage(
    header,
    dashboardSidebar(disable = TRUE),
    body
  )
}
