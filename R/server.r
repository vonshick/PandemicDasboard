#'@import plotly
#'@import shiny
#'@import shinydashboard
#'@importFrom dplyr between filter %>%
pandash_server <- function(input, output, session) {

  country_data_rv <- eventReactive(input$country_select, {
    country_data <-
      get_statistics_for_specific_country(input$country_select)

    updateDateRangeInput(
      session,
      "date_range",
      start = min(country_data$date),
      end = max(country_data$date),
      min = min(country_data$date),
      max = max(country_data$date)
    )

    return(country_data)
  })

  country_data_with_trend_rv <- eventReactive(input$date_range, {
    data_and_coefficient_list <-
      add_regression_line(
        country_data_rv(),
        start_date = input$date_range[1],
        end_date = input$date_range[2]
      )

    output$trendline_txt <- renderText(data_and_coefficient_list$coefficient)
    return(data_and_coefficient_list$data_with_trend)
  })

  output$daily_cases_plot <- renderPlotly({
    country_data_with_trend_rv() %>%
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
      add_trace(
        x = ~date,
        y = ~cases_trend,
        type = "scatter",
        mode = "dashes",
        color = I("orangered"),
        name = "New cases trendline"
      ) %>%
      layout(
        title = "Cases by day",
        xaxis = list(title = "Day"),
        yaxis = list(title = "Count")
      )
  })


  output$total_cases_plot <- renderPlotly({
    country_data_with_trend_rv() %>%
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
