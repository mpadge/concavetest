
#' concave
#'
#' @param x x values
#' @param y y values
#' @return hull
#'
#' @export
concave <- function (x, y, concavity = 2, length_threshold = 0)
{
    xy <- data.frame (x = x, y = y)
    h <- grDevices::chull (xy)

    res <- rcpp_concaveman (xy, h - 1, concavity, length_threshold)
    rbind (res, res [1, ])
}
