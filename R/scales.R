#' @title Frequency to MIDI note number
#' @name freq2MIDI
#' @description Converts a vector of frequencies to a vector of the corresponding
#' MIDI note numbers. Note that these MIDI note numbers are ***floating point***
#' values - for example, MIDI note number 60.5 is the quarter-tone between
#' middle C (60) and middle C# (61).
#' @export freq2MIDI
#' @param freq a numeric vector of frequency values
#' @returns a numeric vector of the corresponding MIDI note numbers
#' @examples
#'
#'   # chromatic scale
#'   freq <- 2 ^ (seq(0, 12) / 12) * 220
#'   print(freq2MIDI(freq))
#'

freq2MIDI <- function(freq) {
  return(69 + log2(freq / 440) * 12)
}

#' @title MIDI note number to frequency
#' @name MIDI2freq
#' @description Converts a vector of MIDI note numbers to a vector of the
#' corresponding frequencies. Note that these MIDI note numbers are
#' ***floating point***values - for example, MIDI note number 60.5 is the
#' quarter-tone between middle C (60) and middle C# (61).
#' @export MIDI2freq
#' @param MIDI a numeric vector of MIDI note numbers
#' @returns a numeric vector of the corresponding frequencies
#' @examples
#'
#'   # quarter-tone scale
#'   MIDI <- seq(60, 72, by = 0.5)
#'   print(MIDI2freq(MIDI))
#'

MIDI2freq <- function(MIDI) {
  return(2 ^ ((MIDI - 69) / 12) * 440)
}

#' @title Cents to Ratio
#' @name cents2ratio
#' @description Converts a vector of cents to a vector of the corresponding
#' ratios
#' @export cents2ratio
#' @param cents a numeric vector of cents values
#' @returns a numeric vector of the corresponding ratios
#' @examples
#'   print(cents2ratio(seq(0, 1200, by = 100)))
#'

cents2ratio <- function(cents) {
  return(2 ^ (cents / 1200))
}

#' @title Ratio to Cents
#' @name ratio2cents
#' @description Converts a vector of ratios to a vector of the corresponding
#' cents values
#' @export ratio2cents
#' @param ratio a numeric vector of ratios
#' @returns a numeric vector of the corresponding cents values
#' @examples
#'   i <- seq(0, 12)
#'   print(ratio2cents(2.0 ^ (i / 12.0)))
#'

ratio2cents <- function(ratio) {
  return(log2(ratio) * 1200)
}

#' @title Cents to Fraction
#' @name cents2frac
#' @description Converts a vector of cents to a vector of the corresponding
#' ratios, expressed as a character vector of vulgar fractions
#' @importFrom fractional fractional
#' @export cents2frac
#' @param cents a numeric vector of cents values
#' @returns a vector of the corresponding vulgar fractions
#' @examples
#'   print(cents2frac(seq(0, 1200, by = 100)))
#'

cents2frac <- function(cents) {
  return(as.character(fractional::fractional(2 ^ (cents / 1200))))
}

#' @title Ratio to Factors
#' @name ratio2factors
#' @description Converts a vector of ratios to a vector of the corresponding
#' integer factors.
#' @importFrom numbers mLCM
#' @importFrom fractional denominators
#' @export ratio2factors
#' @param ratio a numeric vector of ratios
#' @returns a list of vectors, with each vector the integer factors that
#' determined the corresponding ratio
#' @examples
#' print(super <- sclfile_scale_table(system.file(
#'   "test_scl_files/carlos_super.scl",
#'   package = "consonaR"
#' ))$scale_table)
#' print(super_factors <- ratio2factors(cents2ratio(super$ratio_cents)))
#'
#' print(harm <- sclfile_scale_table(system.file(
#'   "test_scl_files/carlos_harm.scl",
#'   package = "consonaR"
#' ))$scale_table)
#' print(harm_factors <- ratio2factors(cents2ratio(harm$ratio_cents)))
#'
#' # we know the factors that yield the 1-3-5-7 Hexany
#' # can we recover them?
#' (hexany <- prodset_scale_table(list(
#'   c(1, 3),
#'   c(1, 5),
#'   c(1, 7),
#'   c(3, 5),
#'   c(3, 7),
#'   c(5, 7)
#' ))$ratio)
#' (hexany_factors <- ratio2factors(hexany))
#'

