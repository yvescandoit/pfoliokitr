test_that("print.portfolio_metrics prints only present fields", {
  m <- structure(list(sharpe_ratio = 0.831, beta = 0.847), class = "portfolio_metrics")

  output <- capture.output(print(m, label = "TEST"))

  expect_true(any(grepl("TEST", output)))
  expect_true(any(grepl("Sharpe Ratio", output)))
  expect_true(any(grepl("Beta vs Benchmark", output)))
  expect_false(any(grepl("Alpha", output)))
  expect_false(any(grepl("VaR", output)))
})


test_that("combine_metrics merges multiple lists and keeps the portfolio_metrics class", {
  a <- structure(list(x = 1), class = "portfolio_metrics")
  b <- structure(list(y = 2), class = "portfolio_metrics")

  combined <- combine_metrics(a,b)

  expect_s3_class(combined, "portfolio_metrics")
  expect_named(combined, c("x", "y"))
  expect_equal(combined$x, 1)
  expect_equal(combined$y, 2)
})

