#' @export
knit_print.matrix = function(x, options, ...) {
  res = paste(c(
    '', '', kable(x, options$render.args$kable$format, ...)
  ), collapse = '\n')
  asis_output(res)
}
#' @export
knit_print.data.frame = knit_print.matrix

#' @export
knit_print.table = function(x, options) {
  if (any(dim(x) == 0)) return('Empty table')
  d = length(dim(x))
  if (d == 1) {
    x = matrix(c(x), nrow = 1, dimnames = list(NULL, names(x)))
  } else if (d == 2) {
    class(x) = 'matrix'
  } else {
    # TODO: there might be better ways to represent such high-dimensional tables
    x = as.data.frame(x, stringsAsFactors = FALSE)
    m = ncol(x); n = nrow(x)
    # order from first to last column instead of the opposite (default)
    x = x[do.call(order, as.list(x[, -m])), ]
    # remove duplicate entries
    x[, -m] = matrix(apply(x[, -m], 2, function(z) {
      z[c(FALSE, z[-1] == z[-n])] = ''
      z
    }), nrow = n)
    rownames(x) = NULL
  }
  if (d == 2) {
    knit_print(
      x, options, row.names = TRUE,
      rownames.name = paste(names(dimnames(x)), collapse = '/')
    )
  } else {
    knit_print(x, options)
  }
}

#' @export
knit_print.summary.lm = function(x, options) {
  res = paste(c(
    '', '', x$call
  ), collapse = '\n')
  asis_output(res)
}

#' @export
knit_print.lm = function(x, options, ...) {
  res = paste(c(
    '', '', kable(summary(x)$coefficients, options$render.args$kable$format, ...)
  ), collapse = '\n')
  asis_output(res)
}

#' @export
knit_print.summary.plm = function(x, options) {
  res = paste(c(
    '', '', x$call
  ), collapse = '\n')
  asis_output(res)
}

#' @export
knit_print.plm = function(x, options, ...) {
  res = paste(c(
    '', '', kable(summary(x)$coefficients, options$render.args$kable$format, ...)
  ), collapse = '\n')
  asis_output(res)
}
