<!-- README.md is generated from README.Rmd. Please edit that file -->

# concavetest

Test package to benchmark Mapbox’s ‘concaveman’ algorithm in both
javascipt and C++ versions. Requires `libv8` for the `concaveman`
package which wraps the `.js` version.

``` r
library (concaveman)
if (!"concavetest" %in% rownames (installed.packages ()))
    remotes::install_github("mpadge/concavetest")
library (concavetest)
library (rbenchmark)
```

``` r
n <- 1e4
x <- runif (n)
y <- runif (n)
h <- concave (x, y)
knitr::kable (rbenchmark::benchmark (
                                     concave (x, y),
                                     concaveman (cbind (x, y)),
                                     replications = 100))
```

| test                    | replications | elapsed | relative | user.self | sys.self | user.child | sys.child |
| :---------------------- | -----------: | ------: | -------: | --------: | -------: | ---------: | --------: |
| concave(x, y)           |          100 |   1.808 |    1.000 |     1.791 |    0.017 |          0 |         0 |
| concaveman(cbind(x, y)) |          100 |  13.150 |    7.273 |    20.807 |    0.276 |          0 |         0 |
