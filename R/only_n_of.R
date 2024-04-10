#' Select exact number of columns from a character vector
#'
#' @inheritParams tidyselect::any_of
#' @param n Exact number of column matches to expect
#' @param ... Unused.
#'
#' @return
#' @export
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(ID = 1, id = 1)
#' id_vec <- c("ID", "id")
#'
#' df %>% select(any_of(id_vec))
#'
#' df %>% select(only_n_of(id_vec, 2))
#' try(
#'   df %>% select(only_n_of(id_vec, 1))
#' )
only_n_of <- function(x, n, ..., vars = NULL) {
  rlang::check_dots_empty()
  cols <- tidyselect::any_of(x, vars = vars)
  if (length(cols) != n) {
    rlang::abort("Number of columns matched in `x` does not equal `n`")
  }
  cols
}
