test_that("tckr_data fetches the adjusted data correctly", {
  skip_if_offline()
  skip_on_cran()

  prices <- suppressWarnings(tckr_data("AAPL", from = "2020-01-01"))

  expect_s3_class(prices, "xts")
  expect_equal(ncol(prices), 1)
  expect_true(grepl("Adjusted", colnames(prices)))
})


test_that("tckr_data errors invalid ticker" , {
  skip_if_offline()
  skip_on_cran()

  expect_error(suppressWarnings(tckr_data("XYCUSUS",from = "2024-01-01")))
})

