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
(super <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_super.scl",
  package = "consonaR"
))$scale_table$ratio)
#>  [1] 1.000000 1.062500 1.125000 1.200000 1.250000 1.333333 1.375000 1.500000
#>  [9] 1.625000 1.666667 1.750000 1.875000 2.000000
(super_factors <- ratio2factors(super))
#> $`240`
#> [1] 2 2 2 2 3 5
#> 
#> $`255`
#> [1]  3  5 17
#> 
#> $`270`
#> [1] 2 3 3 3 5
#> 
#> $`288`
#> [1] 2 2 2 2 2 3 3
#> 
#> $`300`
#> [1] 2 2 3 5 5
#> 
#> $`320`
#> [1] 2 2 2 2 2 2 5
#> 
#> $`330`
#> [1]  2  3  5 11
#> 
#> $`360`
#> [1] 2 2 2 3 3 5
#> 
#> $`390`
#> [1]  2  3  5 13
#> 
#> $`400`
#> [1] 2 2 2 2 5 5
#> 
#> $`420`
#> [1] 2 2 3 5 7
#> 
#> $`450`
#> [1] 2 3 3 5 5
#> 
#> $`480`
#> [1] 2 2 2 2 2 3 5
#> 

(harm <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_harm.scl",
  package = "consonaR"
))$scale_table$ratio)
#>  [1] 1.0000 1.0625 1.1250 1.1875 1.2500 1.3125 1.3750 1.5000 1.6250 1.6875
#> [11] 1.7500 1.8750 2.0000
(harm_factors <- ratio2factors(harm))
#> $`16`
#> [1] 2 2 2 2
#> 
#> $`17`
#> [1] 17
#> 
#> $`18`
#> [1] 2 3 3
#> 
#> $`19`
#> [1] 19
#> 
#> $`20`
#> [1] 2 2 5
#> 
#> $`21`
#> [1] 3 7
#> 
#> $`22`
#> [1]  2 11
#> 
#> $`24`
#> [1] 2 2 2 3
#> 
#> $`26`
#> [1]  2 13
#> 
#> $`27`
#> [1] 3 3 3
#> 
#> $`28`
#> [1] 2 2 7
#> 
#> $`30`
#> [1] 2 3 5
#> 
#> $`32`
#> [1] 2 2 2 2 2
#> 

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
