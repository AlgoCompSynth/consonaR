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
