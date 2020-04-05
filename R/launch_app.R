#' @export
#'
#' @importFrom shiny shinyApp
#'

launch_app <- function() {
  shinyApp(ui = ui, server = server)
}
