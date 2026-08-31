#' Compute Value at Risk and Conditional VaR(ES) for a return series
#'
#' @param ret An xts object of daily log returns.
#' @param p Confidence level. Default 0.95.
#' @param method Distribution assumption: "historical" (empirical, no
#'   distributional assumption), "gaussian" (assumes normal returns), or
#'   "modified" (Cornish-Fisher, adjusts for skew/kurtosis).
#'
#' @return An object of class `portfolio_metrics` with `var` and `cvar`,
#'   both expressed as percentages.
#' @export
#' @examples
#' dates <- as.Date("2024-01-01") + 0:99
#' ret   <- xts::xts(rnorm(100, 0, 0.02), order.by = dates)
#' risk_metrics(ret, 0.95, method = "historical")
#' risk_metrics(ret, 0.95, method = "gaussian")
#'
risk_metrics <- function(ret, p = 0.95, method = c("historical", "gaussian", "modified"))  {
  method <- match.arg(method)
  structure( list(
    var  = as.numeric(PerformanceAnalytics::VaR(ret, p = p, method = method)) * 100,
    cvar = as.numeric(PerformanceAnalytics::CVaR(ret, p = p, method = method)) * 100
  ),
  class = "portfolio_metrics")
}


#' Simulate multi-day returns via block bootstrap
#'
#' Resamples `n_sim` random starting points and sums `block` consecutive
#' daily log returns from each, producing simulated `block`-day returns.
#' Since log returns are additive, this preserves some of the day-to-day
#' correlation structure that a plain (single-day) resample would destroy.
#'
#' @param returns Numeric vector or xts object of daily log returns.
#' @param block Number of consecutive days to sum per simulated draw.
#'   Default 10.
#' @param n_sim Number of simulated draws. Default 10000.
#'
#' @return A numeric vector of length `n_sim`, each a simulated `block`-day
#'   log return.
#' @export
#' @examples
#' daily_ret <- rnorm(100, 0, 0.02)
#' sim  <- bootstrap_ret(daily_ret, 10,1000)
#' risk_metrics(sim, 0.95, "historical")
#'
bootstrap_ret <- function(returns, block = 10, n_sim = 10000)  {
  rvec <- as.numeric(returns)
  n <- length(rvec)
  rsim <- rep(0,n_sim)
  pos <- sample(seq_len(n - block + 1), n_sim, replace = TRUE)
  for (i in seq_len(block)) {
    rsim <- rsim + rvec[pos]
    pos <- pos + 1
  }
  rsim
}
