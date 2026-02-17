# Period Reduce

Reduce a vector of ratios to a given period

## Usage

``` r
period_reduce(scale, period = 2)
```

## Arguments

- scale:

  a numeric vector of ratios representing a scale

- period:

  the period of the scale - default is 2.0, the "octave"

## Value

the scale reduced so that all ratios are between 1 and the period

## Examples

``` r
  test_scale <- cents2ratio(seq(2400, 3500, by = 100))
  print(scale <- period_reduce(test_scale, 2))
#>  [1] 1.000000 1.059463 1.122462 1.189207 1.259921 1.334840 1.414214 1.498307
#>  [9] 1.587401 1.681793 1.781797 1.887749
```