ratio2factors <- function(ratio) {

  # get rid of the denominators
  lcm_denoms <- numbers::mLCM(fractional::denominators(ratio))
  integers <- as.list(lcm_denoms * ratio)
  names(integers) <- as.character(integers)
  prime_factors <- lapply(integers, FUN = numbers::primeFactors)
  return(prime_factors)
}

#' @title Period Reduce
#' @name period_reduce
#' @description Reduce a vector of ratios to a given period
#' @export period_reduce
#' @param scale a numeric vector of ratios representing a scale
#' @param period the period of the scale - default is 2.0, the "octave"
#' @returns the scale reduced so that all ratios are between 1 and the period
#' @examples
#'   test_scale <- cents2ratio(seq(2400, 3500, by = 100))
#'   print(scale <- period_reduce(test_scale, 2))
#'

period_reduce <- function(scale, period = 2.0) {
  w <- as.numeric(scale)

  ix <- (w >= period)
  while (any(ix)) {
    w[ix] <- w[ix] / period
    ix <- (w >= period)
  }

  ix <- (w < 1)
  while (any(ix)) {
    w[ix] <- w[ix] * period
    ix <- (w < 1)
  }

  return(w)
}

#' @title Sine Wave Dissonance
#' @name sine_dissonance
#' @description Calculates the dissonance function for two sine waves
#' @importFrom Rdpack reprompt
#' @export sine_dissonance
#' @param freq1 frequency in Hertz of the first sine wave
#' @param freq2 frequency in Hertz of the second sine wave
#' @param loud1 loudness of the first sine wave
#' @param loud2 loudness of the second sine wave
#' @returns the dissonance value
#' @details This algorithm comes from Appendix E of
#' \insertCite{sethares2013tuning}{consonaR}
#' @references
#' \insertAllCited{}

sine_dissonance <- function(freq1, freq2, loud1, loud2) {
  if (freq1 < freq2) {
    f1 <- freq1
    f2 <- freq2
    l1 <- loud1
    l2 <- loud2
  } else {
    f2 <- freq1
    f1 <- freq2
    l2 <- loud1
    l1 <- loud2
  }
  l12 <- min(l1, l2)

  # constants
  B1 <- -3.5
  B2 <- -5.75
  X_STAR <- 0.24
  S1 <- 0.021
  S2 <- 19

  # scale factor
  s <- (X_STAR * (f2 - f1)) / (S1 * f1 + S2)

  dissonance <- l12 * (exp(B1 * s) - exp(B2 * s))
  return(dissonance)
}

#' @title Create Equal-Tempered Scale Table
#' @name et_scale_table
#' @description Creates a scale table for equal divisions of a specified
#' period.
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table "shift"
#' @importFrom utils globalVariables
#' @export et_scale_table
#' @param period The period - default is 2, for an octave
#' @param divisions Number of degrees in the scale - default is 12
#' @param root_freq root frequency of the scale - default is middle C:
#' 440 / (2 ^ (9 / 12))
#' @returns a `data.table` with six columns:
#' \itemize{
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
#' for this type of scale are usually irrational, so this is an approximation,
#' computed by `fractional::fractional`.
#' \item `frequency`: frequency of the note given the `root_freq`
#' parameter
#' \item `interval_cents`: interval between this note and the previous note
#' in cents
#' \item `interval_frac`: interval between this note and the previous note
#' as a vulgar fraction
#' }
#' @examples
#'
#' print(vanilla <- et_scale_table()) # default is 12EDO, of course
#'
#' # 19-EDO
#' print(edo19 <- et_scale_table(2.0, 19))
#'
#' # 31-EDO
#' print(edo31 <- et_scale_table(2.0, 31))
#'
#' # equal-tempered Bohlen-Pierce
#' print(bohlen_pierce_et <- et_scale_table(3.0, 13))
#'
#' # Carlos Alpha
#' print(carlos_alpha <- et_scale_table(1.5, 9))

