# Repository Guidelines

Welcome to **consonaR**, an R package implementing consonance-based algorithms for algorithmic composition of music, based on William Sethares' _Tuning, Timbre, Spectrum, Scale_.

## Project Structure & Module Organization

```
consonaR/
├── R/                    # Source code (R functions)
│   └── scales.R          # Consonance/scale functions
├── man/                  # Generated function documentation (.Rd files)
├── vignettes/            # Package vignettes (Rmd format)
├── inst/                 # Installed files (e.g., REFERENCES.bib)
├── docs/                 # Built pkgdown website
├── DESCRIPTION           # Package metadata
├── NAMESPACE             # Exported functions
└── README.md             # Package documentation
```

- All source code resides in `R/`. Documentation is generated via **roxygen2**.
- Vignettes are written in RMarkdown (`.Rmd`) and stored in `vignettes/`.
- The `docs/` directory contains the built pkgdown site (do not edit manually).

## Build, Test, and Development Commands

| Command | Description |
|---------|-------------|
| `R CMD build .` | Build the package tarball |
| `R CMD check consonaR_*.tar.gz` | Run full package checks |
| `devtools::load_all()` | Load package for interactive development |
| `devtools::document()` | Regenerate documentation from roxygen2 comments |
| `pkgdown::build_site()` | Build the pkgdown website |
| `Rscript -e "devtools::test()"` | Run package tests (if testthat suite exists) |

## Coding Style & Naming Conventions

- **Indentation**: Use 2 spaces (R standard).
- **Function names**: snake_case (e.g., `freq2MIDI`, `cents2ratio`).
- **Documentation**: All exported functions must include roxygen2 comments with `@title`, `@description`, `@param`, `@returns`, and `@examples`.
- **Formatting**: Follow [Tidyverse Style Guide](https://style.tidyverse.org/).
- **Linting**: Use `lintr` for static analysis (configure via `.lintr`).

```r
#' @title Frequency to MIDI note number
#' @name freq2MIDI
#' @description Converts frequencies to MIDI note numbers.
#' @param freq a numeric vector of frequency values
#' @returns a numeric vector of MIDI note numbers
#' @export
freq2MIDI <- function(freq) {
  return(69 + log2(freq / 440) * 12)
}
```

## Testing Guidelines

- **Framework**: `testthat` (if tests are present).
- **Location**: Tests belong in `tests/testthat/`.
- **Naming**: Test files should be named `test-*.R`.
- **Coverage**: Aim for high coverage on core conversion functions.

Run tests with:
```bash
Rscript -e "devtools::test()"
```

## Commit & Pull Request Guidelines

### Commit Messages
- Keep messages concise and descriptive.
- Common patterns observed:
  - `cleanup` — general maintenance
  - `rebuild` / `rebuild site` — regenerate docs/site
  - `fix <issue>` — bug fixes
  - `update <component>` — updates to DESCRIPTION, bibliography, etc.
  - `add <feature>` — new functionality

### Pull Requests
- Include a clear description of changes.
- Link to relevant issues or discussions.
- Ensure `devtools::document()` has been run before committing.
- Verify `R CMD check` passes with no errors or warnings.
- For vignette changes, rebuild the site with `pkgdown::build_site()`.

## Agent-Specific Instructions

- Always run `devtools::document()` after modifying R functions.
- Do not edit files in `man/` or `docs/` directly—they are auto-generated.
- Update `inst/REFERENCES.bib` when adding new citations.
- Bump the version in `DESCRIPTION` for meaningful releases.
