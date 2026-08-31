test_that("risk_metrics returns a portfolio_metrics object with var and cvar", {

  dates <- as.Date("2024-01-01") + 0:299
  ret <- xts::xts(rnorm(300,0,1), order.by = dates)

  results <- risk_metrics(ret, 0.95, method = "historical")

  expect_s3_class(results, "portfolio_metrics")
  expect_named(results, c("var", "cvar"))
})


test_that("risk_metrics accepts all three methods", {
  set.seed(1)
  dates <- as.Date("2024-01-01") + 0:299
  ret <- xts::xts(rnorm(300, 0, 0.02), order.by = dates)

  expect_silent(risk_metrics(ret, method = "historical"))
  expect_silent(risk_metrics(ret, method = "gaussian"))
  expect_silent(suppressWarnings(risk_metrics(ret, method = "modified")))
})


test_that("risk metrics gives CVAR which is at least as extreme as VAR(for historical)", {
  set.seed(1)
  dates <- as.Date("2024-01-01") + 0:299
  ret <- xts::xts(rnorm(300, 0, 0.02), order.by = dates)

  results <- risk_metrics(ret, 0.95, method = "historical")

  expect_true(results$cvar <= results$var)
})


test_that("bootstrap_returns produces n_sim draws",  {
  set.seed(1)
  ret <- rnorm(300, 0, 1)
  results <- bootstrap_ret(ret, 10, 5000)

  expect_length(results, 5000)
  expect_type(results, "double")
})



