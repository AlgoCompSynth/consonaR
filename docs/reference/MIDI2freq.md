# MIDI note number to frequency

Converts a vector of MIDI note numbers to a vector of the corresponding
frequencies. Note that these MIDI note numbers are ***floating
point***values - for example, MIDI note number 60.5 is the quarter-tone
between middle C (60) and middle C# (61).

## Usage

``` r
MIDI2freq(MIDI)
```

## Arguments

- MIDI:

  a numeric vector of MIDI note numbers

## Value

a numeric vector of the corresponding frequencies

## Examples

``` r

  # quarter-tone scale
  MIDI <- seq(60, 72, by = 0.5)
  print(MIDI2freq(MIDI))
#>  [1] 261.6256 269.2918 277.1826 285.3047 293.6648 302.2698 311.1270 320.2437
#>  [9] 329.6276 339.2864 349.2282 359.4614 369.9944 380.8361 391.9954 403.4818
#> [17] 415.3047 427.4741 440.0000 452.8930 466.1638 479.8234 493.8833 508.3552
#> [25] 523.2511
```
