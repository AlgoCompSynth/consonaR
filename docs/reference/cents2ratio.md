# Cents to Ratio

Converts a vector of cents to a vector of the corresponding ratios

## Usage

``` r
cents2ratio(cents)
```

## Arguments

- cents:

  a numeric vector of cents values

## Value

a numeric vector of the corresponding ratios

## Examples

``` r
  print(cents2ratio(seq(0, 1200, by = 100)))
#>  [1] 1.000000 1.059463 1.122462 1.189207 1.259921 1.334840 1.414214 1.498307
#>  [9] 1.587401 1.681793 1.781797 1.887749 2.000000
```
