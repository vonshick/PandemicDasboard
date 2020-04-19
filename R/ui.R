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
            label = "Country:",
            choices = c("Poland", "Belarus", "Italy", "Spain", "Germany") #, "Japan", "China")
          ),
          dateRangeInput(inputId = "date_range", label = "Date range of new cases trendline:"),
          tags$b("Trendline coefficient:"),
          textOutput(outputId = "trendline_txt")
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
