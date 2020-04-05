
#'@importFrom dplyr mutate_at vars %>%
#'@importFrom tidyr replace_na %>%
replace_na_with_zeros <- function(data) {
  data %>%
    mutate_at(
      vars(total_cases:total_cases_per1m),
      ~replace_na(
        as.numeric(
          str_replace(., ",", "")
      ))) %>%
    return()
}

#'@importFrom dplyr mutate group_by ungroup filter %>%
#'@importFrom lubridate ymd_hms date
select_the_newest_records <- function(data) {
  data %>%
    mutate(
      record_date = ymd_hms(record_date),
      date = date(record_date)
    ) %>%
    group_by(date) %>%
    filter(record_date == max(record_date)) %>%
    ungroup() %>%
    return()
}

#'@importFrom dplyr as_tibble %>%
#'@importFrom testthat test_that expect_true
#'@importFrom purrr map_df
convert_response_data_to_df <- function(list) {
  test_that("List contains `stat_by_country`", expect_true("stat_by_country" %in% names(list)))

  map_df(list$stat_by_country, function(record){
    # column `region` is NULL for Poland
    as_tibble(record[names(record) != "region"])
  }) %>%
  select_the_newest_records() %>%
  replace_na_with_zeros() %>%
  return()
}

#' Download cases history for specific country
#'
#'@importFrom httr GET add_headers content
#'@importFrom testthat test_that expect_equal
#'@importFrom dplyr %>%
#'@param country string e.g. "Poland", "Italy", etc.
#'@export
get_statistics_for_specific_country <- function(country) {
  response <- GET(
    url = 'https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_particular_country.php',
    query = list(country = country),
    add_headers(
      `x-rapidapi-host` = 'coronavirus-monitor.p.rapidapi.com',
      `x-rapidapi-key` = '7abb4b4a46mshf9509105bb90c14p16045cjsn46e459e3af56'
    )
  )

  test_that("Response code should be equal to 200", expect_equal(response$status_code, 200))

  response_data <- response %>%
    content(as = "parsed", type = "application/json") %>%
    convert_response_data_to_df() %>%
    return()
}
