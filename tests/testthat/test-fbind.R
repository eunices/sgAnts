test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("fbind() binds factor (or character)", {
  x <- c("a", "b")
  x_fact <- factor(x)
  y <- c("c", "d")
  z <- factor(c("a", "b", "c", "d"))

  expect_identical(fbind(x, y), z)
  expect_identical(fbind(x_fact, y), z)
})
