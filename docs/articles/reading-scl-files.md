# Reading Scala .scl Files

``` r

library(setharophone)
```

``` r

# parse_scale <- function(v) {
#   fractional::fractional(vapply(
#     c(" 1/1", v),
#     FUN = function(x) eval(parse(text = x)),
#     FUN.VALUE = 1
#   ))
# }
# lcmd <- function(v) {
#   fractional::numerical(numbers::mLCM(fractional::denominators(v)) * v)
# }
# 
# carlos_harm <-
#   readLines("d:/znmeb/Downloads/Scala scales/scl/carlos_harm.scl") |>
#   grep(pattern = "/", value = TRUE) |>
#   parse_scale()
# (carlos_harm)
# (lcmd(carlos_harm))
# 
# carlos_super <-
#   readLines("d:/znmeb/Downloads/Scala scales/scl/carlos_super.scl") |>
#   grep(pattern = "/", value = TRUE) |>
#   parse_scale()
# (carlos_super)
# (lcmd(carlos_super))
# 
# bohlen_pierce <-
#   readLines("d:/znmeb/Downloads/Scala scales/scl/bohlen-p.scl") |>
#   grep(pattern = "/", value = TRUE) |>
#   parse_scale()
# (bohlen_pierce)
# (lcmd(bohlen_pierce))
```
