#' Read FARS file
#'
#' A FARS file contains data from the US National Highway Traffic Safety
#' Administration's Fatality Analysis Reporting System, which is a nationwide
#' census providing the American public yearly data regarding fatal injuries
#' suffered in motor vehicle traffic crashes.
#'
#' Requires dpyr, tidyr, readr, maps, graphics
#'
#' @param filename Name of the file to read
#'
#' @return This function returns a data frame containing the data read from the file
#' if the requested file does not exist, an error will be reported and the function
#' will stop
#'
#' @examples
#' \dontrun{
#' fars_read("data/accident_2015.csv.bz2")
#' }
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Create a FARS filename for a particular year
#'
#' @param year The year for which to generate the filename
#'
#' @return This function returns the formatted file name.
#' If year is not numeric, a warning is generated: "NAs introduced by coercion"
#'
#' @examples
#' \dontrun{
#' make_filename("2015")
#' }
#'
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Reads months and years from multiple FARS files (for multiple years)
#'
#' Notes:
#' The FARS file(s) must be located in the current working directory.
#'
#' @param years A vector or list of years for which to read FARS files
#'
#' @return This function returns a list of months and years of accidents from the specified datafile(s)
#' If any error occurs, a warning is generated: "invalid year: XXXX"
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013:2015)
#' fars_read_years(list(2013, 2015))
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
          file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate_(dat, year = ~year) %>%
                                dplyr::select_("MONTH", "year")
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Reads months and years from FARS files and summarizes how many accidents occurred per month/year
#'
#' Notes:
#' The FARS file(s) must be located in the current working directory.
#'
#' @param years A vector or list of years for which to read FARS files
#'
#' @return This function returns a tibble containing the number of accidents per month. Each column represents a year and each row a month.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013:2015)
#' }
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by_("year", "MONTH") %>%
                dplyr::summarize_(n = ~n()) %>%
                tidyr::spread_("year", "n")
}

#' Plots location of accidents on a map.
#'
#' @param state.num The state to load data for
#' @param year The year to load data for
#'
#' @return NULL. Draws a plot. On error (invalid state, no accidents), displays a message.
#'
#' @examples
#' \dontrun{
#' fars_map_state(9, 2013)
#' }
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#' @importFrom tidyr spread
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter_(data, ~STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
