# Agents.md - Development Guidelines for consonaR

## Build/Lint/Test Commands

### Build Commands
```bash
# Install package in development mode
devtools::load_all()

# Install dependencies
devtools::install_deps()

# Build the package
R CMD build .

# Install the package
R CMD INSTALL .
```

### Documentation Commands
```bash
# Generate roxygen2 documentation (updates man/*.Rd files)
devtools::document()

# Check documentation completeness
devtools::document(); devtools::load_all()

# Build vignettes
devtools::build_vignettes()
```

### Testing Commands
```bash
# Run all tests (uses testthat framework)
devtools::test()

# Run tests for a specific R file (e.g., scales.R)
testthat::test_file("tests/testthat/test-scales.R")

# Run tests with output coverage
devtools::test(include_coverage = TRUE)

# Run tests without stopping on first error
devtools::test(stopper = function(...) { TRUE })
```

### Linting & Code Checking
```bash
# Run full package check (runs R CMD check)
devtools::check()

# Run checks without building PDF manual
devtools::check(man = FALSE, vignettes = FALSE)

# Run linting only
lintr::lint_package()

# Run lint on specific file
lintr::lint("R/scales.R")

# Run cran-check against current CRAN standards
devtools::check_cran()
```

### Release Preparation
```bash
# Create a new tag for release
git tag -a vX.Y.Z -m "Release version X.Y.Z"

# View package news/changelog
cat NEWS.md
```

## Code Style Guidelines

### Imports
- Use `@importFrom` annotations for package functions in roxygen2 comments
- Explicitly name package functions using `package::function()` syntax in code (e.g., `data.table::data.table()`)
- Prefer selective imports over `import(* )` for clarity
- Add new imports to DESCRIPTION, using alphabetical ordering
- Functions from base R don't need imports

### Formatting
- Use 2-space indentation throughout R files
- Maximum line width: 80 characters preferred, 120 maximum
- Single spaces after commas, around operators
- No trailing whitespace in files
- Use empty lines between logical blocks within functions
- Function parameters on separate lines when there are 3+ parameters
- Align continuation lines with first line of parameter list

### Naming Conventions
- **Functions**: snake_case with descriptive names (e.g., `freq2MIDI`, `cents2ratio`, `ratio2factors`)
- **Variables**: snake_case with descriptive names (e.g., `scale_table`, `root_freq`)
- **Constants**: UPPER_CASE (e.g., `X_STAR <- 0.24`)
- **Parameters**: snake_case, always include type information in roxygen
- **Package structure**: R function files should match exported function names

### Types & Data Structures
- Explicitly document expected vector types in roxygen (e.g., "a numeric vector")
- Use `vapply()` with `FUN.VALUE` for type-safe vector operations
- Use `data.table` for structured data manipulation
- Document return types explicitly in roxygen `@returns`
- Use `as.numeric()` for explicit type conversion

### Error Handling
- For file operations, use `try()` wrapped in `tryCatch()` with informative error messages
- Return named lists with `status` field for functions that may fail (e.g., `sclfile_scale_table`)
- Validate input parameters and fail early with clear messages
- Use `options(warn = 2)` temporarily to promote warnings to errors when needed
- Document expected error conditions in roxygen `@details` or `@description`

### Roxygen2 Documentation
- All exported functions must have complete roxygen2 documentation
- Required tags: `@title`, `@name`, `@description`, `@export`, `@param`, `@returns`
- Include `@examples` tag with runnable code demonstrating usage
- Include `@importFrom` tags for all non-base R functions used
- Use `\itemize{}` for lists in documentation
- Use `\insertCite` for citations, `\insertAllCited` for references section
- Use `@details` for algorithm sources and implementation notes

### Testing Structure
- Tests live in `tests/testthat/` directory
- Test files: `test-<source_file>.R` (e.g., `test-scales.R`)
- Test naming: `test_that("<description>", { ... })`
- Use `expect_equal()`, `expect_true()`, `expect_error()`, `expect_warning()`
- Test edge cases: empty inputs, single values, error conditions
- Test with both integer and floating point inputs where relevant

### Package Structure
- R source code: `R/*.R` files
- Compiled man pages: `man/*.Rd` (generated from roxygen2)
- Vignettes: `vignettes/*.Rmd`
- Test data: `inst/test_scl_files/`
- Namespace exports: `NAMESPACE` (generated from roxygen2)
- Package metadata: `DESCRIPTION`

### General Best Practices
- Always use `return()` statement explicitly in functions
- Comment non-obvious algorithms with source attribution
- Keep helper functions internal; don't export unless necessary
- Use existing helper functions from the same file before duplicating
- Add new test files to `.gitignore` except `.R` files
- Run `devtools::document()` after adding/modifying exports

### File Organization
- Multiple functions in a single `.R` file when logically related
- Related conversion functions grouped together
- Scale table generators grouped together
- Utility/helper functions at end of file or in separate file

### Git Workflow
- Commit R source files only; generated documentation in separate commits
- Update roxygen2 after R changes, then commit man/.Rd files in subsequent commit
- Use descriptive commit messages with function names affected
- Run `devtools::check()` before submitting PRs

### Common Commands Reference
```bash
# Start R session with package loaded
R -e "devtools::load_all()"

# Interactive development cycle
R -e "devtools::load_all(); devtools::document()"

# Check package before release
R CMD check --no-manual .

# Build documentation preview
R -e "devtools::build_readme()"
```
