check_select_context <- function(fn) {
  if (rlang::is_missing(fn)) {
    fn <- rlang::caller_call()[[1]]
  }
  cnd <- rlang::catch_cnd(tidyselect::peek_vars(fn = fn))
  if (!is.null(cnd)) {
    cnd$body <- NULL
    rlang::cnd_signal(cnd)
  }
}
