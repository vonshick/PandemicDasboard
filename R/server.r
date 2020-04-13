#'@import plotly
#'@import shiny
#'@import shinydashboard
pandash_server <- function(input, output) {

  country_data <- eventReactive(input$country_select, {
    get_statistics_for_specific_country(input$country_select)
  })

  output$daily_cases_plot <- renderPlotly({
    country_data() %>%
      plot_ly(
        x = ~date,
        y = ~new_cases,
        type = "scatter",
        mode = "lines",
        color = I("orange"),
        name = "New cases"
      ) %>%
      add_trace(
        x = ~date,
        y = ~new_deaths,
        type = "scatter",
        mode = "lines",
        color = I("red"),
        name = "New deaths"
      ) %>%
      add_trace(
        x = ~date,
        y = ~new_recovered,
        type = "scatter",
        mode = "lines",
        color = I("green"),
        name = "New recovered"
      ) %>%
      layout(
        title = "Cases by day",
        xaxis = list(title = "Day"),
        yaxis = list(title = "Count")
      )
  })


  output$total_cases_plot <- renderPlotly({
    country_data() %>%
      plot_ly(
        x = ~date,
        y = ~total_cases,
        type = "scatter",
        mode = "lines",
        color = I("orange"),
        name = "All cases"
      ) %>%
      add_trace(
        x = ~date,
        y = ~total_deaths,
        type = "scatter",
        mode = "lines",
        color = I("red"),
        name = "All deaths"
      ) %>%
      add_trace(
        x = ~date,
        y = ~total_recovered,
        type = "scatter",
        mode = "lines",
        color = I("green"),
        name = "All recovered"
      ) %>%
      layout(
        title = "Total cases",
        xaxis = list(title = "Day"),
        yaxis = list(title = "Count")
      )
  })
}