et_scale_table <- function(
    period = 2.0,
    divisions = 12,
    root_freq = 440 / (2 ^ (9 / 12))
  ) {
  degree <- seq(0, divisions)
  ratio_cents <- degree * ratio2cents(period) / divisions
  ratio_frac <- cents2frac(ratio_cents)
  frequency <- cents2ratio(ratio_cents) * root_freq
  scale_table <- data.table::data.table(
    degree,
    ratio_cents,
    ratio_frac,
    frequency
  )
  data.table::setkey(scale_table, ratio_cents)
  scale_table <- scale_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents)
  )]
  scale_table <- scale_table[, `:=`(
    interval_frac = cents2frac(interval_cents)
  )]
  scale_table$degree[divisions + 1] <- 0
  return(scale_table)
}

#' @title Create Scale Table From a Scala `.scl` File
#' @name sclfile_scale_table
#' @description Creates a scale table from a given `.scl` file
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table "shift"
#' @importFrom utils globalVariables
#' @export sclfile_scale_table
#' @param sclfile_path The path to a valid Scala `.scl` file
#' @param root_freq root frequency of the scale - default is middle C:
#' 440 / (2 ^ (9 / 12))
#' @returns a list with two or three items:
#' \itemize{
#' \item `status` (character): "Oll Korrect" if the results are valid,
#' otherwise an error message
#' \item `file_contents` (character vector): the contents read from the file
#' \item `scale_table` (data.table): if everything worked, the scale table
#' }
#' @examples
#'
#' # a file with ratios specified in cents
#' alpha <- sclfile_scale_table(system.file(
#'   "test_scl_files/carlos_alpha.scl",
#'   package = "consonaR"
#' ))
#' if (alpha$status == "Oll Korrect") {
#'   print(alpha$scale_table)
#' } else {
#'   print(alpha$status)
#' }
#'
#' # a file with ratios specified as vulgar fractions
#' harm <- sclfile_scale_table(system.file(
#'   "test_scl_files/carlos_harm.scl",
#'   package = "consonaR"
#' ))
#' if (harm$status == "Oll Korrect") {
#'   print(harm$scale_table)
#' } else {
#'   print(harm$status)
#' }
#'
#' # another file with ratios specified as vulgar fractions
#' super <- sclfile_scale_table(system.file(
#'   "test_scl_files/carlos_super.scl",
#'   package = "consonaR"
#' ))
#' if (super$status == "Oll Korrect") {
#'   print(super$scale_table)
#' } else {
#'   print(super$status)
#' }
#'
#' # a file that doesn't exist
#' nosuch <- sclfile_scale_table(system.file(
#'   "carlo_scl_iles/carlos_harm.scl",
#'   package = "consonaR"
#' ))
#' if (nosuch$status == "Oll Korrect") {
#'   print(nosuch$scale_table)
#' } else {
#'   print(nosuch$status)
#' }
#'

