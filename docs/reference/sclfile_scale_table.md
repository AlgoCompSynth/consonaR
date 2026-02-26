# Create Scale Table From a Scala `.scl` File

Creates a scale table from a given `.scl` file

## Usage

``` r
sclfile_scale_table(sclfile_path, root_freq = 440/(2^(9/12)))
```

## Arguments

- sclfile_path:

  The path to a valid Scala `.scl` file

- root_freq:

  root frequency of the scale - default is middle C: 440 / (2 ^ (9 /
  12))

## Value

a list with two or three items:

- `status` (character): "Oll Korrect" if the results are valid,
  otherwise an error message

- `file_contents` (character vector): the contents read from the file

- `scale_table` (data.table): if everything worked, the scale table

## Examples

``` r
# a file with ratios specified in cents
alpha <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_alpha.scl",
  package = "consonaR"
))
if (alpha$status == "Oll Korrect") {
  print(alpha$scale_table)
} else {
  print(alpha$status)
}
#> Key: <ratio_cents>
#>     degree ratio_cents  ratio_frac frequency interval_cents interval_frac
#>      <num>       <num>  <charFrac>     <num>          <num>    <charFrac>
#>  1:      0           0           1  261.6256             NA           1/0
#>  2:      1          78   2338/2235  273.6826             78     2338/2235
#>  3:      2         156     441/403  286.2952             78     2338/2235
#>  4:      3         234    1139/995  299.4891             78     2338/2235
#>  5:      4         312     285/238  313.2910             78     2338/2235
#>  6:      5         390     823/657  327.7290             78     2338/2235
#>  7:      6         468     933/712  342.8324             78     2338/2235
#>  8:      7         546   4063/2964  358.6318             78     2338/2235
#>  9:      8         624   3843/2680  375.1594             78     2338/2235
#> 10:      9         702 19235/12823  392.4485             78     2338/2235
#> 11:     10         780   3471/2212  410.5345             78     2338/2235
#> 12:     11         858    1195/728  429.4540             78     2338/2235
#> 13:     12         936     431/251  449.2453             78     2338/2235
#> 14:     13        1014    1058/589  469.9488             78     2338/2235
#> 15:     14        1092    1103/587  491.6063             78     2338/2235
#> 16:     15        1170    1087/553  514.2620             78     2338/2235
#> 17:     16        1248   2889/1405  537.9617             78     2338/2235
#> 18:     17        1326   3590/1669  562.7537             78     2338/2235
#> 19:      0        1404   4804/2135  588.6881             78     2338/2235

# a file with ratios specified as vulgar fractions
harm <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_harm.scl",
  package = "consonaR"
))
if (harm$status == "Oll Korrect") {
  print(harm$scale_table)
} else {
  print(harm$status)
}
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

# another file with ratios specified as vulgar fractions
super <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_super.scl",
  package = "consonaR"
))
if (super$status == "Oll Korrect") {
  print(super$scale_table)
} else {
  print(super$status)
}
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

# a file that doesn't exist
nosuch <- sclfile_scale_table(system.file(
  "carlo_scl_iles/carlos_harm.scl",
  package = "consonaR"
))
if (nosuch$status == "Oll Korrect") {
  print(nosuch$scale_table)
} else {
  print(nosuch$status)
}
#> [1] "cannot open file '' for reading text"
```
