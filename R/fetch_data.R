#' Fetch adjusted close prices for a ticker
#'
#' @param tckr A stock or index ticker, e.g. "AAPL", "SPY", "^NSEI".
#' @param from Start date, "YYYY-MM-DD".
#'
#' @return An xts object of adjusted close prices.
#' @export
#' @examples
#' \dontrun{
#' aapl_prices <- tckr_data("AAPL", from = "2023-01-01")
#' head(aapl_prices)
#' }

tckr_data <- function(tckr, from)  {
  raw <- quantmod::getSymbols(tckr, from = from,
                              to = Sys.Date(), auto.assign = FALSE)

  quantmod::Ad(raw)
}
