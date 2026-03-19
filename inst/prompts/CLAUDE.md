# CLAUDE.md - consonaR Package Guidelines

## Overview

`consonaR` is an R package for consonance-based algorithmic music composition, based on William Sethares' *Tuning, Timbre, Spectrum, Scale*. It provides functions for musical scale calculations, frequency/MIDI conversions, cents/ratio mathematics, and Scala `.scl` file parsing.

## Package Structure

```
R/
  scales.R          # Main source file - all exported functions
man/               # Generated .Rd documentation files
vignettes/         # Rmarkdown vignettes
inst/
  REFERENCES.bib   # Citation database for Rdpack
  test_scl_files/  # Sample Scala scale files for examples
  prompts/         # Agent instructions (this file)
docs/              # pkgdown-generated website output
```

## Key Files

- **R/scales.R**: Contains all package functions (8 exported functions)
- **inst/test_scl_files/**: Directory for test Scala scale files
- **inst/prompts/AGENTS.md**: Detailed development guidelines
- **DESCRIPTION**: Package metadata

## Main Functions

1. **Conversion Functions**:
   - `freq2MIDI()`: Frequency to MIDI note number
   - `MIDI2freq()`: MIDI note number to frequency
   - `cents2ratio()`: Cents to ratio
   - `ratio2cents()`: Ratio to cents
   - `cents2frac()`: Cents to vulgar fraction
   - `ratio2factors()`: Ratio to prime factors

2. **Scale Generation Functions**:
   - `et_scale_table()`: Create equal-tempered scale table
   - `sclfile_scale_table()`: Parse Scala `.scl` files
   - `prodset_scale_table()`: Create product set scale table

3. **Utility Functions**:
   - `period_reduce()`: Reduce ratios to a given period
   - `sine_dissonance()`: Calculate dissonance between two sine waves

## Development Commands

### Package Management

```bash
# Load package in development mode
devtools::load_all()

# Check package
R CMD check
devtools::check()

# Generate documentation
devtools::document()

# Build package
R CMD build .

# Install from source
R CMD INSTALL .
```

### Code Quality

```bash
# Format code
styler::style_pkg()

# Lint code
lintr::lint_package()
```

### Vignettes

```bash
# Build vignettes
Rscript -e "devtools::build_vignettes()"
```

## Coding Standards

### Naming Conventions

- **Functions**: snake_case with descriptive names
  - Conversion: `X2Y` pattern (e.g., `freq2MIDI`, `cents2ratio`)
  - Scale tables: `_scale_table` suffix (e.g., `et_scale_table`)
- **Variables**: snake_case (e.g., `ratio_cents`, `file_contents`)
- **Constants**: UPPERCASE (e.g., `B1`, `X_STAR`)

### Documentation (Roxygen2)

All exported functions require:
- `@title`, `@name`, `@description`
- `@param` for each parameter with type
- `@returns` with type and meaning
- `@examples` with runnable code
- `@export` tag
- Use `\insertCite{}{consonaR}` for citations

### Error Handling

Return named lists with `status` field:
- `"Oll Korrect"` for success
- Error message string for failures

Example:
```r
if (result$status != "Oll Korrect") {
  stop(result$status)
}
```

### Imports

Use `@importFrom` in Roxygen2 comments:
```r
#' @importFrom data.table data.table setkey ":=" shift ".I"
#' @importFrom fractional fractional
#' @importFrom numbers mLCM
```

## Testing

No tests currently exist. When adding tests, use `testthat`:

```bash
devtools::use_testthat()
devtools::test()
```

## Mathematical Conventions

- Use explicit decimal notation: `2.0` not `2`
- Use spaces in math: `2 ^ (cents / 1200)` not `2^(cents/1200)`
- All functions return numeric vectors

## File I/O Best Practices

- Store test files in `inst/test_scl_files/`
- Access via `system.file(...)` never absolute paths
- Close file connections: `close(connection)`
- Handle errors: file not found, insufficient content, invalid format

## Git Workflow

```bash
git add .
git commit -m "<descriptive message>"
git push origin main
```

Commit messages:
- Start with verb (Fix, Add, Update, Remove)
- Present tense
- Capitalize first letter
- Under 50 characters

## References

- Sethares, W. A. 2013. *Tuning, Timbre, Spectrum, Scale, Second Edition*. Springer London.
- Package website: https://algocompsynth.github.io/consonaR/
- GitHub: https://github.com/AlgoCompSynth/consonaR

## For AI Agents

Before making changes, review `inst/prompts/AGENTS.md` for detailed guidelines.

### Key Directories

- `R/scales.R`: Main source file
- `inst/test_scl_files/`: Test data
- `inst/prompts/AGENTS.md`: Full development guide

### Development Workflow

1. Read AGENTS.md guidelines
2. Format with `styler::style_pkg()`
3. Lint with `lintr::lint_package()`
4. Check with `R CMD check`
5. Document with complete Roxygen2 comments

## Dependencies

- R (>= 4.2.0)
- data.table (>= 1.14.8)
- fractional (>= 0.1.3)
- numbers (>= 0.8.5)
- Rdpack (>= 2.4)
