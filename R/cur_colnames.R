#' Get a vector of current column names
#'
#' A wrapper to `tidyselect::peek_vars()`, which is not re-exported in `dplyr`.
#'
#' @export
#' @seealso [tidyselect::peek_vars()]
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- as.data.frame(as.list(1:10))
#'
#' identical(
#'   df,
#'   df %>% select(cur_colnames())
#' )
#'
#' df %>%
#'   select(rev(cur_colnames()))
#'
#' df %>%
#'   select(stringr::str_subset(cur_colnames(), "[1-5]L$"))
cur_colnames <- function() {
  tidyselect::peek_vars(fn = "cur_colnames")
}
