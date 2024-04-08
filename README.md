
<!-- README.md is generated from README.Rmd. Please edit that file -->

# selectmore

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{selectmore}` provides extensions built on top of `{tidyselect}` for
more flexible and powerful column subsetting patterns.

## Installation

You can install the development version of selectmore from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("yjunechoe/selectmore")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(selectmore)
library(dplyr, warn.conflicts = FALSE)
df <- data.frame(
  x_1 = 1,
  x_2 = 2,
  y_2 = 3,
  y_1 = 4,
  y_3 = 5,
  x_3 = 6,
  dontselect = 0
)
```

Baseline comparison with `matches()`:

``` r
df %>%
  select(matches("(x|y)_(\\d)"))
#>   x_1 x_2 y_2 y_1 y_3 x_3
#> 1   1   2   3   4   5   6
```

Match *and* order with `match_order()`:

``` r
# Order with priority on keeping the letters (1st group) close together
df %>%
  select(match_order("(x|y)_(\\d)", c(1, 2)))
#>   x_1 x_2 x_3 y_1 y_2 y_3
#> 1   1   2   6   4   3   5
# Same as above, but sort letters in reverse order
df %>%
  select(match_order("(x|y)_(\\d)", c(-1, 2)))
#>   y_1 y_2 y_3 x_1 x_2 x_3
#> 1   4   3   5   1   2   6
# Order with priority on keeping the numbers (2nd group) close together
df %>%
  select(match_order("(x|y)_(\\d)", c(2, 1)))
#>   x_1 y_1 x_2 y_2 x_3 y_3
#> 1   1   4   2   3   6   5
# Same as above, the 2nd group is "slowest" because it has more categories
df %>%
  select(match_order("(x|y)_(\\d)", order_by = "slowest"))
#>   x_1 x_2 x_3 y_1 y_2 y_3
#> 1   1   2   6   4   3   5
```
