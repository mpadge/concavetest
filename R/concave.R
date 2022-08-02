MASS_bandwidth.nrd <-
function (x)
{
  r <- quantile(x, c(0.25, 0.75))
  h <- (r[2L] - r[1L])/1.34
  ## MASS does 4 * this
  1.06 * min(sqrt(var(x)), h) * length(x)^(-1/5)
}

#' c_cpp
#'
#' @param x x values
#' @param y y values
#' @return hull
#'
#' @export
c_cpp <- function (x, y, concavity = 2, length_threshold = NULL)
{
    if (is.null(length_threshold)) {
      length_threshold <- min(c(MASS_bandwidth.nrd(x), MASS_bandwidth.nrd(y)))
    }
    xy <- data.frame (x = x, y = y)
    h <- grDevices::chull (xy)

    res <- rcpp_concaveman (xy, h - 1, concavity, length_threshold)
    rbind (res, res [1, ])
}

#' c_js
#'
#' 'javascipt' implementation of concaveman, mostly from code of @joelgombin
#' @param x x values
#' @param y y values
#' @param concavity a relative measure of concavity. 1 results in a relatively detailed shape, Infinity results in a convex hull. You can use values lower than 1, but they can produce pretty crazy shapes.
#' @param length_threshold when a segment length is under this threshold, it stops being considered for further detalization. Higher values result in simpler shapes.
#'
#' @return concave hull
#' @export
c_js <- function(x, y, concavity = 2, length_threshold = 1)
{
	points <- rbind (x, y)

	ctx <- V8::v8()
	ctx$source(system.file("js", "concaveman.js", package = "concavetest"))
	workhorse <- function(points, concavity, length_threshold) {
		jscode <- sprintf(
				  "var points = %s; var polygon = concaveman(points, concavity = %s, lengthThreshold = %s);",
				  jsonlite::toJSON(points, dataframe = 'values'),
				  concavity,
				  length_threshold
		)
		ctx$eval(jscode)
		df <- as.matrix(as.data.frame(ctx$get('polygon')))
		df
  }
  workhorse(points, concavity, length_threshold)
}
