#' Vectorized last_col
#'
#' @param offsets An integer vector of columns to select from the end.
#'   If a single number is provided, selects `(offsets - 1):0`.
#'
#' @export
#' @seealso [tidyselect::last_col()]
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' df <- as.data.frame(as.list(1:10))
#'
#' # Selects last 5 columns
#' df %>% select(last_cols(5))
#' # Same as above
#' df %>% select(last_cols(4:0))
#'
#' # Using tidyselect::last_col()
#' df %>% select(last_col(4):last_col())
last_cols <- function(offsets) {
  if (length(offsets) == 1) {
    offsets <- (offsets - 1):0
  }
  tidyselect::last_col(0) - offsets
}
