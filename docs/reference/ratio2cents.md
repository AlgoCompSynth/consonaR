# Ratio to Cents

Converts a vector of ratios to a vector of the corresponding cents
values

## Usage

``` r
ratio2cents(ratio)
```

## Arguments

- ratio:

  a numeric vector of ratios

## Value

a numeric vector of the corresponding cents values

## Examples

``` r
  i <- seq(0, 12)
  print(ratio2cents(2.0 ^ (i / 12.0)))
#>  [1]    0  100  200  300  400  500  600  700  800  900 1000 1100 1200
```
