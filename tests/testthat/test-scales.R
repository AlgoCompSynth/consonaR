test_that("freq2MIDI and MIDI2freq are inverses", {
  freqs <- c(440, 880, 261.63)
  midis <- freq2MIDI(freqs)
  expect_equal(MIDI2freq(midis), freqs, tolerance = 1e-5)
})

test_that("freq2MIDI throws on invalid input", {
  expect_error(freq2MIDI(-440))
  expect_error(freq2MIDI(0))
  expect_error(freq2MIDI("not a number"))
})

test_that("cents2ratio and ratio2cents are inverses", {
  cents <- c(0, 100, 700, 1200)
  ratios <- cents2ratio(cents)
  expect_equal(ratio2cents(ratios), cents, tolerance = 1e-5)
})

test_that("ratio2cents throws on invalid input", {
  expect_error(ratio2cents(-1))
  expect_error(ratio2cents(0))
})

test_that("cents2frac produces expected vulgar fractions", {
  # 700 cents is approx 3/2 (Perfect Fifth)
  # Using a known value where fractional package works well
  expect_match(cents2frac(0), "1")
  expect_match(cents2frac(1200), "2")
})

test_that("ratio2factors recovers prime factors", {
  ratios <- c(3/2, 5/4)
  factors <- ratio2factors(ratios)
  # 3/2: product of (3 * 2^-1)? Actually numbers::primeFactors only does positive integers.
  # Let's check implementation: it multiplies by mLCM of denominators.
  # For c(3/2, 5/4), LCM is 4. Integers are 6 and 5.
  # Prime factors of 6 are 2, 3; of 5 is 5.
  expect_equal(unlist(factors[[1]]), sort(c(2, 3)))
  expect_equal(unlist(factors[[2]]), 5)
})

test_that("period_reduce correctly reduces ratios", {
  # Octave reduction (period = 2)
  expect_equal(period_reduce(c(0.5, 1.5, 2.5, 4.2), 2), c(1.0, 1.5, 1.25, 1.05), tolerance = 1e-5)
  # Tritave reduction (period = 3)
  expect_equal(period_reduce(c(0.1, 3.1, 9.1), 3), c(2.7, 1.033333, 1.011111), tolerance = 1e-5)
})

test_that("period_reduce throws on invalid period", {
  expect_error(period_reduce(c(1.5), 1))
  expect_error(period_reduce(c(1.5), 0))
})

test_that("sine_dissonance is vectorized and handles inputs", {
  f1 <- c(440, 440)
  f2 <- c(445, 880) # one close (dissonant), one far'ish
  l1 <- c(1, 1)
  l2 <- c(1, 1)
  
  res <- sine_dissonance(f1, f2, l1, l2)
  expect_length(res, 2)
  expect_true(res[1] > res[2]) # Small interval should be more dissonant than octave
})

test_that("sine_dissonance throws on negative frequencies", {
  expect_error(sine_dissonance(-440, 440, 1, 1))
})

test_that("et_scale_table produces a valid table", {
  tbl <- et_scale_table(period = 2, divisions = 12)
  expect_s3_class(tbl, "data.table")
  expect_equal(nrow(tbl), 13) # 0 to 12
  expect_equal(tbl$degree[13], 0) # Wrap around
  expect_equal(tbl$ratio_cents[13], 1200)
})

test_that("et_scale_table throws on divisions = 0", {
  expect_error(et_scale_table(divisions = 0))
})

test_that("prodset_scale_table produces expected ratios for Hexany", {
  hexany_def <- list(c(1, 3), c(1, 5), c(1, 7), c(3, 5), c(3, 7), c(5, 7))
  tbl <- prodset_scale_table(hexany_def)
  expect_s3_class(tbl, "data.table")
  # Hexany should have degree 0-6 (total 7 rows including ratio=period)
  expect_equal(nrow(tbl), 7)
})
