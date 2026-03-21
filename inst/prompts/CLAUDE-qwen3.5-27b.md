# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`consonaR` is an R package implementing consonance-based algorithms for algorithmic music composition, based on William Sethares' *Tuning, Timbre, Spectrum, Scale*. It's part of the `xen.assist` project for algorithmic xentonal composition.

## Core Functions

The package provides scale generation and audio-related functions in `R/scales.R`:

- **Frequency/MIDI conversion**: `freq2MIDI()`, `MIDI2freq()` - converts between frequencies and floating-point MIDI note numbers (supports microtonal intervals)
- **Cents/ratio conversion**: `cents2ratio()`, `ratio2cents()`, `cents2frac()` - converts between cents, ratios, and vulgar fractions
- **Factor analysis**: `ratio2factors()` - decomposes ratios into prime factors
- **Period reduction**: `period_reduce()` - reduces ratios to a given period (default: octave)
- **Dissonance calculation**: `sine_dissonance()` - calculates dissonance between two sine waves per Sethares' algorithm
- **Scale table generation**:
  - `et_scale_table()` - equal-tempered scales (any divisions, any period)
  - `sclfile_scale_table()` - parses Scala `.scl` files (cents or fractions format)
  - `prodset_scale_table()` - product set scales (e.g., Hexany)

## Development Commands

```bash
# Install package dependencies and load package
R -e "devtools::load_all()"

# Build the package
R CMD build .

# Run tests (if testthat tests exist)
R -e "devtools::test()"

# Document with roxygen2
R -e "devtools::document()"

# Build documentation site with pkgdown
R -e "pkgdown::build_site()"

# Check package
R CMD check consonaR_*.tar.gz
```

## Key Dependencies

- `data.table` - for scale table data structures
- `fractional` - for vulgar fraction representation
- `numbers` - for LCM and prime factor calculations
- `Rdpack` - for citation handling in documentation

## Architecture Notes

All functions return `data.table` objects for scale tables with consistent column naming:
- `degree`, `ratio_cents`, `ratio_frac`, `frequency`, `interval_cents`, `interval_frac`
- `prodset_scale_table()` additionally returns `ratio` and `bent_midi`

Root frequency defaults to middle C: `440 / (2^(9/12))`.

## Test Files

Test Scala `.scl` files are in `inst/test_scl_files/` for use in examples and tests.
