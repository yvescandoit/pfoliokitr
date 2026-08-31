test_that("log_ret coputes correct log returns and drops NA", {

  date <- as.Date("2024-01-01") + 0:2
  prices <- xts::xts(c(100,101,103), order.by = date)

  result <- log_ret(prices)
  expected <- diff(log(prices))[-1]

  expect_equal(as.numeric(result), as.numeric(expected))
  expect_equal(length(result), length(expected))
})


test_that("log_ret only keeps an xts object",  {
  date <- as.Date("2024-01-01") + 0:2
  prices <- xts::xts(c(100,101,103), order.by = date)

  expect_s3_class(log_ret(prices),"xts")
})


test_that("aligned_returns keeps only common dates",{
  x <- xts::xts(1:5, order.by = as.Date("2024-01-01") + 0:4)
  y <- xts::xts(1:3, order.by = as.Date("2024-01-01") + 0:2)

  result <- aligned_returns(x,y)

  expect_equal(length(result$x),3)
  expect_equal(length(result$y),3)
  expect_equal(zoo::index(result$x),zoo::index(result$y))
})


