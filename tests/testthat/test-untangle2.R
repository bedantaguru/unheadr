context("untangle2")

test_that("target variable is called 'regex'", {
  df <- data.frame(
    regex = c("gpA", "a", "b", "gpB", "c", "c"),
    vals = c(NA, 1, 2, NA, 3, 4), stringsAsFactors = FALSE
  )
  expect_warning(
    untangle2(df, regex = "^gp", orig = regex, new = new_col)
  )
})

test_that("grepl matches produce message", {
  df <- data.frame(
    var_eb = c("gpA", "a", "b", "gpB", "c", "c"),
    vals = c(NA, 1, 2, NA, 3, 4), stringsAsFactors = FALSE
  )
  expect_message(
    untangle2(df, regex = "^gp", orig = var_eb, new = new_col)
  )
  expect_message(
    untangle2(df, regex = "^gpA", orig = var_eb, new = new_col)
  )
  expect_message(
    untangle2(df, regex = "xx", orig = var_eb, new = new_col)
  )
})
