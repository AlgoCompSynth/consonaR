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
#' \insertCite{sethares2013tuning}{setharophone}
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
#' @importFrom data.table ".I"
#' @importFrom data.table "shift"
#' @importFrom fractional fractional
#' @importFrom utils globalVariables
#' @export et_scale_table
#' @param period The period - default is 2, for an octave
#' @param divisions Number of degrees in the scale - default is 12
#' @param root Frequency of the scale root - default is middle C = 261.6256
#' @returns a `data.table` with six columns:
#' \itemize{
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' `period`
#' \item `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
#' for this type of scale are usually irrational, so this is an approximation,
#' computed by `fractional::fractional`.
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `frequency`: frequency of the note given the `root` parameter
#' \item `interval_cents`: interval between this note and the previous note
#' \item `degree`: scale degree from zero to (number of notes) - 1
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
    root = 440 / (2 ^ 0.75)
  ) {
  degree <- seq(0, divisions)
  ratio_cents <- degree * ratio2cents(period) / divisions
  ratio <- cents2ratio(ratio_cents)
  ratio_frac <- as.character(fractional::fractional(ratio))
  frequency <- ratio * root
  scale_table <- data.table::data.table(
    ratio,
    ratio_frac,
    ratio_cents,
    frequency
  )
  data.table::setkey(scale_table, ratio)
  scale_table <- scale_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents),
    degree = .I - 1
  )]
  scale_table$degree[divisions + 1] <- 0
  return(scale_table)
}