sclfile_scale_table <- function(
    sclfile_path,
    root_freq = 440 / (2 ^ (9 / 12))
) {

  # bail if the file can't be opened for reading text
  previous_warn_option <- as.integer(options(warn = 2))
  connection <- try(file(sclfile_path, open = "rt"), silent = TRUE)
  options(warn = previous_warn_option)

  if (inherits(connection, "try-error")) {
    return(list(
      status =
        paste0("cannot open file '", sclfile_path, "' for reading text" )
    ))
  }

  # read the file and close the connection
  file_contents <- readLines(connection)
  close(connection)

  # remove comments
  raw <- grep("^!", file_contents, value = TRUE, invert = TRUE)
  raw <- raw[2:length(raw)] # first line is a comment

  # number of degrees must be at least two so there must be at least three
  # lines remaining
  if (length(raw) < 3) {
    return(list(
      status = paste0("fewer than three lines in file '", sclfile_path, "'"),
      file_contents = file_contents
    ))
  }

  # get scale degrees
  degrees <- as.numeric(raw[1])
  raw <- raw[2:length(raw)]
  degree <- seq(0, degrees)

  # check length
  if (degrees != length(raw)) {
    return(list(
      status = "file length error",
      file_contents = file_contents
    ))
  }

  if (length(grep("/", raw, fixed = TRUE)) == degrees) {

    # fractional ratios - parse
    ratio <- vapply(
        c(" 1/1", raw),
        FUN = function(x) eval(parse(text = x)),
        FUN.VALUE = 1
    )
    ratio_cents <- ratio2cents(ratio)
  } else if (length(grep(".", raw, fixed = TRUE)) == degrees) {

    # cents ratios
    ratio_cents <- vapply(
      c(" 0.0", raw),
      FUN = function(x) eval(parse(text = x)),
      FUN.VALUE = 1
    )
    ratio <- cents2ratio(ratio_cents)
  } else {
    return(list(
      status = "incorrect ratio format(s)",
      file_contents = file_contents
    ))
  }

  # finish up
  ratio_frac <- cents2frac(ratio_cents)
  frequency <- ratio * root_freq
  scale_table <- data.table::data.table(
    degree,
    ratio_cents,
    ratio_frac,
    frequency
  )
  data.table::setkey(scale_table, ratio_cents)
  scale_table <- scale_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents)
  )]
  scale_table <- scale_table[, `:=`(
    interval_frac = cents2frac(interval_cents)
  )]
  scale_table$degree[degrees + 1] <- 0

  return(list(
    status = "Oll Korrect",
    file_contents = file_contents,
    scale_table = scale_table
  ))
}

#' @title Create Product Set Scale Table
#' @name prodset_scale_table
#' @description Creates a scale table from a product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom data.table "shift"
#' @importFrom fractional fractional
#' @export prodset_scale_table
#' @param prodset_def the product set scale definition. This is a list of
#' numeric vectors. Each vector is a multiset of any number of integers.
#' For example, the `prodset_def` of the 1-3-5-7 Hexany is
#'
#'   `list(c(1, 3), c(1, 5), c(1, 7), c(3, 5), c(3, 7), c(5, 7))`
#' @param period the period of the scale - default is 2.
#' @param tonic_note_number MIDI note number of the tonic for the scale -
#' - default is middle C = 60
#' @returns a `data.table` with seven columns:
#' \itemize{
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' `period`
#' \item `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
#' for this type of scale are usually irrational, so this is an approximation,
#' computed by `fractional::fractional`.
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `frequency`: frequency of the note given the `tonic_note_number`
#' parameter
#' \item `bent_midi`: the MIDI note number as an integer plus a fraction. For
#' example, middle C is MIDI note number 60 and middle C sharp is 61. The
#' quarter-tone half-way between C and C sharp would have a `bent_midi` value
#' of 60.5. The name `bent_midi` comes from the fact that a MIDI sequencer
#' can convert the value to a regular integer MIDI note number message and
#' a pitch bend message.
#' \item `interval_cents`: interval between this note and the previous note
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' }
#' @examples
#' (hexany <- prodset_scale_table(list(
#'   c(1, 3),
#'   c(1, 5),
#'   c(1, 7),
#'   c(3, 5),
#'   c(3, 7),
#'   c(5, 7)
#' )))
#'

prodset_scale_table <- function(
  prodset_def,
  period = 2,
  tonic_note_number = 60
) {
  degrees <- length(prodset_def)
  products <- unlist(lapply(prodset_def, FUN = prod))
  normalizer <- min(products)
  ratio <- c(sort(period_reduce(products / normalizer, period)), period)
  ratio_cents <- ratio2cents(ratio)

  # finish up
  ratio_frac <- as.character(fractional::fractional(ratio))
  tonic_frequency <- 440 * 2 ^ ((tonic_note_number - 69) / 12)
  frequency <- ratio * tonic_frequency
  bent_midi <- 0.01 * ratio_cents + tonic_note_number
  scale_table <- data.table::data.table(
    ratio,
    ratio_frac,
    ratio_cents,
    frequency,
    bent_midi
  )
  data.table::setkey(scale_table, ratio)
  scale_table <- scale_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents),
    degree = .I - 1
  )]
  scale_table$degree[degrees + 1] <- 0
  return(scale_table)
}

utils::globalVariables(c(
  "interval_cents"
))
