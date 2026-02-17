# Create Scale Table From a Scala `.scl` File

Creates a scale table from a given `.scl` file

## Usage

``` r
sclfile_scale_table(sclfile_path, tonic_note_number = 60)
```

## Arguments

- sclfile_path:

  The path to a valid Scala `.scl` file

- tonic_note_number:

  MIDI note number of the tonic for the scale -

  - default is middle C = 60

## Value

a `data.table` with seven columns:

- `ratio`: the ratio that defines the note, as a number between 1 and
  `period`

- `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
  for this type of scale are usually irrational, so this is an
  approximation, computed by
  [`fractional::fractional`](https://rdrr.io/pkg/fractional/man/fractional.html).

- `ratio_cents`: the ratio in cents (hundredths of a semitone)

- `frequency`: frequency of the note given the `tonic_note_number`
  parameter

- `bent_midi`: the MIDI note number as an integer plus a fraction. For
  example, middle C is MIDI note number 60 and middle C sharp is 61. The
  quarter-tone half-way between C and C sharp would have a `bent_midi`
  value of 60.5. The name `bent_midi` comes from the fact that a MIDI
  sequencer can convert the value to a regular integer MIDI note number
  message and a pitch bend message.

- `interval_cents`: interval between this note and the previous note

- `degree`: scale degree from zero to (number of notes) - 1

## Examples

``` r

# a file with ratios specified in cents
cents <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_alpha.scl",
  package = "consonaR"
))
if (cents$status == "Oll Korrect") {
  print(cents$scale_table)
} else {
  print(cents$status)
}
#> Key: <ratio>
#>        ratio  ratio_frac ratio_cents frequency bent_midi interval_cents degree
#>        <num>  <charFrac>       <num>     <num>     <num>          <num>  <num>
#>  1: 1.000000           1           0  261.6256     60.00             NA      0
#>  2: 1.046085   2338/2235          78  273.6826     60.78             78      1
#>  3: 1.094294     441/403         156  286.2952     61.56             78      2
#>  4: 1.144724    1139/995         234  299.4891     62.34             78      3
#>  5: 1.197479     285/238         312  313.2910     63.12             78      4
#>  6: 1.252664     823/657         390  327.7290     63.90             78      5
#>  7: 1.310393     933/712         468  342.8324     64.68             78      6
#>  8: 1.370783   4063/2964         546  358.6318     65.46             78      7
#>  9: 1.433955   3843/2680         624  375.1594     66.24             78      8
#> 10: 1.500039 19235/12823         702  392.4485     67.02             78      9
#> 11: 1.569168   3471/2212         780  410.5345     67.80             78     10
#> 12: 1.641483    1195/728         858  429.4540     68.58             78     11
#> 13: 1.717131     431/251         936  449.2453     69.36             78     12
#> 14: 1.796265    1058/589        1014  469.9488     70.14             78     13
#> 15: 1.879045    1103/587        1092  491.6063     70.92             78     14
#> 16: 1.965641    1087/553        1170  514.2620     71.70             78     15
#> 17: 2.056228   2889/1405        1248  537.9617     72.48             78     16
#> 18: 2.150989   3590/1669        1326  562.7537     73.26             78     17
#> 19: 2.250117   4804/2135        1404  588.6881     74.04             78      0

# a file with ratios specified as vulgar fractions
ratios <- sclfile_scale_table(system.file(
  "test_scl_files/carlos_harm.scl",
  package = "consonaR"
))
if (ratios$status == "Oll Korrect") {
  print(ratios$scale_table)
} else {
  print(ratios$status)
}
#> Key: <ratio>
#>      ratio ratio_frac ratio_cents frequency bent_midi interval_cents degree
#>      <num> <charFrac>       <num>     <num>     <num>          <num>  <num>
#>  1: 1.0000          1      0.0000  261.6256  60.00000             NA      0
#>  2: 1.0625      17/16    104.9554  277.9772  61.04955      104.95541      1
#>  3: 1.1250        9/8    203.9100  294.3288  62.03910       98.95459      2
#>  4: 1.1875      19/16    297.5130  310.6804  62.97513       93.60301      3
#>  5: 1.2500        5/4    386.3137  327.0320  63.86314       88.80070      4
#>  6: 1.3125      21/16    470.7809  343.3836  64.70781       84.46719      5
#>  7: 1.3750       11/8    551.3179  359.7352  65.51318       80.53704      6
#>  8: 1.5000        3/2    701.9550  392.4383  67.01955      150.63706      7
#>  9: 1.6250       13/8    840.5277  425.1415  68.40528      138.57266      8
#> 10: 1.6875      27/16    905.8650  441.4931  69.05865       65.33734      9
#> 11: 1.7500        7/4    968.8259  457.8447  69.68826       62.96090     10
#> 12: 1.8750       15/8   1088.2687  490.5479  70.88269      119.44281     11
#> 13: 2.0000          2   1200.0000  523.2511  72.00000      111.73129      0

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
