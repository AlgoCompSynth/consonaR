# Create Product Set Scale Table

Creates a scale table from a product set definition

## Usage

``` r
prodset_scale_table(prodset_def, period = 2, tonic_note_number = 60)
```

## Arguments

- prodset_def:

  the product set scale definition. This is a list of numeric vectors.
  Each vector is a multiset of any number of integers. For example, the
  `prodset_def` of the 1-3-5-7 Hexany is

  `list(c(1, 3), c(1, 5), c(1, 7), c(3, 5), c(3, 7), c(5, 7))`

- period:

  the period of the scale - default is 2.

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
(hexany <- prodset_scale_table(list(
  c(1, 3),
  c(1, 5),
  c(1, 7),
  c(3, 5),
  c(3, 7),
  c(5, 7)
)))
#> Key: <ratio>
#>       ratio ratio_frac ratio_cents frequency bent_midi interval_cents degree
#>       <num> <charFrac>       <num>     <num>     <num>          <num>  <num>
#> 1: 1.000000          1      0.0000  261.6256  60.00000             NA      0
#> 2: 1.166667        7/6    266.8709  305.2298  62.66871      266.87091      1
#> 3: 1.250000        5/4    386.3137  327.0320  63.86314      119.44281      2
#> 4: 1.458333      35/24    653.1846  381.5373  66.53185      266.87091      3
#> 5: 1.666667        5/3    884.3587  436.0426  68.84359      231.17409      4
#> 6: 1.750000        7/4    968.8259  457.8447  69.68826       84.46719      5
#> 7: 2.000000          2   1200.0000  523.2511  72.00000      231.17409      0
```
