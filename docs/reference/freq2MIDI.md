# Frequency to MIDI note number

Converts a vector of frequencies to a vector of the corresponding MIDI
note numbers. Note that these MIDI note numbers are ***floating point***
values - for example, MIDI note number 60.5 is the quarter-tone between
middle C (60) and middle C# (61).

## Usage

``` r
freq2MIDI(freq)
```

## Arguments

- freq:

  a numeric vector of frequency values

## Value

a numeric vector of the corresponding MIDI note numbers

## Examples

``` r

  # chromatic scale
  freq <- 2 ^ (seq(0, 12) / 12) * 220
  print(freq2MIDI(freq))
#>  [1] 57 58 59 60 61 62 63 64 65 66 67 68 69
```
