#' Unbreak values using regex to match the broken half of the value
#'
#' @param df A data frame with one or more values within a variable broken up
#'   across two rows.
#' @param regex Regular expression for matching the second half of the broken
#'   values.
#' @param ogcol Variable to unbreak.
#' @param newcol Name of the new variable with the unified values.
#' @param sep Character string to separate the unified values (default is space).
#' @param .slice_groups When `.slice_groups = FALSE`  (the default), the extra
#'   rows and the variable with broken values will not be dropped.
#' @return A tibble with unbroken values. The variable that originally
#' contained the broken values gets dropped, and the new variable with the
#' unified values is placed as the first column.
#'
#' @details This function is limited to quite specific cases, but useful when
#'   dealing with tables that contain scientific names broken across two rows.
#'   For background and examples, see
#'   \url{https://luisdva.github.io/rstats/Tidyeval-pdf-hell/}; for unwrapping
#'   values, see \code{\link{unwrap_cols}}.
#'
#' @examples
#' data(primates2017_broken)
#' # regex matches strings starting in lowercase (broken species epithets)
#' unbreak_vals(primates2017_broken, "^[a-z]", scientific_name, sciname_new)
#' @importFrom rlang :=
#' @export
unbreak_vals <- function(df, regex, ogcol, newcol, sep = " ", .slice_groups = FALSE) {
  ogcol <- dplyr::enquo(ogcol)
  newcol <- dplyr::enquo(newcol)

  dfind <- dplyr::mutate(
    df,
    !!newcol := ifelse(stringr::str_detect(!!ogcol, stringr::regex(regex)),
      yes = paste(dplyr::lag(!!ogcol), !!ogcol, sep = sep),
      no = !!ogcol
    )
  )

  if (.slice_groups == FALSE) {
    dffilled_groups <- tidyr::fill(dfind, !!newcol)
    return(dffilled_groups)
  } else {
    dffilled <- tidyr::fill(dfind, dplyr::everything())
    dfsliced <- dplyr::slice(dffilled, -(which(stringr::str_detect(!!ogcol, stringr::regex(regex))) - 1))
    dfout <- dplyr::select(dfsliced, -!!ogcol)
    dplyr::select(dfout, !!newcol, dplyr::everything())
  }
}
