#' @keywords internal
match_rename <- function(match, fns, ..., convert) {

  check_select_context()
  rlang::check_dots_empty()

  locs <- tidyselect::matches(match)
  if (rlang::is_empty(locs)) {
    return(integer(0))
  }
  cols <- tidyselect::peek_vars()[locs]

  if (!rlang::is_function(fns) && !rlang::is_bare_list(fns)) {
    rlang::abort("`fns` must be a function or a list of functions")
  }

  if (rlang::is_function(fns) || length(fns) == 1) {
    nms <- fns(cols)
    names(cols) <- nms
    return(tidyselect::any_of(cols))
  }

  stop("Not implemented yet...")
  # groups <- simplify2array(regmatches(cols, regexec(match, cols)))[-1,]
  # groups_list <- lapply(asplit(groups, 1), try_convert)
  # groups_converted <- t(mapply(\(f,x) f(x), fns, groups_converted))

}
