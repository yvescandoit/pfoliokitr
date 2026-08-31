
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pfoliokitr

<!-- badges: start -->
<!-- badges: end -->

pfoliokitr is a small toolkit for fetching stock price data, computing
returns, and evaluating performance and risk for stocks and benchmarks.
Built on top of `quantmod`, `PerformanceAnalytics`, and `xts`.

## Installation

You can install the development version of pfoliokitr like so:

``` r
devtools::install_github("yvescandoit/pfoliokitr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(pfoliokitr)

lly <- tckr_data("LLY", from = "2021-04-01")
spy <- tckr_data("SPY", from = "2021-04-01")


lly_ret <- log_ret(lly)
spy_ret <- log_ret(spy)

metrics(lly_ret,0.05)
#> 
#> =====  =====
#> Annualised return   : +35.09%
#> Annualised Vol      : 32.34%
#> Sharpe Ratio        : -3.093
#> Sortino Ratio       : 10.440
#> Calmar Ratio        : 0.885
#> Max Drawdown        : 39.65%
#> Skewness            : 0.2295
#> Excess Kurtosis     : 7.8914
relative_metrics(lly_ret,spy_ret)
#> 
#> =====  =====
#> Beta vs Benchmark   : 0.568
#> Alpha (annualised)  : +27.65%
```

## What’s included

- **`tckr_data()`** — fetch adjusted close prices for a ticker
- **`log_ret()`** — compute daily log returns
- **`aligned_returns()`** — align two return series on shared dates
- **`metrics()`** — annualised return, volatility, Sharpe, Sortino,
  Calmar, max drawdown, skewness, kurtosis
- **`risk_metrics()`** — VaR / CVaR, switchable between historical,
  Gaussian, and modified (Cornish-Fisher) methods
- **`bootstrap_returns()`** — block bootstrap simulation for multi-day
  risk estimates
- **`relative_metrics()`** — beta and alpha vs. a benchmark
- **`combine_metrics()` / `print()` / `as.data.frame()`** — merge,
  display, and export results

See `vignette("pfoliokitr-walkthrough")` for a full walkthrough.
