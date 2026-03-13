# consonaR Agent Instructions

## Package Overview

consonaR is an R package implementing consonance-based algorithms for
algorithmic composition, based on William Sethares’ *Tuning, Timbre,
Spectrum, Scale*. It provides functions for musical scale calculations
including frequency/MIDI conversion, cents/ratio math, and Scala `.scl`
file parsing.

## Build Commands

``` bash
# Install dependencies and load package in development mode
devtools::load_all()

# Check package (linting, documentation, etc.)
R CMD check

# Run specific checks only:
devtools::check()              # Full check
devtools::document()           # Generate documentation from Roxygen2
devtools::spell_check()        # Spelling
devtools::test()               # Tests (none currently)
packageDependencies::pbd_report()  # Check package dependencies

# Build vignettes
Rscript -e "devtools::build_vignettes()"

# Build complete package
R CMD build .

# Install from source
R CMD INSTALL .
```

## Linting and Style

``` bash
# Run styler for automatic code formatting
styler::style_pkg()

# Use lintr for linting issues (no standard lint command exists yet)
lintr::lint_package()
```

## Tests

No tests currently exist. When adding tests, use the `testthat`
framework:

``` bash
# Create test file structure
devtools::use_testthat()

# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-scales.R")

# Run a single test
testthat::test_local(filter = "test_name")
```

## Code Style Guidelines

### Imports and Dependencies

- Use `@importFrom` in Roxygen2 comments for all external function
  imports

- Group related imports: data.table operations, fractional package,
  numbers package

- Never use `importFrom(utils, globalVariables)` except to declare `.I`,
  `:=`, etc. from data.table

- Example:

  ``` r
  #' @importFrom data.table data.table setkey shift ":=" ".I"
  ```

### Function Documentation (Roxygen2)

All exported functions require complete Roxygen2 documentation with: -
`@title` - Brief function name/description - `@name` - Function name -
`@description` - Detailed description in markdown - `@param` - Each
parameter with type and description - `@returns` - Return value type and
meaning - `@examples` - At least one runnable example (must work without
modification) - `@export` - For all exported functions - Use
`\itemize{}` for lists in documentation - Use
`\insertCite{key}{consonaR}` with Rdpack for citations from
inst/REFERENCES.bib

### Type Safety and Parameter Handling

- Explicitly type all parameters as `numeric`, `character`, or `list`

- Use default parameter values liberally when sensible

- Always return explicit values; avoid implicit returns where possible

- For file I/O, set `warn = 2` to treat warnings as errors during file
  operations

- Check for try-error results from file operations:

  ``` r
  result <- try(file(path, open = "rt"), silent = TRUE)
  if (inherits(result, "try-error")) {
    return(list(status = paste0("error message")))
  }
  ```

### Error Handling

- Return named lists with `status` field for error conditions:
  - `"Oll Korrect"` for success
  - Error messages as character strings otherwise
- Include relevant data in errors (e.g., `file_contents` on parse
  failures)
- Validate input early and return status before proceeding

### Naming Conventions

- Function names: snake_case with descriptive, self-documenting names
  - Conversion functions use `X2Y` pattern: `freq2MIDI`, `cents2ratio`,
    `ratio2factors`
  - Table-generating functions end in `_scale_table`: `et_scale_table`,
    `sclfile_scale_table`, `prodset_scale_table`
- Variable names: snake_case, descriptive (e.g., `degree`,
  `ratio_cents`, `file_contents`)
- Use consistent parameter naming: `root_freq`, `period`, `divisions`,
  `sclfile_path`, `freq1`, `freq2`
- Numeric constants use decimal points for float types: `2.0`,
  `B1 <- -3.5`

### Data Processing with data.table

- Create tables with named columns immediately

- Use backticks for special operators: `` `:=`() ``, `".I"`, `"shift"`

- Set keys after table creation: `data.table::setkey(table, column)`

- Append computed columns using shift operations and `:=`:

  ``` r
  result <- result[, `:=`(new_col = col - data.table::shift(col))]
  ```

### Vectorized Operations

- Use [`vapply()`](https://rdrr.io/r/base/lapply.html) over
  [`lapply()`](https://rdrr.io/r/base/lapply.html) when return type is
  known (numeric vectors)
- Prefer [`sapply()`](https://rdrr.io/r/base/lapply.html),
  [`mapply()`](https://rdrr.io/r/base/mapply.html) for simple
  vectorization
- Use [`lapply()`](https://rdrr.io/r/base/lapply.html) for complex
  list-processing tasks

### Mathematical Conventions

- Always use explicit decimal notation in math: `2 ^ (cents / 1200)` not
  `2^(cents/1200)`
- Define algorithm constants locally with uppercase names: `B1`,
  `X_STAR`, `S1`
- Return numeric values for all mathematical functions

### Code Layout

- Place empty lines between logical sections of a function
- Keep lines under 80 characters when readable
- Use parentheses around return expressions consistently:
  `return(expression)`
- Align continuation lines with meaningful indentation

### File I/O Best Practices

- Store test files in `inst/test_scl_files/`
- Access package files via `system.file(...)` never using absolute paths
- Close file connections after use (`close(connection)`)
- Handle three error types: file not found, insufficient content,
  invalid format

### Example Documentation

``` r
#' @examples
#' 
#' # Standard example
#' print(result <- et_scale_table())
#' 
#' # With conditional output based on status
#' result <- sclfile_scale_table(system.file(
#'   "test_scl_files/example.scl",
#'   package = "consonaR"
#' ))
#' if (result$status == "Oll Korrect") {
#'   print(result$scale_table)
#' } else {
#'   print(result$status)
#' }
```

## Package Structure

    R/
      scales.R          # Main source file - all exported functions
    man/               # Generated .Rd documentation files
    vignettes/         # Rmarkdown vignettes
    docs/              # pkgdown-generated website output
    inst/
      REFERENCES.bib   # Citation database for Rdpack
      test_scl_files/  # Sample Scala scale files for examples

## Vignettes

All vignettes use knitr with markdown: - Set
`knitr::opts_chunk$set(echo = TRUE)` in setup - Include `bibliography`
for citations from inst/REFERENCES.bib - Use parameterized code chunks
consistent with source
