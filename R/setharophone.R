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

#' @title Dissonance
#' @name dissonance
#' @description Calculates the dissonance function for two sine waves
#' @importFrom Rdpack reprompt
#' @export dissonance
#' @param freq1 frequency in Hertz of the first sine wave
#' @param freq2 frequency in Hertz of the second sine wave
#' @param loud1 loudness of the first sine wave
#' @param loud2 loudness of the second sine wave
#' @returns the dissonance value
#' @details This algorithm comes from Appendix E of
#' \insertCite{sethares2013tuning}{setharophone}
#' @references
#' \insertAllCited{}

dissonance <- function(freq1, freq2, loud1, loud2) {
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
