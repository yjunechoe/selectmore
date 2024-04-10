#' Match and rename columns using unglue syntax
#'
#' Renames a pattern matched set of columns using `unglue::unglue_sub()`
#'
#' @inheritParams unglue::unglue_sub
#' @param ... Unused.
#' @param convert Whether to convert matches to integer where possible.
#'
#' @export
#' @seealso [unglue::unglue_sub()]
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(
#'   x_1 = 1,
#'   x_2 = 2,
#'   y_1 = 3,
#'   y_2 = 4,
#'   nomatch = 0
#' )
#'
#' # Select and rename
#' df %>%
#'   select(
#'     match_rename("{letter}_{number}", list(toupper, ~ .x * 10))
#'   )
#'
#' # More explicit form
#' df %>%
#'   select(
#'     match_rename(
#'       patterns = "{letter=x|y}_{number=\\d}",
#'       repl = list(letter = toupper, number = ~ .x * 10),
#'       convert = TRUE
#'     )
#'   )
#'
#' # Use inside `rename()` to rename in place, without subsetting columns
#' df %>%
#'   rename(
#'     match_rename("{letter}_{number}", list(toupper, ~ .x * 10))
#'   )
match_rename <- function(patterns, repl = identity, ..., convert = TRUE) {

  check_select_context()
  rlang::check_dots_empty()

  all_cols <- tidyselect::peek_vars()
  locs <- which(unglue::unglue_detect(all_cols, patterns))
  if (rlang::is_empty(locs)) {
    return(integer(0))
  }
  cols <- all_cols[locs]

  if (rlang::is_function(repl)) {
    names(cols) <- repl(cols)
  } else if (rlang::is_bare_list(repl)) {
    if (!rlang::is_named(repl)) {
      names(repl) <- colnames(unglue::unglue_data(cols, patterns))
    }
    if (convert) repl <- lapply(repl, integerly)
    names(cols) <- unglue::unglue_sub(cols, patterns, repl)
  } else {
    rlang::abort("`repl` must be a function or a list of replacements")
  }

  tidyselect::any_of(cols)

}
