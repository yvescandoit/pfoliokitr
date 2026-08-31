test_that("metrics returns a portfolio_metrics object with expected fields", {
  set.seed(1)
  dates <- as.Date("2024-01-01") + 0:251
  ret <- xts::xts(rnorm(252, 0.0005, 0.01), order.by = dates)

  m <- metrics(ret, rf = 0.05 / 252)

  expect_s3_class(m, "portfolio_metrics")
  expect_named(m, c("ann_return", "ann_volatility", "sharpe_ratio", "sortino_ratio",
                    "calmar_ratio", "max_drawdown", "skewness", "kurtosis"))
  expect_type(m$sharpe, "double")
})


test_that("relative_metrics computes a realistic beta on identical series", {
  set.seed(1)
  dates <- as.Date("2024-01-01") + 0:99
  bench <- xts::xts(rnorm(100, 0, 0.01), order.by = dates)
  stock <- bench

  rel <- relative_metrics(stock, bench, rf = 0.05 / 252)

  expect_s3_class(rel, "portfolio_metrics")
  expect_named(rel, c("beta", "alpha"))
  expect_equal(rel$beta, 1, tolerance = 1e-6)
})


test_that("relative_metrics algins the mismatched index of two series", {
  set.seed(1)
  bench <- xts::xts(rnorm(100, 0, 0.01), order.by = as.Date("2024-01-01") + 0:99)
  stock <- xts::xts(rnorm(90, 0, 0.01), order.by = as.Date("2024-01-05") + 0:89)

  expect_silent(rel <- relative_metrics(stock, bench, rf = 0.05))
})
