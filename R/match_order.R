#' Match and sort columns with regex capture groups
#'
#' @param match A regular expression. Passed to `tidyselect::matches()`.
#' @param ordering An integer vector of regex capture group IDs to order
#'   the columns by. Negative indices sort the group in reverse order.
#'   If not specified, defaults to the mutually exclusive argument `order_by`.
#' @inheritDotParams tidyselect::matches
#' @param order_by One of `"fastest"` or `"slowest"`. Determines the speed
#'   of cycling through column groups. Mutually exclusive with `ordering`.
#'   Defaults to `"fastest"`.
#'
#' @export
#' @seealso [tidyselect::matches()]
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- data.frame(
#'   x_1 = 1,
#'   x_2 = 2,
#'   y_2 = 3,
#'   y_1 = 4,
#'   y_3 = 5,
#'   x_3 = 6
#' )
#'
#' # Comparison: `matches()`
#' df %>%
#'   select(matches("(x|y)_(\\d)"))
#'
#' # Order with priority on keeping the letters (1st group) close together
#' df %>%
#'   select(match_order("(x|y)_(\\d)", c(1, 2)))
#' # Same as above, but sort letters in reverse order
#' df %>%
#'   select(match_order("(x|y)_(\\d)", c(-1, 2)))
#'
#' # Order with priority on keeping the numbers (2nd group) close together
#' df %>%
#'   select(match_order("(x|y)_(\\d)", c(2, 1)))
#' # Same as above, the 2nd group is "slowest" because it has more categories
#' df %>%
#'   select(match_order("(x|y)_(\\d)", order_by = "slowest"))
match_order <- function(match, ordering, ...,
                        order_by = c("fastest", "slowest")) {

  check_select_context()
  rlang::check_dots_empty()

  locs <- tidyselect::matches(match)
  if (rlang::is_empty(locs)) {
    return(integer(0))
  }
  cols <- tidyselect::peek_vars()[locs]

  groups <- simplify2array(regmatches(cols, regexec(match, cols)))[-1,]
  if (rlang::is_missing(ordering)) {
    varies <- apply(groups, 1, \(x) length(unique(x)))
    order_by <- rlang::arg_match(order_by)
    if (order_by == "fastest") varies <- -varies
    ordering <- order(varies)
  } else {
    rlang::check_exclusive(ordering, order_by)
  }

  groups_sign <- sign(ordering)
  ordering <- abs(ordering)

  groups_list <- asplit(groups[ordering, ], 1)
  groups_sorted <- lapply(seq_along(groups_list), \(i) {
    rank(groups_list[[i]]) * groups_sign[i]
  })
  sorted <- do.call("order", groups_sorted)

  locs[sorted]
}
