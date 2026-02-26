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
print(super <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_super.scl",
  package = "consonaR"
))$scale_table)
#> Key: <ratio_cents>
#>     degree ratio_cents ratio_frac frequency interval_cents interval_frac
#>      <num>       <num> <charFrac>     <num>          <num>    <charFrac>
#>  1:      0      0.0000          1  261.6256             NA           1/0
#>  2:      1    104.9554      17/16  277.9772      104.95541         17/16
#>  3:      2    203.9100        9/8  294.3288       98.95459         18/17
#>  4:      3    315.6413        6/5  313.9507      111.73129         16/15
#>  5:      4    386.3137        5/4  327.0320       70.67243         25/24
#>  6:      5    498.0450        4/3  348.8341      111.73129         16/15
#>  7:      6    551.3179       11/8  359.7352       53.27294         33/32
#>  8:      7    701.9550        3/2  392.4383      150.63706         12/11
#>  9:      8    840.5277       13/8  425.1415      138.57266         13/12
#> 10:      9    884.3587        5/3  436.0426       43.83105         40/39
#> 11:     10    968.8259        7/4  457.8447       84.46719         21/20
#> 12:     11   1088.2687       15/8  490.5479      119.44281         15/14
#> 13:      0   1200.0000          2  523.2511      111.73129         16/15
print(super_factors <- ratio2factors(cents2ratio(super$ratio_cents)))
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

print(harm <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_harm.scl",
  package = "consonaR"
))$scale_table)
#> Key: <ratio_cents>
#>     degree ratio_cents ratio_frac frequency interval_cents interval_frac
#>      <num>       <num> <charFrac>     <num>          <num>    <charFrac>
#>  1:      0      0.0000          1  261.6256             NA           1/0
#>  2:      1    104.9554      17/16  277.9772      104.95541         17/16
#>  3:      2    203.9100        9/8  294.3288       98.95459         18/17
#>  4:      3    297.5130      19/16  310.6804       93.60301         19/18
#>  5:      4    386.3137        5/4  327.0320       88.80070         20/19
#>  6:      5    470.7809      21/16  343.3836       84.46719         21/20
#>  7:      6    551.3179       11/8  359.7352       80.53704         22/21
#>  8:      7    701.9550        3/2  392.4383      150.63706         12/11
#>  9:      8    840.5277       13/8  425.1415      138.57266         13/12
#> 10:      9    905.8650      27/16  441.4931       65.33734         27/26
#> 11:     10    968.8259        7/4  457.8447       62.96090         28/27
#> 12:     11   1088.2687       15/8  490.5479      119.44281         15/14
#> 13:      0   1200.0000          2  523.2511      111.73129         16/15
print(harm_factors <- ratio2factors(cents2ratio(harm$ratio_cents)))
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
