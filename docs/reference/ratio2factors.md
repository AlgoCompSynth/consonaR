# Ratio to Factors

Converts a vector of ratios to a vector of the corresponding integer
factors.

## Usage

``` r
ratio2factors(ratio)
```

## Arguments

- ratio:

  a numeric vector of ratios

## Value

a list of vectors, with each vector the integer factors that determined
the corresponding ratio

## Examples

``` r
# we know the factors that yield the 1-3-5-7 Hexany
# can we recover them?
(hexany <- prodset_scale_table(list(
  c(1, 3),
  c(1, 5),
  c(1, 7),
  c(3, 5),
  c(3, 7),
  c(5, 7)
))$ratio)
#> [1] 1.000000 1.166667 1.250000 1.458333 1.666667 1.750000 2.000000
(hexany_factors <- ratio2factors(hexany))
#> $`24`
#> [1] 2 2 2 3
#> 
#> $`28`
#> [1] 2 2 7
#> 
#> $`30`
#> [1] 2 3 5
#> 
#> $`35`
#> [1] 5 7
#> 
#> $`40`
#> [1] 2 2 2 5
#> 
#> $`42`
#> [1] 2 3 7
#> 
#> $`48`
#> [1] 2 2 2 2 3
#> 
```
