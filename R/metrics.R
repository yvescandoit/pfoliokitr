#' Compute standalone performance metrics for a return series
#'
#' @param ret An xts object of daily log returns.
#' @param rf Daily risk-free rate.
#'
#' @return An object of class `portfolio_metrics` with annualised return,
#'   annualised volatility, Sharpe, Sortino, Calmar, max drawdown,
#'   skewness, and excess kurtosis.
#' @export
#' @examples
#' set.seed(1)
#' dates <- as.Date("2024-01-01") + 0:251
#' ret <- xts::xts(rnorm(252, 0.0005, 0.01), order.by = dates)
#' metrics(ret, 0.05)


metrics <- function(ret, rf) {
  result <-  list(
    ann_return     = PerformanceAnalytics::Return.annualized(ret) * 100,
    ann_volatility = stats::sd(ret) * sqrt(252) * 100,
    sharpe_ratio    = PerformanceAnalytics::SharpeRatio.annualized(ret, Rf = rf),
    sortino_ratio   = PerformanceAnalytics::SortinoRatio(ret) * 100,
    calmar_ratio   = PerformanceAnalytics::CalmarRatio(ret),
    max_drawdown  = PerformanceAnalytics::maxDrawdown(ret) * 100,
    skewness      = PerformanceAnalytics::skewness(ret),
    kurtosis      = PerformanceAnalytics::kurtosis(ret)
  )
  structure(result, class = "portfolio_metrics")
}


#' Compute metrics relative to a benchmark
#'
#' @param ret,bench xts objects of daily log returns (need not be
#'   pre-aligned — this function aligns them internally via
#'   `aligned_returns()`).
#' @param rf Daily risk-free rate.
#'
#' @return An object of class `portfolio_metrics` with `beta` and
#'   annualised `alpha` (%).
#' @export
#' @examples
#' dates <- as.Date("2024-01-01") + 0:251
#' bench <- xts::xts(rnorm(252, 0.0005, 0.01), order.by = dates)
#' ret <- xts::xts(1.2 * as.numeric(bench) + rnorm(252, 0, 0.005), order.by = dates)
#' relative_metrics(ret, bench, 0.05)

relative_metrics <- function(ret, bench, rf) {
  aligned <- aligned_returns(ret, bench)

  x <- as.numeric(aligned$x)
  y <- as.numeric(aligned$y)

  beta  <- stats::cov(x, y) / stats::var(y)
  alpha <- (mean(x) - beta * mean(y)) * 252 * 100

  structure(list(beta = beta, alpha = alpha), class = "portfolio_metrics")
}
