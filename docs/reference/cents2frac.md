# Cents to Fraction

Converts a vector of cents to a vector of the corresponding ratios,
expressed as a character vector of vulgar fractions

## Usage

``` r
cents2frac(cents)
```

## Arguments

- cents:

  a numeric vector of cents values

## Value

a vector of the corresponding vulgar fractions

## Examples

``` r
  print(cents2frac(seq(0, 1200, by = 100)))
#>  [1] 1         1461/1379 1714/1527 1785/1501 635/504   3249/2434 1393/985 
#>  [8] 2213/1477 1008/635  3002/1785 1527/857  2943/1559 2        
```
