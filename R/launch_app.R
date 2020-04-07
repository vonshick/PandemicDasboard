#' @export
#'
#' @importFrom shiny shinyApp
#'

launch_app <- function() {
  shinyApp(ui = pandash_ui(), server = pandash_server)
}
