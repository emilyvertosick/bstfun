% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gts_add_p_footnotes.R
\name{gts_add_p_footnotes}
\alias{gts_add_p_footnotes}
\title{Moves p-value footnotes to individual p-values}
\usage{
gts_add_p_footnotes(x, printer = c("gt", "flextable"), index_start = 2)
}
\arguments{
\item{x}{object with class \code{"tbl_summary"} created from the gtsummary package}

\item{printer}{String indicating the output format. Must be one of \code{"gt"}, or
\code{"flextable"}}

\item{index_start}{for flextable output, this is the number the footnotes begin
counting from}
}
\description{
This function converts a gtsummary object to the output type indicated in
\verb{printer=}: your object will no longer be of class gtsummary and you can
no longer use gtsummary functions to modify the object.
}
\examples{
library(gtsummary)
trial \%>\%
  select(trt, age, grade) \%>\%
  tbl_summary(by = trt) \%>\%
  add_p() \%>\%
  gts_add_p_footnotes()
}
