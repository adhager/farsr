% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Plots location of accidents on a map.}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{The state to load data for}

\item{year}{The year to load data for}
}
\value{
NULL. Draws a plot. On error (invalid state, no accidents), displays a message.
}
\description{
Plots location of accidents on a map.
}
\examples{
\dontrun{
fars_map_state(9, 2013)
}

}

