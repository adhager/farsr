context("Test farsr package")

library(dplyr)
library(maps)

setwd(system.file("extdata", package = "farsr"))

test_that("test fars_read()", {
     expect_is(fars_read("accident_2015.csv.bz2"), "tbl_df")
     expect_equal(as.numeric(fars_read("accident_2015.csv.bz2")[3,2]),10003)
})

test_that("test fars_summarize_years()", {
     expect_is(fars_summarize_years(2013:2015), "tbl_df")
     expect_equal(as.numeric(fars_summarize_years(2013:2015)[3,2]), 2356)
})
