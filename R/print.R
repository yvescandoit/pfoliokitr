#' Registry of metric labels and print formats
#'
#' Internal lookup table mapping each metric field name to its display
#' label and `sprintf` format string, used by `print.portfolio_metrics()`.
#'
#' @keywords internal

metric_registry <- list(
  ann_return      = list(label = "Annualised return",  fmt = "%+.2f%%"),
  ann_volatility  = list(label = "Annualised Vol",     fmt = "%.2f%%"),
  sharpe_ratio    = list(label = "Sharpe Ratio",       fmt = "%.3f"),
  sortino_ratio   = list(label = "Sortino Ratio",      fmt = "%.3f"),
  calmar_ratio    = list(label = "Calmar Ratio",       fmt = "%.3f"),
  max_drawdown   = list(label = "Max Drawdown",        fmt = "%.2f%%"),
  beta            = list(label = "Beta vs Benchmark",  fmt = "%.3f"),
  alpha           = list(label = "Alpha (annualised)", fmt = "%+.2f%%"),
  var              = list(label = "VaR 95% (daily)",   fmt = "%.3f%%"),
  cvar            = list(label = "CVaR 95% (daily)",   fmt = "%.3f%%"),
  skewness        = list(label = "Skewness",           fmt = "%.4f"),
  kurtosis        = list(label = "Excess Kurtosis",    fmt = "%.4f")
)

#' Combine multiple metric lists into one classed object
#'
#' @param ... Any number of `portfolio_metrics` objects (or plain named
#'   lists) to merge into one.
#'
#' @return A single object of class `portfolio_metrics` containing all
#'   fields from the inputs.
#' @export
#' @examples
#' set.seed(1)
#' dates <- as.Date("2024-01-01") + 0:251
#' bench <- xts::xts(rnorm(252, 0.005, 1), order.by = dates)
#' ret <- xts::xts(1.2 * as.numeric(bench) + rnorm(252, 0, 0.005), order.by = dates)
#' metr <- metrics(ret, 0.05)
#' risk <- risk_metrics(ret, 0.95, "historical")
#' relative <- relative_metrics(ret, bench, 0.05)
#' combine_metrics(metr, risk, relative)
#'

combine_metrics <- function(...)  {
  structure(c(...), class = "portfolio_metrics")
}

#' Print a formatted performance summary
#'
#' Accepts any combination of output from `metrics()`, `risk_metrics()`,
#' and `relative_metrics()`, merged together with `combine_metrics()`.
#' Missing fields are simply skipped.
#'
#' @param x A `portfolio_metrics` object.
#' @param label A header label, e.g. the ticker symbol "LLY","AAPL".
#' @param ... Additional arguments.
#'
#' @return `x`, invisibly.
#' @export
#' @examples
#' set.seed(1)
#' dates <- as.Date("2024-01-01") + 0:251
#' ret <- xts::xts(rnorm(252, 0.005, 1), order.by = dates)
#' m <- metrics(ret, 0.05)
#' print(m, label = "Example stock")
print.portfolio_metrics <- function(x, label = "",...)   {
  cat(sprintf("\n===== %s =====\n", label))
  for (name in names(metric_registry)) {
    if (!is.null(x[[name]])) {
      info <- metric_registry[[name]]
      cat(sprintf("%-20s: %s\n", info$label,sprintf(info$fmt, x[[name]])))
    }
  }
  invisible(x)
}


#' Convert a portfolio_metrics object to a data frame
#'
#' @param x A `portfolio_metrics` object.
#' @param ... Additional arguments passed to `as.data.frame()`.
#'
#' @return A one-row data frame, one column per metric field.
#' @export
#' @examples
#' set.seed(1)
#' dates <- as.Date("2024-01-01") + 0:251
#' ret <- xts::xts(rnorm(252, 0.005, 1), order.by = dates)
#' m <- metrics(ret, 0.05)
#' as.data.frame(m)

as.data.frame.portfolio_metrics <- function(x,...)  {
  as.data.frame(unclass(x), ...)
}
