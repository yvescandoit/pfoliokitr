#' Compute daily log returns from adjusted prices
#'
#' @param prices An xts object of adjusted close prices (e.g. from `tckr_data()`).
#'
#' @return An xts object of daily log returns, with the leading NA removed.
#' @export
#' @examples
#' dates <- as.Date("2024-01-01") + 0:4
#' prices <- xts::xts(c(100, 102, 101, 105, 107), order.by = dates)
#' log_ret(prices)

log_ret <- function(prices)  {
if (!xts::is.xts(prices)) {
  print("'prices' must be an xts object to compute log returns.")
} else
  stats::na.omit(diff(log(prices)))
}


#' Align two return series on their shared dates
#'
#' @param x,y xts objects of returns, possibly on different calendars.
#'
#' @return A named list with `x` and `y`, trimmed to common dates.
#' @export
#' @examples
#' x <- xts::xts(1:5, order.by = as.Date("2024-01-01") + 0:4)
#' y <- xts::xts(1:3, order.by = as.Date("2024-01-01") + 0:2)
#' aligned <- aligned_returns(x,y)
#' aligned$x
#' aligned$y

aligned_returns <- function(x, y) {
  merged <- intersect(zoo::index(x), zoo::index(y))
  merged <- as.Date(merged, origin = "1970-01-01")
  list(
    x = x[merged],
    y = y[merged]
  )
}

