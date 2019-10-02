<!-- README.md is generated from README.Rmd. Please edit that file -->

# concavetest

Test package to benchmark Mapbox’s ‘concaveman’ algorithm in both
javascipt and C++ versions.

``` r
if (!"concavetest" %in% rownames (installed.packages ()))
    remotes::install_github("mpadge/concavetest")
library (concavetest)
library (rbenchmark)
```

``` r
n <- 1e4
x <- runif (n)
y <- runif (n)
knitr::kable (rbenchmark::benchmark (
                                     c_js (x, y),
                                     c_cpp (x, y),
                                     replications = 100))
```

|   | test         | replications | elapsed | relative | user.self | sys.self | user.child | sys.child |
| - | :----------- | -----------: | ------: | -------: | --------: | -------: | ---------: | --------: |
| 2 | c\_cpp(x, y) |          100 |   1.603 |    1.000 |     1.588 |    0.013 |          0 |         0 |
| 1 | c\_js(x, y)  |          100 |  10.060 |    6.276 |    10.294 |    0.084 |          0 |         0 |

And C++ is loads faster than javascript. The end.

