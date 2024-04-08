#' Match and sort columns by name
#'
#' Sorts a regex-matched set of columns using `stringr::str_sort()`
#'
#' @param match A regular expression. Passed to `tidyselect::matches()`.
#' @inheritDotParams stringr::str_sort
#'
#' @export
#' @seealso [stringr::str_sort()], [tidyselect::matches()]
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(c = 1, ch = 3, h = 2, dont_pick = 0)
#'
#' df %>%
#'   select(match_str_sort("^[a-z]+$"))
#'
#' # "ch" sorts after "h" in Czech locale
#' df %>%
#'   select(match_str_sort("^[a-z]+$", locale = "cs"))
match_str_sort <- function(match, ...) {
  rlang::check_installed("stringr")
  check_select_context()
  locs <- tidyselect::matches(match)
  if (rlang::is_empty(locs)) {
    return(integer(0))
  }
  cols <- tidyselect::peek_vars()[locs]
  locs[stringr::str_order(cols, ...)]
}
