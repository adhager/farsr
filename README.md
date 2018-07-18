# FARS: Package for reading FARS data.


This is `R` package was created as part of an assignment for the Coursera course [Building R Packages](https://www.coursera.org/learn/r-packages/home/welcome).

The farsr library contains functions for the reading and displaying of FARS data.

A FARS data file contains data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes.

The library requires dplyr, tidyr, readr, maps, and graphics.


## Functions

`fars_map_state`          Plots location of accidents on a map.

`fars_read`               Read FARS file

`fars_read_years`         Reads months and years from multiple FARS files (for multiple years)

`fars_summarize_years`    Reads months and years from FARS files and summarizes how many accidents occurred per month/year

`make_filename`           Create a FARS filename for a particular year

[![Travis-CI Build Status](https://travis-ci.org/adhager/farsr.svg?branch=master)](https://travis-ci.org/adhager/farsr)
